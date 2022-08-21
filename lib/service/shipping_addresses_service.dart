import 'package:flutter/material.dart';
import '../../model/shipping_addresses_model.dart';
import 'dart:convert';

import '../../service/common_service.dart';
import '../../view/utils/constant_name.dart';
import 'package:http/http.dart' as http;

class ShippingAddressesService with ChangeNotifier {
  List<Datum> shippingAddresseList = [];
  Datum? selectedAddress;
  bool isLoading = false;
  bool changePassLoading = false;
  String? name;
  String? email;
  String? phone;
  String? countryCode;
  String countryId = '1';
  String stateID = '1';
  String? zipCode;
  String? address;
  String? city;
  bool alertBoxLoading = false;
  bool noData = false;

  setName(value) {
    name = value;
    notifyListeners();
  }

  clearSelectedAddress() {
    selectedAddress =
        shippingAddresseList.isNotEmpty ? shippingAddresseList[0] : null;
    noData = false;
    isLoading = false;
    notifyListeners();
  }

  clearAll() {
    noData = false;
    isLoading = false;
    name = null;
    email = null;
    phone = null;
    countryCode = null;
    zipCode = null;
    countryId = '1';
    stateID = '1';
    address = null;
    city = null;
    notifyListeners();
  }

  setCity(value) {
    city = value;
    notifyListeners();
  }

  setAddress(value) {
    address = value;
    notifyListeners();
  }

  setPhone(value) {
    phone = value;
    notifyListeners();
  }

  setEmail(value) {
    email = value;
    notifyListeners();
  }

  setZipCode(value) {
    zipCode = value;
    notifyListeners();
  }

  setCountryId(value) {
    countryId = value;
    notifyListeners();
  }

  setStateId(value) {
    stateID = value;
    notifyListeners();
  }

  setSelectedAddress(value) {
    selectedAddress = value;
    notifyListeners();
  }

  setCountryCode(value) {
    countryCode = value;
    notifyListeners();
  }

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setAlertBoxLoading(value) {
    alertBoxLoading = value;
    notifyListeners();
  }

  setNoData(value) {
    noData = value;
    notifyListeners();
  }

  Future<dynamic> fetchUsersShippingAddress() async {
    print('$globalUserToken --------------');
    final url = Uri.parse('$baseApiUrl/user/all-shipping-address');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Bearer $globalUserToken",
    };
    try {
      final response = await http.get(url, headers: header);
      if (response.statusCode == 200) {
        final data = ShippingAddressesModel.fromJson(jsonDecode(response.body));
        shippingAddresseList = data.data;
        noData = shippingAddresseList.isEmpty;
        selectedAddress ??= shippingAddresseList[0];

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

  Future<dynamic> addShippingAddress() async {
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
        'email': email,
        'phone': phone,
        'country': countryId,
        'state': stateID,
        'city': city,
        'zip_code': zipCode,
        'address': address,
      });
      print(response.body);
      if (response.statusCode == 200) {
        print(response.body);
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

  Future<dynamic> deleteSingleAddress(id) async {
    print('$globalUserToken --------------');
    final url = Uri.parse('$baseApiUrl/user/shipping-address/delete/$id');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Authorization": "Bearer $globalUserToken",
    };
    // try {
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      print(response.body);
      shippingAddresseList.removeWhere((element) => element.id == id);
      if (shippingAddresseList.isEmpty) {
        noData = true;
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
    // } catch (error) {
    //   print(error);

    //   rethrow;
    // }
  }
}
