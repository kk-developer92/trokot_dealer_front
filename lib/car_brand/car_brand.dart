import 'package:trokot_dealer_mobile/common/ref/model_ref.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class CarBrandRepository {
  final ServiceClient serviceClient;

  CarBrandRepository({
    required this.serviceClient,
  });

  Future<List<CarBrandListItem>> getCarBrandList({
    String? name,
  }) async {
    final params = <String, dynamic>{
      if (name != null) 'name': name,
    };
    final response = await serviceClient.callFunction(
      path: '/car-brand/get-list',
      params: params,
    );
    final list = response['data'] as List;
    return list.map((item) => CarBrandListItem.fromJson(item)).toList();
  }

  Future<List<CarBrandRef>> getSelectionHistory() async {
    final response = await serviceClient.callFunction(path: '/car-brand/get-selection-history');
    final list = response['data'] as List;
    return list.map((item) => CarBrandRef.fromJson(item)).toList();
  }

  Future<void> rememberSelection({
    required String carBrandId,
  }) async {
    final params = <String, dynamic>{
      'carBrandId': carBrandId,
    };
    await serviceClient.callFunction(
      path: '/car-brand/remember-selection',
      params: params,
    );
  }

  Future<void> deleteSelection({
    required String carBrandId,
  }) async {
    final params = <String, dynamic>{
      'carBrandId': carBrandId,
    };
    await serviceClient.callFunction(
      path: '/car-brand/delete-selection',
      params: params,
    );
  }
}

class CarBrandListItem {
  final String id;
  final String name;

  CarBrandListItem({
    required this.id,
    required this.name,
  });

  CarBrandRef ref() => CarBrandRef(id: id, repr: name);

  factory CarBrandListItem.fromJson(Map<String, dynamic> json) => CarBrandListItem(
        id: json['id'],
        name: json['name'],
      );
}

class CarBrandRef extends ModelRef {
  CarBrandRef({
    required super.id,
    required super.repr,
  });

  factory CarBrandRef.fromJson(Map<String, dynamic> json) => CarBrandRef(
        id: json['id'],
        repr: json['repr'],
      );
}
