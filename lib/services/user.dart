import 'package:decimal/decimal.dart';
import 'package:trokot_dealer_mobile/partner/partner.dart';

class User {
  final String id;
  final String name;
  final Partner partner;
  final Decimal balance;

  User({
    required this.id,
    required this.name,
    required this.partner,
    required this.balance,    
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      partner: Partner.fromJson(json['partner']),
      balance: Decimal.parse(json['balance']),
    );
  }
}