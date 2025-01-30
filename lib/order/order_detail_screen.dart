import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/common/date_time_ext.dart';
import 'package:trokot_dealer_mobile/order/order.dart';
import 'package:trokot_dealer_mobile/order/order_detail_notifier.dart';
import 'package:trokot_dealer_mobile/common/events.dart';
import 'package:trokot_dealer_mobile/payment/payment.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showOrderDetailScreen({
  required BuildContext context,
  required String orderId,
}) async {
  await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(id: orderId),
      ));
}

class OrderDetailScreen extends StatelessWidget {
  final String id;

  const OrderDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderDetailNotifier(
        orderRepository: context.read<OrderRepository>(),
        paymentRepository: context.read<PaymentRepository>(),
        eventBus: context.read<EventBus>(),
        id: id,
      ),
      child: Consumer<OrderDetailNotifier>(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Заказ покупателя'),
          ),
          // body: state.loading ? const CircularProgressIndicator() : OrderWidget(order: state.data),
          body: state.loading ? const Center(child: CircularProgressIndicator()) : OrderWidget(order: state.data),
          // body: Container(),
          floatingActionButton: state.loading ? null : OrderButtons(screenContext: context, state: state),
          floatingActionButtonAnimator: FloatingActionButtonAnimator.noAnimation,
        ),
      ),
    );
  }
}

class OrderWidget extends StatelessWidget {
  final Order order;

  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: Text('Номер', style: TextStyle(fontWeight: FontWeight.bold))),
                Text(order.number),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('Дата', style: TextStyle(fontWeight: FontWeight.bold))),
                Text(order.date.formatDateTime()),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('Контрагент', style: TextStyle(fontWeight: FontWeight.bold))),
                Text(order.partner.repr),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('Статус', style: TextStyle(fontWeight: FontWeight.bold))),
                Text(order.status),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('Статус оплаты', style: TextStyle(fontWeight: FontWeight.bold))),
                Text(order.paymentStatus),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('Сумма', style: TextStyle(fontWeight: FontWeight.bold))),
                Text('${order.totalPrice.toString()} ₽'),
              ],
            ),
            const SizedBox(height: 10),
            Column(
              children: order.itemList
                  .map((item) => ListTile(
                        title: Row(
                          children: [
                            Expanded(child: Text(item.product.repr)),
                            Text('${item.quantity} шт.')
                          ],
                        ),
                        subtitle: Text('Цена: ${item.price} ₽, Сумма: ${item.totalPrice} ₽'),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Комментарий',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            Text(order.notes),
          ],
        ),
      ),
    );
  }
}

class OrderButtons extends StatelessWidget {
  final OrderDetailNotifier state;
  final BuildContext screenContext;

  const OrderButtons({
    super.key,
    required this.screenContext,
    required this.state,
  });

  void payOrderOnline() {
    state.createOnlinePaymentUrl().then((paymentUrl) async {
      final paymentUri = Uri.parse(paymentUrl);
      launchUrl(paymentUri, mode: LaunchMode.externalApplication).catchError((error) {
        final messenger = ScaffoldMessenger.of(screenContext);
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    });
  }

  void getInvoicePdf() async {
    final url = await state.getInvoicePdfUrl();
    final uri = Uri.parse(url);
    await launchUrl(uri);
  }

  void payOrderFromBalance(Decimal paymentAmount) async {
    state.payFromBalance(paymentAmount).then((value) {
      if (!screenContext.mounted) return;
      showDialog(
          context: screenContext,
          builder: (context) {
            return AlertDialog(
              content: const Text(
                'Аванс зачтен',
                textAlign: TextAlign.center,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ОК'),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            );
          });
    }).catchError((error) {
      if (!screenContext.mounted) return;
      showDialog(
          context: screenContext,
          builder: (context) {
            return AlertDialog(
              content: const Text(
                'Ошибка зачета аванса',
                textAlign: TextAlign.center,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ОК'),
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final paymentAmount = state.data.paymentAmount;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (paymentAmount > Decimal.zero)
          ElevatedButton(
            onPressed: state.checkPayment,
            child: const Text('Проверить'),
          ),
        if (paymentAmount > Decimal.zero && !state.justPaid) const SizedBox(width: 5),
        if (paymentAmount > Decimal.zero && !state.justPaid)
          ElevatedButton(
            onPressed: payOrderOnline,
            child: const Text('Оплатить'),
          ),
        if (paymentAmount > Decimal.zero) const SizedBox(width: 5),
        if (paymentAmount > Decimal.zero)
          ElevatedButton(
            onPressed: () => payOrderFromBalance(paymentAmount),
            child: const Text('Зачесть аванс'),
          ),
        if (paymentAmount > Decimal.zero) const SizedBox(width: 5),
        if (paymentAmount > Decimal.zero)
          ElevatedButton(
            onPressed: getInvoicePdf,
            child: const Text('Счет'),
          ),
      ],
    );
  }
}
