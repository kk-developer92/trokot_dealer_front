import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/common/date_time_ext.dart';
import 'package:trokot_dealer_mobile/order/order.dart';
import 'package:trokot_dealer_mobile/order/order_events.dart';
import 'package:trokot_dealer_mobile/payment/payment.dart';
import 'package:trokot_dealer_mobile/services/service_events.dart';
import 'package:uuid/v4.dart';

class OrderDetailNotifier extends ChangeNotifier {
  final OrderRepository orderRepository;
  final PaymentRepository paymentRepository;
  final EventBus eventBus;

  final idempotenceKey = const UuidV4();
  bool justPaid = false;

  String id;
  late Order data;

  bool loading = false;

  OrderDetailNotifier({
    required this.orderRepository,
    required this.paymentRepository,
    required this.eventBus,
    required this.id,
  }) {
    refresh();
  }

  Future<void> refresh() async {
    loading = true;
    notifyListeners();

    try {
      data = await orderRepository.getOrder(id: id);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<String> createOnlinePaymentUrl() async {
    loading = true;
    notifyListeners();

    try {
      final paymentAmount = data.paymentAmount;
      if (paymentAmount < Decimal.zero) {
        throw 'Заказ полностью оплачен';
      }
      final paymentUrl = await orderRepository.createOrderPaymentUrl(
        orderId: data.id,
        description: 'Заказ № ${data.number} от ${data.date.formatDate()} (${data.totalPrice} руб.)',
        amount: paymentAmount,
      );

      justPaid = true;
      notifyListeners();

      return paymentUrl;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> checkPayment() async {
    loading = true;
    notifyListeners();

    try {
      data = await orderRepository.checkOrderPayment(id: data.id);
    } finally {
      eventBus.sink.add(OrderRefreshListEvent());

      loading = false;
      notifyListeners();
    }
  }

  Future<void> payFromBalance(Decimal amount) async {
    loading = true;
    notifyListeners();

    try {
      data = await orderRepository.payFromBalance(id: id, amount: amount);
    } finally {
      eventBus.sink.add(OrderRefreshListEvent());
      eventBus.sink.add(ServicePingEvent());

      loading = false;
      notifyListeners();
    }
  }

  Future<String> getInvoicePdfUrl() async {
    loading = true;
    notifyListeners();
    
    try {
      return await orderRepository.getInvoicePdfUrl(id: id);
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}