import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:gren_mart/service/common_service.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:http/http.dart' as http;

class ShippingAddressesService with ChangeNotifier {
  String? name;
  String? address;
  bool isLoading = false;

  setName(value) {
    name = value;
    notifyListeners();
  }

  setAddress(value) {
    address = value;
    notifyListeners();
  }

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  Future<dynamic> fetchUsersShippingAddress() async {
    print('$globalUserToken --------------');
    final url = Uri.parse('$baseApiUrl/user/store-shipping-address');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Authorization": "Bearer $globalUserToken",
    };
    try {
      final response = await http.post(url, headers: header, body: {
        'name': name,
        'address': address,
      });
      print(response.body);
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));

        notifyListeners();
        return;
      }
      if (response.statusCode == 422) {
        final data = json.decode(response.body);
        print(data['message']);
        return data['message'];
      }

      return 'Someting went wrong';
    } catch (error) {
      print(error);

      rethrow;
    }
  }
}
