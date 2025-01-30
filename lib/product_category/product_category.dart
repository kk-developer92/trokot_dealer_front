import 'package:trokot_dealer_mobile/common/ref/model_ref.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class ProductCategoryRepository {
  final ServiceClient serviceClient;

  ProductCategoryRepository({
    required this.serviceClient,
  });

  Future<List<ProductCategoryItem>> getProductCategoryList({
    String? name,
  }) async {
    final params = <String, dynamic>{
      if (name != null) 'name': name,
    };

    final response = await serviceClient.callFunction(
      path: '/product-category/get-list',
      params: params,
    );
    final list = response['data'] as List;

    return list.map((item) => ProductCategoryItem.fromJson(item)).toList();
  }

  Future<List<ProductCategoryRef>> getSelectionHistory() async {
    final response = await serviceClient.callFunction(path: '/product-category/get-selection-history');
    final list = response['data'] as List;
    return list.map((item) => ProductCategoryRef.fromJson(item)).toList();
  }

  Future<void> rememberSelection({
    required String productCategoryId,
  }) async {
    final params = <String, dynamic>{
      'productCategoryId': productCategoryId,
    };
    await serviceClient.callFunction(
      path: '/product-category/remember-selection',
      params: params,
    );
  }

  Future<void> deleteSelection({
    required String productCategoryId,
  }) async {
    final params = <String, dynamic>{
      'productCategoryId': productCategoryId,
    };
    await serviceClient.callFunction(
      path: '/product-category/delete-selection',
      params: params,
    );
  }
}

class ProductCategoryItem {
  final String id;
  final String name;

  ProductCategoryItem({
    required this.id,
    required this.name,
  });

  ProductCategoryRef ref() => ProductCategoryRef(id: id, repr: name);

  factory ProductCategoryItem.fromJson(Map<String, dynamic> json) => ProductCategoryItem(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}

class ProductCategory {
  final String id;
  final String name;

  ProductCategory({
    required this.id,
    required this.name,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
        id: json['id'] as String,
        name: json['name'] as String,
      );
}

class ProductCategoryRef extends ModelRef {
  ProductCategoryRef({
    required super.id,
    required super.repr,
  });

  factory ProductCategoryRef.fromJson(Map<String, dynamic> json) => ProductCategoryRef(
        id: json['id'] as String,
        repr: json['repr'] as String,
      );
}
