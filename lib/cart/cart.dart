import 'package:decimal/decimal.dart';
import 'package:trokot_dealer_mobile/product/product.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class CartRepository {
  final ServiceClient serviceClient;

  CartRepository({
    required this.serviceClient,
  });

  Future<List<CartItem>> getProductList() async {
    final response = await serviceClient.callFunction(path: '/cart/get-product-list');
    final list = response['data'] as List;
    return list.map((item) => CartItem.fromJson(item)).toList();
  }

  Future<List<CartItem>> addProduct(String productId, Decimal quantity) async {
    final params = <String, dynamic>{
      'productId': productId,
      'quantity': quantity.toJson(),
    };
    final response = await serviceClient.callFunction(
      path: '/cart/add-product',
      params: params,
    );
    final list = response['data'] as List;
    return list.map((item) => CartItem.fromJson(item)).toList();
  }

  Future<List<CartItem>> removeProduct(String productId, Decimal quantity) async {
    final params = <String, dynamic>{
      'productId': productId,
      'quantity': quantity.toJson(),
    };
    final response = await serviceClient.callFunction(
      path: '/cart/remove-product',
      params: params,
    );
    final list = response['data'] as List;
    return list.map((item) => CartItem.fromJson(item)).toList();
  }

  Future<List<CartItem>> setProduct(String productId, Decimal quantity) async {
    final params = <String, dynamic>{
      'productId': productId,
      'quantity': quantity.toJson(),
    };
    final response = await serviceClient.callFunction(
      path: '/cart/set-product',
      params: params,
    );
    final list = response['data'] as List;
    return list.map((item) => CartItem.fromJson(item)).toList();
  }

  Future<List<CartItem>> clear() async {
    final response = await serviceClient.callFunction(
      path: '/cart/clear',
    );
    final list = response['data'] as List;
    return list.map((item) => CartItem.fromJson(item)).toList();
  }
}

class CartItem {
  final String id;
  final ProductRef product;
  final String sku;
  final Decimal quantity;
  final Decimal price;
  final Decimal totalPrice;

  CartItem({
    required this.id,
    required this.product,
    required this.sku,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as String,
        product: ProductRef.fromJson(json['product']),
        sku: json['sku'] as String,
        quantity: Decimal.parse(json['quantity']),
        price: Decimal.parse(json['price']),
        totalPrice: Decimal.parse(json['totalPrice']),
      );
}
