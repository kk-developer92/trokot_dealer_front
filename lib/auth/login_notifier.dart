import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:trokot_dealer_mobile/exceptions.dart';
import 'package:trokot_dealer_mobile/services/service_client.dart';

class LoginNotifier extends ChangeNotifier {
  final ServiceClient serviceClient;

  LoginNotifier({
    required this.serviceClient,
  });

  String username = '';
  setUsername(String value) {
    username = value;
    notifyListeners();
  }

  String password = '';
  setPassword(String value) {
    password = value;
    notifyListeners();
  }

  bool loading = false;

  final StreamController<String> _errorStreamController = StreamController.broadcast();
  Stream<String> get errorStream => _errorStreamController.stream;

  void displayError(Object error) {
    final errorMessage = userErrorMessage(error);
    _errorStreamController.sink.add(errorMessage);
  }

  login() async {
    try {
      if (username.isEmpty) {
        throw ValidationException('Заполните логин');
      }
      if (password.isEmpty) {
        throw ValidationException('Заполните пароль');
      }
      loading = true;
      notifyListeners();

      await serviceClient.login(username, password);
      notifyListeners();
    } catch (error) {
      displayError(error);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  logout() async {
    try {
      loading = true;
      await serviceClient.logOut();
    } catch (error) {
      displayError(error);
    } finally {
      loading = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _errorStreamController.close();
  }
}
