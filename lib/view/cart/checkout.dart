import 'package:flutter/material.dart';
import 'package:gren_mart/service/cart_data_service.dart';
import '../../db/database_helper.dart';
import '../../service/shipping_addresses_service.dart';

import '../../view/cart/cart_grid_tile.dart';
import '../../view/cart/payment_status.dart';
import '../../view/settings/new_address.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_name.dart';
import '../../view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class Checkout extends StatelessWidget {
  static const routeName = 'checkout';

  ConstantColors cc = ConstantColors();

  String selectedName = 'payp';
  bool error = false;
  String selectedId = '01';
  int subTotal = 0;

  List gridImages = [
    'cod',
    'payp',
    'razor',
    'mollie',
    'payt',
    'stripe',
    'pays',
    'wave',
    'mid',
    'payfast',
    'mercado',
    'insta',
    'cash',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled('Checkout', () {
        Navigator.of(context).pop();
      }, hasButton: true, hasElevation: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            // CustomTextField(
            //   'enter new address',
            //   controller: TextEditingController(),
            //   leadingImage: 'assets/images/icons/location.png',
            // ),
            // const SizedBox(height: 10),
            if (Provider.of<ShippingAddressesService>(context)
                    .shippingAddresseList
                    .isEmpty &&
                !(Provider.of<ShippingAddressesService>(context).noData))
              loadingProgressBar(),
            ...Provider.of<ShippingAddressesService>(context)
                .shippingAddresseList
                .map(((e) {
              final saService =
                  Provider.of<ShippingAddressesService>(context, listen: false);
              return GestureDetector(
                onTap: () {
                  if (saService.selectedAddress!.id == e.id) {
                    return;
                  }
                  saService.setSelectedAddress(e);
                },
                child: addressBox(e.id),
              );
            })).toList(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AddNewAddress.routeName);
              },
              child: Container(
                  // margin: const EdgeInsets.all(8),
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: ConstantColors().primaryColor,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icons/location.png',
                        height: 30,
                        color: cc.primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Add new address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ConstantColors().primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 20),
            Container(
              // height: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: cc.whiteGrey,
              ),
              child: Column(children: [
                rows('Product', trailing: '\$Subtotal'),
                const SizedBox(height: 15),
                SizedBox(
                  child: Consumer<CartDataService>(
                      builder: (context, cService, child) {
                    return Column(
                      children: cService.cartList.values.toList().map((e) {
                        final showAdditionlInfo = e.size != null ||
                            e.color != null ||
                            e.sauce != null ||
                            e.mayo != null ||
                            e.cheese != null;
                        subTotal += e.price;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: screenWidth / 1.7,
                                child: RichText(
                                  text: TextSpan(
                                      text: e.title,
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 13,
                                          color: cc.greyHint),
                                      children: [
                                        if (showAdditionlInfo)
                                          TextSpan(
                                              text: ' (' +
                                                  (e.size == null
                                                      ? ''
                                                      : 'Size: ${e.size!.capitalize()}. ') +
                                                  (e.cheese == null
                                                      ? ''
                                                      : 'Color: ${e.color!.capitalize()}. ') +
                                                  (e.sauce == null
                                                      ? ''
                                                      : 'Sauce: ${e.sauce!.capitalize()}. ') +
                                                  (e.mayo == null
                                                      ? ''
                                                      : 'Mayo: ${e.mayo!.capitalize()}. ') +
                                                  (e.cheese == null
                                                      ? ''
                                                      : 'Cheese: ${e.cheese!.capitalize()}.'
                                                          '') +
                                                  ') '),
                                        const TextSpan(text: 'X'),
                                        TextSpan(
                                            text: '${e.quantity}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600))
                                      ]),
                                ),
                              ),
                              Text(
                                '\$${e.price * e.quantity}',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 13,
                                  color: cc.greyHint,
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ),
                const SizedBox(height: 15),
                rows('Subtotal',
                    trailing:
                        '\$${Provider.of<CartDataService>(context, listen: false).subTotal}'),
                const SizedBox(height: 15),
                rows('Shipping', trailing: '\$shippingCos'),
                const SizedBox(height: 15),
                rows('Discount', trailing: '-\$discount'),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 25),
                rows('Total', trailing: '\${totalPrice}'),
                const SizedBox(height: 25),
                rows('Cupon code'),
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: screenWidth / 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: 'Enter Cupon code',
                                  hintStyle: TextStyle(
                                    color: cc.greyHint,
                                    fontSize: 13,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: ConstantColors().greyBorder,
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: ConstantColors().greyBorder,
                                        width: 1),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: ConstantColors().orange,
                                        width: 1),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: ConstantColors().orange,
                                        width: 1),
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
                            width: screenWidth / 4,
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
                Text(
                  'Chose a payment method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cc.titleTexts,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    height: screenHight / 2.74,
                    child: GridView(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 3 / 1.2,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 12),
                      children: gridImages
                          .map((e) => GestureDetector(
                              onTap: () => selectedName = e,
                              child: GestureDetector(
                                  onTap: () {
                                    if (selectedName == e) {
                                      return;
                                    }
                                    // setState(() {
                                    //   selectedName = e;
                                    // });
                                  },
                                  child: CartGridTile(e, e == selectedName))))
                          .toList(),
                    )),
                const SizedBox(height: 20),
                customContainerButton('Pay & Confirm', double.maxFinite, () {
                  DbHelper.deleteDbTable('cart');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentStatusView(error)),
                  );
                  error = true;
                }),
                const SizedBox(height: 30),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressBox(int id) {
    return Consumer<ShippingAddressesService>(
        builder: (context, saService, child) {
      final shippingAddress = saService.shippingAddresseList
          .firstWhere((element) => element.id == id);
      final selected = shippingAddress.id == saService.selectedAddress!.id;
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected ? cc.lightPrimery3 : cc.whiteGrey,
            border: Border.all(
                color: selected ? cc.primaryColor : cc.greyHint, width: .5)),
        child: Stack(children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(shippingAddress.name),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(shippingAddress.address),
            ),
          ),
          if (selected)
            Positioned(
                top: 10,
                right: 15,
                child: Icon(
                  Icons.check_box,
                  color: cc.primaryColor,
                ))
        ]),
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
              fontSize: 15,
              fontWeight: FontWeight.bold),
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
