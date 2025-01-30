import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/cart/cart.dart';
import 'package:trokot_dealer_mobile/product/product.dart';

import 'package:trokot_dealer_mobile/cart/cart_events.dart';


class CartNotifier extends ChangeNotifier {
  final CartRepository cartRepository;
  final EventBus eventBus;
  final bool autoRefresh;

  late final StreamSubscription<AppEvent> eventStreamSubscription;

  CartNotifier({
    required this.cartRepository,
    required this.eventBus,
    this.autoRefresh = false,
  }) {
    if (autoRefresh) {
      refresh();
      eventStreamSubscription = eventBus.stream.listen((event) {
        if (event is CartRefreshListEvent) {
          refresh();
        }
      });
    }
  }

  @override
  dispose() {
    eventStreamSubscription.cancel();
    super.dispose();
  }

  List<CartItem> _productList = [];
  List<CartItem> get productList => _productList;
  set productList(List<CartItem> value) {
    _productList = value;
    // _total = Decimal.parse('100');
    _total = _productList.fold(Decimal.zero, (totalPrice, element) => totalPrice + element.totalPrice);
  }

  Decimal _total = Decimal.zero;
  Decimal get totalPrice => _total;

  refresh() async {
    productList = await cartRepository.getProductList();
    notifyListeners();
  }

  addProduct(ProductRef product) async {
    productList = await cartRepository.addProduct(product.id, Decimal.one);
    notifyListeners();
  }

  removeProduct(ProductRef product) async {
    productList = await cartRepository.removeProduct(product.id, Decimal.one);
    notifyListeners();
  }

  setProduct(ProductRef product, Decimal quantity) async {
    productList = await cartRepository.setProduct(product.id, quantity);
    notifyListeners();
  }

  clear() async {
    productList = await cartRepository.clear();
    notifyListeners();
  }
}
