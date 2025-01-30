import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/product/product.dart';
import 'package:trokot_dealer_mobile/catalog_settings/catalog_settings.dart';

class CatalogNotifier extends ChangeNotifier {
  final ProductRepository productRepository;
  final bool autoRefresh;

  CatalogNotifier({
    required this.productRepository,
    this.autoRefresh = false,
  }) {
    if (autoRefresh) {
      refresh();
    }
  }

  CatalogSettings settings = CatalogSettings();

  bool loading = false;

  final StreamController<String> _errorStreamController = StreamController<String>.broadcast();
  Stream<String> get errorStream => _errorStreamController.stream;

  void displayError(String errorMessage) {
    _errorStreamController.sink.add(errorMessage);
  }

  List<ProductItem> list = [];

  refresh() async {
    try {
      loading = true;
      notifyListeners();

      String? categoryId;
      if (settings.category != null) {
        categoryId = settings.category!.id;
      }

      String? setTypeId;
      if (settings.setType != null) {
        setTypeId = settings.setType!.id;
      }

      String? carBrandId;
      if (settings.carBrand != null) {
        carBrandId = settings.carBrand!.id;
      }

      String? carModelId;
      if (settings.carModel != null) {
        carModelId = settings.carModel!.id;
      }

      String? carBodyStyleId;
      if (settings.carBodyStyle != null) {
        carBodyStyleId = settings.carBodyStyle!.id;
      }
      print('+++ carBodyStyleId: $carBodyStyleId');


      list = await productRepository.getProductList(
        name: settings.name,
        sku: settings.sku,
        categoryId: categoryId,
        setTypeId: setTypeId,
        carBrandId: carBrandId,
        carModelId: carModelId,        
        carBodyStyleId: carBodyStyleId,
        inStock: settings.inStock,
        skip: 0,
        limit: 300,
      );
    } catch (e) {
      displayError(e.toString());
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _errorStreamController.close();
  }

  setSettings(CatalogSettings settings) {
    this.settings = settings;
    print('+++ settings.carBodyStyleRef: ${settings.carBodyStyle?.repr}');
    refresh();
  }
}
