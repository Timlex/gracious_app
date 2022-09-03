import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/menual_payment_service.dart';
import 'package:gren_mart/view/payment/cash_free_payment.dart';
import 'package:gren_mart/view/payment/flutter_wave_payment.dart';
import 'package:gren_mart/view/payment/instamojo_payment.dart';
import 'package:gren_mart/view/payment/mercado_pago_payment.dart';
import 'package:gren_mart/view/payment/mid_trans_payment.dart';
import 'package:gren_mart/view/payment/mollie_payment.dart';
import 'package:gren_mart/view/payment/payfast_payment.dart';
import 'package:gren_mart/view/payment/paystack_payment.dart';
import 'package:gren_mart/view/payment/paytabs_payment.dart';
import 'package:gren_mart/view/payment/razorpay_payment.dart';
import 'package:gren_mart/view/payment/squareup_payment.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:gren_mart/service/cupon_discount_service.dart';
import 'package:gren_mart/service/payment_gateaway_service.dart';

import '../../service/cart_data_service.dart';
import '../../service/shipping_zone_service.dart';
import '../payment/paypal_payment.dart';
import '../payment/stripe_payment.dart';
import '../settings/new_address.dart';
import '../utils/text_themes.dart';
import 'payment_grid_tile.dart';
import '../../service/shipping_addresses_service.dart';
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
    return Scaffold(
      appBar: AppBars().appBarTitled('Checkout', () {
        Provider.of<ShippingAddressesService>(context, listen: false)
            .clearSelectedAddress();
        Provider.of<PaymentGateawayService>(context, listen: false)
            .resetGateaway();
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

          FutureBuilder(
              future: Provider.of<ShippingAddressesService>(context,
                      listen: false)
                  .fetchUsersShippingAddress(context, loadShippingZone: true),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return loadingProgressBar();
                }
                if (snapShot.hasData) {
                  return Center(
                    child: Text(snapShot.data.toString()),
                  );
                }
                return Consumer<ShippingAddressesService>(
                    builder: (context, saService, child) {
                  return Column(
                      children: saService.shippingAddresseList.map(((e) {
                    final shippingAddress = saService.shippingAddresseList
                        .firstWhere((element) => element.id == e.id);
                    final selected =
                        shippingAddress.id == saService.selectedAddress!.id;
                    return GestureDetector(
                        onTap: () {
                          if (saService.selectedAddress!.id == e.id) {
                            return;
                          }
                          saService.setSelectedAddress(e, context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: selected ? cc.lightPrimery3 : cc.whiteGrey,
                              border: Border.all(
                                  color:
                                      selected ? cc.primaryColor : cc.greyHint,
                                  width: .5)),
                          child: Stack(children: [
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: Text(shippingAddress.name),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
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
                        ));
                  })).toList());
                });
              }),
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
              rows('Product', trailing: 'Subtotal'),
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
                                    style:
                                        TextThemeConstrants.greyHint13Eclipse,
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
                              style: TextThemeConstrants.greyHint13Eclipse,
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
                      '\$${Provider.of<CartDataService>(context, listen: false).calculateSubtotal()}'),
              const SizedBox(height: 15),
              rows('Shipping cost', trailing: ''),
              const SizedBox(height: 15),
              Consumer<ShippingZoneService>(
                builder: (context, sService, child) {
                  return sService.noData
                      ? const Text('Select a shipping address.')
                      : (sService.isLoading
                          ? loadingProgressBar()
                          : Column(
                              children: sService.shippingOptionsList!
                                  .map((element) {
                                    return Row(
                                      children: [
                                        Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(
                                              // splashRadius: 30,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              activeColor:
                                                  ConstantColors().primaryColor,
                                              value:
                                                  sService.selectedOption!.id ==
                                                      element.id,
                                              shape: const CircleBorder(),
                                              side: BorderSide(
                                                width: 1.5,
                                                color:
                                                    ConstantColors().greyBorder,
                                              ),
                                              onChanged: (v) {
                                                sService
                                                    .setSelectedOption(element);
                                              }),
                                        ),
                                        Text(element.name),
                                        const Spacer(),
                                        Text(
                                            '\$${element.availableOptions.cost}')
                                      ],
                                    );
                                  })
                                  .toList()
                                  .reversed
                                  .toList(),
                            ));
                },
              ),
              const SizedBox(height: 15),
              Consumer<ShippingZoneService>(
                  builder: (context, szService, child) {
                return rows('Tax',
                    trailing:
                        '\$${szService.taxMoney(context).toStringAsFixed(2)}');
              }),
              const SizedBox(height: 15),
              Consumer<CuponDiscountService>(
                  builder: (context, cupService, child) {
                return rows('Coupon discount',
                    trailing:
                        '-\$${cupService.cuponDiscount.toStringAsFixed(2)}');
              }),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 25),
              Consumer<ShippingZoneService>(
                  builder: (context, szService, child) {
                return rows('Total',
                    trailing:
                        '\$${szService.totalCounter(context).toStringAsFixed(2)}');
              }),
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
                        style: TextThemeConstrants.greyHint13,
                        decoration: InputDecoration(
                            hintText: 'Enter Coupon code',
                            hintStyle: TextThemeConstrants.greyHint13,
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
                Consumer<CuponDiscountService>(
                    builder: (context, cService, child) {
                  return GestureDetector(
                    onTap: cService.isLoading
                        ? () {}
                        : () {
                            cService.setTotalAmount(0);
                            cService.getCuponDiscontAmount().then((value) {
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
                        if (cService.isLoading)
                          Container(
                              width: screenWidth / 4,
                              color: Colors.white60,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 10),
                              child: loadingProgressBar(size: 20))
                      ],
                    ),
                  );
                }),
              ]),
              const SizedBox(height: 15),
              Text(
                'Chose a payment method',
                style: TextThemeConstrants.titleText,
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                  future: Provider.of<PaymentGateawayService>(context,
                          listen: false)
                      .fetchPaymentGetterData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    if (snapshot.hasError) {
                      snackBar(context, 'An error occured');
                      return Text(snapshot.error.toString());
                    }
                    return Consumer<PaymentGateawayService>(
                        builder: (context, pgService, child) {
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
                            children: pgService.gatawayList
                                .map((e) => GestureDetector(
                                    onTap: () {
                                      if (pgService.selectedGateaway == e) {
                                        return;
                                      }
                                      pgService.setSelectedGareaway(e);
                                    },
                                    child: CartGridTile(
                                        e.logoLink, pgService.itemSelected(e))))
                                .toList(),
                          ));
                    });
                  }),
              const SizedBox(height: 20),
              customContainerButton('Pay & Confirm', double.maxFinite, () {
                startPayment(context);
                // DbHelper.deleteDbTable('cart');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => PaymentStatusView(error)),
                // );
                // error = true;
              }),
              const SizedBox(height: 30),
            ]),
          ),
        ],
      ),
    );
  }

  Widget rows(String leading, {String? trailing}) {
    final textStyle = TextStyle(
        color: cc.greyParagraph, fontSize: 15, fontWeight: FontWeight.bold);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leading,
          style: textStyle,
        ),
        if (trailing != null)
          Text(
            trailing,
            style: textStyle,
          ),
      ],
    );
  }

  startPayment(BuildContext context) async {
    final selectedGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway;
    if (selectedGateaway!.name.toLowerCase().contains('paypal')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PaypalPayment(
            onFinish: (number) async {
              // payment done
              print('order id: ' + number);
            },
          ),
        ),
      );
      return;
    }
    if (selectedGateaway.name.toLowerCase().contains('stripe')) {
      await StripePayment().makePayment(context);
      return;
    }
    if (selectedGateaway.name.toLowerCase().contains('razorpay')) {
      RazorpayPayment().createOrder(context);

      return;
    }
    if (selectedGateaway.name.toLowerCase().contains('paystack')) {
      PaystackPayment(ctx: context, price: 100, email: 'fake@gmail.com')
          .chargeCardAndMakePayment();
      return;
    }
    if (selectedGateaway.name.toLowerCase().contains('flutterwave')) {
      FlutterWavePayment().makePayment(context);
      return;
    }
    if (selectedGateaway.name.toLowerCase().contains('cashfree')) {
      CashFreePayment().doPayment(context);
      return;
    }
    // if (selectedGateaway.name.toLowerCase().contains('midtrans')) {
    //   // MidTransPayment().startPayment(context);
    //   // Navigator.of(context).push(
    //   //   MaterialPageRoute(
    //   //     builder: (BuildContext context) => MidTransPayment(),
    //   //   ),
    //   // );
    //   return;
    // }
    if (selectedGateaway.name.toLowerCase().contains('marcadopago')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => MercadopagoPayment(),
        ),
      );
      return;
    }
    // }
    if (selectedGateaway.name.toLowerCase().contains('payfast')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => SquareUpPayment(),
        ),
      );
      return;
    }
    if (selectedGateaway.name.toLowerCase().contains('midtrans')) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => PayTabsPayment(),
        ),
      );

      return;
    }
    if (selectedGateaway.name.toLowerCase().contains('instamojo')) {
      // MercadoPagoMobileCheckout.startCheckout(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => InstamojoPayment(),
        ),
      );
      return;
    }
    if (selectedGateaway.name.toLowerCase().contains('mollie')) {
      // MercadoPagoMobileCheckout.startCheckout(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => MolliePayment(),
        ),
      );
      return;
    }
    if (selectedGateaway.name.toLowerCase().contains('manual_payment')) {
      showDialog(
          context: context,
          builder: (context) {
            return Consumer<MenualPaymentService>(
                builder: (context, mService, child) {
              return AlertDialog(
                content: GestureDetector(
                  onTap: (() {
                    imageSelector(context);
                  }),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: cc.primaryColor,
                            )),
                        child: mService.pickedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt_outlined),
                                  Text('Select an image from gallary'),
                                ],
                              )
                            : Image.file(mService.pickedImage!),
                      )),
                ),
                actions: [
                  customContainerButton('Upload image', double.infinity, () {
                    Navigator.of(context).pop();
                  })
                ],
              );
            });
          });
      return;
    }

    snackBar(context, 'Select a payment Gateaway');
  }

  Future<void> imageSelector(BuildContext context,
      {ImageSource imageSource = ImageSource.camera}) async {
    try {
      final pickedImage =
          await ImagePicker.platform.pickImage(source: imageSource);
      Provider.of<MenualPaymentService>(context, listen: false)
          .setPickedImage(File(pickedImage!.path));
    } catch (error) {
      print(error.toString());
    }
  }
}
