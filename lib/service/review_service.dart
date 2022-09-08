import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'dart:convert';

import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class ReviewService with ChangeNotifier {
  String rating = '1';
  String comment = '';
  bool isLoading = false;

  setRating(value) {
    rating = value;
    notifyListeners();
  }

  setComment(value) {
    comment = value;
    notifyListeners();
  }

  toggleLaodingSpinner(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<dynamic> submitReview(String id, BuildContext context) async {
    final url = Uri.parse('$baseApiUrl/product-review');
    toggleLaodingSpinner(true);
    print('$id, $comment, $rating, $isLoading');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      'Content-Type': 'application/json',
      "Authorization": "Bearer $globalUserToken",
    };
    // try {
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          'id': id,
          'rating': rating,
          'comment': comment,
        }));
    print(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      notifyListeners();
      return;
    }
    if (response.statusCode == 422) {
      final data = json.decode(response.body);
      print(data['message']);
      return data['message'];
    }
    snackBar(context, 'Connection failed');
    return 'Someting went wrong';
    // } catch (error) {
    //   print(error);

    //   rethrow;
    // }
  }
}
