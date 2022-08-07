import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/ticket_chat_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

import '../view/utils/constant_name.dart';

class TicketChatService with ChangeNotifier {
  List<AllMessage> messagesList = [];
  late TicketDetails ticketDetails;
  bool isLoading = false;
  String message = '';
  File? pickedImage;

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setMessage(value) {
    message = value;
    notifyListeners();
  }

  clearAllMessages() {
    messagesList = [];
    pickedImage = null;
  }

  setPickedImage(value) {
    pickedImage = value;
    notifyListeners();
  }

  Future fetchSingleTickets(id) async {
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
        messagesList = data.allMessages.reversed.toList();
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

  Future sendMessage(id) async {
    print('sending------------------');
    final url = Uri.parse('$baseApiUrl/user/ticket/chat/send/$id');

    Map<String, String> fieldss = {
      'user_type': 'mobile',
      'message': message,
      'send_notify_mail': 'on',
    };

    var request = http.MultipartRequest('POST', url);

    fieldss.forEach((key, value) {
      request.fields[key] = value;
    });

    request.headers.addAll(
      {
        "Accept": "application/json",
        "Authorization": "Bearer $globalUserToken",
      },
    );

    // var header = {
    //   //if header type is application/json then the data should be in jsonEncode method
    //   "Accept": "application/json",
    //   "Authorization": "Bearer $globalUserToken",
    // };
    print('searching in progress');

    print(url);
    try {
      if (pickedImage != null) {
        print(pickedImage!.path);
        var multiport = await http.MultipartFile.fromPath(
          'file',
          pickedImage!.path,
        );

        request.files.add(multiport);
      }
      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        message = '';
        // var data = TicketChatModel.fromJson(jsonDecode(response.body));

        // setNoProduct(resultMeta!.total == 0);

        notifyListeners();
      } else {}
    } catch (error) {
      print(error);

      rethrow;
    }
  }
}
