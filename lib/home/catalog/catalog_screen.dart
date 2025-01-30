import 'package:flutter/material.dart';
import 'package:trokot_dealer_mobile/home/catalog/catalog_notifier.dart';
import 'package:trokot_dealer_mobile/product/product.dart';

import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/catalog_settings/catalog_settings_screen.dart';
import 'package:trokot_dealer_mobile/product/product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CatalogNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => state.refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              final newSettings = await showCatalogSettingsScreen(context, state.settings);
              if (newSettings != null) {
                state.setSettings(newSettings);
              }
            },
          )
        ],
      ),
      body: ProductListWidget(state.list),
      // body: Text('${catalogProvider.list.length}'),
    );
  }
}

class ProductListWidget extends StatefulWidget {
  final List<ProductItem> list;

  const ProductListWidget(this.list, {super.key});

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: widget.list.length,
      // itemExtent: -40,
      itemBuilder: (context, index) {
        final item = widget.list[index];
        return ProductItemWidget(key: ValueKey(item.id), item);
      },
    );
  }
}

class ProductItemWidget extends StatelessWidget {
  final ProductItem item;

  const ProductItemWidget(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(item.id),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text('${item.price.toString()} ₽'),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(item.sku),
          ),
          Text('${item.quantity} шт.'),
        ],
      ),
      onTap: () => showProductDetailScreen(
        context,
        id: item.id,
        name: item.name,
        sku: item.sku,
      ),
    );
  }
}
