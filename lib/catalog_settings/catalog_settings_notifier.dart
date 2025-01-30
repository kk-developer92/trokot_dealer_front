import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/car_body_style/car_body_style.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/car_model/car_model.dart';
import 'package:trokot_dealer_mobile/product_category/product_category.dart';
import 'package:trokot_dealer_mobile/catalog_settings/catalog_settings.dart';
import 'package:trokot_dealer_mobile/setType/set_type.dart';

class CatalogSettingsNotifier extends ChangeNotifier {
  CatalogSettingsNotifier(CatalogSettings catalogSettings) {
    name = catalogSettings.name;
    sku = catalogSettings.sku;
    category = catalogSettings.category;
    setType = catalogSettings.setType;
    carBrand = catalogSettings.carBrand;
    carModel = catalogSettings.carModel;
    carBodyStyle = catalogSettings.carBodyStyle;
    inStock = catalogSettings.inStock;    
  }

  String? name;
  setName(String? value) {
    name = value;
    notifyListeners();
  }

  String? sku;
  setSku(String? value) {
    sku = value;
    notifyListeners();
  }

  ProductCategoryRef? category;
  setCategory(ProductCategoryRef? value) {
    category = value;
    notifyListeners();
  }

  SetTypeRef? setType;
  setSetType(SetTypeRef? value) {
    setType = value;
    notifyListeners();
  }

  CarBrandRef? carBrand;
  setCarBrand(CarBrandRef? value) {
    carBrand = value;

    notifyListeners();
  }

  CarModelRef? carModel;
  setCarModel(CarModelRef? value) {
    carModel = value;
    notifyListeners();
  }

  CarBodyStyleRef? carBodyStyle;
  setCarBodyStyle(CarBodyStyleRef? value) {
    carBodyStyle = value;
    notifyListeners();
  }  

  late bool inStock;
  setInStock(bool value) {
    inStock = value;
    notifyListeners();
  }
}
