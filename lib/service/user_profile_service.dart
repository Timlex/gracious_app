import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/model/user_profile_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class UserProfileService with ChangeNotifier {
  late UserDetails userProfileData;

  Future<void> fetchProfileService(var token) async {
    print('fetching posters');

    final url = Uri.parse('$baseApiUrl/user/profile');
    print(token);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(url, headers: header);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = UserProfileModel.fromJson(jsonDecode(response.body));
        userProfileData = data.userDetails;

        // posterDataList = data.data;
        // print(userProfileData.name + userProfileData.email + '---------------');
        // print('-------------------------------------');
        notifyListeners();
      } else {
        // print('something went wrong');
      }
    } catch (error) {
      // print(error);

      rethrow;
    }
  }
}
