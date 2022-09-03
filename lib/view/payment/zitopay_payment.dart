import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/payment_gateaway_service.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:namefully/namefully.dart';
import 'package:http/http.dart' as http;

import '../../service/cart_data_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/user_profile_service.dart';

class ZitopayPayment extends StatelessWidget {
  ZitopayPayment(this.url, {Key? key}) : super(key: key);
  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBars().appBarTitled('', () {
          Navigator.of(context).pop();
        }),
        body: WebView(
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
          onPageStarted: (value) async {
            print("on progress.........................$value");
            if (!value.contains('confirm_trans')) {
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
                    content: Text('Payment has been failed.'),
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
        ));
  }
}

Future<bool> verifyPayment(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  print(response.body.contains('successful'));
  return response.body.contains('successful');
}