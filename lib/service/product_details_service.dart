import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/product_details_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class ProductDetailsService with ChangeNotifier {
  ProductDetailsModel? productDetails;

  clearProdcutDetails() {
    productDetails = null;
    notifyListeners();
  }

  Future fetchProductDetails(id) async {
    print(id);
    final url = Uri.parse('$baseApiUrl/product/55');

    try {
      final response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = ProductDetailsModel.fromJson(jsonDecode(response.body));
        productDetails = data;

        print(productDetails!.product.title);
        // print(countryDropdownList);

        notifyListeners();
      } else {
        //something went wrong
      }
    } catch (error) {
      print(error);

      rethrow;
    }
  }
}
