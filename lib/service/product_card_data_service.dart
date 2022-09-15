// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../../model/campaign_product_model.dart';
import '../../model/featured_product_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class ProductCardDataService with ChangeNotifier {
  List<Datum> featuredCardProductsList = [];
  List<Product> campaignCardProductList = [];
  List<Product> campaignPageProductList = [];
  CampaignInfo? campaignInfo;
  CampaignInfo? campaignPageInfo;
  bool featureNoData = false;
  bool campaignNoData = false;

  Future fetchFeaturedProductCardData() async {
    if (featuredCardProductsList.isNotEmpty) {
      return;
    }
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
    if (campaignCardProductList.isNotEmpty) {
      return;
    }
    print('get featured products ran');
    final url = Uri.parse('$baseApiUrl/campaign/product');

    // try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = CampaignProductModel.fromJson(jsonDecode(response.body));
      campaignCardProductList = data.products;
      campaignInfo = data.campaignInfo;

      // print(featuredCardProductsList[0].prdId);
      // print(countryDropdownList);

      featureNoData = false;
      notifyListeners();
    }
    featureNoData = true;
    notifyListeners();
  }

  Future fetchCapmaignPageProductData({id}) async {
    print('get featured products ran-------------$id');
    final url = Uri.parse('$baseApiUrl/campaign/product/${id ?? ''}');

    // try {print
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = CampaignProductModel.fromJson(jsonDecode(response.body));
      campaignPageProductList = data.products;
      campaignPageInfo = data.campaignInfo;

      // print(featuredCardProductsList[0].prdId);
      // print(countryDropdownList);
      campaignNoData = false;

      notifyListeners();
    }
    campaignNoData = true;
    notifyListeners();
    // } catch (error) {
    //   print(error);

    //   rethrow;
    // }
  }
}
