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

class CartView extends StatelessWidget {
  static const routeName = 'cart';
  CartView({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    List<String> cuponData = [];
    return Consumer<CartDataService>(builder: (context, cartData, child) {
      cartData.cartList!.forEach((key, value) {
        value.forEach((element) {
          cuponData.add(
              '{"id":${element['productId']},"price":${(element['price'] as int) * (element['quantity'] as int)}}');
        });
      });
      print(cuponData);
      return Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
                physics: Provider.of<CartDataService>(context).cartList!.isEmpty
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                children: [
                  ...cartTiles(cartData),
                  if (cartData.cartList!.isEmpty)
                    Center(
                        child: Text('Add item to cart!',
                            style: TextStyle(color: cc.greyHint))),
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

  List<Widget> cartTiles(CartDataService cService) {
    List<Widget> list = [];
    cService.cartList!.forEach((key, value) {
      value.forEach((e) {
        list.add(CartTile(
          e['productId'] as int,
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
