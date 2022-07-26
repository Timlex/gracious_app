// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/country_dropdown_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class CountryDropdownService with ChangeNotifier {
  List countryDropdownList = [];
  List countryDropdownIdList = [];
  var selectedCountry;
  var selectedCountryId;

  setCountryIdAndValue(
    var value,
  ) {
    selectedCountry = value;
    var valueIndex;
    valueIndex = countryDropdownList.indexOf(value);
    selectedCountryId = countryDropdownIdList[valueIndex];
    print(selectedCountry + '-------' + selectedCountryId.toString());
    notifyListeners();
  }

  Future getContries() async {
    if (countryDropdownList.isNotEmpty) {
      return;
    }

    print('get countries function ran');
    final url = Uri.parse('$baseApiUrl/country');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = CountryDropdownModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < data.countries.length; i++) {
          countryDropdownList.add(data.countries[i].name);
          countryDropdownIdList.add(data.countries[i].id);
        }

        selectedCountry = data.countries[0].name;
        selectedCountryId = data.countries[0].id;

        print(selectedCountry);
        // print(countryDropdownList);

        notifyListeners();
      } else {
        //something went wrong
      }
    } catch (error) {
      print(error);

      rethrow;
    }
  }
}
