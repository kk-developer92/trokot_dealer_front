import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/common/date_time_ext.dart';
import 'package:trokot_dealer_mobile/order/order.dart';
import 'package:trokot_dealer_mobile/order/order_detail_screen.dart';
import 'package:trokot_dealer_mobile/order/order_list_notifier.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OrderListNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Заказы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.refresh,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: state.items
              .map((e) => OrderListItemTile(
                    key: ValueKey(e.id),
                    item: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class OrderListItemTile extends StatelessWidget {
  final OrderListItem item;

  const OrderListItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        key: ValueKey(item.id),
        title: Row(
          children: [
            Expanded(child: Text(item.date.formatDateTime())),
            Text('№ ${item.number.toString()}'),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(child: Text('${item.status} | ${item.paymentStatus}')),
            Text('${item.totalPrice.toString()} ₽'),
          ],
        ),
        onTap: () => showOrderDetailScreen(context: context, orderId: item.id));
  }
}
