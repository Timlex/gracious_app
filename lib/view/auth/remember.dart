import 'package:flutter/material.dart';

import '../utils/constant_colors.dart';

class RememberBox extends StatefulWidget {
  bool rememberPass = false;
  RememberBox(this.rememberPass);

  @override
  State<RememberBox> createState() => _RememberBoxState();
}

class _RememberBoxState extends State<RememberBox> {
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
              value: widget.rememberPass,
              onChanged: (value) {
                setState(() {
                  widget.rememberPass = value as bool;
                });
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
