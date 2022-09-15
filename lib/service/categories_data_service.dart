import 'dart:convert';

import 'package:flutter/material.dart';
import '../../model/category_model.dart';
import '../../model/sub_category_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class CategoriesDataService with ChangeNotifier {
  List<Category> categorydataList = [];
  String selectedCategorieId = '';
  Subcategory? subCategorydataList;
  String selectedSubCategorieId = '';
  bool noSubcategory = false;
  bool loading = false;
  bool hasError = false;
  double minPrice = 0;
  double maxPrice = 0;

  setSelectedCategory(value) async {
    selectedCategorieId = value;
    subCategorydataList = null;
    loading = true;
    noSubcategory = false;
    notifyListeners();
    if (value != '') {
      fetchSubCategories().onError((error, stackTrace) {
        loading = false;
        noSubcategory = true;
        notifyListeners();
      });
    }
  }

  setSelectedSubCategory(value) {
    selectedSubCategorieId = value;
    notifyListeners();
  }

  Future fetchCategories() async {
    if (categorydataList.isNotEmpty) {
      return;
    }
    fetchPriceRange();
    final url = Uri.parse('$baseApiUrl/category');

    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      final data = CategoryModel.fromJson(jsonDecode(response.body));

      categorydataList = data.categories;

      notifyListeners();
    } else {
      throw '';
    }
  }

  Future fetchSubCategories() async {
    print('here we are');
    if (subCategorydataList != null) {
      return;
    }
    print('fetching sub category');
    final url = Uri.parse('$baseApiUrl/subcategory/$selectedCategorieId');

    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      final data = SubcategoryModel.fromJson(jsonDecode(response.body));

      subCategorydataList = data.subcategory;
      print(subCategorydataList);
      noSubcategory = subCategorydataList == null;
      loading = false;
      notifyListeners();
      return;
    }
    noSubcategory = true;
    loading = false;
    notifyListeners();
  }

  Future fetchPriceRange() async {
    final url = Uri.parse('$baseApiUrl/product/price-range');

    final response = await http.get(
      url,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      minPrice = data['min_price'].toDouble();
      maxPrice = data['max_price'].toDouble();
      print(minPrice);
      print(maxPrice);
      categorydataList = data.categories;

      notifyListeners();
    } else {
      throw '';
    }
  }
}
