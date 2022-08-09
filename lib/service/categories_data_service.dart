import 'dart:convert';

import 'package:flutter/material.dart';
import '../../model/category_model.dart';
import '../../model/sub_category_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class CategoriesDataService with ChangeNotifier {
  List<Category> categorydataList = [];
  String selectedCategorieId = '';
  List<Subcategory> subCategorydataList = [];
  String selectedSubCategorieId = '';

  setSelectedCategory(value) {
    selectedCategorieId = value;
    notifyListeners();
  }

  setSelectedSubCategory(value) {
    selectedSubCategorieId = value;
    notifyListeners();
  }

  Future fetchCategories() async {
    if (categorydataList.isNotEmpty) {
      return;
    }

    final url = Uri.parse('$baseApiUrl/category');

    try {
      final response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final data = CategoryModel.fromJson(jsonDecode(response.body));

        categorydataList = data.categories;

        notifyListeners();
      } else {
        // print('something went wrong');
      }
    } catch (error) {
      // print(error);

      rethrow;
    }
  }

  Future fetchSubCategories() async {
    if (subCategorydataList.isNotEmpty) {
      return;
    }
    final url = Uri.parse('$baseApiUrl/subcategory');

    try {
      final response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final data = SubCategoryModel.fromJson(jsonDecode(response.body));

        subCategorydataList = data.subcategories;

        notifyListeners();
      } else {
        // print('something went wrong');
      }
    } catch (error) {
      // print(error);

      rethrow;
    }
  }
}
