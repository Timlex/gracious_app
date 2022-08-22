import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import '../../view/utils/constant_colors.dart';

class OrderDetailsTile extends StatelessWidget {
  final String title;
  final String image;
  final double price;
  final int quantity;
  final bool divider;

  OrderDetailsTile(
      this.title, this.price, this.quantity, this.image, this.divider,
      {Key? key})
      : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 75,
      child: Column(
        children: [
          ListTile(
            leading: Container(
              // height: 80,
              // width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                image,
                fit: BoxFit.fill,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth / 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '(Sauce: Tartar, Mayo: Lime, Cheese: mozzarella)',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 45,
                        style: TextStyle(
                          fontSize: 11,
                          color: cc.greyParagraph,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'x$quantity',
                  style: TextStyle(
                      color: cc.greyHint,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                      color: cc.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ],
            ),
          ),
          if (!divider) const Divider(),
        ],
      ),
    );
  }
}
