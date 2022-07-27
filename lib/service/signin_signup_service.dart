import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/signin_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInSignUpService with ChangeNotifier {
  SignInModel? signInData;
  var _token;
  var password;
  var email;
  bool login = true;
  bool isLoading = false;
  bool rememberPass = false;

  toggleSigninSignup() {
    login = !login;
    notifyListeners();
  }

  toggleLaodingSpinner() {
    isLoading = !isLoading;
    print(isLoading.toString() + '------------------------');
    notifyListeners();
  }

  toggleRememberPass(bool? value) {
    rememberPass = value as bool;
    print(rememberPass);
    notifyListeners();
  }

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return signInData!.users.id.toString();
  }

  String? get token {
    if (signInData!.token == null) {
      return null;
    }
    return _token;
  }

  Future<bool> signInOption(String? email, String? password) async {
    toggleLaodingSpinner();
    print('$email + $password');
    final url = Uri.parse('$baseApiUrl/login');

    try {
      final response = await http.post(url, body: {
        'username': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        final data = SignInModel.fromJson(jsonDecode(response.body));
        print(data);
        signInData = data;
        _token = signInData!.token;

        final pref = await SharedPreferences.getInstance();
        print('working on pref');
        final tokenData = json.encode({
          'token': signInData!.token,
        });
        await pref.setString('token', tokenData);
        if (rememberPass) {
          final userData = json.encode({
            'email': email,
            'password': password,
          });
          pref.setString('userData', userData);
        }
        if (!rememberPass) {
          resetEmailPassData();
        }

        notifyListeners();
        return true;
      }

      return false;
    } catch (error) {
      print(error);

      rethrow;
    }
  }

  Future<dynamic> getToken() async {
    var token;
    final ref = await SharedPreferences.getInstance();
    if (!ref.containsKey('token')) {
      return;
    }
    final data = ref.getString('token');
    token = json.decode(data.toString());
    _token = token['token'];
    notifyListeners();
    print(token);
    return _token;
  }

  Future<bool> getUserData() async {
    final ref = await SharedPreferences.getInstance();
    if (!ref.containsKey('userData')) {
      return false;
    }
    final data = ref.getString('userData');
    final signinData = json.decode(data.toString()) as Map<String, dynamic>;
    email = signinData['email'];
    password = signinData['password'];
    toggleRememberPass(true);
    notifyListeners();
    return true;
  }

  Future<void> resetEmailPassData() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove('userData');
    email = null;
    password = null;
    notifyListeners();
  }

  Future<void> signOut() async {
    final ref = await SharedPreferences.getInstance();
    if (!ref.containsKey('token')) {
      return;
    }
    ref.remove('token');

    notifyListeners();
    print(token);
    return _token;
  }
}
