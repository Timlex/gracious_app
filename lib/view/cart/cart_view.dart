import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/service/payment_gateaway_service.dart';
import 'package:provider/provider.dart';

import '../../service/checkout_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/navigation_bar_helper_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/cart_data_service.dart';
import '../../view/cart/cart_tile.dart';
import '../../view/cart/checkout.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_styles.dart';
import '../order/order_details.dart';
import '../utils/constant_name.dart';
import '../utils/text_themes.dart';

class CartView extends StatelessWidget {
  static const routeName = 'cart';
  CartView({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    initiateDeviceSize(context);
    return WillPopScope(
      onWillPop: () =>
          Provider.of<NavigationBarHelperService>(context, listen: false)
              .setNavigationIndex(0),
      child: Consumer<CartDataService>(builder: (context, cartData, child) {
        List<String> cuponData = [];
        cartData.cartList!.forEach((key, value) {
          value.forEach((element) {
            cuponData.add(
                '{"id":${element['id']},"price":${(element['price'] as int) * (element['quantity'] as int)}}');
          });
        });
        print(cuponData);
        return Column(
          children: [
            const SizedBox(height: 10),
            if (cartData.cartList!.isNotEmpty)
              Expanded(
                child: ListView(
                    physics:
                        Provider.of<CartDataService>(context).cartList!.isEmpty
                            ? const NeverScrollableScrollPhysics()
                            : const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      ...cartTiles(cartData),
                    ]),
              ),
            if (cartData.cartList!.isEmpty)
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenHight / 2.5,
                    padding: const EdgeInsets.all(20),
                    child: Image.asset('assets/images/empty_cart.png'),
                  ),
                  Center(
                      child: Text('Add item to cart!',
                          style: TextStyle(
                            color: cc.greyHint,
                          ))),
                ],
              )),
            if (Provider.of<CartDataService>(context, listen: false)
                .cartList!
                .isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: customContainerButton(
                  'Checkout',
                  double.infinity,
                  () {
                    print(cuponData.toString());
                    Provider.of<CuponDiscountService>(context, listen: false)
                        .setCarData(cuponData.toString().replaceAll(' ', ''));
                    Navigator.of(context)
                        .pushNamed(Checkout.routeName)
                        .then((value) {
                      Provider.of<ShippingZoneService>(context, listen: false)
                          .resetChecout();
                    });
                  },
                ),
              ),
          ],
        );
      }),
    );
  }

  List<Widget> cartTiles(CartDataService cService) {
    List<Widget> list = [];
    cService.cartList!.forEach((key, value) {
      value.forEach((e) {
        list.add(CartTile(
          e['id'] as int,
          e['title'] as String,
          e['imgUrl'] as String,
          e['quantity'] as int,
          e['price'] as int,
          e['attributes'] == null
              ? null
              : e['attributes'] as Map<String, dynamic>,
        ));
      });
    });
    return list;
  }
}
