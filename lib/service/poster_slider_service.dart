import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/model/poster_slider_model.dart';
import 'package:gren_mart/service/common_service.dart';
import 'package:http/http.dart' as http;

class PosterSliderService with ChangeNotifier {
  List<Datum> posterDataList = [];

  Future<void> fetchPosters() async {
    if (posterDataList.isNotEmpty) {
      return;
    }
    print('fetching posters');

    final url = Uri.parse('$baseApiUrl/mobile-slider/1');

    try {
      final response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        final data = PosterSliderModel.fromJson(jsonDecode(response.body));
        var stateData = [];
        // for (int i = 0; i < data.data.length; i++) {
        //   posterDataList.add({
        //     'title': data.data[i].title,
        //     'description': data.data[i].description,
        //     'image': data.data[i].image,
        //   });        }
        posterDataList = data.data;
        print(posterDataList[0]);
        print('-------------------------------------');
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
