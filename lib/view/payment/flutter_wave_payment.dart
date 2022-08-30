import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:flutterwave_standard/models/subaccount.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../service/cart_data_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/payment_gateaway_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/user_profile_service.dart';
import '../utils/constant_styles.dart';

class FlutterWavePayment {
  late BuildContext context;
  String currency = 'USD';

  void makePayment(BuildContext context) async {
    this.context = context;
    _handlePaymentInitialization(context);

    // final userData =
    //     Provider.of<UserProfileService>(context, listen: false).userProfileData;
    // final cartData = Provider.of<CartDataService>(context, listen: false);
    // final shippingAddress =
    //     Provider.of<ShippingAddressesService>(context, listen: false);
    // final shippingZone =
    //     Provider.of<ShippingZoneService>(context, listen: false);
    // final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
    // final selectrdGateaway =
    //     Provider.of<PaymentGateawayService>(context, listen: false)
    //         .selectedGateaway!;
    // final amount = (shippingZone.taxMoney(context) +
    //         shippingZone.shippingCost +
    //         cartData.calculateSubtotal() -
    //         cuponData.cuponDiscount)
    //     .toInt()
    //     .toString();
    // try {
    //   Flutterwave flutterwave = Flutterwave.forUIPayment(
    //       context: context,
    //       encryptionKey: "FLWSECK_TEST4734027149f5",
    //       publicKey: selectrdGateaway.publicKey as String,
    //       currency: "Usd",
    //       amount: amount,
    //       email: userData.email,
    //       fullName: userData.name,
    //       txRef: "_ref!44152654",
    //       isDebugMode: true,
    //       phoneNumber: shippingAddress.selectedAddress!.phone,
    //       acceptCardPayment: true,
    //       acceptUSSDPayment: true,
    //       acceptAccountPayment: true,
    //       acceptBankTransfer: true,
    //       acceptFrancophoneMobileMoney: false,
    //       acceptGhanaPayment: true,
    //       acceptMpesaPayment: true,
    //       acceptRwandaMoneyPayment: true,
    //       acceptUgandaPayment: true,
    //       acceptZambiaPayment: true);

    //   final response = await flutterwave.initializeForUiPayments();

    //   if (response == null) {
    //     print("Transaction Failed");
    //   } else {
    //     ///
    //     if (response.status == "success") {
    //       print(response.data);
    //       print(response.message);
    //     } else {
    //       print(response.message);
    //     }
    //   }
    // } catch (error) {
    //   print(error);
    // }
  }

  _handlePaymentInitialization(BuildContext context) async {
    // String amount;
    // var bcProvider =
    //     Provider.of<BookConfirmationService>(context, listen: false);
    // var pProvider = Provider.of<PersonalizationService>(context, listen: false);
    // var bookProvider = Provider.of<BookService>(context, listen: false);

    // // var name = bookProvider.name ?? '';
    // var phone = bookProvider.phone ?? '';
    // var email = bookProvider.email ?? '';

    final userData =
        Provider.of<UserProfileService>(context, listen: false).userProfileData;
    final cartData = Provider.of<CartDataService>(context, listen: false);
    final shippingAddress =
        Provider.of<ShippingAddressesService>(context, listen: false);
    final shippingZone =
        Provider.of<ShippingZoneService>(context, listen: false);
    final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
    final selectrdGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    final amount = (shippingZone.taxMoney(context) +
            shippingZone.shippingCost +
            cartData.calculateSubtotal() -
            cuponData.cuponDiscount)
        .toInt()
        .toString();

    // if (pProvider.isOnline == 0) {
    //   amount = bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2);
    // } else {
    //   amount = bcProvider.totalPriceOnlineServiceAfterAllCalculation
    //       .toStringAsFixed(2);
    // }

    if (selectrdGateaway.publicKey == null ||
        selectrdGateaway.secretKey == null) {
      snackBar(context, 'Invalid developer keys');
    }

    // String publicKey = 'FLWPUBK_TEST-86cce2ec43c63e09a517290a8347fcab-X';
    String publicKey = selectrdGateaway.publicKey ?? '';

    final style = FlutterwaveStyle(
      appBarText: "Flutterwave payment",
      buttonColor: Colors.blue,
      buttonTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      appBarColor: Colors.blue,
      dialogCancelTextStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 17,
      ),
      dialogContinueTextStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 17,
      ),
      mainBackgroundColor: Colors.white,
      mainTextStyle:
          const TextStyle(color: Colors.black, fontSize: 17, letterSpacing: 2),
      dialogBackgroundColor: Colors.white,
      appBarIcon: const Icon(Icons.arrow_back, color: Colors.white),
      buttonText: "Pay \$ $amount",
      appBarTitleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
      ),
    );

    final Customer customer = Customer(
        name: userData.name,
        phoneNumber: userData.phone,
        email: userData.email);

    final subAccounts = [
      SubAccount(
          id: "RS_1A3278129B808CB588B53A14608169AD",
          transactionChargeType: "flat",
          transactionPercentage: 25),
      SubAccount(
          id: "RS_C7C265B8E4B16C2D472475D7F9F4426A",
          transactionChargeType: "flat",
          transactionPercentage: 50)
    ];

    final Flutterwave flutterwave = Flutterwave(
        context: context,
        style: style,
        publicKey: publicKey,
        currency: currency,
        txRef: const Uuid().v1(),
        amount: amount,
        customer: customer,
        subAccounts: subAccounts,
        paymentOptions: "card, payattitude",
        customization: Customization(title: "Test Payment"),
        redirectUrl: "https://www.google.com",
        isTestMode: false);
    var response = await flutterwave.charge();
    if (response != null) {
      showLoading(response.status!, context);
      print('flutterwave payment successfull');
      // Provider.of<PlaceOrderService>(context, listen: false)
      //     .makePaymentSuccess(context);
      // print("${response.toJson()}");
    } else {
      //User cancelled the payment
      // showLoading("No Response!");
    }
  }

  Future<void> showLoading(String message, context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}
