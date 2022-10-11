import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:http/http.dart' as http;

import '../db/database_helper.dart';
import 'common_service.dart';

class CartDataService with ChangeNotifier {
  Map<String, List<Map<String, Object?>>>? _cartItems = {};

  Map<String, List<Map<String, Object?>>>? get cartList {
    final clist = _cartItems;
    return clist;
  }

  int calculateSubtotal() {
    int sum = 0;
    _cartItems!.forEach((key, value) {
      value.forEach((element) {
        sum += (element['price'] as int) * (element['quantity'] as int);
      });
    });
    return sum;
  }

  formatItems() {
    Map map = {};

    _cartItems!.keys.forEach((element) {
      List list = [];
      print(element);
      _cartItems![element]!.forEach((e) {
        if (e['attributes'] == null) {
          list.add(({
            'id': e['id'],
            'quantity': e['quantity'],
            'attributes': {"price": e['price']},
          }));
        }
        if (e['attributes'] != null) {
          (e['attributes'] as Map).putIfAbsent("price", () => e['price']);
          list.add(({
            'id': e['id'],
            'quantity': e['quantity'],
            'hash': e['hash'],
            'attributes': e['attributes'],
          }));
        }
      });
      (list[0]['attributes'] as Map).remove('Color_name');
      (list[0]['attributes'] as Map).remove('Color');
      print(list);
      map.putIfAbsent(element, () => list);
      print(list);
    });
    print(map);
    return map;
  }

  void addItem(BuildContext context, int id,
      {int? extraQuantity, inventorySet}) async {
    _cartItems![id.toString()]!.forEach((element) {
      if (element['id'] == id &&
          (element.containsValue(inventorySet) ||
              (jsonEncode(inventorySet) == jsonEncode(element['attributes'])) ||
              (inventorySet == null && element['attributes'] == null))) {
        element.update('quantity', (value) {
          int sum = (value as int) + (extraQuantity ?? 1);
          print(sum);
          snackBar(context, 'Item added to cart');
          return sum;
        });
      }
    });

    DbHelper.updateQuantity(
      'cart',
      id,
      {
        'data': jsonEncode({
          id.toString(): cartList![id.toString()],
        })
      },
    );

    notifyListeners();
  }

  void minusItem(int id, BuildContext context, {inventorySet}) {
    _cartItems![id.toString()]!.forEach((element) {
      if (element['id'] == id &&
          (element.containsValue(inventorySet) ||
              (inventorySet == null && element['attributes'] == null))) {
        print(element['quantity']);
        element.update('quantity', (value) {
          int sum = value as int;
          if (value != 1) {
            sum -= 1;
          }
          print(sum);

          // };
          return sum;
        });
        print(element['quantity']);
      }
    });

    DbHelper.updateQuantity(
      'cart',
      id,
      {
        'data': jsonEncode({
          id.toString(): cartList![id.toString()],
        })
      },
    );
    snackBar(context, 'Item minused from cart', backgroundColor: cc.orange);

    notifyListeners();
  }

  void addCartItem(BuildContext context, int id, String title, int price,
      int discountPrice, double campaignPercentage, int quantity, String imgUrl,
      {String? hash, inventorySet}) async {
    // print(inventorySet);
    Map<String, List<Map<String, Object?>>>? map = {
      id.toString(): [
        {
          'id': id,
          'title': title,
          'price': price,
          'imgUrl': imgUrl,
          'quantity': quantity,
          'hash': hash,
          'attributes': inventorySet ?? {}
        },
      ]
    };
    if (!_cartItems!.containsKey(id.toString())) {
      await DbHelper.insert('cart', {
        'productId': id,
        'data': jsonEncode(map),
      });
      _cartItems![id.toString()] = [
        {
          'id': id,
          'title': title,
          'price': price,
          'imgUrl': imgUrl,
          'quantity': quantity,
          'hash': hash,
          'attributes': inventorySet ?? {}
        }
      ];
      snackBar(context, 'Item added to cart.');
      notifyListeners();
      return;
    }

    bool haveData = false;
    _cartItems![id.toString()]!.forEach((element) {
      if ((element.containsValue(inventorySet) ||
          (jsonEncode(inventorySet) == jsonEncode(element['attributes'])) ||
          (inventorySet == null && element['attributes'] == null))) {
        haveData = true;
      }
    });
    print(inventorySet);
    print('have data on cart--$haveData');
    if (_cartItems!.containsKey(id.toString()) && haveData) {
      addItem(context, id, extraQuantity: quantity, inventorySet: inventorySet);
      notifyListeners();
      return;
    }

    // try {
    if (_cartItems!.containsKey(id.toString()) && !haveData) {
      _cartItems![id.toString()]!.add({
        'id': id,
        'title': title,
        'price': price,
        'imgUrl': imgUrl,
        'quantity': quantity,
        'hash': hash,
        'attributes': inventorySet ?? {}
      });
      DbHelper.updateQuantity(
        'cart',
        id,
        {
          'data': jsonEncode({
            id.toString(): cartList![id.toString()],
          })
        },
      );
      snackBar(context, 'Item added to cart');

      notifyListeners();
    }
  }

  void fetchCarts() async {
    final dbData = await DbHelper.fetchDb('cart');
    Map<String, List<Map<String, Object?>>> dataList = {};
    if (dbData == null || dbData.isEmpty) {
      print('cart db is empty');
      return;
    }
    for (var element in dbData) {
      final data = jsonDecode(element['data']);
      List<dynamic> listData = data[element['productId'].toString()];
      List<Map<String, Object?>> listMap = [];
      listData.forEach((element) {
        listMap.add(element);
      });
      dataList[element['productId'].toString()] = listMap;
      ;
    }
    dataList.forEach((key, value) {});
    _cartItems = dataList;
    notifyListeners();
    refreshCartList();
    print('fetching carts');
    // _cartList = dataList;
  }

  void deleteCartItem(int id, {inventorySet}) async {
    print(inventorySet);
    if (!cartList!.containsKey(id.toString())) {
      return;
    }
    if (cartList![id.toString()]!.length == 1) {
      await DbHelper.deleteDbSI('cart', id);
      _cartItems!.remove(id.toString());
      notifyListeners();
      return;
    }
    Map<String, Object?> targetedElement = {};
    _cartItems![id.toString()]!.forEach((element) {
      if (element['id'] == id &&
          (element.containsValue(inventorySet) ||
              (inventorySet == null && element['attributes'] == null))) {
        print(element);
        targetedElement = element;
      }
    });
    _cartItems![id.toString()]!.remove(targetedElement);
    DbHelper.updateQuantity('cart', id, {
      'data': jsonEncode({id.toString(): cartList![id.toString()]})
    });

    notifyListeners();
  }

  int totalQuantity() {
    var total = 0;
    cartList!.values.forEach((value) {
      value.forEach((element) {
        total += element['quantity'] as int;
      });
    });
    return total;
  }

  refreshCartList() async {
    try {
      cartList!.forEach((key, value) async {
        final url = Uri.parse('$baseApiUrl/product/$key');

        // try {
        final response = await http.get(url);
        if (response.statusCode != 200) {
          deleteCartItem(int.parse(key));
        }
      });
    } catch (e) {
      print(e);
    }
  }

  emptyCart() async {
    await DbHelper.deleteDbTable('cart');
    _cartItems = {};
    notifyListeners();
  }
}
