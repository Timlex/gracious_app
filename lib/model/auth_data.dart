import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthData with ChangeNotifier {
  String? _token;
  String? _userId;
  String? _userName;
  bool login = true;
  bool isLoading = false;

  toggleSigninSignup() {
    login = !login;
    notifyListeners();
  }

  toggleLaodingSpinner() {
    isLoading = !isLoading;
    print(isLoading.toString() + '------------------------');
    notifyListeners();
  }

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_token == null) {
      return null;
    }
    return _token;
  }

  void logout() {
    _token = null;
    isLoading = false;
  }

  Future<bool> toggleOption(String? email, String? password) async {
    toggleLaodingSpinner();
    print('$email + $password');
    final url =
        Uri.parse('https://zahid.xgenious.com/grenmart-api/api/v1/login');

    try {
      final response = await http.post(url, body: {
        'username': email,
        'password': password,
      });
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['token'] != null) {
        return true;
      }

      return false;
    } catch (error) {
      print(error);

      rethrow;
    }
  }
}
