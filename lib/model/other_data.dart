import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class OtherData with ChangeNotifier {
  String? country;
  List<String> countries = [];
  List<dynamic> countryData = [];
  String? state;
  List<String> states = [];
  List<StateData> stateData = [];
  bool showState = false;

  void setCountry(String? value) {
    print(value);
    country = value;
    showState = true;
    filterStates(value as String);
    notifyListeners();
  }

  void setState(String? value) {
    state = value;
    showState = true;
    notifyListeners();
  }

  void filterStates(String countryName) {
    states = ['No internet'];
    final countryId = countryData
        .firstWhere((element) => element['name'] == countryName)['id'];
    for (var element in stateData) {
      if (element.countryId == countryId) {
        states.add(element.name);
      }
    }

    notifyListeners();
  }

  Future<List<String>> getContries() async {
    final url =
        Uri.parse('https://zahid.xgenious.com/grenmart-api/api/v1/country');

    try {
      final response = await http.get(
        url,
      );

      final responseData = json.decode(response.body);
      // print(responseData['countries']);
      countryData = responseData['countries'] as List<dynamic>;
      for (var element in (responseData['countries'] as List<dynamic>)) {
        countries.add(element['name']);
      }

      // country = countries[0];
      notifyListeners();
      return countries;
    } catch (error) {
      print(error);

      rethrow;
    }
  }

  Future<void> getStates() async {
    final url =
        Uri.parse('https://zahid.xgenious.com/grenmart-api/api/v1/state/1');

    try {
      final responseState = await http.get(
        url,
      );
      final responseStateData = json.decode(responseState.body);
      final stateDatas = responseStateData['state'] as List<dynamic>;
      for (var element in stateDatas) {
        stateData.add(
            StateData(element['id'], element['name'], element['country_id']));
      }
      notifyListeners();
    } catch (error) {
      print(error);

      rethrow;
    }
  }
}

class CountryData {
  final String name;
  final int id;
  CountryData(this.id, this.name);
}

class StateData {
  final int id;
  final String name;
  final int countryId;
  StateData(this.id, this.name, this.countryId);
}
