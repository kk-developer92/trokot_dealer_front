import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/cart/cart.dart';
import 'package:trokot_dealer_mobile/cart/cart_events.dart';
import 'package:trokot_dealer_mobile/cart/cart_notifier.dart';
import 'package:trokot_dealer_mobile/cart/cart_screen.dart';
import 'package:trokot_dealer_mobile/home/catalog/catalog_notifier.dart';
import 'package:trokot_dealer_mobile/home/catalog/catalog_screen.dart';
import 'package:trokot_dealer_mobile/home/profile/profile_screen.dart';
import 'package:trokot_dealer_mobile/order/order.dart';
import 'package:trokot_dealer_mobile/order/order_events.dart';
import 'package:trokot_dealer_mobile/order/order_list_notifier.dart';
import 'package:trokot_dealer_mobile/order/order_list_screen.dart';
import 'package:trokot_dealer_mobile/product/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;

  final List<Widget> pages = [
    Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => const CatalogScreen(),
      ),
    ),
    Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    ),
    Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => const OrderListScreen(),
      ),
    ),
    Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CatalogNotifier(
            productRepository: context.read<ProductRepository>(),
            autoRefresh: true,
          ),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => CartNotifier(
            cartRepository: context.read<CartRepository>(),
            eventBus: context.read<EventBus>(),
            autoRefresh: true,
          ),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => OrderListNotifier(
            orderRepository: context.read<OrderRepository>(),
            eventBus: context.read<EventBus>(),
            autoRefresh: true,
          ),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: currentPageIndex,
          children: pages,
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(CupertinoIcons.list_bullet),
              label: 'Каталог',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.cart),
              label: 'Корзина',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.arrow_down_square),
              label: 'Заказы',
            ),
            NavigationDestination(
              icon: Icon(CupertinoIcons.profile_circled),
              label: 'Профиль',
            ),
          ],
          selectedIndex: currentPageIndex,
        ),
      ),
    );
  }
}
