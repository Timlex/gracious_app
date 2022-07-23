import 'package:flutter/material.dart';
import 'package:gren_mart/db/database_helper.dart';

import 'package:gren_mart/view/cart/cart_grid_tile.dart';
import 'package:gren_mart/view/cart/payment_status.dart';
import 'package:gren_mart/view/settings/new_address.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';

class Checkout extends StatefulWidget {
  static const routeName = 'checkout';

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  ConstantColors cc = ConstantColors();

  String selectedName = 'payp';
  bool error = false;
  String selectedId = '01';

  List addresses = [
    {
      'id': '01',
      'title': 'Home',
      'address': '6391 Elgin St. Celina, Delaware 10299'
    },
    {
      'id': '02',
      'title': 'Home',
      'address': '6391 Elgin St. Celina, Delaware 10299'
    },
  ];

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
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // CustomTextField(
            //   'enter new address',
            //   controller: TextEditingController(),
            //   leadingImage: 'assets/images/icons/location.png',
            // ),
            // const SizedBox(height: 10),
            ...addresses.map(((e) => GestureDetector(
                  onTap: () {
                    if (selectedId == e['id']) {
                      return;
                    }
                    setState(() {
                      selectedId = e['id'];
                    });
                  },
                  child: addressBox(selectedId == e['id']),
                ))),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(NewAddress.routeName);
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
                height: 260,
                child: GridView(
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
                                setState(() {
                                  selectedName = e;
                                });
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

  Widget addressBox(bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected ? cc.lightPrimery3 : cc.whiteGrey,
          border: Border.all(
              color: selected ? cc.primaryColor : cc.greyHint, width: .5)),
      child: Stack(children: [
        const ListTile(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text('Home'),
          ),
          subtitle: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text('6391 Elgin St. Celina, Delaware 10299'),
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
  }
}
