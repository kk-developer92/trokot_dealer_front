
import 'package:decimal/decimal.dart';
import 'package:trokot_dealer_mobile/product/product.dart';

class CheckoutItem {
  final ProductRef product;
  final String sku;
  final Decimal quantity;
  final Decimal price;
  final Decimal totalPrice;

  CheckoutItem({
    required this.product,
    required this.sku,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });  
}