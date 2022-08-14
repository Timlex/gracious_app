import 'package:flutter/material.dart';
import '../../service/cart_data_service.dart';
import '../../view/cart/cart_tile.dart';
import '../../view/cart/checkout.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_name.dart';
import '../../view/utils/constant_styles.dart';
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
      return Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
                physics: Provider.of<CartDataService>(context).cartList.isEmpty
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                children: [
                  ...cartData.cartList.values.map((e) => CartTile(
                        e.id,
                        e.title,
                        e.imgUrl,
                        e.quantity,
                        e.price,
                        e.discountPrice,
                      )),
                  if (cartData.cartList.isEmpty)
                    SizedBox(
                      height: (screenHight / 3.1),
                      child: Center(
                          child: Text('Add item to cart!',
                              style: TextStyle(color: cc.greyHint))),
                    ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: customContainerButton(
              'Checkout',
              double.infinity,
              () {
                Provider.of<ShippingAddressesService>(context, listen: false)
                    .fetchUsersShippingAddress();
                Navigator.of(context).pushNamed(Checkout.routeName);
              },
            ),
          ),
        ],
      );
    });
  }
}
