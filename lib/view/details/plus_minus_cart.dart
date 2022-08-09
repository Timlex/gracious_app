import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';

class PlusMinusCart extends StatefulWidget {
  int count = 0;
  int amount;
  int totalAmount;
  PlusMinusCart(this.count, this.amount, this.totalAmount, {Key? key})
      : super(key: key);

  @override
  State<PlusMinusCart> createState() => _PlusMinusCartState();
}

class _PlusMinusCartState extends State<PlusMinusCart> {
  ConstantColors cc = ConstantColors();

  void addItem(int totalSum) {
    setState(() {
      widget.count++;
      widget.totalAmount = widget.count * widget.amount;
    });
  }

  void minusItem(int totalSum) {
    if (widget.count == 1) {
      return;
    }
    setState(() {
      widget.count--;
      widget.totalAmount = widget.count * widget.amount;
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
          width: screenWidth / 3,
          child: Row(
            children: [
              Container(
                width: screenWidth / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(33, 208, 47, 68),
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
                width: screenWidth / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(39, 0, 177, 6),
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
        const Spacer(),
        Stack(children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: cc.primaryColor,
            ),
            height: 48,
            width: screenWidth / 2.1,
            child: Row(
              children: [
                SvgPicture.asset('assets/images/icons/bag.svg'),
                const SizedBox(width: 4),
                SizedBox(
                  width: screenWidth / 5,
                  child: Text(
                    'Add to cart',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: cc.pureWhite,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              height: 50,
              width: screenWidth / 5,
              color: const Color.fromARGB(24, 0, 0, 0),
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
