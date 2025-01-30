import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/product_category/product_category.dart';

class ProductCategoryListNotifier extends ChangeNotifier {
  final ProductCategoryRepository productCategoryRepository;
  
  final bool autoLoad;
  final bool pickMode;
  final ProductCategoryRef? currentItem;

  ProductCategoryListNotifier({
    required this.productCategoryRepository,
    this.autoLoad = false,
    this.pickMode = false,
    this.currentItem,
  }) {
    loadHistory();
  }

  bool loading = false;
  bool historyMode = true;

  List<ProductCategoryItem> list = [];
  List<ProductCategoryRef> historyList = [];

    bool showSearchBarFlag = true;
  String searchString = '';
  String searchStringTemp = '';

  showSearchBar() {
    searchStringTemp = searchString;
    showSearchBarFlag = true;
    notifyListeners();
  }

  acceptSearch() {
    searchString = searchStringTemp;
    refresh();
    showSearchBarFlag = false;
    notifyListeners();
  }

  cancelSearch() {
    showSearchBarFlag = false;
    notifyListeners();
  }

  refresh() async {
    if (showSearchBarFlag) {
      searchString = searchStringTemp;
    }    
    try {
      loading = true;
      notifyListeners();

      historyMode = false;
      historyList.clear();

      list = await productCategoryRepository.getProductCategoryList(
        name: searchString.isEmpty ? null: searchString,
      );
    } catch (error) {
      print('+++ ProductCategoryNotifier.loda()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  loadHistory() async {
    try {
      loading = true;
      notifyListeners();

      historyMode = true;
      list.clear();

      historyList = await productCategoryRepository.getSelectionHistory();
    } catch (error) {
      print('+++ SetTypeListNotifier.loadHistory()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  rememberSelection(ProductCategoryRef productCategory) async {
    try {
      loading = true;
      notifyListeners();

      await productCategoryRepository.rememberSelection(productCategoryId: productCategory.id);
      historyList = historyList.where((item) => item.id != productCategory.id).toList();
    } catch (error) {
      print('+++ SetTypeListNotifier.rememberSelection()... error: $error');
    } finally {
      loading = true;
      notifyListeners();
    }
  }

  deleteSelection(ProductCategoryRef productCategory) async {
    try {
      loading = true;
      notifyListeners();

      await productCategoryRepository.deleteSelection(productCategoryId: productCategory.id);
      historyList = historyList.where((item) => item.id != productCategory.id).toList();
    } catch (error) {
      print('+++ SetTypeListNotifier.deleteSelection()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
