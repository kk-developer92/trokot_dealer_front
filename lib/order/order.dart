import 'package:decimal/decimal.dart';
import 'package:trokot_dealer_mobile/common/date_time_ext.dart';
import 'package:trokot_dealer_mobile/partner/partner.dart';
import 'package:trokot_dealer_mobile/product/product.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class OrderRepository {
  final ServiceClient serviceClient;

  OrderRepository({
    required this.serviceClient,
  });

  Future<List<OrderListItem>> getOrderList() async {
    final response = await serviceClient.callFunction(path: '/order/get-order-list');
    final list = response['data'] as List;

    return list.map((item) => OrderListItem.fromJson(item)).toList();
  }

  Future<Order> getOrder({required String id}) async {
    final params = <String, dynamic>{
      'id': id,
    };
    final response = await serviceClient.callFunction(
      path: '/order/get-order',
      params: params,
    );
    final data = response['data'] as Map<String, dynamic>;
    return Order.fromJson(data);
  }

  Future<void> createOrder(OrderCreate order) async {
    // final params = order.toJson();

    final params = <String, dynamic>{
      'userId': serviceClient.user!.id,
      'notes': order.notes,
      'data': order.toJson(),
    };

    final result = await serviceClient.callFunction(
      path: '/order/create-order',
      params: params,
      timeout: const Duration(seconds: 60),
    );
  }

  Future<String> createOrderPaymentUrl({
    required String orderId,
    required String description,
    required Decimal amount,
  }) async {
    final params = <String, dynamic>{
      'orderId': orderId,
      'description': description,
      'amount': amount.toString(),
    };
    final result = await serviceClient.callFunction(
      path: '/order/create-order-payment-url',
      params: params,
    );
    final url = result['url'] as String;
    return url;
  }

  Future<Order> checkOrderPayment({
    required String id,
  }) async {
    final params = <String, dynamic>{
      'orderId': id,
    };
    final response = await serviceClient.callFunction(
      path: '/order/check-order-payment',
      params: params,
      timeout: const Duration(seconds: 60),
    );
    final data = response['data'] as Map<String, dynamic>;
    return Order.fromJson(data);
  }

  Future<Order> payFromBalance({
    required String id,
    required Decimal amount,
  }) async {
    final params = <String, dynamic>{
      'orderId': id,
      'amount': amount.toString(),
    };
    final response = await serviceClient.callFunction(
      path: '/order/pay-order-from-balance',
      params: params,
    );
    final data = response['data'] as Map<String, dynamic>;
    return Order.fromJson(data);
  }

  Future<String> getInvoicePdfUrl({required String id}) async {
    final params = <String, dynamic>{
      'orderId': id,
    };
    final response = await serviceClient.callFunction(
      path: '/order/create-invoice-pdf-url',
      params: params,
      timeout: const Duration(seconds: 60),
    );
    final url = response['url'] as String;
    return url;
  }
}

class OrderListItem {
  final String id;
  final DateTime date;
  final String number;
  final Decimal totalPrice;
  final Decimal totalPayment;
  final String status;

  String get paymentStatus {
    if (totalPayment == Decimal.zero) {
      return 'Не оплачен';
    } else if (totalPayment < totalPrice) {
      return 'Частично: $totalPayment ₽';
    } else if (totalPayment == totalPrice) {
      return 'Оплачен';
    } else {
      return 'Переплата: $totalPayment ₽';
    }
  }

  OrderListItem({
    required this.id,
    required this.date,
    required this.number,
    required this.totalPrice,
    required this.totalPayment,
    required this.status,
  });

  factory OrderListItem.fromJson(Map<String, dynamic> json) => OrderListItem(
        id: json['id'],
        date: decodeDate(json['date']),
        number: json['number'],
        totalPrice: Decimal.parse(json['totalPrice']),
        totalPayment: Decimal.parse(json['totalPayment']),
        status: json['status'],
      );
}

class Order {
  final String id;
  final DateTime date;
  final String number;
  final PartnerRef partner;
  final Decimal totalPrice;
  final Decimal totalPayment;
  final String status;
  final String notes;

  String get paymentStatus {
    if (totalPayment == Decimal.zero) {
      return 'Не оплачен';
    } else if (totalPayment < totalPrice) {
      return 'Частично: $totalPayment ₽';
    } else if (totalPayment == totalPrice) {
      return 'Оплачен';
    } else {
      return 'Переплата: $totalPayment ₽';
    }
  }

  Decimal get paymentAmount => totalPrice - totalPayment;

  final List<OrderItem> itemList;

  Order({
    required this.id,
    required this.date,
    required this.number,
    required this.partner,
    required this.totalPrice,
    required this.totalPayment,
    required this.status,
    required this.notes,
    required this.itemList,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id'],
        date: decodeDate(json['date']),
        number: json['number'],
        partner: PartnerRef.fromJson(json['partner']),
        totalPrice: Decimal.parse(json['totalPrice']),
        totalPayment: Decimal.parse(json['totalPayment']),
        status: json['status'],
        notes: json['notes'],
        itemList: (json['itemList'] as List).map((e) => OrderItem.fromJson(e)).toList(),
      );
}

class OrderItem {
  final int lineNumber;
  final ProductRef product;
  final Decimal quantity;
  final Decimal price;
  final Decimal totalPrice;

  OrderItem({
    required this.lineNumber,
    required this.product,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        lineNumber: json['lineNumber'],
        product: ProductRef.fromJson(json['product']),
        quantity: Decimal.parse(json['quantity']),
        price: Decimal.parse(json['price']),
        totalPrice: Decimal.parse(json['totalPrice']),
      );
}

class OrderCreate {
  final String partnerId;
  final Decimal totalPrice;
  final String notes;

  final List<OrderCreateItem> items;

  OrderCreate({
    required this.partnerId,
    required this.totalPrice,
    required this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'partnerId': partnerId,
        'totalPrice': totalPrice.toString(),
        'notes': notes,
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class OrderCreateItem {
  final String productId;
  final Decimal quantity;
  final Decimal price;
  final Decimal totalPrice;

  OrderCreateItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory OrderCreateItem.fromJson(Map<String, dynamic> json) => OrderCreateItem(
        productId: json['productId'],
        quantity: Decimal.parse(json['quantity']),
        price: Decimal.parse(json['price']),
        totalPrice: Decimal.parse(json['totalPrice']),
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity.toString(),
        'price': price.toString(),
        'totalPrice': totalPrice.toString(),
      };
}
