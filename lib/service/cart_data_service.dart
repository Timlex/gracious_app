import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../db/database_helper.dart';
import '../model/cart_data_model.dart';
import 'common_service.dart';

class CartDataService with ChangeNotifier {
  Map<String, Cart> _cartItems = {}
      // Map<String, List<Map<String, dynamic>>> _cartItems = {}
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

  int calculateSubtotal() {
    int sum = 0;
    cartList.forEach((key, value) {
      sum += value.discountPrice * value.quantity;
    });
    return sum;
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
        colorName: value.colorName,
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
        colorName: value.colorName,
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
    String? colorName,
    String? sauce,
    String? mayo,
    String? cheese,
  }) async {
    if (_cartItems.containsKey(id.toString())) {
      addItem(id, extraQuantity: quantity);
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
          'colorName': colorName,
          'sauce': sauce,
          'mayo': mayo,
          'cheese': cheese,
        },
      );
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
                colorName: colorName,
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
          colorName: element['colorName'],
          sauce: element['sauce'],
          mayo: element['mayo'],
          cheese: element['cheese'],
        );
      });
    }
    dataList.forEach((key, value) {});
    _cartItems = dataList;
    notifyListeners();
    refreshCartList();
    print('fetching carts');
    // _cartList = dataList;
  }

  void deleteCartItem(int id) async {
    await DbHelper.deleteDbSI('cart', id);
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

  refreshCartList() {
    cartList.forEach((key, value) async {
      final url = Uri.parse('$baseApiUrl/product/$key');

      // try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        deleteCartItem(value.id);
      }
    });
  }
}
