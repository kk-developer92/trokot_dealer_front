import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trokot_dealer_mobile/auth/auth_guard.dart';
import 'package:trokot_dealer_mobile/car_body_style/car_body_style.dart';
import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/car_model/car_model.dart';
import 'package:trokot_dealer_mobile/cart/cart.dart';
import 'package:trokot_dealer_mobile/common/ui/theme.dart';
import 'package:trokot_dealer_mobile/home/home_screen.dart';
import 'package:trokot_dealer_mobile/order/order.dart';
import 'package:trokot_dealer_mobile/payment/payment.dart';
import 'package:trokot_dealer_mobile/product/product.dart';
import 'package:trokot_dealer_mobile/product_category/product_category.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

import 'package:trokot_dealer_mobile/common/events.dart';

import 'package:provider/provider.dart';
import 'package:trokot_dealer_mobile/setType/set_type.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // debugPaintSizeEnabled = false;

  // const baseUrl = 'http://192.168.50.101:3000';
  // const baseUrl = 'http://10.0.2.2:3000';
  // const baseUrl = 'http://localhost:3000';
  const baseUrl = 'https://trokot-dealer.dzenroamer.ru/api';

  print('+++ baseUrl: ${baseUrl}');

  // get saved token from device store
  final String? token = 'hIE8PP3eDHOeJsNzuS-RwNpNhTSobd0xD3G-F-eQ';
  // final String? token = 'xxx';

  final eventBus = EventBus.broadcast();

  final serviceClient = ServiceClient(
    baseUrl: baseUrl,
    token: token,
    eventBus: eventBus,
  );

  if (token != null) {
    try {
      await serviceClient.ping();
    } catch (e) {
      print('+++ saved token not valid...');
    }
  }

  final globalNavigator = GlobalKey<NavigatorState>();

  final productRepository = ProductRepository(serviceClient: serviceClient);
  final productCategoryRepository = ProductCategoryRepository(serviceClient: serviceClient);
  final cartRepository = CartRepository(serviceClient: serviceClient);
  final orderRepository = OrderRepository(serviceClient: serviceClient);
  final setTypeRepository = SetTypeRepository(serviceClient: serviceClient);
  final carBrandRepository = CarBrandRepository(serviceClient: serviceClient);
  final carModelRepository = CarModelRepository(serviceClient: serviceClient);
  final carBodyStyleRepository = CarBodyStyleRepository(serviceClient: serviceClient);
  final paymentRepository = PaymentRepository(serviceClient: serviceClient);

  Provider.debugCheckInvalidValueType = null;

  runApp(MultiProvider(
    providers: [
      Provider<GlobalKey<NavigatorState>>.value(value: globalNavigator),
      Provider<ServiceClient>.value(value: serviceClient),
      Provider<ProductRepository>.value(value: productRepository),
      Provider<ProductCategoryRepository>.value(value: productCategoryRepository),
      Provider<CartRepository>.value(value: cartRepository),
      Provider<OrderRepository>.value(value: orderRepository),
      Provider<PaymentRepository>.value(value: paymentRepository),
      // EventBus
      Provider<EventBus>.value(value: eventBus),
      // Misc
      Provider<SetTypeRepository>.value(value: setTypeRepository),
      Provider<CarBrandRepository>.value(value: carBrandRepository),
      Provider<CarModelRepository>.value(value: carModelRepository),
      Provider.value(value: carBodyStyleRepository),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trokot Dealer App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      navigatorKey: context.read<GlobalKey<NavigatorState>>(),

      home: Consumer<ServiceClient>(
        builder: (context, serviceClient, child) => AuthGuard(
          user: serviceClient.user,
          userStream: serviceClient.userStream,
          child: const HomeScreen(),
        ),
      ),
      // home: NavigationExample(),
    );
  }
}
