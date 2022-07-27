import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/signin_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInSignUpService with ChangeNotifier {
  SignInModel? signInData;
  var _token;
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
    return signInData!.users.id.toString();
  }

  String? get token {
    if (signInData!.token == null) {
      return null;
    }
    return _token;
  }

  void logout() {
    // signInData!.token = null;
    isLoading = false;
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
        final userData = json.encode({
          'token': signInData!.token,
        });
        await pref.setString('userData', userData);
        print(json.decode(pref.getString('userData').toString()));
        notifyListeners();
        return true;
      }

      return false;
    } catch (error) {
      print(error);

      rethrow;
    }
  }

  Future<bool> getToken() async {
    var token;
    final ref = await SharedPreferences.getInstance();
    if (!ref.containsKey('userData')) {
      return false;
    }
    final data = ref.getString('userData');
    token = json.decode(data.toString());
    _token = token;
    notifyListeners();
    return true;
  }
}
