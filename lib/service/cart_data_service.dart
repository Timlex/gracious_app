import 'dart:convert';

import 'package:flutter/material.dart';
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
    List list = [];
    Map map = {};

    _cartItems!.keys.forEach((element) {
      _cartItems![element]!.forEach((e) {
        if (e['attributes'] == null) {
          list.add(({
            'id': e['id'],
            'quantity': e['quantity'],
            'attributes': {},
          }));
        }
        if (e['attributes'] != null) {
          list.add(({
            'id': e['id'],
            'quantity': e['quantity'],
            'attributes': e['attributes'],
          }));
        }
      });
      map.putIfAbsent(element, () => list);
    });
    return map;
  }

  void addItem(int id, {int? extraQuantity, inventorySet}) async {
    _cartItems![id.toString()]!.forEach((element) {
      if (element['id'] == id &&
          (element.containsValue(inventorySet) ||
              (inventorySet == null && element['attributes'] == null))) {
        element.update('quantity', (value) {
          int sum = (value as int) + (extraQuantity ?? 1);
          print(sum);
          // _cartItems![id.toString()]!.firstWhere((e) =>
          //     e.containsKey(id.toString()) &&
          //     e.containsValue(inventorySet))['quantity'] = sum;
          // return {
          //   'prodcutId': value['prodcutId'],
          //   'title': value['title'],
          //   'price': value['price'],
          //   'imgUrl': value['imgUrl'],
          //   'quantity': sum,
          //   'attributes': value['attributes'],
          // };
          return sum;
        });
      }
    });
    // _cartItems![id.toString()]!
    //     .where((element) =>
    //         element.containsKey(id.toString()) &&
    //         element.containsValue(inventorySet))
    //     .first
    //     .update(id.toString(), (value) {
    //   int sum = (value as Map)['quantity'] + (extraQuantity ?? 1);
    //   _cartItems![id.toString()]!.firstWhere((e) =>
    //       e.containsKey(id.toString()) &&
    //       e.containsValue(inventorySet))['quantity'] = sum;
    //   return {
    //     'prodcutId': value['prodcutId'],
    //     'title': value['title'],
    //     'price': value['price'],
    //     'imgUrl': value['imgUrl'],
    //     'quantity': sum,
    //     'attributes': value['attributes'],
    //   };
    // });
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

  void minusItem(int id, {inventorySet}) {
    _cartItems![id.toString()]!.forEach((element) {
      if (element['id'] == id &&
          (element.containsValue(inventorySet) ||
              (inventorySet == null && element['attributes'] == null))) {
        element.update('quantity', (value) {
          int sum = value as int;
          if (value != 1) {
            sum -= 1;
          }
          print(sum);
          // _cartItems![id.toString()]!.firstWhere((e) =>
          //     e.containsKey(id.toString()) &&
          //     e.containsValue(inventorySet))['quantity'] = sum;
          // return {
          //   'prodcutId': value['prodcutId'],
          //   'title': value['title'],
          //   'price': value['price'],
          //   'imgUrl': value['imgUrl'],
          //   'quantity': sum,
          //   'attributes': value['attributes'],
          // };
          return sum;
        });
      }
    });
    // if (_cartItems![id.toString()]!.firstWhere((element) =>
    //         element.containsKey(id.toString()) &&
    //         element.containsValue(inventorySet))['quantity'] ==
    //     1) {
    //   return;
    // }
    // _cartItems![id.toString()]!
    //     .firstWhere((element) =>
    //         element.containsKey(id.toString()) &&
    //         element.containsValue(inventorySet))
    //     .update(id.toString(), (value) {
    //   int sum = (value as Map)['quantity'] - 1;
    //   return {
    //     'prodcutId': value['prodcutId'],
    //     'title': value['title'],
    //     'price': value['price'],
    //     'imgUrl': value['imgUrl'],
    //     'quantity': sum,
    //     'attributes': value['attributes'],
    //   };
    // });
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

  void deleteFromCart(String id) {
    // int index = _cartList.indexWhere((element) => element['prodcutId'].id == id);

    // _cartList.removeAt(index);
    // print(_cartList.length.toString());
  }

  void addCartItem(int id, String title, int price, int discountPrice,
      double campaignPercentage, int quantity, String imgUrl,
      {inventorySet}) async {
    print(inventorySet);
    Map<String, List<Map<String, Object?>>>? map = {
      id.toString(): [
        {
          'id': id,
          'title': title,
          'price': price,
          'imgUrl': imgUrl,
          'quantity': quantity,
          'attributes': inventorySet
        },
      ]
    };
    bool haveData = false;
    if (_cartItems!.containsKey(id.toString()))
      cartList![id.toString()]!.forEach((element) {
        print(element);
        if (element.containsValue(inventorySet)) {
          haveData = true;
        }
      });
    print(id);
    print(_cartItems!.containsKey(id.toString()) && haveData);
    if (haveData) {
      addItem(id, extraQuantity: quantity);
      notifyListeners();
      return;
    }

    // try {

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
          'attributes': inventorySet
        }
      ];
      // _cartItems!.putIfAbsent(
      //     id.toString(),
      //     () => [
      //           {
      //             'id': id,
      //             'title': title,
      //             'price': price,
      //             'imgUrl': imgUrl,
      //             'quantity': quantity,
      //             'attributes': inventorySet
      //           }
      //         ]);
      notifyListeners();
      return;
    }

    // bool itemAbsent = false;
    // _cartItems![id.toString()]!.forEach((element) {
    //   itemAbsent =
    //       element['attributes'] == inventorySet && inventorySet != null;
    // });
    // if (_cartItems!.containsKey(id.toString()) && itemAbsent) {
    _cartItems![id.toString()]!.add({
      'id': id,
      'title': title,
      'price': price,
      'imgUrl': imgUrl,
      'quantity': quantity,
      'attributes': inventorySet
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
    // }
    print(id);
    print(_cartItems![id.toString]);
    // _cartItems![id.toString]!.add({
    //     'id': id,
    //     'title': title,
    //     'price': price,
    //     'imgUrl': imgUrl,
    //     'quantity': quantity,
    //     'attributes': inventorySet
    //   });
    notifyListeners();
    // } catch (error) {
    //   print(error);
    //   return;
    // }
  }

  void fetchCarts() async {
    final dbData = await DbHelper.fetchDb('cart');
    Map<String, List<Map<String, Object?>>> dataList = {};
    if (dbData == null) {
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
    print(cartList![id.toString()]!.length);
    print(inventorySet);
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

    // notifyListeners();
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

  refreshCartList() {
    cartList!.forEach((key, value) async {
      final url = Uri.parse('$baseApiUrl/product/$key');

      // try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        deleteCartItem(int.parse(key));
      }
    });
  }
}
