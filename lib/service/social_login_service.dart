import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gren_mart/service/common_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SocialLoginService with ChangeNotifier {
  Future facebookLogin() async {
    try {
      final AccessToken? accessToken = await FacebookAuth.instance.accessToken;
// or FacebookAuth.i.accessToken
      if (accessToken != null) {
        final userData = await FacebookAuth.i.getUserData(
          fields: "name,email,id",
        );
        print(userData['email']);
        print(userData['id']);
        print(userData['name']);
        return socialLogin(
            '0', userData['email'], userData['name'], userData['id']);
      }

      final response = await FacebookAuth.i.login(
        permissions: [
          'email',
          'public_profile',
        ],
      );
      if (response.status == LoginStatus.success) {
        final userData = await FacebookAuth.i.getUserData(
          fields: "name,email,id",
        );
        print(userData['email']);
        print(userData['id']);
        print(userData['name']);
        return socialLogin(
            '0', userData['email'], userData['name'], userData['id']);
      }
      throw '';
    } catch (e) {
      throw '';
    }
  }

  Future googleLogin() async {
    try {
      await GoogleSignIn().signOut();
      final response = await GoogleSignIn().signIn();
      if (response!.id != null) {
        print(response.email);
        print(response.id);
        print(response.displayName);
        print('===========================================');
        return socialLogin(
            1, response.email, response.displayName, response.id);
      }
      throw '';
    } catch (e) {
      print(e);
    }
  }

  Future socialLogin(isGoogle, email, name, id) async {
    final url = Uri.parse('$baseApiUrl/social/login');

    final response = await http.post(url, body: {
      'email': email.toString(),
      'isGoogle': isGoogle,
      'displayName': name.toString(),
      'id': id.toString(),
    });
    print(jsonDecode(response.body)['token']);
    if (response.statusCode == 200) {
      final loginData = jsonDecode(response.body);
      final pref = await SharedPreferences.getInstance();
      if (pref.containsKey('token')) {
        pref.remove('token');
      }
      print('working on pref');
      final tokenData = json.encode({
        'token': loginData['token'],
      });
      print('here');
      return loginData['token'];
    }
    print('why here');
    throw '';
  }
}