import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/car_model/car_model.dart';

class CarModelListNotifier extends ChangeNotifier {
  final CarModelRepository carModelRepository;
  final CarBrandRef? carBrand;

  final bool autoLoad;
  final bool pickMode;
  final CarModelRef? currentItem;

  CarModelListNotifier({
    required this.carModelRepository,
    this.carBrand,
    this.autoLoad = false,
    this.pickMode = false,
    this.currentItem,
  }) {
    loadHistory();
  }

  bool loading = false;
  bool historyMode = true;

  List<CarModelListItem> list = [];
  List<CarModelRef> historyList = [];

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

      list = await carModelRepository.getCarModelList(
        name: searchString.isEmpty ? null : searchString,
        carBrandId: carBrand?.id,
      );
    } catch (error) {
      print('+++ CarModelListNotifier.load()... error: $error');
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

      historyList = await carModelRepository.getSelectionHistory();
    } catch (error) {
      print('+++ CarModelListNotifier.loadHistory()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  rememberSelection(CarModelRef carModel) async {
    try {
      loading = true;
      notifyListeners();

      await carModelRepository.rememberSelection(carModelId: carModel.id);
    } catch (error) {
      print('+++ CarModelListNotifier.rememberSelection()... $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  deleteSelection(CarModelRef setType) async {
    try {
      loading = true;
      notifyListeners();

      await carModelRepository.deleteSelection(carModelId: setType.id);
      historyList = historyList.where((item) => item.id != setType.id).toList();
    } catch (error) {
      print('+++ SetTypeListNotifier.deleteSelection()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
