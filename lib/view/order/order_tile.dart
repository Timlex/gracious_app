import 'package:flutter/material.dart';
import '../../view/order/order_details.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_name.dart';
import 'package:intl/intl.dart';

class OrderTile extends StatelessWidget {
  final double totalAmount;
  final String trackingCode;
  final DateTime orderedDate;
  final bool delivered;
  final bool divider;
  OrderTile(
    this.totalAmount,
    this.trackingCode,
    this.orderedDate,
    this.delivered,
    this.divider, {
    Key? key,
  }) : super(key: key);
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHight / 10 < 82 ? 82 : screenHight / 10,
      child: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            style: ListTileStyle.drawer,
            visualDensity: const VisualDensity(vertical: -3),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (BuildContext context) => OrderDetails(trackingCode),
              ));
            },
            title: Text(
              '\$${totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Row(
              children: [
                Text(
                  trackingCode,
                  style: TextStyle(
                      color: cc.primaryColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat.yMMMd().format(orderedDate),
                  style: TextStyle(color: cc.greyHint),
                )
              ],
            ),
            trailing: SizedBox(
              width: screenWidth / 2.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: screenWidth / 4,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: delivered ? cc.primaryColor : cc.orange,
                    ),
                    child: Text(
                      delivered ? 'Delivered' : 'Pending',
                      style: TextStyle(color: cc.pureWhite),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
          if (divider) const Divider()
        ],
      ),
    );
  }
}
