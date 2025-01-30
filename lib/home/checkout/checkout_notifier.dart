import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:trokot_dealer_mobile/cart/cart.dart';
import 'package:trokot_dealer_mobile/home/checkout/checkout.dart';
import 'package:trokot_dealer_mobile/order/order.dart';
import 'package:trokot_dealer_mobile/partner/partner.dart';

import 'package:trokot_dealer_mobile/order/order_events.dart';
import 'package:trokot_dealer_mobile/cart/cart_events.dart';

class CheckoutNotifier extends ChangeNotifier {
  final OrderRepository orderRepository;
  final CartRepository cartRepository;
  final EventBus eventBus;

  final Partner partner;
  final Decimal totalPrice;

  String notes = '';
  void setNotes(String value) {
    notes = value;
    notifyListeners();
  }

  final List<CheckoutItem> items;

  bool loading = false;

  CheckoutNotifier({
    required this.orderRepository,
    required this.cartRepository,
    required this.eventBus,
    required this.partner,
    required this.items,
    required this.totalPrice,
  });

  Future<void> placeOrder() async {
    final orderCreate = OrderCreate(
      partnerId: partner.id,
      notes: notes,
      items: items
          .map((e) => OrderCreateItem(
                productId: e.product.id,
                quantity: e.quantity,
                price: e.price,
                totalPrice: e.totalPrice,
              ))
          .toList(),
      totalPrice: totalPrice,
    );
    try {
      loading = true;
      notifyListeners();

      // await Future.delayed(const Duration(seconds: 2));
      // throw 'Что-то пошло не так';

      await orderRepository.createOrder(orderCreate);
      await cartRepository.clear();
    } finally {
      eventBus.sink.add(CartRefreshListEvent());
      eventBus.sink.add(OrderRefreshListEvent());

      loading = false;
      notifyListeners();
    }
  }
}
