import 'package:flutter/cupertino.dart';
import 'package:gren_mart/db/database_helper.dart';
import 'package:gren_mart/model/product_data.dart';

class Cart {
  final String id;
  int quantity;
  Product product;

  Cart(this.id, this.quantity, this.product);
}

class CartData with ChangeNotifier {
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

  void addItem(String id) async {
    _cartItems.update(id, (value) {
      int sum = value.quantity + 1;
      DbHelper.updateQuantity(
        'cart',
        id,
        {
          'productId': value.product.id,
          'quantity': sum,
          'title': value.product.title,
          'discountPecentage': value.product.discountPecentage,
          'amount': value.product.amount,
          'image': value.product.image[0],
        },
      );
      return Cart(
        value.id,
        sum,
        value.product,
      );
    });

    notifyListeners();
  }

  void minusItem(String id) {
    if (_cartItems[id]!.quantity == 1) {
      return;
    }
    _cartItems.update(id, (value) {
      int sum = value.quantity - 1;
      return Cart(
        value.id,
        sum,
        value.product,
      );
    });

    notifyListeners();
  }

  void deleteFromCart(String id) {
    // int index = _cartList.indexWhere((element) => element['id'].id == id);

    // _cartList.removeAt(index);
    // print(_cartList.length.toString());
  }

  void addCartItem(String id, Product product) async {
    if (_cartItems.containsKey(id)) {
      addItem(id);
      notifyListeners();
      return;
    }

    try {
      await DbHelper.insert(
        'cart',
        {
          'productId': product.id,
          'quantity': 1,
          'title': product.title,
          'discountPecentage': product.discountPecentage,
          'amount': product.amount,
          'image': product.image[0],
        },
      );
      _cartItems.putIfAbsent(id, (() => Cart(id, 1, product)));
      notifyListeners();
    } catch (error) {
      return;
    }
  }

  void fetchCarts() async {
    final dbData = await DbHelper.fetchDb('cart');
    Map<String, Cart> dataList = {};
    for (var element in dbData) {
      final product = Product(
        id: element['productId'],
        title: element['title'],
        amount: element['amount'],
        discountPecentage: element['discountPecentage'],
        image: [element['image'].toString()],
      );
      dataList.putIfAbsent(element['productId'],
          () => Cart(element['productId'], element['quantuty'] ?? 1, product));
    }
    _cartItems = dataList;
    notifyListeners();
    print('fetching carts');
    // _cartList = dataList;
  }

  void deleteCartItem(String id) async {
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
