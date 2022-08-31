// import 'package:crypto/crypto.dart';
// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class PayfastPay {
//   final orderData = {
//     "merchant_id": "10024000",
//     "merchant_key": "77jcu5v4ufdod",
//     "name_first": "afsffs",
//     "name_last": "sdfsdfs",
//     "email_address": "fs@fsfs.sdfs",
//     "m_payment_id": "f4155",
//     "amount": "1255",
//     "item_name": "sfsfwfr",
//   };
//   creatSignature() async {
//     final dataToHash = jsonEncode(orderData);

//     var bytesToHash = utf8.encode(dataToHash);
//     var md5Digest = md5.convert(bytesToHash);

//     print('Data to hash: $dataToHash');
//     print('MD5: $md5Digest');
//     final url = Uri.parse(
//         'https://api.payfast.co.za/subscriptions/2afa4575-5628-051a-d0ed-4e071b56a7b0/fetch?testing=true');
//     final response = await http.get(url, headers: {
//       'merchant-id': '10024000',
//       'version': 'v1',
//       'timestamp': '${DateTime.now()}',
//       'signature': 'md5Digest',
//     });
//     print(response.body);
//   }
// }
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

class PayfastPayment extends StatelessWidget {
  PayfastPayment({Key? key}) : super(key: key);
  String? url;
  late WebViewController _controller;
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
                print('on finished.........................$value');
                if (value.contains('finish')) {
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
                          content: Text('Payment has been cancelled.'),
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
                }
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

  JavascriptChannel _extractDataJSChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Flutter',
      onMessageReceived: (JavascriptMessage message) {
        String pageBody = message.message;
        print('page body: $pageBody');
      },
    );
  }

  waitForIt(BuildContext context) {
    final userData =
        Provider.of<UserProfileService>(context, listen: false).userProfileData;
    final cartData = Provider.of<CartDataService>(context, listen: false);
    final shippingAddress =
        Provider.of<ShippingAddressesService>(context, listen: false);
    final shippingZone =
        Provider.of<ShippingZoneService>(context, listen: false);
    final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
    final selectedGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    final amount = (shippingZone.taxMoney(context) +
        shippingZone.shippingCost +
        cartData.calculateSubtotal() -
        cuponData.cuponDiscount);
    if (selectedGateaway.merchantId == null ||
        selectedGateaway.merchantKey == null) {
      snackBar(context, 'Invalid developer keys');
    }
    print('here');
    // final selectedGateaway =
    //     Provider.of<PaymentGateawayService>(context, listen: false)
    //         .selectedGateaway!;
    // final url = Uri.parse(
    //     'https://sandbox.payfast.co.za/eng/process?merchant_id=${selectedGateaway.merchantId}&merchant_key=${selectedGateaway.merchantId}&production=false&amount=$amount&item_name=Grenmart20%groceries');
    // final username = selectedGateaway.serverKey;
    // final password = selectedGateaway.clientKey;
    // final basicAuth =
    //     'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    // final header = {
    //   "Content-Type": "application/json",
    //   "Accept": "application/json",
    //   "Authorization": basicAuth,
    //   // Above is API server key for the Midtrans account, encoded to base64
    // };
    // final orderId = Random().nextInt(23000).toInt();
    // final response = await http.post(url,
    //     headers: header,
    //     body: jsonEncode({
    //       "transaction_details": {
    //         "order_id": "$orderId",
    //         "gross_amount": amount.toInt()
    //       },
    //       "credit_card": {"secure": true},
    //       "customer_details": {
    //         "first_name": userData.name,
    //         "email": userData.email,
    //         "phone": shippingAddress.phone,
    //       }
    //     }));
    // print(response.statusCode);
    // if (response.statusCode == 201) {
    this.url =
        'https://sandbox.payfast.co.za/eng/process?merchant_id=${selectedGateaway.merchantId}&merchant_key=${selectedGateaway.merchantKey}&amount=$amount&item_name=GrenmartGroceries';
    //   return;
    // }

    // return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('successful'));
    return response.body.contains('successful');
  }
}
