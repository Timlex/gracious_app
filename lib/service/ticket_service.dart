import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/model/tickets_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:http/http.dart' as http;

class TicketService with ChangeNotifier {
  List<Datum> ticketsList = [];
  Datum? selectedTicket;
  bool isLoading = false;
  bool? lastPage;
  int pageNumber = 2;
  bool noProduct = false;
  int pageNo = 1;
  String? title;
  String? subject;

  String priority = 'Low';
  String department = 'Product Delivery';
  String? description;

  List<String> priorityList = [
    'Low',
    'Medium',
    'High',
    'Urgent',
  ];
  List<String> departmentsList = [
    'Product Delivery',
    'Product Coupon',
  ];

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setPageNo() {
    pageNo++;
    notifyListeners();
  }

  setSelectedTicket(value) {
    selectedTicket = value;
    notifyListeners();
  }

  setPriority(value) {
    priority = value;
    notifyListeners();
  }

  setDepartment(value) {
    department = value;
    notifyListeners();
  }

  setTitle(value) {
    title = value;
    notifyListeners();
  }

  setSubject(value) {
    subject = value;
    notifyListeners();
  }

  setDescription(value) {
    description = value;
    notifyListeners();
  }

  Future fetchTickets() async {
    print(lastPage);

    if (lastPage != null && lastPage!) {
      setIsLoading(false);
      notifyListeners();
      print('Leaving fetching___________');
      return 'No more product found!';
    }

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Bearer $globalUserToken",
    };
    print('searching in progress');
    final url = Uri.parse('$baseApiUrl/user/ticket');
    print(url);
    try {
      final response = await http.get(url, headers: header);

      if (response.statusCode == 200) {
        var data = TicketsModel.fromJson(jsonDecode(response.body));

        lastPage = data.lastPage == pageNo;
        for (var element in data.data) {
          ticketsList.add(element);
        }
        print(isLoading);
        print(ticketsList.length);
        print(data.lastPage.toString() + '-------------------');
        print(data.total.toString() + '-------------------');
        setIsLoading(false);
        // setNoProduct(resultMeta!.total == 0);

        notifyListeners();
      } else {}
    } catch (error) {
      print(error);

      rethrow;
    }
  }
}
