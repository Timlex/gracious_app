import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/payment_gateaway_service.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_styles.dart';
import '../../service/checkout_service.dart';
import '../../service/confirm_payment_service.dart';
import '../cart/payment_status.dart';

class RazorpayPayment extends StatelessWidget {
  RazorpayPayment({Key? key}) : super(key: key);
  String? url;
  String? paynentID;
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
                  onPageFinished: (value) async {
                    // final title = await _controller.currentUrl();
                    // print(title);
                    print('on finished.........................$value');
                    final uri = Uri.parse(value);
                    final response = await http.get(uri);
                    // if (response.body.contains('PAYMENT ID')) {
                    print(response.body.contains('PAID'));
                    ;
                    bool paySuccess = response.body.contains('status":"paid');
                    print('closing payment......');
                    print('closing payment.............');
                    print('closing payment...................');
                    print('closing payment..........................');
                    if (paySuccess) {
                      await Provider.of<ConfirmPaymentService>(context,
                              listen: false)
                          .confirmPayment(context);
                      return;
                    }
                  });
            }),
      ),
    );
  }

  Future waitForIt(BuildContext context) async {
    final selectedGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    final uri = Uri.parse('https://api.razorpay.com/v1/payment_links');
    // String username = "rzp_test_qfnlVh6GDZoveL";
    // String password = "1BKI89076hFeXRsbGuSaj29C";
    final username = selectedGateaway.apiKey;
    final password = selectedGateaway.apiSecret;
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
    };
    final checkoutInfo =
        Provider.of<CheckoutService>(context, listen: false).checkoutModel;
    final orderId = checkoutInfo!.id;
    print(orderId);
    // final orderId = Random().nextInt(23000).toInt();
    final response = await http.post(uri,
        headers: header,
        body: jsonEncode({
          "amount": double.parse(checkoutInfo.totalAmount).toInt() * 100,
          //NOTE: When used USD giving error page.
          "currency": "INR",
          "accept_partial": false,
          "reference_id": orderId.toString(),
          "description": "Grenmart Payment",
          "customer": {
            "name": checkoutInfo.name,
            "contact": checkoutInfo.phone,
            "email": checkoutInfo.email
          },
          // "notify": {"sms": true, "email": true},
          "notes": {"policy_name": "Grenmart"},
        }));
    print(response.body);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['short_url'];
      this.paynentID = jsonDecode(response.body)['id'];
      print(this.url);
      return;
    }
    snackBar(context, 'Connection failed', backgroundColor: cc.orange);
    return 'skhfadi';
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('Payment Completed'));
    return response.body.contains('Payment Completed');
  }
}
