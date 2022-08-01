// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/campaign_product_model.dart';
import 'package:gren_mart/model/featured_product_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class ProductCardDataService with ChangeNotifier {
  List<Datum> featuredCardProductsList = [];
  List<Product> campaignCardProductList = [];
  CampaignInfo? campaignInfo;

  Future fetchFeaturedProductCardData() async {
    print('get featured products ran');
    final url = Uri.parse('$baseApiUrl/featured/product');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = FeaturedCardProducts.fromJson(jsonDecode(response.body));
        featuredCardProductsList = data.data;

        print(featuredCardProductsList[0].prdId);
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

  Future fetchCapmaignCardProductData() async {
    print('get featured products ran');
    final url = Uri.parse('$baseApiUrl/campaign/product');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = CampaignProductModel.fromJson(jsonDecode(response.body));
        campaignCardProductList = data.products;
        campaignInfo = data.campaignInfo;

        // print(featuredCardProductsList[0].prdId);
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
