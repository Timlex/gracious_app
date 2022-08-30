import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/model/mobile_slider_model.dart';
import '../../service/common_service.dart';
import 'package:http/http.dart' as http;

class PosterCampaignSliderService with ChangeNotifier {
  List<Datum> posterDataList = [];
  List<Datum> campaignDataList = [];

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
        final data = MobileSliderModel.fromJson(jsonDecode(response.body));
        var stateData = [];
        // for (int i = 0; i < data.data.length; i++) {
        //   posterDataList.add({
        //     'title': data.data[i].title,
        //     'description': data.data[i].description,
        //     'image': data.data[i].image,
        //   });        }
        posterDataList = data.data;
        print(posterDataList[0].title);
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

  Future<void> fetchCampaigns() async {
    if (campaignDataList.isNotEmpty) {
      return;
    }
    print('fetching Campaign');

    final url = Uri.parse('$baseApiUrl/mobile-slider/2');

    // try {
    final response = await http.get(
      url,
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = MobileSliderModel.fromJson(jsonDecode(response.body));
      // var stateData = [];

      campaignDataList = data.data;
      print(campaignDataList[0].title);
      print('-------------------------------------');
      notifyListeners();
    }

    // else {
    //   // print('something went wrong');
    // }
    // } catch (error) {
    //   // print(error);

    //   rethrow;
    // }
  }
}
