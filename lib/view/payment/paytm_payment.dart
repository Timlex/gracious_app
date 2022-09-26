import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../service/checkout_service.dart';
import '../../service/confirm_payment_service.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_styles.dart';
import '../cart/payment_status.dart';

class PaytmPayment extends StatelessWidget {
  PaytmPayment({Key? key}) : super(key: key);
  WebViewController? _controller;
  String? html;
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
        child: WebView(
          onWebViewCreated: (controller) {
            _controller = controller;
            controller.loadHtmlString(
                Provider.of<CheckoutService>(context, listen: false)
                    .paytmResponse as String);
          },
          initialUrl: "url",
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (value) {
            print('on progress.........................$value');
            if (value.contains('success')) {
              print('closing payment......');
              print('closing payment.............');
              print('closing payment...................');
              print('closing payment..........................');

              Provider.of<ConfirmPaymentService>(context, listen: false)
                  .confirmPayment(context);
            }
          },
          navigationDelegate: (navData) {
            if (navData.url.contains('success')) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PaymentStatusView(false)),
                  (Route<dynamic> route) => false);
              return NavigationDecision.prevent;
            }
            if (navData.url.contains('failed')) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PaymentStatusView(true)),
                  (Route<dynamic> route) => false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}

Future<bool> verifyPayment(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  print(response.body.contains('successful'));
  return response.body.contains('successful');
}
