import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/checkout_service.dart';
import 'package:gren_mart/service/confirm_payment_service.dart';
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
import '../cart/payment_status.dart';
import '../home/home_front.dart';

class BillplzPayment extends StatelessWidget {
  BillplzPayment({Key? key}) : super(key: key);
  String? url;
  late WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled(context, '', () async {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Your payment proccess will get terminated.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => PaymentStatusView(true)),
                        (Route<dynamic> route) => false),
                    child: Text(
                      'Yes',
                      style: TextStyle(color: cc.primaryColor),
                    ),
                  )
                ],
              );
            });
      }),
      body: WillPopScope(
        onWillPop: () async {
          await showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Your payment proccess will get terminated.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => PaymentStatusView(true)),
                          (Route<dynamic> route) => false),
                      child: Text(
                        'Yes',
                        style: TextStyle(color: cc.primaryColor),
                      ),
                    )
                  ],
                );
              });
          return false;
        },
        child: FutureBuilder(
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
                            onPressed: () => Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentStatusView(true)),
                                    (Route<dynamic> route) => false),
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
                  verifyPayment(value, context);
                },
              );
            }),
      ),
    );
  }

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        print('page body: $pageBody');
      },
    );
  }

  waitForIt(BuildContext context) async {
    final checkoutInfo =
        Provider.of<CheckoutService>(context, listen: false).checkoutModel;
    final orderId = checkoutInfo!.id;

    final url = Uri.parse('https://www.billplz-sandbox.com/api/v3/bills');
    final username = 'b2ead199-e6f3-4420-ae5c-c94f1b1e8ed6';
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$username'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "collection_id": "kjj5ya006",
          "description": "Grenmart payment",
          "email": checkoutInfo!.email,
          "name": checkoutInfo!.name,
          "amount": "${checkoutInfo!.totalAmount}",
          "reference_1_label": "Bank Code",
          "reference_1": "BP-FKR01",
          "callback_url": "http://www.gxenious.com"
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)["url"];
      return;
    }

    return true;
  }
}

Future verifyPayment(String url, BuildContext context) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  if (response.body.contains('paid')) {
    Provider.of<ConfirmPaymentService>(context, listen: false)
        .confirmPayment(context);
    ;
    return;
  }
  if (response.body.contains('your payment was not')) {
    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Payment failed!'),
            content: Text('Payment has been failed.'),
            actions: [
              Spacer(),
              TextButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => PaymentStatusView(true)),
                    (Route<dynamic> route) => false),
                child: Text(
                  'Ok',
                  style: TextStyle(color: cc.primaryColor),
                ),
              )
            ],
          );
        });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => PaymentStatusView(true)),
        (Route<dynamic> route) => false);
    ;
    return;
  }
}
