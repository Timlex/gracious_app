import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class ManageAccountService with ChangeNotifier {
  String name = '';
  String email = '';
  String phoneNumber = '';
  String countryCode = 'BD';
  String countryId = '1';
  String stateId = '1';
  String? city = '';
  String zipCode = '';
  String? address = '';
  String? imgUrl;
  File? pickeImage;
  bool isLoading = false;

  setInitialValue(nameValue, emailValue, phoneValue, countryIdValue,
      stateIdValue, cityValue, zipCodeValue, addressValue, imageUrl) {
    name = nameValue;
    email = emailValue;
    phoneNumber = phoneValue;
    countryId = countryIdValue;
    stateId = stateIdValue;
    cityValue = cityValue;
    zipCode = zipCodeValue;
    address = addressValue;
    imgUrl = imageUrl;
  }

  setName(value) {
    name = value;
    notifyListeners();
  }

  setEmail(value) {
    email = value;
    notifyListeners();
  }

  setPhoneNumber(value) {
    phoneNumber = value;
    notifyListeners();
  }

  setCountryCode(value) {
    countryCode = value;
    notifyListeners();
  }

  setCountryID(value) {
    countryId = value;
    notifyListeners();
  }

  setStateId(value) {
    stateId = value;
    notifyListeners();
  }

  setCity(value) {
    city = value;
    notifyListeners();
  }

  setZipCode(value) {
    zipCode = value;
    notifyListeners();
  }

  setAddress(value) {
    address = value;
    notifyListeners();
  }

  setPickedImage(value) {
    pickeImage = value;
    notifyListeners();
  }

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  Future updateProfile(var token) async {
    print('Edit in proccess');
    print(token);
    Map<String, String> fieldss = {
      'name': name,
      'email': email,
      'phone': phoneNumber,
      'country_code': countryCode,
      'country': countryId,
      'state': stateId,
      'city': city ?? '',
      'zip_code': zipCode,
      'address': address ?? '',
    };

    final url = Uri.parse('$baseApiUrl/user/update-profile');
    print(token);
    var request = http.MultipartRequest('POST', url);

    fieldss.forEach((key, value) {
      request.fields[key] = value;
    });
    print(
        '$name, $email, $phoneNumber, $countryCode, $countryId, $stateId, $city, $zipCode,$address');
    request.headers.addAll(
      {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    print(pickeImage);
    if (pickeImage != null) {
      print(pickeImage!.path);
      var multiport = await http.MultipartFile.fromPath(
        'file',
        pickeImage!.path,
      );

      request.files.add(multiport);
    }
    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    // var header = {
    //   //if header type is application/json then the data should be in jsonEncode method
    //   "Accept": "application/json",
    //   "Authorization": "Bearer $token",
    // };
    // // try {
    // final response = await http.post(url, headers: header, body: {
    //   'name': name,
    //   'email': email,
    //   'phone': phoneNumber,
    //   'country_code': countryCode,
    //   'country': countryId,
    //   'state': stateId,
    //   'city': city,
    //   'zip_code': zipCode,
    //   'address': address,
    //   'file': pickeImage,
    // });
    print(response.statusCode.toString() + '++++++++++++++');
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      notifyListeners();
      return;
    }
    if (response.statusCode == 500) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }

    return;
    // throw '';
  }
  //   //  catch (error) {
  //   //   // print(error);

  //   //   rethrow;
  //   // }
  // }
}
