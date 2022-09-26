import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/service/state_dropdown_service.dart';
import 'package:provider/provider.dart';
import '../../model/country_dropdown_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

import '../view/utils/constant_styles.dart';

class CountryDropdownService with ChangeNotifier {
  List countryDropdownList = [];
  List countryDropdownIdList = [];
  var selectedCountry;
  var selectedCountryId;

  setCountryIdAndValue(
    var value,
  ) {
    selectedCountry = value;
    int valueIndex;
    valueIndex = countryDropdownList.indexOf(value);
    selectedCountryId = countryDropdownIdList[valueIndex];
    print(selectedCountry + '-------' + selectedCountryId.toString());
    notifyListeners();
  }

  Future getContries(BuildContext context) async {
    // if (countryDropdownList.isNotEmpty) {
    //   return;
    // }
    countryDropdownList = [];

    print('get countries function ran');
    final url = Uri.parse('$baseApiUrl/country');

    try {
      Provider.of<StateDropdownService>(context, listen: false).resetState();
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = CountryDropdownModel.fromJson(jsonDecode(response.body));
        for (int i = 0; i < data.countries.length; i++) {
          countryDropdownList.add(data.countries[i].name);
          countryDropdownIdList.add(data.countries[i].id);
        }

        selectedCountry = 'Bangladesh';
        selectedCountryId = 1;
        await Provider.of<StateDropdownService>(context, listen: false)
            .getStates(selectedCountryId, context: context);
        print(selectedCountry);
        // print(countryDropdownList);

        notifyListeners();
        return selectedCountryId;
      } else {
        //something went wrong
      }
    } catch (error) {
      snackBar(context, 'Connection failed!', backgroundColor: cc.orange);
      print(error);

      return;
    }
  }
}
