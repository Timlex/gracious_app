import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';

class CustomDropdown extends StatefulWidget {
  String city;
  CustomDropdown(this.city, {Key? key}) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  List citys = [
    'Bangladesh',
    'Japan',
    'Korea',
    'Africa',
  ];
  ConstantColors cc = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ConstantColors().greyBorder,
          width: 1,
        ),
      ),
      child: DropdownButton(
        hint: Text('Select your city'),
        underline: Container(),
        elevation: 0,
        value: widget.city,
        style: TextStyle(color: cc.greyHint),
        icon: Icon(
          Icons.keyboard_arrow_down_sharp,
          color: ConstantColors().greyHint,
        ),
        onChanged: (value) {
          setState(() {
            widget.city = value as String;
          });
        },
        items: <String>[
          'Bangladesh',
          'Japan',
          'Korea',
          'Africa',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            alignment: Alignment.centerLeft,
            value: value,
            child: SizedBox(
              width: screenWidth - 83,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
