import 'dart:convert';

import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class LanguageService {
  bool rtl = false;

  Future setLanguage() async {
    final url = Uri.parse('$baseApiUrl/default-lang');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        rtl = jsonDecode(response.body)['lang_info']['direction'] == 'rtl';
      } else {
        // print('something went wrong');
      }
    } catch (error) {
      // print(error);

      rethrow;
    }
  }
}
