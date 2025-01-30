import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/product_category/product_category.dart';
import 'package:trokot_dealer_mobile/product_category/product_category_notifier.dart';

Future<ProductCategoryRef?> pickProductCategory({
  required BuildContext context,
  ProductCategoryRef? currentItem,
}) async {
  return await Navigator.push<ProductCategoryRef>(
    context,
    MaterialPageRoute(
      builder: (context) => ProductCategoryScreen(
        pickMode: true,
        currentItem: currentItem,
      ),
    ),
  );
}

class ProductCategoryScreen extends StatelessWidget {
  final bool pickMode;
  final ProductCategoryRef? currentItem;

  const ProductCategoryScreen({
    super.key,
    this.pickMode = false,
    this.currentItem,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProductCategoryListNotifier>(
      create: (context) => ProductCategoryListNotifier(
        productCategoryRepository: context.read<ProductCategoryRepository>(),
        autoLoad: true,
        pickMode: pickMode,
        currentItem: currentItem,
      ),
      child: Consumer<ProductCategoryListNotifier>(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Категории товара'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: state.refresh,
              ),
            ],
          ),
          body: state.historyMode ? HistoryListView(state: state) : ItemListView(list: state.list),
          floatingActionButton: FloatingButton(state: state),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomSheet: state.showSearchBarFlag ? SearchWidget(state: state) : null,
        ),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  final ProductCategoryListNotifier state;

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


class ItemListView extends StatefulWidget {
  final List<ProductCategoryItem> list;

  const ItemListView({
    super.key,
    required this.list,
  });

  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        final item = widget.list[index];
        return ItemWidget(
          key: ValueKey(item.id),
          item: item,
        );
      },
    );
  }
}

class ItemWidget extends StatelessWidget {
  final ProductCategoryItem item;

  const ItemWidget({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<ProductCategoryListNotifier>();

    return ListTile(
      title: Text(item.name),
      onTap: () {
        if (state.pickMode) {
          state.rememberSelection(item.ref());
          Navigator.pop(context, item.ref());
        }
      },
    );
  }
}

class HistoryListView extends StatefulWidget {
  final ProductCategoryListNotifier state;

  const HistoryListView({
    super.key,
    required this.state,
  });

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
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
  final ProductCategoryListNotifier state;

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
