import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand_list_notifier.dart';

Future<CarBrandRef?> pickCarBrand({
  required BuildContext context,
  CarBrandRef? currentItem,
}) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CarBrandListScreen(
        pickMode: true,
        currentItem: currentItem,
      ),
    ),
  );
}

class CarBrandListScreen extends StatelessWidget {
  final bool pickMode;
  final CarBrandRef? currentItem;

  const CarBrandListScreen({
    super.key,
    this.pickMode = false,
    this.currentItem,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CarBrandListNotifier(
        carBrandRepository: context.read(),
        autoLoad: true,
        pickMode: true,
      ),
      child: Consumer<CarBrandListNotifier>(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            title: const Text("Марки автомобилей"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state.refresh,
              ),
            ],
          ),
          body: state.historyMode ? CarBrandHistoryListView(state: state) : CarBrandListView(state: state),
          floatingActionButton: FloatingButton(state: state),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomSheet: state.showSearchBarFlag ? SearchWidget(state: state) : null,
        ),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  final CarBrandListNotifier state;

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

class CarBrandListView extends StatefulWidget {
  final CarBrandListNotifier state;

  const CarBrandListView({
    super.key,
    required this.state,
  });

  @override
  State<CarBrandListView> createState() => _CarBrandListViewState();
}

class _CarBrandListViewState extends State<CarBrandListView> {
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
          onTap: () {
            if (state.pickMode) {
              state.rememberSelection(item.ref());
              Navigator.pop(context, item.ref());
            }
          },
        );
      },
    );
  }
}

class CarBrandHistoryListView extends StatefulWidget {
  final CarBrandListNotifier state;

  const CarBrandHistoryListView({
    super.key,
    required this.state,
  });

  @override
  State<CarBrandHistoryListView> createState() => _CarBrandHistoryListViewState();
}

class _CarBrandHistoryListViewState extends State<CarBrandHistoryListView> {
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
  final CarBrandListNotifier state;

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
