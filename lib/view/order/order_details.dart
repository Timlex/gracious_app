import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/order_data.dart';
import 'package:gren_mart/view/order/order_details_tile.dart';
import 'package:provider/provider.dart';

import '../utils/app_bars.dart';
import '../utils/constant_styles.dart';

class OrderDetails extends StatelessWidget {
  final String tracker;
  const OrderDetails(this.tracker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final tracker =
    // (ModalRoute.of(context)!.settings.arguments! as List)[0] as String;
    final orderData = Provider.of<OrderData>(context, listen: false)
        .orderItem
        .firstWhere((element) => element.trackingCode == tracker);
    double shippingCos = 0;
    double discount = 0;
    double totalPrice = orderData.totalAmount;
    return Scaffold(
      appBar: AppBars().appBarTitled('My orders', () {
        Navigator.of(context).pop();
      }),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ...orderData.productInfos.map((e) {
            return OrderDetailsTile(e['title'], e['price'], e['quantity'],
                e['image'], orderData.productInfos.last['id'] == e['id']);
          }).toList(),
          Container(
            // height: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: cc.whiteGrey,
            ),
            child: Column(children: [
              rows('Subtotal', trailing: '\$$totalPrice'),
              const SizedBox(height: 15),
              rows('Shipping', trailing: '\$$shippingCos'),
              const SizedBox(height: 15),
              rows('Discount', trailing: '-\$$discount'),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 25),
              rows('Total',
                  trailing: '\$${totalPrice + shippingCos + discount}'),
            ]),
          ),
        ],
      ),
    );
  }

  Widget rows(String leading, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leading,
          style: TextStyle(
            color: cc.greyParagraph,
            fontSize: 13,
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: TextStyle(
                color: cc.greyParagraph,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
