import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/car_model/car_model.dart';
import 'package:trokot_dealer_mobile/car_model/car_model_list_notifier.dart';

Future<CarModelRef?> pickCarModel({
  required BuildContext context,
  CarModelRef? currentItem,
  CarBrandRef? carBrand,
}) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CarModelListScreen(
        pickMode: true,
        currentItem: currentItem,
        carBrand: carBrand,
      ),
    ),
  );
}

class CarModelListScreen extends StatelessWidget {
  final bool pickMode;
  final CarModelRef? currentItem;

  final CarBrandRef? carBrand;

  const CarModelListScreen({
    super.key,
    this.pickMode = false,
    this.currentItem,
    this.carBrand,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarModelListNotifier(
        carModelRepository: context.read<CarModelRepository>(),
        carBrand: carBrand,
        autoLoad: true,
        pickMode: true,
      ),
      child: Consumer<CarModelListNotifier>(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            title: const Text("Модели автомобилей"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state.refresh,
              ),
            ],
          ),
          body: state.historyMode ? CarModelHistoryListView(state: state) : CarModelListView(state: state),
          floatingActionButton: FloatingButton(state: state),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomSheet: state.showSearchBarFlag ? SearchWidget(state: state) : null,
        ),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  final CarModelListNotifier state;

  const FloatingButton({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (state.showSearchBarFlag)
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: state.acceptSearch,
          ),
        if (state.showSearchBarFlag)
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: state.cancelSearch,
          ),
        if (!state.showSearchBarFlag)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: state.showSearchBar,
          ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: state.refresh,
        )
      ],
    );
  }
}

class CarModelListView extends StatefulWidget {
  final CarModelListNotifier state;

  const CarModelListView({
    super.key,
    required this.state,
  });

  @override
  State<CarModelListView> createState() => _CarModelListViewState();
}

class _CarModelListViewState extends State<CarModelListView> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return ListView.builder(
      controller: scrollController,
      itemCount: state.list.length,
      itemBuilder: (context, index) {
        final item = state.list[index];
        return ListTile(
            key: ValueKey(item.id),
            title: Text(item.name),
            subtitle: Text(item.carBrand.repr),
            onTap: () {
              if (state.pickMode) {
                state.rememberSelection(item.ref());
                Navigator.pop(context, item.ref());
              }
            });
      },
    );
  }
}

class CarModelHistoryListView extends StatefulWidget {
  final CarModelListNotifier state;

  const CarModelHistoryListView({
    super.key,
    required this.state,
  });

  @override
  State<CarModelHistoryListView> createState() => _CarModelHistoryListViewState();
}

class _CarModelHistoryListViewState extends State<CarModelHistoryListView> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return ListView.builder(
      controller: scrollController,
      itemCount: state.historyList.length,
      itemBuilder: (context, index) {
        final item = state.historyList[index];
        return ListTile(
          key: ValueKey(item.id),
          title: Text(item.repr),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => state.deleteSelection(item),
          ),
          onTap: () {
            if (state.pickMode) {
              state.rememberSelection(item);
              Navigator.pop(context, item);
            }
          },
        );
      },
    );
  }
}

class SearchWidget extends StatefulWidget {
  final CarModelListNotifier state;

  const SearchWidget({
    super.key,
    required this.state,
  });

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.state.searchStringTemp;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        left: 5,
        right: 5,
        bottom: 5,
      ),
      child: TextField(
        autofocus: true,
        controller: controller,
        decoration: InputDecoration(
          label: const Text('Наименование'),
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.text = '';
              widget.state.searchStringTemp = '';
            },
          ),
        ),
        onChanged: (value) {
          widget.state.searchStringTemp = value;
        },
        onEditingComplete: () {
          widget.state.acceptSearch();
        },
      ),
    );
  }
}

