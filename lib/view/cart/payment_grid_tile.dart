import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import '../../view/utils/constant_name.dart';

import '../utils/constant_colors.dart';

class CartGridTile extends StatelessWidget {
  final String imageUrl;
  bool isSelected;
  CartGridTile(this.imageUrl, this.isSelected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 1,
      width: screenWidth / 3,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              isSelected ? ConstantColors().pink : ConstantColors().greyBorder2,
          width: 1,
        ),
        color: isSelected ? ConstantColors().lightpink : cc.pureWhite,
      ),
      child: Center(
        child: Image.network(
          imageUrl,
        ),
      ),
    );
  }
}
