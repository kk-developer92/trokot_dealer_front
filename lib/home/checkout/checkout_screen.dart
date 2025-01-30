import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/cart/cart.dart';
import 'package:trokot_dealer_mobile/common/ui/text_field.dart';
import 'package:trokot_dealer_mobile/home/checkout/checkout.dart';
import 'package:trokot_dealer_mobile/home/checkout/checkout_notifier.dart';
import 'package:trokot_dealer_mobile/order/order.dart';
import 'package:trokot_dealer_mobile/partner/partner.dart';

import 'package:trokot_dealer_mobile/common/events.dart';
import 'package:trokot_dealer_mobile/cart/cart_events.dart';
import 'package:trokot_dealer_mobile/order/order_events.dart';


Future<void> showCheckOutScreen({
  required BuildContext context,
  required Partner partner,
  required List<CheckoutItem> itemList,
  required Decimal totalPrice,
}) async {
  final globalNavigator = context.read<GlobalKey<NavigatorState>>().currentState!;
  await globalNavigator.push(
    MaterialPageRoute(
      builder: (context) => CheckoutScreen(
        partner: partner,
        items: itemList,
        totalPrice: totalPrice,
      ),
    ),
  );
}

class CheckoutScreen extends StatelessWidget {
  final Partner partner;
  final List<CheckoutItem> items;
  final Decimal totalPrice;

  const CheckoutScreen({
    super.key,
    required this.partner,
    required this.items,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutNotifier>(
      create: (context) => CheckoutNotifier(
        orderRepository: context.read<OrderRepository>(),
        cartRepository: context.read<CartRepository>(),
        eventBus: context.read<EventBus>(),
        partner: partner,
        items: items,
        totalPrice: totalPrice,
      ),
      child: Consumer<CheckoutNotifier>(
        builder: (context, state, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Оформление заказа'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Контрагент', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(state.partner.name),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ИНН', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(state.partner.tin),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: state.items.map((item) => OrderItemTile(item: item)).toList(),
                    ),
                    const SizedBox(height: 8),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Комментарий', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 4),
                    AppTextField(
                      text: state.notes,
                      onChanged: state.setNotes,
                      decoration: const InputDecoration(
                        // label: Text('Комментарий'),

                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            floatingActionButton: ButtonsBlock(state: state),
          );
        },
      ),
    );
  }
}

class OrderItemTile extends StatelessWidget {
  final CheckoutItem item;

  const OrderItemTile({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(item.product.repr)),
          Text('${item.quantity} шт.'),
        ],
      ),
      subtitle: Text('Цена: ${item.price}, Сумма: ${item.totalPrice}'),
    );
  }
}

class ButtonsBlock extends StatelessWidget {
  final CheckoutNotifier state;
  const ButtonsBlock({
    super.key,
    required this.state,
  });

  placeOrder(BuildContext context) {
    state.placeOrder().then((onValue) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: const Text(
              'Заказ успешно создан',
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
        },
      ).then((value) {
        Navigator.of(context).pop();
      });
    }).onError(
      (error, stackTrace) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Center(child: Text('Ошибка')),
                content: const Text(
                  'Заказ не был создан',
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: state.loading ? null : () => placeOrder(context),
          // onPressed: null,
          child: Text('Оформить заказ (${state.totalPrice} ₽)'),
        ),
      ],
    );
  }
}
