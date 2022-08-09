import 'package:flutter/material.dart';
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
                .isEmpty)
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            })
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
}
