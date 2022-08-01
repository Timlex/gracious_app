import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/model/user_profile_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class UserProfileService with ChangeNotifier {
  late UserDetails userProfileData;

  Future<UserDetails> fetchProfileService(var token) async {
    print('fetching profile data');
    print(token);

    final url = Uri.parse('$baseApiUrl/user/profile');
    print(token);

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    // try {
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = UserProfileModel.fromJson(jsonDecode(response.body));
      print(data.userDetails.name);
      userProfileData = data.userDetails;

      // posterDataList = data.data;
      print(userProfileData.name +
          userProfileData.email.toString() +
          '---------------');
      // print('-------------------------------------');
      notifyListeners();
      return userProfileData;
    }
    return userProfileData;
    // throw '';
  }
  //   //  catch (error) {
  //   //   // print(error);

  //   //   rethrow;
  //   // }
  // }
}
