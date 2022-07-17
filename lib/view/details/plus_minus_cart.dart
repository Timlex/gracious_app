import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';

class PlusMinusCart extends StatefulWidget {
  int count = 0;
  double amount;
  double totalAmount;
  PlusMinusCart(this.count, this.amount, this.totalAmount, {Key? key})
      : super(key: key);

  @override
  State<PlusMinusCart> createState() => _PlusMinusCartState();
}

class _PlusMinusCartState extends State<PlusMinusCart> {
  ConstantColors cc = ConstantColors();

  void addItem(double totalSum) {
    setState(() {
      widget.count++;
      widget.totalAmount = widget.count.toDouble() * widget.amount;
    });
  }

  void minusItem(double totalSum) {
    if (widget.count == 1) {
      return;
    }
    setState(() {
      widget.count--;
      widget.totalAmount = widget.count.toDouble() * widget.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: cc.pureWhite,
          ),
          height: 48,
          width: 135,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(33, 208, 47, 68),
                ),
                child: IconButton(
                    onPressed: () => minusItem(widget.totalAmount),
                    icon: SvgPicture.asset(
                      'assets/images/icons/minus.svg',
                      color: const Color.fromARGB(255, 208, 47, 68),
                    )),
              ),
              Expanded(
                  child: Text(
                widget.count.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xff475467),
                    fontWeight: FontWeight.w600),
              )),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(39, 0, 177, 6),
                ),
                child: IconButton(
                    onPressed: () => addItem(widget.totalAmount),
                    icon: SvgPicture.asset(
                      'assets/images/icons/add.svg',
                      color: cc.primaryColor,
                    )),
              ),
            ],
          ),
        ),
        Spacer(),
        Stack(children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: cc.primaryColor,
            ),
            height: 48,
            width: MediaQuery.of(context).size.width / 2.1,
            child: Row(
              children: [
                SvgPicture.asset('assets/images/icons/bag.svg'),
                const SizedBox(width: 4),
                Text(
                  'Add to cart',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: cc.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              height: 50,
              width: 80,
              color: Color.fromARGB(24, 0, 0, 0),
              child: Center(
                child: Text(
                  '\$' + widget.totalAmount.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 13,
                    color: cc.pureWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ])
      ],
    );
  }
}
