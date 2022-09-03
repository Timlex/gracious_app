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

class SquareUpPayment extends StatelessWidget {
  SquareUpPayment({Key? key}) : super(key: key);
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
              // onPageStarted: (value) {
              //   print("on progress.........................$value");
              //   if (value.contains('finish')) {
              //     print('closing payment......');
              //     print('closing payment.............');
              //     print('closing payment...................');
              //     print('closing payment..........................');
              //     Navigator.of(context).pop();
              //   }
              // },
              // navigationDelegate: (navRequest) async {
              //   print('nav req to .......................${navRequest.url}');
              //   return NavigationDecision.navigate;
              // },
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
    final url = Uri.parse(
        'https://connect.squareupsandbox.com/v2/online-checkout/payment-links');
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization":
          'Bearer EAAAEOuLQObrVwJvCvoio3H13b8Ssqz1ighmTBKZvIENW9qxirHGHkqsGcPBC1uN',
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final orderId = Random().nextInt(23000).toInt();
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "description": "a grenmart item",
          "idempotency_key": "$orderId",
          "quick_pay": {
            "location_id": "LE9C12TNM5HAS",
            "name": "grenmart items",
            "price_money": {"amount": amount.toInt(), "currency": "USD"}
          },
          "payment_note": "grenmart groceries",
          "pre_populated_data": {"buyer_email": "kizrudroa@gmail.com"}
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['payment_link']['url'];
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
