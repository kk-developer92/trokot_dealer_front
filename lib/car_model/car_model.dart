import 'package:trokot_dealer_mobile/car_brand/car_brand.dart';
import 'package:trokot_dealer_mobile/common/ref/model_ref.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class CarModelRepository {
  final ServiceClient serviceClient;

  CarModelRepository({
    required this.serviceClient,
  });

  Future<List<CarModelListItem>> getCarModelList({
    String? name,
    String? carBrandId,
  }) async {
    final params = <String, dynamic>{
      if (name != null) 'name': name,
      if (carBrandId != null) 'carBrandId': carBrandId,
    };
    final response = await serviceClient.callFunction(
      path: '/car-model/get-list',
      params: params,
    );
    final list = response['data'] as List;
    return list.map((item) => CarModelListItem.fromJson(item)).toList();
  }

  Future<List<CarModelRef>> getSelectionHistory() async {
    final response = await serviceClient.callFunction(path: '/car-model/get-selection-history');
    final list = response['data'] as List;
    return list.map((item) => CarModelRef.fromJson(item)).toList();
  }

  Future<void> rememberSelection({
    required String carModelId,
  }) async {
    final params = <String, dynamic>{
      'carModelId': carModelId,
    };
    await serviceClient.callFunction(
      path: '/car-model/remember-selection',
      params: params,
    );
  }

  Future<void> deleteSelection({
    required String carModelId,
  }) async {
    final params = <String, dynamic>{
      'carModelId': carModelId,
    };
    await serviceClient.callFunction(
      path: '/car-model/delete-selection',
      params: params,
    );
  }
}

class CarModelListItem {
  final String id;
  final String name;
  final CarBrandRef carBrand;

  CarModelListItem({
    required this.id,
    required this.name,
    required this.carBrand,
  });

  CarModelRef ref() => CarModelRef(id: id, repr: name);

  factory CarModelListItem.fromJson(Map<String, dynamic> json) {
    final carBrand = CarBrandRef.fromJson(json['carBrand']);
    return CarModelListItem(
      id: json['id'],
      name: '${json['name']} [${carBrand.repr}]',
      carBrand: carBrand,
    );
  }
}

class CarModelRef extends ModelRef {
  CarModelRef({
    required super.id,
    required super.repr,
  });

  factory CarModelRef.fromJson(Map<String, dynamic> json) => CarModelRef(
        id: json['id'],
        repr: json['repr'],
      );
}
