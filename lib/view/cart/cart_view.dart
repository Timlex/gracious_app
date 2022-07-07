import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/view/cart/cart_card.dart';
import 'package:gren_mart/view/cart/checkout.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';

class Cart extends StatelessWidget {
  static const routeName = 'cart';
  Cart({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        CartCard(),
        Container(
          // height: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: cc.whiteGrey,
          ),
          child: Column(children: [
            rows('Subtotal', trailing: '\$453'),
            const SizedBox(height: 15),
            rows('Shipping', trailing: '\$8'),
            const SizedBox(height: 15),
            rows('Discount', trailing: '-\$20'),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 25),
            rows('Total', trailing: '-\$438'),
            const SizedBox(height: 25),
            rows('Promo code'),
            const SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                  width: 225,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          label: Text(
                            'Enter promo code',
                            style: TextStyle(color: cc.greyHint),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ConstantColors().greyBorder, width: 1),
                          ),
                          contentPadding: const EdgeInsets.all(15)),
                    ),
                  )
                  //  CustomTextField(
                  //     'Enter promo code', TextEditingController()),
                  ),
              GestureDetector(
                onTap: () {
                  print('something!');
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    'Apply Promo code',
                    style: TextStyle(
                      color: Colors.transparent,
                      shadows: [
                        Shadow(
                            offset: const Offset(0, -5), color: cc.primaryColor)
                      ],
                      decoration: TextDecoration.underline,
                      decorationColor: cc.primaryColor,
                      decorationThickness: 2,
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 15),
            customContainerButton('Checkout', double.infinity, () {
              Navigator.of(context).pushNamed(Checkout.routeName);
            })
          ]),
        ),
      ],
    );
  }

  Widget rows(String leading, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leading,
          style: TextStyle(
            color: cc.greyParagraph,
            fontSize: 15,
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: TextStyle(
                color: cc.greyParagraph,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
