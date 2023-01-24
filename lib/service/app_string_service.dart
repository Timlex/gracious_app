import 'package:flutter/material.dart';

import '../view/utils/app_strings.dart';

class AppStringService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  // fetchTranslatedStrings() async {
  //   if (tStrings != null) {
  //     //if already loaded. no need to load again
  //     return;
  //   }
  //   var connection = await Connectivity().checkConnectivity();
  //   if (connection != ConnectivityResult.none) {
  //     //internet connection is on
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var token = prefs.getString('token');

  //     setLoadingTrue();

  //     var data = jsonEncode({
  //       'strings': jsonEncode(appStrings),
  //     });

  //     var header = {
  //       //if header type is application/json then the data should be in jsonEncode method
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     };

  //     var response = await http.post(Uri.parse('$baseApiUrl/translate-string'),
  //         headers: header, body: data);

  //     if (response.statusCode == 201) {
  //       tStrings = jsonDecode(response.body)['strings'];
  //       notifyListeners();
  //     } else {
  //       print('error fetching translations ' + response.body);
  //       notifyListeners();
  //     }
  //   }
  // }

  getString(String staticString) {
    var tStrings = appStrings;
    if (tStrings == null) {
      return staticString;
    }
    if (tStrings.containsKey(staticString) &&
        tStrings[staticString].toString().isNotEmpty) {
      return tStrings[staticString];
    } else {
      return staticString;
    }
  }
}
