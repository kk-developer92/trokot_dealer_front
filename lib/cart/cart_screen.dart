import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/cart/cart.dart';
import 'package:trokot_dealer_mobile/cart/cart_notifier.dart';
import 'package:trokot_dealer_mobile/common/ui/decimal_field.dart';
import 'package:trokot_dealer_mobile/home/checkout/checkout.dart';
import 'package:trokot_dealer_mobile/home/checkout/checkout_screen.dart';
import 'package:trokot_dealer_mobile/product/product_detail_screen.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CartNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: state.refresh,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              ...state.productList
                  .map((item) => CartItemTile(
                        item: item,
                        state: state,
                      ))
                  .toList(),
              const SizedBox(height: 50),
            ],

            // children: [
            //   Expanded(
            //     child: ListView.separated(
            //       itemCount: state.productList.length,
            //       itemBuilder: (context, index) {
            //         final item = state.productList[index];
            //         return CartItemTile(
            //           item: item,
            //           state: state,
            //         );
            //       },
            //       separatorBuilder: (context, index) => const SizedBox(height: 10),

            //     ),
            //   ),
            // ],
          ),
        ),
      ),
      floatingActionButton: ButtonsBlock(
        cartProvider: state,
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final CartNotifier state;

  const CartItemTile({
    super.key,
    required this.item,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(item.id),
      // tileColor: Colors.pink,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),

      title: Text(
        item.product.repr,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        'Цена: ${item.price} ₽, Сумма: ${item.totalPrice} ₽',
        style: const TextStyle(fontSize: 12),
      ),
      trailing: SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 70,
              // height: 100,
              child: AppDecimalField(
                value: item.quantity,
                onChanged: (value) => state.setProduct(item.product, value),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () => state.setProduct(item.product, Decimal.zero),
            ),
          ],
        ),
      ),
      onTap: () => showProductDetailScreen(context, id: item.product.id, name: item.product.repr, sku: item.sku),
    );
  }
}

class ButtonsBlock extends StatelessWidget {
  final CartNotifier cartProvider;

  const ButtonsBlock({
    super.key,
    required this.cartProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (cartProvider.productList.isNotEmpty)
          ElevatedButton(
            onPressed: cartProvider.clear,
            child: const Text('Очистить'),
          ),
        const SizedBox(width: 10),
        if (cartProvider.productList.isNotEmpty)
          ElevatedButton(
            onPressed: () => showCheckOutScreen(
              context: context,
              partner: context.read<ServiceClient>().user!.partner,
              itemList: cartProvider.productList
                  .map((e) => CheckoutItem(
                        product: e.product,
                        sku: e.sku,
                        quantity: e.quantity,
                        price: e.price,
                        totalPrice: e.totalPrice,
                      ))
                  .toList(),
              totalPrice: cartProvider.totalPrice,
            ),
            child: Text('Заказать (${cartProvider.totalPrice} ₽)'),
          ),
      ],
    );
  }
}
