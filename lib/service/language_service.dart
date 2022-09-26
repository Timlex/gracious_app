import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class LanguageService with ChangeNotifier {
  bool rtl = false;
  String currencySymbol = '\$';

  Future setLanguage() async {
    final url = Uri.parse('$baseApiUrl/default-lang');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        rtl = jsonDecode(response.body)['lang_info']['direction'] == 'rtl';
        notifyListeners();
      } else {
        // print('something went wrong');
      }
    } catch (error) {
      // print(error);

      rethrow;
    }
  }

  Future setCurrency() async {
    // final url = Uri.parse('$baseApiUrl/default-lang');
    // try {
    // final response = await http.get(url);
    // print(response.body);
    // if (response.statusCode == 200) {
    currencySymbol = '\$';
    //       jsonDecode(response.body)['currency']['site_default_currency_symbol'];
    //   notifyListeners();
    // } else {
    //   // print('something went wrong');
    // }
    // } catch (error) {
    //   // print(error);

    //   rethrow;
    // }
  }
}
