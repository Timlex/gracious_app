import 'package:flutter/material.dart';
import 'package:gren_mart/model/shipping_addresses_model.dart';
import 'dart:convert';

import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class ShippingAddressesService with ChangeNotifier {
  List<Datum> shippingAddresseList = [];
  late Datum selectedAddress;
  bool isLoading = false;
  bool changePassLoading = false;

  setSelectedAddress(value) {
    selectedAddress = value;
    notifyListeners();
  }

  Future<dynamic> fetchUsersShippingAddress(token) async {
    print('$token --------------');
    final url = Uri.parse('$baseApiUrl/user/all-shipping-address');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Bearer $token",
    };
    try {
      final response = await http.get(url, headers: header);
      print(response.body);
      if (response.statusCode == 200) {
        final data = ShippingAddressesModel.fromJson(jsonDecode(response.body));
        shippingAddresseList = data.data;
        if (!(selectedAddress != null)) {
          selectedAddress = shippingAddresseList[0];
        }
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
