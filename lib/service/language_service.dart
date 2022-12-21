import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class LanguageService with ChangeNotifier {
  bool rtl = false;
  bool currencyRTL = false;
  String currency = '\$';

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
    final url = Uri.parse('$baseApiUrl/site_currency_symbol');
    // try {
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      currency = jsonDecode(response.body)['symbol'];
      currencyRTL = jsonDecode(response.body)['direction'] == 'rtl';
      notifyListeners();
    } else {
      // print('something went wrong');
    }
    // } catch (error) {
    //   // print(error);

    //   rethrow;
    // }
  }
}
