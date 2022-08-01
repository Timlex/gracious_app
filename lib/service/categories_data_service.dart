import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/model/category_model.dart';
import 'package:gren_mart/model/sub_category_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class CategoriesDataService with ChangeNotifier {
  List<Category> categorydataList = [];
  Category? selectedCategorie;
  List<Subcategory> subCategorydataList = [];
  Subcategory? selectedSubCategorie;

  setSelectedCategory(value) {
    selectedCategorie = value;
    notifyListeners();
  }

  setSelectedSubCategory(value) {
    selectedSubCategorie = value;
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
        selectedCategorie = categorydataList[0];

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
        selectedSubCategorie = subCategorydataList[0];

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
