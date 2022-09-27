import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../model/campaign_product_model.dart';
import '../../model/featured_product_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

import '../view/utils/constant_name.dart';

class CampaignCardListService with ChangeNotifier {
  List list = [
    1,
    1,
    1,
    2,
    6,
    6,
    6,
    6,
  ];
  Future fetchFeaturedProductCardData() async {
    await Future.delayed(Duration(seconds: 1));
    final url = Uri.parse('$baseApiUrl/user/order-list/');
    final header = {'Authorization': 'Bearer $globalUserToken'};
    final response = await http.get(url, headers: header);
    print(response.body);
    if (response.statusCode == 200) {
      final data = response;
    }
    return;
  }
}
