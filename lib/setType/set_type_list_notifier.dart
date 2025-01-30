import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/setType/set_type.dart';

class SetTypeListNotifier extends ChangeNotifier {
  final SetTypeRepository setTypeRepository;

  final bool autoLoad;
  final bool pickMode;
  final SetTypeRef? currentItem;

  SetTypeListNotifier({
    required this.setTypeRepository,
    this.autoLoad = false,
    this.pickMode = false,
    this.currentItem,
  }) {
      loadHistory();
  }

  bool loading = false;
  bool historyMode = true;

  List<SetTypeListItem> list = [];
  List<SetTypeRef> historyList = [];

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

      list = await setTypeRepository.getSetTypeList(
        name: searchString.isEmpty ? null : searchString,
        );
    } catch (error) {
      print('+++ SetTypeListNotifier.load()... error: $error');
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

      historyList = await setTypeRepository.getSelectionHistory();
    } catch (error) {
      print('+++ SetTypeListNotifier.loadHistory()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  rememberSelection(SetTypeRef setType) async {
    try {
      loading = true;
      notifyListeners();

      await setTypeRepository.rememberSelection(setTypeId: setType.id);
    } catch (error) {
      print('+++ SetTypeListNotifier.rememberSelection()... error: $error');
    } finally {
      loading = true;
      notifyListeners();
    }
  }

  deleteSelection(SetTypeRef setType) async {
    try {
      loading = true;
      notifyListeners();

      await setTypeRepository.deleteSelection(setTypeId: setType.id);
      historyList = historyList.where((item) => item.id != setType.id).toList();
    } catch (error) {
      print('+++ SetTypeListNotifier.deleteSelection()... error: $error');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
