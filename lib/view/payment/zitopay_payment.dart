import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gren_mart/view/home/home_front.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../service/checkout_service.dart';
import '../cart/payment_status.dart';

class ZitopayPayment extends StatelessWidget {
  ZitopayPayment(this.userName, {Key? key}) : super(key: key);
  String? userName;
  @override
  Widget build(BuildContext context) {
    final checkoutInfo =
        Provider.of<CheckoutService>(context, listen: false).checkoutModel;
    final orderId = checkoutInfo!.id;
    return Scaffold(
        appBar: AppBars().appBarTitled('', () async {
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
                        onPressed: () => Navigator.of(context)
                            .pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentStatusView(true)),
                                (Route<dynamic> route) => false),
                        child: Text('Yes',
                            style: TextStyle(color: cc.primaryColor)),
                      )
                    ],
                  );
                });
            return false;
          },
          child: WebView(
            onWebResourceError: (error) => showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('Loading failed!'),
                    content: Text('Failed to load payment page.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed(HomeFront.routeName),
                        child: Text(
                          'Return',
                          style: TextStyle(color: cc.primaryColor),
                        ),
                      )
                    ],
                  );
                }),
            initialUrl:
                'https://zitopay.africa/sci/?currency=USD&amount=${checkoutInfo!.totalAmount}&receiver=$userName',
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (value) async {
              print("on progress.........................$value");
              if (!value.contains('confirm_trans')) {
                return;
              }
              bool paySuccess = await verifyPayment(value);
              if (paySuccess) {
                final checkoutInfo =
                    Provider.of<CheckoutService>(context, listen: false);
                final orderId = checkoutInfo!.checkoutModel!.id;
                Navigator.of(context).pop();
                return;
              }
              await showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('Payment failed!'),
                      content: Text('Payment has been failed.'),
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
                            'Ok',
                            style: TextStyle(color: cc.primaryColor),
                          ),
                        )
                      ],
                    );
                  });

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PaymentStatusView(true)),
                  (Route<dynamic> route) => false);
            },
          ),
        ));
  }
}

Future<bool> verifyPayment(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  print(response.body.contains('successful'));
  return response.body.contains('successful');
}
