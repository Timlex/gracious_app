import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

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
      width: 180,
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
              Positioned(
                  top: 0,
                  left: 6,
                  child: Container(
                    color: cc.primaryColor,
                    child: Text(
                      'New',
                      style: TextStyle(
                        color: cc.blackColor,
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
                    Text(discountAmount <= 0
                        ? _amount.toString()
                        : discountAmount.toString())
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
