import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/payment_gateaway_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PayFastPayment extends StatelessWidget {
  PayFastPayment({Key? key}) : super(key: key);
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
            return WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (value) {
                print('on progress.........................$value');
                if (value.contains('success')) {
                  print('closing payment......');
                  print('closing payment.............');
                  print('closing payment...................');
                  print('closing payment..........................');
                  Navigator.of(context).pop();
                }
              },
              onPageStarted: (value) {
                print("on progress.........................$value");
                if (value.contains('success')) {
                  print('closing payment......');
                  print('closing payment.............');
                  print('closing payment...................');
                  print('closing payment..........................');
                  Navigator.of(context).pop();
                }
              },
            );
          }),
    );
  }

  waitForIt(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    final url =
        Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions');
    final selectedGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    final username = selectedGateaway.serverKey;
    final password = selectedGateaway.clientKey;
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final response = await http.post(url,
        headers: header,
        body: jsonEncode({
          "transaction_details": {"order_id": "2154", "gross_amount": 10000},
          "credit_card": {"secure": true},
          "customer_details": {
            "first_name": "Johny",
            "last_name": "Kane",
            "email": "testmidtrans@mailnesia.com",
            "phone": "08111222333"
          }
        }));
    print(jsonDecode(response.body));
    this.url = jsonDecode(response.body)['redirect_url'];

    return true;
  }
}
