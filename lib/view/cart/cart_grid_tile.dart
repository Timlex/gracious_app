import 'package:flutter/material.dart';

import '../utils/constant_colors.dart';

class CartGridTile extends StatelessWidget {
  final String imageName;
  bool isSelected;
  CartGridTile(this.imageName, this.isSelected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 1,
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              isSelected ? ConstantColors().pink : ConstantColors().greyBorder2,
          width: 1,
        ),
        color: isSelected ? ConstantColors().lightpink : null,
      ),
      child: Image.asset(
        'assets/images/$imageName.png',
      ),
    );
  }
}
