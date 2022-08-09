import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../model/product_details_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class ProductDetailsService with ChangeNotifier {
  ProductDetailsModel? productDetails;
  bool descriptionExpand = false;
  bool aDescriptionExpand = false;

  toggleDescriptionExpande() {
    descriptionExpand = !descriptionExpand;
    notifyListeners();
  }

  toggleADescriptionExpande() {
    aDescriptionExpand = !aDescriptionExpand;
    notifyListeners();
  }

  Map<String, String> setAditionalInfo() {
    Map<String, String> data = {};
    for (var element in productDetails!.product.additionalInfo) {
      data.putIfAbsent(element.title, () => element.text);
    }
    return data;
  }

  clearProdcutDetails() {
    productDetails = null;
    descriptionExpand = false;
    bool aDescriptionExpand = false;
    notifyListeners();
  }

  Future fetchProductDetails(id) async {
    print(id);
    final url = Uri.parse('$baseApiUrl/product/$id');

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
