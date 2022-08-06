import 'package:flutter/material.dart';
import 'package:gren_mart/service/cart_data_service.dart';
import 'package:gren_mart/view/cart/cart_tile.dart';
import 'package:gren_mart/view/cart/checkout.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../service/shipping_addresses_service.dart';

class CartView extends StatelessWidget {
  static const routeName = 'cart';
  CartView({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartDataService>(builder: (context, cartData, child) {
      double shippingCos = 0;
      double discount = 0;
      double totalPrice = 0;
      for (var element in cartData.cartList.values) {
        totalPrice += (element.price * element.quantity);
      }
      return ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          const SizedBox(height: 10),
          ...cartData.cartList.values
              .map((e) => CartTile(
                    e.id,
                    e.title,
                    e.imgUrl,
                    e.quantity,
                    e.price,
                    e.discountPrice,
                  ))
              .toList(),
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
              rows('Subtotal', trailing: '\$$totalPrice'),
              const SizedBox(height: 15),
              rows('Shipping', trailing: '\$$shippingCos'),
              const SizedBox(height: 15),
              rows('Discount', trailing: '-\$$discount'),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 25),
              rows('Total',
                  trailing: '\$${totalPrice + shippingCos + discount}'),
              const SizedBox(height: 25),
              rows('Cupon code'),
              const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                    width: screenWidth / 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            label: Text(
                              'Enter Cupon code',
                              style: TextStyle(
                                color: cc.greyHint,
                                fontSize: 13,
                              ),
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
                    child: SizedBox(
                      width: screenWidth / 3,
                      child: FittedBox(
                        child: Text(
                          'Apply Promo code',
                          style: TextStyle(
                            color: Colors.transparent,
                            shadows: [
                              Shadow(
                                  offset: const Offset(0, -5),
                                  color: cc.primaryColor)
                            ],
                            decoration: TextDecoration.underline,
                            decorationColor: cc.primaryColor,
                            decorationThickness: 1.5,
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 15),
              customContainerButton('Checkout', double.infinity, () {
                Provider.of<ShippingAddressesService>(context, listen: false)
                    .fetchUsersShippingAddress();
                Navigator.of(context).pushNamed(Checkout.routeName);
              }),
              const SizedBox(height: 30),
            ]),
          ),
        ],
      );
    });
  }

  Widget rows(String leading, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leading,
          style: TextStyle(
            color: cc.greyParagraph,
            fontSize: 13,
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
