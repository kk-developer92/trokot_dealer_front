import 'package:flutter/material.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';

class CarBrandListNotifier extends ChangeNotifier {
  final CarBrandRepository carBrandRepository;

  final bool autoLoad;
  final bool pickMode;
  final CarBrandRef? currentItem;

  CarBrandListNotifier({
    required this.carBrandRepository,
    this.autoLoad = false,
    this.pickMode = false,
    this.currentItem,
  }) {
    loadHistory();
  }

  bool loading = false;
  bool historyMode = true;

  List<CarBrandListItem> list = [];
  List<CarBrandRef> historyList = [];

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

      list = await carBrandRepository.getCarBrandList(
        name: searchString.isEmpty ? null : searchString,
      );
    } catch (error) {
      print('+++ CarBrandListNotifier.load()... error: $error');
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

      historyList = await carBrandRepository.getSelectionHistory();
    } catch (error) {
      print('+++ CarBrandListNotifier.loadHistory()... error: ${error}');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  rememberSelection(CarBrandRef carBrand) async {
    try {
      loading = true;
      notifyListeners();

      await carBrandRepository.rememberSelection(carBrandId: carBrand.id);
      historyList = historyList.where((item) => item.id != carBrand.id).toList();
    } catch (error) {
      print('+++ CarBrandListNotifier.rememberSelection()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  deleteSelection(CarBrandRef carBrand) async {
    try {
      loading = true;
      notifyListeners();

      await carBrandRepository.deleteSelection(carBrandId: carBrand.id);
      historyList = historyList.where((item) => item.id != carBrand.id).toList();
    } catch (error) {
      print('+++ CarBrandListNotifier.deleteSelection()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
