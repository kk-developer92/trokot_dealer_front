import 'package:trokot_dealer_mobile/car_body_style/car_body_style.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/car_model/car_model.dart';
import 'package:trokot_dealer_mobile/product_category/product_category.dart';
import 'package:trokot_dealer_mobile/setType/set_type.dart';

class CatalogSettings {
  final String? name;
  final String? sku;
  final ProductCategoryRef? category;
  final SetTypeRef? setType;
  final CarBrandRef? carBrand;
  final CarModelRef? carModel;
  final CarBodyStyleRef? carBodyStyle;
  final bool inStock;

  CatalogSettings({
    this.name,
    this.sku,
    this.category,
    this.setType,
    this.carBrand,
    this.carModel,
    this.carBodyStyle,
    this.inStock = false,
  });
}
