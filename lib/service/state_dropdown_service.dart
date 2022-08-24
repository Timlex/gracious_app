import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/shipping_addresses_service.dart';
import 'package:provider/provider.dart';
import '../../model/state_dropdown_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class StateDropdownService with ChangeNotifier {
  List stateDropdownList = [];
  List stateDropdownIdList = [];
  late List<States> allState;
  var selectedState;
  var selectedStateId;

  bool isLoading = false;

  resetState() {
    isLoading = true;
    notifyListeners();
  }

  setStateIdAndValue(value) {
    selectedState = value;
    final valueIndex = stateDropdownList.indexOf(value);
    selectedStateId = stateDropdownIdList[valueIndex];
    print(selectedState + selectedStateId.toString() + '---------------');
    notifyListeners();
  }

  setStateIdAndValueDefault() {
    // print(allState.length);
    final valueState = allState[0];
    selectedState = valueState.name;
    selectedStateId = valueState.id;
    print(selectedState + selectedStateId.toString() + '---------------');
    notifyListeners();
  }

  Future getStates(selectedCountryId, {BuildContext? context}) async {
    // print('getting state data____________' + selectedCountryId.toString());
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
        allState = data.state;
        print(allState[0].name + '-------------------');
        for (int i = 0; i < data.state.length; i++) {
          var element = data.state[i];
          stateData.add(element.name);
          stateDropdownIdList.add(element.id);
        }
        stateDropdownList = stateData;
        setStateIdAndValueDefault();

        // setStateIdAndValue(selectedCountryId);
        isLoading = false;

        notifyListeners();
        if (context != null) {
          Provider.of<ShippingAddressesService>(context, listen: false)
              .setDefaultCountryState(context);
        }
        return selectedCountryId;
      } else {
        // print('something went wrong');
      }
    } catch (error) {
      // print(error);

      rethrow;
    }
  }
}
