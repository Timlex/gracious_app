import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/order_list_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:http/http.dart' as http;

class OrderListService with ChangeNotifier {
  OrderListModel? orderListModel;
  bool noOrder = false;
  bool isLoading = false;
  bool loadingNextPage = false;

  setLodingNextPage(value) {
    if (value == loadingNextPage) {
      return;
    }
    loadingNextPage = value;
    notifyListeners();
  }

  clearOrder() {}
  Future fetchOrderList() async {
    final url = Uri.parse('$baseApiUrl/user/order-list/');
    final header = {'Authorization': 'Bearer $globalUserToken'};
    final response = await http.get(url, headers: header);
    print(response.body);
    if (response.statusCode == 200) {
      final data = OrderListModel.fromJson(jsonDecode(response.body));
      if (data.data.isEmpty) {
        print(data.data.isEmpty);
        noOrder = true;
        return;
      }
      noOrder = data.data.isEmpty;
      print(data.data.first.orderId);
      orderListModel = data;
      print(orderListModel!.data.first.orderId);
      return 'fetching success.';
    }
    print(jsonDecode(response.body));
    return;
  }

  Future fetchNextPage() async {
    final url = Uri.parse(orderListModel!.nextPageUrl.toString());
    final header = {'Authorization': 'Bearer $globalUserToken'};
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      final data = OrderListModel.fromJson(jsonDecode(response.body));
      print(data.data.first.orderId);
      print(orderListModel);
      data.data.forEach((element) {
        orderListModel!.data.add(element);
      });
      orderListModel!.nextPageUrl = data.nextPageUrl;
      notifyListeners();
      return 'fetching success.';
    }
    print(jsonDecode(response.body));
    return;
  }
}
