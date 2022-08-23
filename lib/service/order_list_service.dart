import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/order_list_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:http/http.dart' as http;

class OrderListService with ChangeNotifier {
  late OrderListModel orderListModel;
  bool noOrder = false;
  bool isLoding = false;

  Future fetchOrderList() async {
    final url = Uri.parse('$baseApiUrl/user/order-list/');
    final header = {'Authorization': 'Bearer $globalUserToken'};
    final response = await http.get(url, headers: header);

    if (response.statusCode == 200) {
      orderListModel = OrderListModel.fromJson(jsonDecode(response.body));
      print(orderListModel);
      noOrder = orderListModel.data.isEmpty;
      return 'fetching success.';
    }
    print(jsonDecode(response.body));
    return;
  }
}
