import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gren_mart/service/cart_data_service.dart';
import 'package:gren_mart/service/cupon_discount_service.dart';
import 'package:gren_mart/service/payment_getter_service.dart';
import 'package:gren_mart/service/shipping_zone_service.dart';

import 'payment_grid_tile.dart';
import '../../db/database_helper.dart';
import '../../service/shipping_addresses_service.dart';
import '../../view/cart/payment_status.dart';
import '../../view/settings/new_address.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_name.dart';
import '../../view/utils/constant_styles.dart';

class Checkout extends StatelessWidget {
  static const routeName = 'checkout';

  ConstantColors cc = ConstantColors();

  bool error = false;

  @override
  Widget build(BuildContext context) {
    print('kenooooooooooooo');
    final sService = Provider.of<ShippingZoneService>(context, listen: false);
    final cService = Provider.of<CartDataService>(context, listen: false);
    final cdService = Provider.of<CuponDiscountService>(context, listen: false);
    final subTotal = cService.subTotal;
    final shippingCost = sService.shippingCost;
    final taxMoney = sService.taxParcentage * cService.subTotal;
    final discount = cdService.cuponDiscount;
    final totalAmount = subTotal + taxMoney + shippingCost - discount;
    return Scaffold(
      appBar: AppBars().appBarTitled('Checkout', () {
        Provider.of<ShippingAddressesService>(context, listen: false)
            .clearSelectedAddress();
        Navigator.of(context).pop();
      }, hasButton: true, hasElevation: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
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
          if ((Provider.of<ShippingAddressesService>(context).noData))
            SizedBox(
                height: 50,
                child: Center(
                    child: Text('No address found.',
                        style: TextStyle(color: cc.greyHint, fontSize: 14)))),
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
                Provider.of<ShippingZoneService>(context, listen: false)
                    .resetChecout();
                saService.setSelectedAddress(e);
                Provider.of<ShippingZoneService>(context, listen: false)
                    .fetchContriesZone(e.countryId)
                    .then((value) =>
                        Provider.of<ShippingZoneService>(context, listen: false)
                            .fetchSatesZone(e.stateId));
              },
              child: addressBox(context, e.id),
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      // subTotal += e.price;
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
                                                (e.colorName == null
                                                    ? ''
                                                    : 'Color: ${e.colorName!.capitalize()}. ') +
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
              rows('Subtotal', trailing: '\$${cService.subTotal}'),
              const SizedBox(height: 15),
              rows('Shipping cost', trailing: ''),
              const SizedBox(height: 15),
              if (!(Provider.of<ShippingAddressesService>(context).noData))
                ...shippingOption(context),
              if ((Provider.of<ShippingAddressesService>(context).noData))
                Text('Select a shipping address.',
                    style: TextStyle(color: cc.greyHint, fontSize: 14)),
              const SizedBox(height: 15),
              rows('Tax', trailing: '\$${taxMoney.toStringAsFixed(2)}'),
              const SizedBox(height: 15),
              rows('Coupon discount',
                  trailing: '-\$${discount.toStringAsFixed(2)}'),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 25),
              rows('Total', trailing: '\$${totalAmount.toStringAsFixed(2)}'),
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
                        style: TextStyle(
                          color: cc.greyHint,
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                            hintText: 'Enter Coupon code',
                            hintStyle: TextStyle(
                              color: cc.greyHint,
                              fontSize: 13,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ConstantColors().greyBorder, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ConstantColors().greyBorder, width: 1),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ConstantColors().orange, width: 1),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ConstantColors().orange, width: 1),
                            ),
                            contentPadding: const EdgeInsets.all(15)),
                        onChanged: (value) {
                          Provider.of<CuponDiscountService>(context,
                                  listen: false)
                              .setCuponText(value.trim());
                        },
                      ),
                    )
                    //  CustomTextField(
                    //     'Enter promo code', TextEditingController()),
                    ),
                GestureDetector(
                  onTap: cdService.isLoading
                      ? () {}
                      : () {
                          Provider.of<CuponDiscountService>(context,
                                  listen: false)
                              .setTotalAmount(
                                  subTotal + taxMoney + shippingCost);
                          Provider.of<CuponDiscountService>(context,
                                  listen: false)
                              .getCuponDiscontAmount()
                              .then((value) {
                            if (value != null) {
                              snackBar(context, value);
                            }
                          });
                          FocusScope.of(context).unfocus();
                        },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                          width: screenWidth / 4,
                          child: FittedBox(
                            child: Text(
                              'Apply Cupon code',
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
                      if (cdService.isLoading)
                        Container(
                            width: screenWidth / 4,
                            color: Colors.white60,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 10),
                            child: loadingProgressBar(size: 20))
                    ],
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
              const SizedBox(height: 20),
              Consumer<PaymentGetterService>(
                  builder: (context, pgService, child) {
                return FutureBuilder(
                    future: pgService.fetchPaymentGetterData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingProgressBar();
                      }
                      if (snapshot.hasError) {
                        snackBar(context, 'An error occured');
                        return Text(snapshot.error.toString());
                      }
                      return SizedBox(
                          height: 270,
                          child: GridView(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 3 / 1.2,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 12),
                            children: pgService.logoList
                                .map((e) => GestureDetector(
                                    onTap: () {
                                      // if (selectedName == e) {
                                      //   return;
                                      // }
                                      // setState(() {
                                      //   selectedName = e;
                                      // });
                                    },
                                    child: CartGridTile(e, false)))
                                .toList(),
                          ));
                    });
              }),
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
    );
  }

  Widget addressBox(BuildContext context, int id) {
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

  List<Widget> shippingOption(BuildContext context) {
    final sService = Provider.of<ShippingZoneService>(context);
    return sService.isLoading
        ? [loadingProgressBar(size: 20)]
        : (sService.shippingOptionsList!
            .map((element) {
              return Row(
                children: [
                  Transform.scale(
                    scale: 1.3,
                    child: Checkbox(
                        // splashRadius: 30,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: ConstantColors().primaryColor,
                        value: sService.selectedOption!.id == element.id,
                        shape: const CircleBorder(),
                        side: BorderSide(
                          width: 1.5,
                          color: ConstantColors().greyBorder,
                        ),
                        onChanged: (v) {
                          print(element.name);
                          sService.setSelectedOption(element);
                        }),
                  ),
                  Text(element.name),
                  const Spacer(),
                  Text('\$${element.availableOptions.cost}')
                ],
              );
            })
            .toList()
            .reversed
            .toList());
  }
}
