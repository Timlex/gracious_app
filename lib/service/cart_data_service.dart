import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../model/cart_data_model.dart';

class CartDataService with ChangeNotifier {
  Map<String, Cart> _cartItems = {}
      // Cart(id: '01', quantity: 2),
      // Cart(id: '03', quantity: 6),
      // Cart(id: '02', quantity: 1),
      // Cart(id: '04', quantity: 1),
      // Cart(id: '05', quantity: 1),
      // Cart('06', 1),
      ;

  Map<String, Cart> get cartList {
    return _cartItems;
  }

  void addItem(int id) async {
    _cartItems.update(id.toString(), (value) {
      int sum = value.quantity + 1;
      DbHelper.updateQuantity(
        'cart',
        id,
        {
          'productId': id,
          'quantity': sum,
          'title': value.title,
          'price': value.price,
          'discountPrice': value.discountPrice,
          'campaignPercentage': value.campaignPercentage,
          'imgUrl': value.imgUrl,
        },
      );
      return Cart(
        value.id,
        value.title,
        value.price,
        value.discountPrice,
        value.campaignPercentage,
        sum,
        value.imgUrl,
      );
    });

    notifyListeners();
  }

  void minusItem(int id) {
    if (_cartItems[id]!.quantity == 1) {
      return;
    }
    _cartItems.update(id.toString(), (value) {
      int sum = value.quantity - 1;
      DbHelper.updateQuantity(
        'cart',
        id,
        {
          'productId': id,
          'quantity': sum,
          'title': value.title,
          'price': value.price,
          'discountPrice': value.discountPrice,
          'campaignPercentage': value.campaignPercentage,
          'imgUrl': value.imgUrl,
        },
      );
      return Cart(
        value.id,
        value.title,
        value.price,
        value.discountPrice,
        value.campaignPercentage,
        sum,
        value.imgUrl,
      );
    });

    notifyListeners();
  }

  void deleteFromCart(String id) {
    // int index = _cartList.indexWhere((element) => element['id'].id == id);

    // _cartList.removeAt(index);
    // print(_cartList.length.toString());
  }

  void addCartItem(
    int id,
    String title,
    int price,
    int discountPrice,
    double campaignPercentage,
    int quantity,
    String imgUrl,
  ) async {
    if (_cartItems.containsKey(id.toString())) {
      addItem(id);
      notifyListeners();
      return;
    }

    try {
      await DbHelper.insert(
        'cart',
        {
          'productId': id,
          'title': title,
          'price': price,
          'discountPrice': discountPrice,
          'campaignPercentage': campaignPercentage,
          'quantity': 1,
          'imgUrl': imgUrl,
        },
      );
      _cartItems.putIfAbsent(
          id.toString(),
          (() => Cart(
              id, title, price, discountPrice, campaignPercentage, 1, imgUrl)));
      notifyListeners();
    } catch (error) {
      return;
    }
  }

  void fetchCarts() async {
    final dbData = await DbHelper.fetchDb('cart');
    Map<String, Cart> dataList = {};
    for (var element in dbData) {
      dataList.putIfAbsent(
          element['productId'].toString(),
          () => Cart(
                element['productId'],
                element['title'],
                element['price'],
                element['discountPrice'],
                element['campaignPercentage'],
                element['quantuty'] ?? 1,
                element['imgUrl'],
              ));
    }
    _cartItems = dataList;
    notifyListeners();
    print('fetching carts');
    // _cartList = dataList;
  }

  void deleteCartItem(int id) async {
    await DbHelper.deleteDbSI('cart', id);
    _cartItems.remove(id);
    notifyListeners();
  }

  int totalQuantity() {
    var total = 0;
    cartList.forEach((key, value) {
      total += value.quantity;
    });
    return total;
  }
}
