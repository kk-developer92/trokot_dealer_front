import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:http/http.dart' as http;
import 'package:trokot_dealer_mobile/exceptions.dart';
import 'package:trokot_dealer_mobile/services/service_events.dart';
import 'dart:convert';

import 'user.dart';

typedef Json = Map<String, dynamic>;

class ServiceClient {
  String baseUrl;
  String? token;

  EventBus eventBus;

  User? user;
  final StreamController<User?> _userStreamController = StreamController<User?>.broadcast();
  Stream<User?> get userStream => _userStreamController.stream;

  bool get isLoggedIn => token is String;

  ServiceClient({
    required this.baseUrl,
    this.token,
    required this.eventBus,
  }) {
    eventBus.stream.listen((event) {
      if (event is ServicePingEvent) {
        ping();
      }
    });
  }

  Future<void> login(String username, String password) async {
    final Json params = {
      'username': username,
      'password': password,
    };

    final result = await callFunction(
      path: '/auth/login',
      params: params,
    );

    token = result['token'];
    user = User.fromJson(result['user']);
    _userStreamController.sink.add(user);
  }

  Future<void> logOut() async {
    await callFunction(path: '/auth/logout');
    token = null;
    user = null;
    _userStreamController.sink.add(null);
  }

  Future<void> ping() async {
    final result = await callFunction(path: '/auth/ping');
    user = User.fromJson(result['data']);

    // final locUser = user;
    // if (locUser == null) {
    //   print('+++ user is $locUser');
    // } else {
    //   print('+++ user > name: ${locUser.name}, balance: ${locUser.balance}');
    // }

    _userStreamController.sink.add(user);
  }

  Future<String> createBalancePaymentUrl({
    required String description,
    required Decimal amount,
  }) async {
    final params = <String, dynamic>{
      'description': description,
      'amount': amount.toString(),
    };
    final result = await callFunction(
      path: '/balance/create-balance-payment-url',
      params: params,
    );
    final url = result['url'] as String;
    return url;
  }

  Future<void> checkBalancePayment() async {
    final response = await callFunction(path: '/balance/check-balance-payment');
    final data = response['data'] as Map<String, dynamic>;
    user = User.fromJson(data);
    _userStreamController.sink.add(user);
  }

  Future<Json> callFunction({
    required String path,
    Json? params,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final uri = Uri.parse('$baseUrl$path');

    final tokenValue = token;
    Map<String, String> headers = <String, String>{
      if (tokenValue != null) 'Authorization': tokenValue,
      'Content-Type': "application/json",
      // 'Authorization': 'xxx',
      // 'Authorization': '-Q7q8DwK38j0pCHJHdkz6uLP9sZbrFCOxUzT4lpM',
    };
    // print('+++ callFunction()... path: $path');
    // print('+++ url: $uri');
    // print('+++ headers: $headers');

    var bodyString = '';
    if (params != null) {
      bodyString = jsonEncode(params);
    }

    http.Response response;
    try {
      response = await http.post(uri, headers: headers, body: bodyString).timeout(timeout);
      // print('+++ response.body: ${response.body}');
      // print('+++ response.body.length: ${response.body.length}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return <String, dynamic>{};
        } else {
          return jsonDecode(response.body);
        }
      } else {
        if (response.statusCode == 401) {
          token = null;
          user = null;
          _userStreamController.sink.add(null);
          throw AuthenticationException('Ошибка авторизации');
        } else if (response.statusCode == 403) {
          throw AuthenticationException('Доступ запрещен');
        } else {
          throw ServiceException('Ошибка коммуникации с сервисом (status: ${response.statusCode}, body: ${response.body})');
        }
      }
    } catch (error) {
      print('+++ error after post request!');
      print('+++ $error');
      print('+++ pass...');

      rethrow;
    }
  }

  void dispose() {
    _userStreamController.close();
  }
}

class ServiceException extends ApplicationException {
  ServiceException(super.message);

  @override
  String toString() => 'ServiceException: $message';
}

class AuthenticationException extends ServiceException {
  AuthenticationException(super.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

class AccessDeniedExcepton extends ServiceException {
  AccessDeniedExcepton(super.message);

  @override
  String toString() => 'AccessDeniedException: $message';
}
