import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/ticket_chat_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

import '../view/utils/constant_name.dart';

class TicketChatService with ChangeNotifier {
  List<AllMessage> messagesList = [];
  late TicketDetails ticketDetails;
  bool isLoading = false;
  int? id;
  Future fetchSingleTicket() async {
    int pageNumber = 2;
    bool noMassege = false;

    setIsLoading(value) {
      isLoading = value;
      notifyListeners();
    }

    Future fetchTickets() async {
      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Authorization": "Bearer $globalUserToken",
      };
      print('searching in progress');
      final url = Uri.parse('$baseApiUrl/user/ticket/$id');
      print(url);
      try {
        final response = await http.get(url, headers: header);

        if (response.statusCode == 200) {
          var data = TicketChatModel.fromJson(jsonDecode(response.body));
          messagesList = data.allMessages;
          ticketDetails = data.ticketDetails;

          print(isLoading);
          print(messagesList.toString() + '-------------------');
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
}
