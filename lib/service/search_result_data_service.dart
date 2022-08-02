// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/model/search_result_data_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class SearchResultDataService with ChangeNotifier {
  List<Datum> searchResult = [];
  Meta? resultMeta;
  String searchText = '';
  RangeValues rangevalue = const RangeValues(0, 3500);
  String maxPrice = '';
  String minPrice = '';
  String ratingPoint = '';
  bool isLoading = false;
  bool? lastPage;
  String categoryId = '';
  String subCategoryId = '';
  bool noProduct = false;

  setRangeValues(value) {
    rangevalue = value;
    minPrice = rangevalue.start.toInt().toString();
    maxPrice = rangevalue.end.toInt().toString();
    notifyListeners();
  }

  setLastPage(value) {
    lastPage = value;
    notifyListeners();
  }

  setIsLoading(value) {
    isLoading = value;
    notifyListeners();
  }

  setSearchText(value) {
    searchText = value;
    notifyListeners();
  }

  setRating(value) {
    ratingPoint = value.toString();
    notifyListeners();
  }

  setCategoryId(value) {
    categoryId = value;
    notifyListeners();
  }

  setNoProduct(value) {
    noProduct = value;
    notifyListeners();
  }

  setSubCategoryId(value) {
    subCategoryId = value;
    notifyListeners();
  }

  resetSerch() {
    lastPage = false;
    searchResult = [];
    resultMeta = null;
    notifyListeners();
  }

  resetSerchFilters() {
    lastPage = false;
    searchResult = [];
    resultMeta = null;
    minPrice = '';
    maxPrice = '';
    categoryId = '';
    subCategoryId = '';
    ratingPoint = '';
    rangevalue = const RangeValues(0, 3500);

    notifyListeners();
  }

  Future fetchProductsBy(
      {String count = '', sortBy = '', String pageNo = ''}) async {
    print(lastPage);
    if (lastPage != null && lastPage!) {
      setIsLoading(false);
      notifyListeners();
      print('Leaving fetching___________');
      return 'No more product found!';
    }
    print('searching in progress');
    final url = Uri.parse(
        '$baseApiUrl/product?count=&q=$searchText&cat=$categoryId&subcat=$subCategoryId&pr_min=$minPrice&pr_max=$maxPrice&rt=$ratingPoint&sort=$sortBy&page=$pageNo');
    print(url);
    try {
      final response = await http.get(url);

      if (response.statusCode == 201) {
        var data = SearchResultDataModel.fromJson(jsonDecode(response.body));

        for (var element in data.data) {
          searchResult.add(element);
        }
        resultMeta = data.meta;
        setLastPage(resultMeta!.lastPage.toString() == pageNo);
        print(isLoading);
        print(searchResult.length);
        print(resultMeta!.total.toString() + '-------------------');
        setIsLoading(false);
        setNoProduct(resultMeta!.total == 0);

        notifyListeners();
      } else {}
    } catch (error) {
      print(error);

      rethrow;
    }
  }
}
