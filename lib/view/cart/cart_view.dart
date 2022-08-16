import 'package:flutter/material.dart';
import 'package:gren_mart/service/cupon_discount_service.dart';
import 'package:gren_mart/service/shipping_zone_service.dart';
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
    List<String> cuponData = [];
    return Consumer<CartDataService>(builder: (context, cartData, child) {
      for (var element in cartData.cartList.values) {
        cuponData.add(
            '{"id":${element.id},"price":${element.price * element.quantity}}');
      }
      print(cuponData);
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
              cuponData.isEmpty
                  ? () {
                      snackBar(context, 'Add Items to cart.');
                    }
                  : () {
                      Provider.of<ShippingAddressesService>(context,
                              listen: false)
                          .fetchUsersShippingAddress()
                          .then((value) {
                        if (value == null) {
                          final countryId =
                              Provider.of<ShippingAddressesService>(context,
                                      listen: false)
                                  .selectedAddress!
                                  .countryId;
                          final stateId = Provider.of<ShippingAddressesService>(
                                  context,
                                  listen: false)
                              .selectedAddress!
                              .stateId;
                          Provider.of<ShippingZoneService>(context,
                                  listen: false)
                              .fetchContriesZone(countryId)
                              .then((value) => Provider.of<ShippingZoneService>(
                                      context,
                                      listen: false)
                                  .fetchSatesZone(stateId));
                        }
                      });
                      print(cuponData.toString());
                      Provider.of<CuponDiscountService>(context, listen: false)
                          .setCarData(cuponData.toString().replaceAll(' ', ''));
                      Navigator.of(context).pushNamed(Checkout.routeName).then(
                          (value) => Provider.of<ShippingZoneService>(context,
                                  listen: false)
                              .resetChecout());
                    },
            ),
          ),
        ],
      );
    });
  }
}
