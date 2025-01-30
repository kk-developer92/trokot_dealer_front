import 'package:trokot_dealer_mobile/common/ref/model_ref.dart';

class Partner {
  final String id;
  final String name;
  final String tin;

  Partner({
    required this.id,
    required this.name,
    required this.tin,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'],
      tin: json['tin'],
    );
  }
}

class PartnerRef extends ModelRef {
  PartnerRef({
    required super.id,
    required super.repr,
  });

  factory PartnerRef.fromJson(Map<String, dynamic> json) => PartnerRef(
    id: json['id'],
    repr: json['repr'],
  );
}
