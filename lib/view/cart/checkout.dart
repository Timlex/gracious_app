import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';

class Checkout extends StatelessWidget {
  static const routeName = 'checkout';
  ConstantColors cc = ConstantColors();

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
      appBar: AppBar(
          elevation: 1.5,
          foregroundColor: cc.blackColor,
          title: Center(
            child: Text(
              'Checkout',
              style:
                  TextStyle(color: cc.blackColor, fontWeight: FontWeight.w600),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              'enter new address',
              TextEditingController(),
              leadingImage: 'assets/images/icons/location.png',
            ),
            const SizedBox(height: 10),
            addressBox(true),
            const SizedBox(height: 10),
            addressBox(false),
            const SizedBox(height: 25),
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
                height: 250,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  children: gridImages.map((e) => gridTiles(e)).toList(),
                )),
            customContainerButton('Pay & Confirm', double.maxFinite, () {})
          ],
        ),
      ),
    );
  }

  Widget addressBox(bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected ? cc.lightPrimery : cc.whiteGrey,
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

  Widget gridTiles(String imageName) {
    return Container(
        height: 15,
        width: 100,
        margin: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ConstantColors().greyBorder,
            width: 1,
          ),
        ),
        child: Image.asset('assets/images/$imageName.png'));
  }
}
