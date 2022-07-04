import 'package:flutter/material.dart';

import '../utils/constant_colors.dart';

class RememberBox extends StatelessWidget {
  bool rememberPass = false;
  Function toggleRemember;
  RememberBox(this.rememberPass, this.toggleRemember);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1.3,
          child: Checkbox(
              // splashRadius: 30,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(
                width: 1,
                color: ConstantColors().greyBorder,
              ),
              activeColor: ConstantColors().primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: BorderSide(
                    width: 1,
                    color: ConstantColors().greyBorder,
                  )),
              value: rememberPass,
              onChanged: (value) {
                toggleRemember(value);
              }),
        ),
        Text(
          'Remeber me',
          style: TextStyle(
            color: ConstantColors().greyHint,
          ),
        )
      ],
    );
  }
}
