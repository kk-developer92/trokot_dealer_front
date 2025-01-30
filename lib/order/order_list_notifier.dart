import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/order/order.dart';
import 'package:trokot_dealer_mobile/order/order_events.dart';
import 'package:trokot_dealer_mobile/services/service_events.dart';

class OrderListNotifier extends ChangeNotifier {
  final OrderRepository orderRepository;
  final EventBus eventBus;
  final bool autoRefresh;

  late final EventStreamSubscription eventStreamSubscription;

  OrderListNotifier({
    required this.orderRepository,
    required this.eventBus,
    this.autoRefresh = false,
  }) {
    if (autoRefresh) {
      refresh();
      eventStreamSubscription = eventBus.stream.listen((event) {
        if (event is OrderRefreshListEvent) {
          refresh();
        }
      });
    }
  }

  @override
  void dispose() {
    eventStreamSubscription.cancel();  
    super.dispose();
  }  

  

  List<OrderListItem> items = [];

  Future<void> refresh() async {
    items = await orderRepository.getOrderList();
    eventBus.sink.add(ServicePingEvent());
    notifyListeners();
  }
}
