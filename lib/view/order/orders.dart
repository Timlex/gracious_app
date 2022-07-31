import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/order_data.dart';
import 'package:gren_mart/view/order/order_tile.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatelessWidget {
  MyOrders({Key? key}) : super(key: key);
  ConstantColors cc = ConstantColors();
  List random = [1, 2, 1, 1, 2, 1];

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderData>(context, listen: false).orderItem;
    return Scaffold(
      appBar: AppBars().appBarTitled('My orders', () {
        Navigator.of(context).pop();
      }),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: orderData
            .map((e) => OrderTile(
                  e.totalAmount,
                  e.trackingCode,
                  DateTime.now(),
                  e.delivered,
                  !(random.last == e),
                ))
            .toList(),
      ),
    );
  }
}
