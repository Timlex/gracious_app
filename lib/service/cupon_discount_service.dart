import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../service/common_service.dart';

class CuponDiscountService with ChangeNotifier {
  String? cuponText;
  String? totalAmount;
  String? cartData;
  double cuponDiscount = 0;
  bool isLoading = false;

  setCuponText(value) {
    cuponText = value;
    notifyListeners();
  }

  setTotalAmount(double value) {
    totalAmount = value.toStringAsFixed(0);
    notifyListeners();
  }

  setCarData(value) {
    cartData = value;
    notifyListeners();
  }

  Future<dynamic> getCuponDiscontAmount() async {
    if (cuponText == null || cuponText == '') {
      return 'Enter a valid cupon';
    }
    isLoading = true;
    notifyListeners();
    final url = Uri.parse('$baseApiUrl/coupon');

    // try {
    final response = await http.post(url, body: {
      'coupon': cuponText,
      'total_amount': totalAmount,
      'ids': cartData,
    });
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      cuponDiscount = json.decode(response.body)['coupon_amount'];
      isLoading = false;
      notifyListeners();
      return;
    }
    if (response.statusCode == 422) {
      final data = json.decode(response.body);
      print(data['coupon_amount']);
      isLoading = false;
      return data['coupon_amount'];
    }
    isLoading = false;
    //   return 'Someting went wrong';
    // } catch (error) {
    //   print(error);

    //   rethrow;
    // }
  }
}
