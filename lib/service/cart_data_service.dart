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
  var subTotal = 0;

  Map<String, Cart> get cartList {
    return _cartItems;
  }

  void addItem(int id, {int? extraQuantity}) async {
    _cartItems.update(id.toString(), (value) {
      int sum = value.quantity + (extraQuantity ?? 1);
      DbHelper.updateQuantity(
        'cart',
        id,
        {
          // 'productId': id,
          'quantity': sum,
          // 'title': value.title,
          // 'price': value.price,
          // 'discountPrice': value.discountPrice,
          // 'campaignPercentage': value.campaignPercentage,
          // 'imgUrl': value.imgUrl,
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
        size: value.size,
        color: value.color,
        sauce: value.sauce,
        mayo: value.mayo,
        cheese: value.cheese,
      );
    });

    notifyListeners();
  }

  void minusItem(int id) {
    if (_cartItems[id.toString()]!.quantity == 1) {
      return;
    }
    _cartItems.update(id.toString(), (value) {
      int sum = value.quantity - 1;
      DbHelper.updateQuantity(
        'cart',
        id,
        {
          // 'productId': id,
          'quantity': sum,
          // 'title': value.title,
          // 'price': value.price,
          // 'discountPrice': value.discountPrice,
          // 'campaignPercentage': value.campaignPercentage,
          // 'imgUrl': value.imgUrl,
        },
      );
      subTotal -= value.price;
      return Cart(
        value.id,
        value.title,
        value.price,
        value.discountPrice,
        value.campaignPercentage,
        sum,
        value.imgUrl,
        size: value.size,
        color: value.color,
        sauce: value.sauce,
        mayo: value.mayo,
        cheese: value.cheese,
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
    String imgUrl, {
    String? size,
    String? color,
    String? sauce,
    String? mayo,
    String? cheese,
  }) async {
    if (_cartItems.containsKey(id.toString())) {
      addItem(id, extraQuantity: quantity);
      subTotal += price * quantity;
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
          'quantity': quantity,
          'imgUrl': imgUrl,
          'size': size,
          'color': color,
          'sauce': sauce,
          'mayo': mayo,
          'cheese': cheese,
        },
      );
      subTotal += price * quantity;
      _cartItems.putIfAbsent(
          id.toString(),
          (() => Cart(
                id,
                title,
                price,
                discountPrice,
                campaignPercentage,
                quantity,
                imgUrl,
                size: size,
                color: color,
                sauce: sauce,
                mayo: mayo,
                cheese: cheese,
              )));

      notifyListeners();
    } catch (error) {
      return;
    }
  }

  void fetchCarts() async {
    final dbData = await DbHelper.fetchDb('cart');
    Map<String, Cart> dataList = {};
    for (var element in dbData) {
      dataList.putIfAbsent(element['productId'].toString(), () {
        return Cart(
          element['productId'],
          element['title'],
          element['price'],
          element['discountPrice'],
          element['campaignPercentage'],
          element['quantity'],
          element['imgUrl'],
          size: element['size'],
          color: element['color'],
          sauce: element['sauce'],
          mayo: element['mayo'],
          cheese: element['cheese'],
        );
      });
    }
    dataList.forEach((key, value) {
      subTotal += value.price * value.quantity;
    });
    _cartItems = dataList;
    notifyListeners();
    print('fetching carts');
    // _cartList = dataList;
  }

  void deleteCartItem(int id) async {
    await DbHelper.deleteDbSI('cart', id);
    subTotal -=
        _cartItems[id.toString()]!.price * _cartItems[id.toString()]!.quantity;
    _cartItems.remove(id.toString());
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
