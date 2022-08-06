import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:intl/intl.dart';

class TicketTile extends StatelessWidget {
  final String title;
  final int ticketId;
  final DateTime submitDate;
  final String priority;
  final bool divider;
  TicketTile(
    this.title,
    this.ticketId,
    this.submitDate,
    this.priority,
    this.divider, {
    Key? key,
  }) : super(key: key);
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screenHight / 7,
      child: Column(
        children: [
          ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -3),
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute<void>(
              //   builder: (BuildContext context) => OrderDetails(title),
              // ));
            },
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Row(
              children: [
                Text(
                  '#$ticketId',
                  style: TextStyle(
                      color: cc.primaryColor, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat.yMMMd().format(submitDate),
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
                      color: cc.whiteGrey,
                    ),
                    child: Text(
                      priority,
                      style: TextStyle(
                          color: cc.blackColor, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Badge(
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
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
