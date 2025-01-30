import 'package:trokot_dealer_mobile/common/ref/model_ref.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class SetTypeRepository {
  final ServiceClient serviceClient;

  SetTypeRepository({
    required this.serviceClient,
  });

  Future<List<SetTypeListItem>> getSetTypeList({
    String? name,
  }) async {
    final params = <String, dynamic>{
      if (name != null) 'name': name,
    };
    final response = await serviceClient.callFunction(
      path: '/set-type/get-list',
      params: params,
    );
    final list = response['data'] as List;
    return list.map((item) => SetTypeListItem.fromJson(item)).toList();
  }

  Future<List<SetTypeRef>> getSelectionHistory() async {
    final response = await serviceClient.callFunction(path: '/set-type/get-selection-history');
    final list = response['data'] as List;
    return list.map((item) => SetTypeRef.fromJson(item)).toList();
  }

  Future<void> rememberSelection({
    required String setTypeId,
  }) async {
    final params = <String, dynamic>{
      'setTypeId': setTypeId,
    };
    await serviceClient.callFunction(
      path: '/set-type/remember-selection',
      params: params,
    );
  }

  Future<void> deleteSelection({
    required String setTypeId,
  }) async {
    final params = <String, dynamic>{
      'setTypeId': setTypeId,
    };
    await serviceClient.callFunction(
      path: '/set-type/delete-selection',
      params: params,
    );
  }
}

class SetTypeListItem {
  final String id;
  final String name;

  SetTypeListItem({
    required this.id,
    required this.name,
  });

  SetTypeRef ref() => SetTypeRef(id: id, repr: name);

  factory SetTypeListItem.fromJson(Map<String, dynamic> json) => SetTypeListItem(
        id: json['id'],
        name: json['name'],
      );
}

class SetTypeRef extends ModelRef {
  SetTypeRef({
    required super.id,
    required super.repr,
  });

  factory SetTypeRef.fromJson(Map<String, dynamic> json) => SetTypeRef(
        id: json['id'],
        repr: json['repr'],
      );
}
