import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../model/favorite_data_model.dart';

class FavoriteDataService with ChangeNotifier {
  Map<String, Favorites> _favoriteItems = {};

  Map<String, Favorites> get favoriteItems {
    return _favoriteItems;
  }

  bool isfavorite(String id) {
    return _favoriteItems.containsKey(id);
  }

  void toggleFavorite(
    int id,
    String title,
    int price,
    int discountPrice,
    String imgUrl,
  ) async {
    if (_favoriteItems.containsKey(id.toString())) {
      deleteFavoriteItem(id);
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
    print('fetching favorite');
  }

  void deleteFavoriteItem(int id) async {
    await DbHelper.deleteDbSI('favorite', id);
    _favoriteItems.removeWhere((key, value) => value.id == id);
    notifyListeners();
  }
}
