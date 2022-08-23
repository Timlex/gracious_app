import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import '../../view/utils/constant_colors.dart';

class OrderDetailsTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final double price;
  final int quantity;

  OrderDetailsTile(
      this.title, this.price, this.quantity, this.image, this.subTitle,
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
            contentPadding: const EdgeInsets.only(left: 20),
            leading: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(
                image,
                fit: BoxFit.fill,
              ),
            ),
            title: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth / 2.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      if (subTitle.trim() != '()') const SizedBox(height: 5),
                      if (subTitle.trim() != '()')
                        Text(
                          subTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 11,
                            color: cc.greyParagraph,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 7),
                SizedBox(
                  width: 67,
                  child: Text(
                    'x$quantity',
                    style: TextStyle(
                        color: cc.greyHint,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ),
                // const Spacer(),
                SizedBox(
                  child: Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: cc.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
