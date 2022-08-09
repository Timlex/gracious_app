import 'dart:convert';

import 'package:flutter/material.dart';
import '../../model/tickets_model.dart';
import '../../service/common_service.dart';
import '../../view/utils/constant_name.dart';
import 'package:http/http.dart' as http;

class TicketService with ChangeNotifier {
  List<Datum> ticketsList = [];
  bool isLoading = false;
  bool? lastPage;
  int pageNumber = 2;
  bool noProduct = false;
  int pageNo = 1;
  String? title;
  String? subject;

  String priority = 'Low';
  String department = 'Product Delivery';
  int? departmentId;
  String? description;

  List<String> priorityList = [
    'Low',
    'Medium',
    'High',
    'Urgent',
  ];
  List<Ddata> departmentsList = [];

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setPageNo() {
    pageNo++;
    notifyListeners();
  }

  // setSelectedTicket(value) {
  //   selectedTicket = value;
  //   notifyListeners();
  // }

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

  clearTickets() {
    ticketsList = [];
    notifyListeners();
  }

  Future fetchTickets() async {
    print(lastPage);

    // if (lastPage != null && lastPage!) {
    //   setIsLoading(false);
    //   notifyListeners();
    //   print('Leaving fetching___________');
    //   return 'No more product found!';
    // }

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
        ticketsList = data.data;
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

  Future getDepartments() async {
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Authorization": "Bearer $globalUserToken",
    };
    print('searching in progress');
    final url = Uri.parse('$baseApiUrl/user/get-department');
    print(url);
    try {
      final response = await http.get(url, headers: header);

      if (response.statusCode == 200) {
        var data = TicketDepartments.fromJson(jsonDecode(response.body));
        departmentsList = data.departmentsData;
        department = departmentsList[0].name;
        departmentId = departmentsList[0].id;
        setIsLoading(false);

        notifyListeners();
      } else {}
    } catch (error) {
      print(error);

      rethrow;
    }
  }
}

TicketDepartments ticketDepartmentsFromJson(String str) =>
    TicketDepartments.fromJson(json.decode(str));

String ticketDepartmentsToJson(TicketDepartments departmentsData) =>
    json.encode(departmentsData.toJson());

class TicketDepartments {
  TicketDepartments({
    required this.departmentsData,
  });

  List<Ddata> departmentsData;

  factory TicketDepartments.fromJson(Map<String, dynamic> json) =>
      TicketDepartments(
        departmentsData:
            List<Ddata>.from(json["data"].map((x) => Ddata.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(departmentsData.map((x) => x.toJson())),
      };
}

class Ddata {
  Ddata({
    required this.id,
    required this.name,
    required this.status,
  });

  int id;
  String name;
  String status;

  factory Ddata.fromJson(Map<String, dynamic> json) => Ddata(
        id: json["id"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
      };
}
