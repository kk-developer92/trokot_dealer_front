import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/car_body_style/car_body_style.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/car_model/car_model.dart';
import 'package:trokot_dealer_mobile/product/product.dart';
import 'package:trokot_dealer_mobile/product_category/product_category.dart';
import 'package:trokot_dealer_mobile/setType/set_type.dart';

class ProductDetailNotifier extends ChangeNotifier {
  final ProductRepository productRepository;

  String id;
  String name;
  String sku;

  late String description;
  late Decimal price;
  late int quantity;
  late ProductCategoryRef category;
  late SetTypeRef? setType;
  late CarBrandRef? carBrand;
  late CarModelRef? carModel;
  late CarBodyStyleRef? carBodyStyle;

  bool loading = false;
  bool initailLoading = true;

  ProductDetailNotifier({
    required this.productRepository,
    required this.id,
    required this.name,
    required this.sku,
  }) {
    load();
  }

  Future<void> load() async {
    try {
      loading = true;
      final product = await productRepository.getProduct(id: id);

      name = product.name;
      sku = product.sku;
      description = product.description;
      price = product.price;
      quantity = product.quantity;
      category = product.category;
      setType = product.setType;
      carBrand = product.carBrand;
      carModel = product.carModel;
      carBodyStyle = product.carBodyStyle;
      
      initailLoading = false;
    } catch (e) {
      print('+++ error: $e');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
