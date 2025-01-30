import 'package:decimal/decimal.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class PaymentRepository {
  final ServiceClient serviceClient;

  PaymentRepository({
    required this.serviceClient,
  });

  Future<
      ({
        String id,
        String paymentUrl
      })> create({
    required Decimal amount,
    required String orderId,
    required String customerId,
    String? idempotenceKey,
  }) async {


    return (
      id: '111-222-333',
      paymentUrl: 'http://localhost',
    );
  }
}
