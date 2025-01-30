import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/cart/cart_notifier.dart';
import 'package:trokot_dealer_mobile/common/ui/decimal_field.dart';
import 'package:trokot_dealer_mobile/product/product.dart';
import 'package:trokot_dealer_mobile/product/product_detail_notifier.dart';

Future<void> showProductDetailScreen(
  BuildContext context, {
  required String id,
  required name,
  required String sku,
}) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailScreen(
        id: id,
        name: name,
        sku: sku,
      ),
    ),
  );
}

class ProductDetailScreen extends StatelessWidget {
  final String id;
  final String name;
  final String sku;

  const ProductDetailScreen({
    super.key,
    required this.id,
    required this.name,
    required this.sku,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetailNotifier(
        productRepository: context.read<ProductRepository>(),
        id: id,
        name: name,
        sku: sku,
      ),
      child: Consumer<ProductDetailNotifier>(
        builder: (context, state, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Карточка товара'),
          ),
          body: detailWidget(state),
          // floatingActionButton: ButtonsBlock(state: state),
          // bottomSheet: Container(
          //   height: 30,
          //   color: Colors.pink,
          // ),
          bottomSheet: ButtonsBlock(state: state),
        ),
      ),
    );
  }
}

Widget detailWidget(ProductDetailNotifier state) {
  if (state.initailLoading) {
    return DetailWidgetPre(state: state);
  } else {
    return DetailWidgetPost(state: state);
  }
}

class DetailWidgetPre extends StatelessWidget {
  final ProductDetailNotifier state;

  const DetailWidgetPre({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DetailWidgetPost extends StatelessWidget {
  final ProductDetailNotifier state;

  const DetailWidgetPost({
    super.key,
    required this.state,
  });

  final headerTextStyle = const TextStyle(fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Наименование',
              style: headerTextStyle,
            ),
            Text(state.name),
            const SizedBox(height: 10),
            Text(
              'Артикул',
              style: headerTextStyle,
            ),
            const SizedBox(height: 10),
            Text(state.sku),
            const SizedBox(height: 10),
            Text(
              'Категория',
              style: headerTextStyle,
            ),
            Text(state.category.repr),
            const SizedBox(height: 10),
            Text(
              'Вид комплекта',
              style: headerTextStyle,
            ),
            Text(state.setType?.repr ?? ''),
            const SizedBox(height: 10),
            Text(
              'Марка автомобиля',
              style: headerTextStyle,
            ),
            Text(state.carBrand?.repr ?? ''),
            const SizedBox(height: 10),
            Text(
              'Модель автомобиля',
              style: headerTextStyle,
            ),
            Text(state.carModel?.repr ?? ''),
            const SizedBox(height: 10),
            Text(
              'Кузов автомобиля',
              style: headerTextStyle,
            ),
            Text(state.carBodyStyle?.repr ?? ''),
            const SizedBox(height: 10),
            Text(
              'Описание',
              style: headerTextStyle,
            ),
            Text(state.description),
            const SizedBox(height: 10),
            Text(
              'Цена',
              style: headerTextStyle,
            ),
            Text('${state.price} ₽'),
            const SizedBox(height: 10),
            Text(
              'Остаток',
              style: headerTextStyle,
            ),
            Text('${state.quantity} шт.'),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class ButtonsBlock_old extends StatelessWidget {
  final ProductDetailNotifier state;

  const ButtonsBlock_old({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifier>(
      builder: (context, cartProvider, child) {
        final quantity = cartProvider.productList.where((element) => element.product.id == state.id).fold(Decimal.zero, (quantity, cartItem) => quantity + cartItem.quantity);

        return ElevatedButton(
          onPressed: () {
            cartProvider.addProduct(ProductRef(id: state.id, repr: state.name));
          },
          child: Text('Заказать (${quantity.toString()})'),
        );
      },
    );
  }
}

class ButtonsBlock extends StatelessWidget {
  final ProductDetailNotifier state;

  const ButtonsBlock({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartNotifier>(
      builder: (context, cartProvider, child) {
        final quantity = cartProvider.productList.where((element) => element.product.id == state.id).fold(Decimal.zero, (quantity, cartItem) => quantity + cartItem.quantity);

        if (quantity == Decimal.zero) {
        } else {}

        return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            // color: Colors.pink,
            child: quantity == Decimal.zero
                ? ElevatedButton(
                    onPressed: () {
                      if (state.price > Decimal.zero) {
                        cartProvider.addProduct(ProductRef(id: state.id, repr: state.name));
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text('Нельзя заказать товар с не установленной ценой'),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text('Заказать'),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          cartProvider.removeProduct(ProductRef(id: state.id, repr: state.name));
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 100,
                        child: AppDecimalField(
                          value: quantity,
                          decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.all(10)),
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          // style: const TextStyle(fontSize: 12),
                          onChanged: (value) => cartProvider.setProduct(
                            ProductRef(id: state.id, repr: state.name),
                            value,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          cartProvider.addProduct(ProductRef(id: state.id, repr: state.name));
                        },
                        icon: const Icon(Icons.add),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => cartProvider.setProduct(
                          ProductRef(id: state.id, repr: state.name),
                          Decimal.zero,
                        ),
                        icon: const Icon(Icons.delete_forever),
                      ),
                      // ElevatedButton(
                      //   onPressed: () => cartProvider.setProduct(
                      //     ProductRef(id: state.id, repr: state.name),
                      //     Decimal.zero,
                      //   ),
                      //   child: const Icon(Icons.delete_forever),
                      // ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.done),
                      ),
                    ],
                  ));
      },
    );
  }
}
