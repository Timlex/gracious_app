import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

class CustomTextField extends StatelessWidget {
  final String levelText;
  String? leadingImage;
  bool? trailing;
  final TextEditingController controller;
  CustomTextField(this.levelText, this.controller,
      {this.leadingImage, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: ConstantColors().primaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: ConstantColors().greyBorder, width: 1),
            ),
            label: Row(
              children: [
                Expanded(
                  child: Text(
                    levelText,
                    style: TextStyle(
                        color: ConstantColors().greyTextFieldLebel,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
            suffixIcon: trailing != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          print('testng');
                        },
                        child: SizedBox(
                          height: 23,
                          child: Image.asset(
                            'assets/images/icons/pass_hide.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
            prefixIcon: leadingImage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 25,
                          child: Image.asset(
                            leadingImage!,
                          )),
                    ],
                  )
                : null
            //  if (leadingImage != null)?
            ),
      ),
    );
  }
}
