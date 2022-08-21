import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:http/http.dart' as http;

import 'common_service.dart';

class PaymentGetterService with ChangeNotifier {
  List<String> logoList = [];
  Future fetchPaymentGetterData() async {
    if (logoList.isNotEmpty) {
      return;
    }
    final url = Uri.parse('$baseApiUrl/user/payment-gateway-list');
    print(globalUserToken);

    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $globalUserToken",
      'x-api-key': 'b8f4a0ba4537ad6c3ee41ec0a43549d1'
    };
    print(header);

    final response = await http.get(url, headers: header);
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<String> emptyList = [];
      data['gateway_list'].forEach((e) {
        emptyList.add(e['logo_link']);
      });
      logoList = emptyList;
      notifyListeners();
    }
  }
}
