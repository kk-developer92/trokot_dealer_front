import 'package:flutter/material.dart';

enum PaymentMethod {
  online,
  fromBalance,
  byInvoice,
}

Future<PaymentMethod?> showPaymentMethodSelection(
    BuildContext context,
    List<
            (
              PaymentMethod value,
              String name
            )>
        list) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Container();
    },
  );
}

class PaymentMethodSelection extends StatelessWidget {
  final String currentMethod;

  const PaymentMethodSelection({
    super.key,
    required this.currentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
