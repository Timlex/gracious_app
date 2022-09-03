import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/payment_gateaway_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../service/cart_data_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/user_profile_service.dart';

class PayTabsPayment extends StatelessWidget {
  PayTabsPayment({Key? key}) : super(key: key);
  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled('', () {
        Navigator.of(context).pop();
      }),
      body: FutureBuilder(
          future: waitForIt(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingProgressBar();
            }
            if (snapshot.hasData) {
              return const Center(
                child: Text('Loding failed.'),
              );
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(
                child: Text('Loding failed.'),
              );
            }
            return WebView(
              // onWebViewCreated: ((controller) {
              //   _controller = controller;
              // }),
              onWebResourceError: (error) => showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('Loading failed!'),
                      content: Text('Failed to load payment page.'),
                      actions: [
                        Spacer(),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Return',
                            style: TextStyle(color: cc.primaryColor),
                          ),
                        )
                      ],
                    );
                  }),
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,

              onPageFinished: (value) async {
                // final title = await _controller.currentUrl();
                // print(title);
                print('on finished......................... $value');
                // if (value.contains('finish')) {
                //   bool paySuccess = await verifyPayment(value);
                //   print('closing payment......');
                //   print('closing payment.............');
                //   print('closing payment...................');
                //   print('closing payment..........................');
                //   if (paySuccess) {
                //     Navigator.of(context).pop();
                //     return;
                //   }
                //   await showDialog(
                //       context: context,
                //       builder: (ctx) {
                //         return AlertDialog(
                //           title: Text('Payment failed!'),
                //           content: Text('Payment has been cancelled.'),
                //           actions: [
                //             Spacer(),
                //             TextButton(
                //               onPressed: () => Navigator.of(context).pop(),
                //               child: Text(
                //                 'Ok',
                //                 style: TextStyle(color: cc.primaryColor),
                //               ),
                //             )
                //           ],
                //         );
                //       });
                //   Navigator.of(context).pop();
                // }
              },
              onPageStarted: (value) async {
                print("on progress.........................$value");
                if (!value.contains('result')) {
                  return;
                }
                bool paySuccess = await verifyPayment(value);
                print('closing payment......');
                print('closing payment.............');
                print('closing payment...................');
                print('closing payment..........................');
                if (paySuccess) {
                  Navigator.of(context).pop();
                  return;
                }
                await showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Payment failed!'),
                        content: Text('Payment has failed.'),
                        actions: [
                          Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Ok',
                              style: TextStyle(color: cc.primaryColor),
                            ),
                          )
                        ],
                      );
                    });
                Navigator.of(context).pop();
              },
              navigationDelegate: (navRequest) async {
                print('nav req to .......................${navRequest.url}');
                return NavigationDecision.navigate;
              },
              // javascriptChannels: <JavascriptChannel>[
              //   // Set Javascript Channel to WebView
              //   JavascriptChannel(
              //       name: 'same',
              //       onMessageReceived: (javMessage) {
              //         print(javMessage.message);
              //         print('...........................................');
              //       }),
              // ].toSet(),
            );
          }),
    );
  }

  waitForIt(BuildContext context) async {
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
        cuponData.cuponDiscount);
    // if (selectrdGateaway.serverKey == null ||
    //     selectrdGateaway.clientKey == null) {
    //   snackBar(context, 'Invalid developer keys');
    // }
    print('here');
    final url = Uri.parse('https://secure-global.paytabs.com/payment/request');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'SKJNDNRHM2-JDKTZDDH2N-H9HLMJNJ2L',
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final orderId = Random().nextInt(23000).toInt();
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "profile_id": 96698,
          "tran_type": "sale",
          "tran_class": "ecom",
          "cart_id": "$orderId",
          "cart_description": "Grenmart groceries",
          "cart_currency": "USD",
          "cart_amount": amount,
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['redirect_url'];
      print(this.url);
      return;
    }

    return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('successful'));
    return response.body.contains('successful');
  }
}