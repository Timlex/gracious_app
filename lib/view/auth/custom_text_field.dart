import 'package:flutter/material.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

class CustomTextField extends StatefulWidget {
  final String levelText;
  String? leadingImage;
  bool trailing;
  bool obscureText;
  final TextEditingController controller;
  CustomTextField(
    this.levelText,
    this.controller, {
    this.leadingImage,
    this.trailing = false,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 0),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 17),
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
          label: Text(
            widget.levelText,
            style: TextStyle(
                color: ConstantColors().greyTextFieldLebel, fontSize: 13),
          ),

          prefixIcon: widget.leadingImage != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 25,
                        child: Image.asset(
                          widget.leadingImage!,
                        )),
                  ],
                )
              : null,
          suffixIcon: widget.trailing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                      child: SizedBox(
                        height: 23,
                        child: widget.obscureText
                            ? Image.asset(
                                'assets/images/icons/pass_hide.png',
                                fit: BoxFit.fitHeight,
                              )
                            : Icon(Icons.remove_red_eye_rounded),
                      ),
                    ),
                  ],
                )
              : null,

          //  if (leadingImage != null)?
        ),
      ),
    );
  }
}
