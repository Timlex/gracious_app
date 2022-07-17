class Cart {
  final String id;
  int quantity;

  Cart(
    this.id,
    this.quantity,
  );
}

class CartData {
  List<Cart> _cartList = [
    Cart('01', 2),
    Cart('03', 6),
    Cart('02', 1),
    Cart('04', 1),
    Cart('05', 1),
    // Cart('06', 1),
  ];

  List<Cart> get cartList {
    return _cartList;
  }

  void addItem(String id) {
    int index = _cartList.indexWhere((element) => element.id == id);
    _cartList[index].quantity++;
  }

  void minusItem(String id) {
    int index = _cartList.indexWhere((element) => element.id == id);
    if (_cartList[index].quantity == 1) {
      print(_cartList[index].quantity.toString());
      return;
    }
    _cartList[index].quantity--;
    print(_cartList[index].quantity.toString());
  }

  void deleteFromCart(String id) {
    int index = _cartList.indexWhere((element) => element.id == id);

    _cartList.removeAt(index);
    print(_cartList.length.toString());
  }
}
