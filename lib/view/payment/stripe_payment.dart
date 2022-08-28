import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/payment_gateaway_service.dart';
import 'package:gren_mart/service/shipping_zone_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../../service/cart_data_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/user_profile_service.dart';

class StripePayment {
  Map<String, dynamic>? paymentIntent;

  Future<void> makePayment(BuildContext context) async {
    Stripe.publishableKey =
        "pk_test_51LbdwFBfDAMfsX2WsDHQ0DafWeg3THiNveRBQFvjS2jqZUeClSFLglEx2s9VZUFTJzcWxF32vbz3n64v3fkSzN2i00dpADItrN";
    // Stripe.publishableKey =
    //     Provider.of<PaymentGateawayService>(context, listen: false)
    //         .selectedGateaway!
    //         .publicKey
    //         .toString();
    try {
      paymentIntent = await createPaymentIntent(context, '10', 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Adnan'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(context);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull"),
                        ],
                      ),
                    ],
                  ),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(
      BuildContext context, String amount, String currency) async {
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
    // try {
    Map<String, dynamic> body = {
      'amount': (shippingZone.taxMoney(context) +
              shippingZone.shippingCost +
              cartData.calculateSubtotal() -
              cuponData.cuponDiscount)
          .toInt()
          .toString(),
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        // 'Authorization': 'Bearer ${selectrdGateaway.secretKey}',
        'Authorization':
            'Bearer sk_test_51LbdwFBfDAMfsX2W42YBqv6juzNaqZwB6Lh9BD65lg6oquPFzxWQoyztuh3SZr9AEyg0eZAugnfPPVJa1iQGKFGx00AET5nhhr',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    // ignore: avoid_print
    print('Payment Intent Body->>> ${response.body}');
    return jsonDecode(response.body);
    // } catch (err) {
    //   // ignore: avoid_print
    //   print('err charging user: ${err.toString()}');
    // }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
