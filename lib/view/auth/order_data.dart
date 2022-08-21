import 'package:flutter/cupertino.dart';

class Orders {
  final String trackingCode;
  final List<Map<String, dynamic>> productInfos;
  final double totalAmount;
  final DateTime orderedDate;
  final bool delivered;

  Orders(this.trackingCode, this.totalAmount, this.orderedDate, this.delivered,
      this.productInfos);
}

class OrderData with ChangeNotifier {
  final List<Orders> _orderItems = [
    Orders(
        '#384956',
        3748,
        DateTime.now().subtract(const Duration(
          days: 10,
        )),
        true,
        [
          {
            'id': '01',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '02',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '03',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '06',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '05',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '04',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
        ]),
    Orders(
        '#384955',
        3748,
        DateTime.now().subtract(const Duration(
          days: 3,
        )),
        false,
        [
          {
            'id': '01',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '02',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 4,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '03',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
        ]),
    Orders(
        '#384959',
        3748,
        DateTime.now().subtract(const Duration(
          days: 5,
        )),
        true,
        [
          {
            'id': '01',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          // {
          //   'id': '02',
          //   'title': 'Fresh fruits',
          //   'price': 260.00,
          //   'discount': 19.7,
          //   'quantity': 3,
          //   'image': 'assets/images/product1.png',
          // },
          {
            'id': '03',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
        ]),
    Orders(
        '#384954',
        3748,
        DateTime.now().subtract(const Duration(
          days: 7,
        )),
        true,
        [
          {
            'id': '01',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '02',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '03',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
          {
            'id': '04',
            'title': 'Fresh fruits',
            'price': 260.00,
            'discount': 19.7,
            'quantity': 3,
            'image': 'assets/images/product1.png',
          },
        ]),
  ];

  List<Orders> get orderItem {
    return _orderItems;
  }
}
