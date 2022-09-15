import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../db/database_helper.dart';
import '../model/favorite_data_model.dart';
import '../view/utils/constant_styles.dart';
import 'common_service.dart';

class FavoriteDataService with ChangeNotifier {
  Map<String, Favorites> _favoriteItems = {};

  Map<String, Favorites> get favoriteItems {
    return _favoriteItems;
  }

  bool isfavorite(String id) {
    return _favoriteItems.containsKey(id);
  }

  void toggleFavorite(
    BuildContext context,
    int id,
    String title,
    int price,
    int discountPrice,
    String imgUrl,
  ) async {
    if (_favoriteItems.containsKey(id.toString())) {
      deleteFavoriteItem(id, context);
      _favoriteItems.remove(id);
      notifyListeners();
      return;
    }
    await DbHelper.insert('favorite', {
      'productId': id,
      'title': title,
      'price': price,
      'discountPrice': discountPrice,
      'imgUrl': imgUrl,
    });
    _favoriteItems.putIfAbsent(id.toString(),
        () => Favorites(id, title, price, discountPrice, imgUrl));
    snackBar(context, 'Item added to favorite.');
    notifyListeners();
  }

  void fetchFavorites() async {
    final dbData = await DbHelper.fetchDb('favorite');
    Map<String, Favorites> dataList = {};
    for (var element in dbData) {
      dataList.putIfAbsent(
          element['productId'].toString(),
          () => Favorites(
                element['productId'],
                element['title'],
                element['price'],
                element['discountPrice'],
                element['imgUrl'],
              ));
    }
    _favoriteItems = dataList;
    notifyListeners();
    refreshFavList();
    print('fetching favorite');
  }

  void deleteFavoriteItem(int id, BuildContext context) async {
    await DbHelper.deleteDbSI('favorite', id);
    _favoriteItems.removeWhere((key, value) => value.id == id);
    snackBar(context, 'Item removed from favorite.',
        backgroundColor: cc.orange);
    notifyListeners();
  }

  refreshFavList() {
    favoriteItems.forEach((key, value) async {
      final url = Uri.parse('$baseApiUrl/product/$key');

      // try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        await DbHelper.deleteDbSI('favorite', value.id);
        _favoriteItems.removeWhere((key, value) => value.id == value.id);
        notifyListeners();
      }
    });
  }
}
