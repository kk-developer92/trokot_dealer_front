import 'package:trokot_dealer_mobile/car_body_style/car_body_style.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/car_model/car_model.dart';
import 'package:trokot_dealer_mobile/product_category/product_category.dart';
import 'package:trokot_dealer_mobile/common/ref/model_ref.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';
import 'package:decimal/decimal.dart';
import 'package:trokot_dealer_mobile/setType/set_type.dart';

class ProductRepository {
  final ServiceClient serviceClient;

  ProductRepository({
    required this.serviceClient,
  });

  Future<List<ProductItem>> getProductList({
    String? name,
    String? sku,
    String? categoryId,
    String? setTypeId,
    String? carBrandId,
    String? carModelId,
    String? carBodyStyleId,
    bool inStock = false,
    required skip,
    required limit,
  }) async {
    final params = <String, dynamic>{
      if (name != null) 'name': name,
      if (sku != null) 'sku': sku,
      if (categoryId != null) 'categoryId': categoryId,
      if (setTypeId != null) 'setTypeId': setTypeId,
      if (carBrandId != null) 'carBrandId': carBrandId,
      if (carModelId != null) 'carModelId': carModelId,
      if (carBodyStyleId != null) 'carBodyStyleId': carBodyStyleId,
      'inStock': inStock,
      'skip': skip,
      'limit': limit,
    };

    final response = await serviceClient.callFunction(
      path: '/product/get-list',
      params: params,
    );
    final list = response['data'] as List;

    return list.map((item) => ProductItem.fromJson(item)).toList();
  }

  Future<Product> getProduct({required String id}) async {
    final params = <String, dynamic>{
      'id': id,
    };
    final response = await serviceClient.callFunction(
      path: '/product/get',
      params: params,
    );
    final item = response['data'] as Map<String, dynamic>;

    return Product.fromJson(item);
  }
}

class ProductItem {
  final String id;
  final String name;
  final String sku;
  final Decimal price;
  final int quantity;

  ProductItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.quantity,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        id: json['id'] as String,
        name: json['name'] as String,
        sku: json['sku'] as String,
        price: Decimal.parse(json['price']),
        quantity: json['quantity'] as int,
      );
}

class Product {
  final String id;
  final String name;
  final String sku;
  final String description;
  final Decimal price;
  final int quantity;
  final ProductCategoryRef category;
  final SetTypeRef? setType;
  final CarBrandRef? carBrand;
  final CarModelRef? carModel;
  final CarBodyStyleRef? carBodyStyle;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    this.setType,
    this.carBrand,
    this.carModel,
    this.carBodyStyle,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        sku: json['sku'] as String,
        description: json['description'] as String,
        price: Decimal.parse(json['price']),
        quantity: json['quantity'] as int,
        category: ProductCategoryRef.fromJson(json['category']),
        setType: json['setType'] == null ? null : SetTypeRef.fromJson(json['setType']),
        carBrand: json['carBrand'] == null ? null : CarBrandRef.fromJson(json['carBrand']),
        carModel: json['carModel'] == null ? null : CarModelRef.fromJson(json['carModel']),
        carBodyStyle: json['carBodyStyle'] == null ? null : CarBodyStyleRef.fromJson(json['carBodyStyle'])
      );
}

class ProductRef extends ModelRef {
  ProductRef({
    required super.id,
    required super.repr,
  });

  factory ProductRef.fromJson(Map<String, dynamic> json) => ProductRef(
        id: json['id'] as String,
        repr: json['repr'] as String,
      );
}
