import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/model/state_dropdown_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class StateDropdownService with ChangeNotifier {
  List stateDropdownList = [];
  List stateDropdownIdList = [];
  var selectedState;
  var selectedStateId;

  bool isLoading = false;

  setStateIdAndValue(value) {
    selectedState = value;
    final valueIndex = stateDropdownList.indexOf(value);
    print(selectedState + selectedStateId.toString() + '---------------');
    notifyListeners();
  }

  Future<void> getStates(selectedCountryId) async {
    print('getting state data____________' + selectedCountryId.toString());
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('$baseApiUrl/state/$selectedCountryId');

    try {
      final response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final data = StateDropdownModel.fromJson(jsonDecode(response.body));
        var stateData = [];
        for (int i = 0; i < data.state.length; i++) {
          var element = data.state[i];
          stateData.add(element.name);
          stateDropdownIdList.add(element.id);
        }
        stateDropdownList = stateData;
        selectedState = stateDropdownList[0];

        // setStateIdAndValue(selectedCountryId);
        isLoading = false;
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
