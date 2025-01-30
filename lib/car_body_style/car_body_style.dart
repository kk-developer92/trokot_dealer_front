import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/common/ref/model_ref.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class CarBodyStyleRepository {
  final ServiceClient serviceClient;

  CarBodyStyleRepository({
    required this.serviceClient,
  });

  Future<List<CarBodyStyleListItem>> getCarBodyStyleList({
    String? name,
    String? carBrandId,
  }) async {
    final params = <String, dynamic>{
      if (name != null) 'name': name,
      if (carBrandId != null) 'carBrandId': carBrandId,
    };
    final response = await serviceClient.callFunction(
      path: '/car-body-style/get-list',
      params: params,
    );
    final list = response['data'] as List;
    return list.map((item) => CarBodyStyleListItem.fromJson(item)).toList();
  }

  Future<List<CarBodyStyleRef>> getSelectionHistory() async {
    final response = await serviceClient.callFunction(path: '/car-body-style/get-selection-history');
    final list = response['data'] as List;
    return list.map((item) => CarBodyStyleRef.fromJson(item)).toList();
  }

  Future<void> rememberSelection({
    required String carBodyStyleId,
  }) async {
    final params = <String, dynamic>{
      'carBodyStyleId': carBodyStyleId,
    };
    await serviceClient.callFunction(
      path: '/car-body-style/remember-selection',
      params: params,
    );
  }

  Future<void> deleteSelection({
    required String carBodyStyleId,
  }) async {
    final params = <String, dynamic>{
      'carBodyStyleId': carBodyStyleId,
    };
    await serviceClient.callFunction(
      path: '/car-body-style/delete-selection',
      params: params,
    );
  }
}

class CarBodyStyleListItem {
  final String id;
  final String name;

  CarBodyStyleListItem({
    required this.id,
    required this.name,
  });

  CarBodyStyleRef ref() => CarBodyStyleRef(id: id, repr: name);

  factory CarBodyStyleListItem.fromJson(Map<String, dynamic> json) {
    return CarBodyStyleListItem(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CarBodyStyleRef extends ModelRef {
  CarBodyStyleRef({
    required super.id,
    required super.repr,
  });

  factory CarBodyStyleRef.fromJson(Map<String, dynamic> json) => CarBodyStyleRef(
        id: json['id'],
        repr: json['repr'],
      );
}
