import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../service/payment_gateaway_service.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_styles.dart';
import '../../service/checkout_service.dart';
import '../../service/confirm_payment_service.dart';
import '../cart/payment_status.dart';

class MolliePayment extends StatelessWidget {
  MolliePayment({Key? key}) : super(key: key);
  String? url;
  String? statusURl;
  @override
  Widget build(BuildContext context) {
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
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                navigationDelegate: (navRequest) async {
                  print('nav req to .......................${navRequest.url}');
                  if (navRequest.url.contains('xgenious')) {
                    print('preventing navigation');
                    String status = await verifyPayment();
                    if (status == 'paid') {
                      await Provider.of<ConfirmPaymentService>(context,
                              listen: false)
                          .confirmPayment(context);
                    }
                    if (status == 'open') {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text('Payment cancelled!'),
                              content: Text('Payment has been cancelled.'),
                              actions: [
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
                    }
                    if (status == 'failed') {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text('Payment failed!'),
                              actions: [
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
                    }
                    if (status == 'expired') {
                      await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text('Payment failed!'),
                              content: Text('Payment has been expired.'),
                              actions: [
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
                    }
                    return NavigationDecision.prevent;
                  }
                  if (navRequest.url.contains('mollie')) {
                    return NavigationDecision.navigate;
                  }
                  return NavigationDecision.prevent;
                },
              );
            }),
      ),
    );
  }

  waitForIt(BuildContext context) async {
    final url = Uri.parse('https://api.mollie.com/v2/payments');
    final selectedGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${selectedGateaway.publicKey}",
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final checkoutInfo =
        Provider.of<CheckoutService>(context, listen: false).checkoutModel;
    final orderId = checkoutInfo!.id;
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "amount": {
            "value": double.parse(checkoutInfo.totalAmount).toStringAsFixed(2),
            "currency": "USD"
          },
          "description": "Grenmart groceries",
          "redirectUrl": "http://www.xgenious.com",
          "webhookUrl": "http://www.xgenious.com",
          "metadata": "creditcard",
          // "method": "creditcard",
        }));
    print(response.body);
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['_links']['checkout']['href'];
      this.statusURl = jsonDecode(response.body)['_links']['self']['href'];
      print(statusURl);
      return;
    }

    return true;
  }

  verifyPayment() async {
    final url = Uri.parse(statusURl as String);
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer test_fVk76gNbAp6ryrtRjfAVvzjxSHxC2v",
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.get(url, headers: header);
    print(jsonDecode(response.body)['status']);
    return jsonDecode(response.body)['status'];
  }
}
