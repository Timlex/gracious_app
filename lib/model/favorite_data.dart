import 'package:flutter/cupertino.dart';
import 'package:gren_mart/db/database_helper.dart';
import 'package:gren_mart/model/product_data.dart';

// class Favorites {
//   final String id;
//   final String name;
//   final String image;
//   double price;
//   Favorites(this.id, this.name, this.image, this.price);
// }

class FavoriteData with ChangeNotifier {
  Map<String, Product?> _favoriteItems = {};

  Map<String, Product?> get favoriteItems {
    return _favoriteItems;
  }

  bool isfavorite(String id) {
    return _favoriteItems.containsKey(id);
  }

  void toggleFavorite(String id, {Product? product}) async {
    if (_favoriteItems.containsKey(id) && product != null) {
      deleteFavoriteItem(id);
      _favoriteItems.remove(id);
      notifyListeners();
      return;
    }
    await DbHelper.insert('favorite', {
      'productId': product!.id,
      'title': product.title,
      'discountPecentage': product.discountPecentage,
      'amount': product.amount,
      'image': product.image[0],
    });
    _favoriteItems.putIfAbsent(id, () => product);
    notifyListeners();
  }

  void fetchFavorites() async {
    final dbData = await DbHelper.fetchDb('cart');
    Map<String, Product> dataList = {};
    for (var element in dbData) {
      final product = Product(
        id: element['productId'],
        title: element['title'],
        amount: element['amount'],
        discountPecentage: element['discountPecentage'],
        image: [element['image'].toString()],
      );
      dataList.putIfAbsent(
          element['productId'],
          () => Product(
                id: element['productId'],
                title: element['title'],
                amount: element['amount'],
                discountPecentage: element['discountPecentage'],
                image: [element['image'].toString()],
              ));
    }
    _favoriteItems = dataList;
    notifyListeners();
    print('fetching carts');
    // _cartList = dataList;
  }

  void deleteFavoriteItem(String id) async {
    await DbHelper.deleteDbSI('favorite', id);
    _favoriteItems.remove(id);
    notifyListeners();
  }
}
