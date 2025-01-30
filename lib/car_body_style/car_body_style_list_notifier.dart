import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/car_body_style/car_body_style.dart';

class CarBodyStyleListNotifier extends ChangeNotifier {
  final CarBodyStyleRepository carBodyStyleRepository;
  final CarBrandRef? carBrand;

  final bool autoLoad;
  final bool pickMode;
  final CarBodyStyleRef? currentItem;

  CarBodyStyleListNotifier({
    required this.carBodyStyleRepository,
    this.carBrand,
    this.autoLoad = false,
    this.pickMode = false,
    this.currentItem,
  }) {
    loadHistory();
  }

  bool loading = false;
  bool historyMode = true;

  List<CarBodyStyleListItem> list = [];
  List<CarBodyStyleRef> historyList = [];

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

  Future<void> refresh() async {
    if (showSearchBarFlag) {
      searchString = searchStringTemp;
    }
    try {
      loading = true;
      notifyListeners();

      historyMode = false;
      historyList.clear();

      list = await carBodyStyleRepository.getCarBodyStyleList(
        name: searchString.isEmpty ? null : searchString,
        carBrandId: carBrand?.id,
      );
    } catch (error) {
      print('+++ CarBodyStyleListNotifier.load()... error: $error');
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

      historyList = await carBodyStyleRepository.getSelectionHistory();
    } catch (error) {
      print('+++ CarBodyStyleListNotifier.loadHistory()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  rememberSelection(CarBodyStyleRef carBodyStyle) async {
    try {
      loading = true;
      notifyListeners();

      await carBodyStyleRepository.rememberSelection(carBodyStyleId: carBodyStyle.id);
    } catch (error) {
      print('+++ CarBodyStyleListNotifier.rememberSelection()... $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  deleteSelection(CarBodyStyleRef carBodyStyle) async {
    try {
      loading = true;
      notifyListeners();

      await carBodyStyleRepository.deleteSelection(carBodyStyleId: carBodyStyle.id);
      historyList = historyList.where((item) => item.id != carBodyStyle.id).toList();
    } catch (error) {
      print('+++ SetTypeListNotifier.deleteSelection()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
