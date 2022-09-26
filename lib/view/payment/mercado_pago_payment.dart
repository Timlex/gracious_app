import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart ' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../service/checkout_service.dart';
import '../../service/confirm_payment_service.dart';
import '../../service/payment_gateaway_service.dart';
import '../cart/payment_status.dart';
import '../home/home_front.dart';
import '../utils/app_bars.dart';
import '../utils/constant_styles.dart';

class MercadopagoPayment extends StatelessWidget {
  MercadopagoPayment({Key? key}) : super(key: key);
  String? url;
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
            future: getPaymentUrl(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingProgressBar();
              }
              if (snapshot.hasData) {
                return const Center(
                  child: Text('Loading failed.'),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: Text('Loading failed.'),
                );
              }
              return WebView(
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
                // onPageFinished: (value) async {
                //   print('on progress.........................$value');
                //   if (value.contains('success')) {
                //     print('closing payment......');
                //     print('closing payment.............');
                //     print('closing payment...................');
                //     print('closing payment..........................');
                //     await Provider.of<ConfirmPaymentService>(context,
                //             listen: false)
                //         .confirmPayment(context);
                //   }
                // },
                // onPageStarted: (value) async {
                //   final response = await http.get(Uri.parse(value));
                //   print(
                //       'Checking condition.............................${response.body.contains('other')}');
                //   print("on progress.........................$value");
                //   if (value.contains('success')) {
                //     await Provider.of<ConfirmPaymentService>(context,
                //             listen: false)
                //         .confirmPayment(context);
                //     print('closing payment......');
                //     print('closing payment.............');
                //     print('closing payment...................');
                //     print('closing payment..........................');

                //     Navigator.of(context).pushAndRemoveUntil(
                //         MaterialPageRoute(
                //             builder: (context) => PaymentStatusView(true)),
                //         (Route<dynamic> route) => false);
                //   }
                // },
                navigationDelegate: (navData) {
                  if (navData.url.contains('success')) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => PaymentStatusView(false)),
                        (Route<dynamic> route) => false);
                    return NavigationDecision.prevent;
                  }
                  if (navData.url.contains('failure') ||
                      navData.url.contains('pending')) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => PaymentStatusView(true)),
                        (Route<dynamic> route) => false);
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              );
            }),
      ),
    );
  }

  Future<dynamic> getPaymentUrl(BuildContext context) async {
    final selectrdGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    final checkoutInfo =
        Provider.of<CheckoutService>(context, listen: false).checkoutModel;
    if (selectrdGateaway.clientSecret == null) {
      snackBar(context, 'Invalid developer keys', backgroundColor: cc.orange);
    }
    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var data = jsonEncode({
      "items": [
        {
          "title": "Grenmart products",
          "description": "Grenmart cart items",
          "quantity": 1,
          "currency_id": "ARS",
          "unit_price": double.parse(checkoutInfo!.totalAmount).toInt()
        }
      ],
      "payer": {"email": checkoutInfo.email},
      "back_urls": {
        "failure": "failure.com",
        "pending": "pending.com",
        "success": "success.com"
      }
    });

    var response = await http.post(
        Uri.parse(
            'https://api.mercadopago.com/checkout/preferences?access_token=${selectrdGateaway.clientSecret}'),
        headers: header,
        body: data);

    // print(response.body);
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['init_point'];
      print(response.body);

      return;
    }
    return '';
  }
}
