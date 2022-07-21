import 'package:flutter/cupertino.dart';
import 'package:gren_mart/model/products.dart';

// class Favorites {
//   final String id;
//   final String name;
//   final String image;
//   double price;
//   Favorites(this.id, this.name, this.image, this.price);
// }

class FavoriteData with ChangeNotifier {
  final Map<String, Product?> _favoriteItems = {};

  Map<String, Product?> get favoriteItems {
    return _favoriteItems;
  }

  bool isfavorite(String id) {
    return _favoriteItems.containsKey(id);
  }

  void toggleFavorite(String id, {Product? product}) {
    if (_favoriteItems.containsKey(id)) {
      _favoriteItems.remove(id);
      notifyListeners();
      return;
    }
    _favoriteItems.putIfAbsent(id, () => product);
    notifyListeners();
  }
}
