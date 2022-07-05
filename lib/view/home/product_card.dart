import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';

class ProductCard extends StatelessWidget {
  final String _title;
  double discountAmount;
  final double _amount;
  final String _image;

  ProductCard(this._title, this._amount, this._image,
      {this.discountAmount = 0});

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: cc.pureWhite,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Image.asset(
                  _image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 13),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: cc.pureWhite,
                ),
                child: Text(
                  'New',
                  style: TextStyle(
                      color: cc.blackColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 35),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: cc.orange,
                ),
                child: Text(
                  '09.75%',
                  style: TextStyle(
                      color: cc.pureWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Positioned(
                  right: 0,
                  child: Container(
                    margin: EdgeInsets.only(top: 9, right: 5),
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: cc.pureWhite,
                      child: IconButton(
                        onPressed: (() {}),
                        icon: Image.asset('assets/images/heart2.png'),
                      ),
                    ),
                  ))
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '\$${discountAmount <= 0 ? _amount.toString() : discountAmount.toString()}',
                      style: TextStyle(
                          color: cc.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '\$${_amount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: cc.cardGreyHint,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: cc.cardGreyHint,
                          fontSize: 11),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).pushReplacementNamed(Auth.routeName);
                  },
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: ConstantColors().primaryColor,
                        ),
                      ),
                      child: Text(
                        'Add to cart',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ConstantColors().primaryColor,
                            fontWeight: FontWeight.w600),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
