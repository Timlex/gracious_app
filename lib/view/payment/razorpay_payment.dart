// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:http/http.dart' as http;

// import '../../service/cart_data_service.dart';
// import '../../service/checkout_service.dart';
// import '../../service/cupon_discount_service.dart';
// import '../../service/payment_gateaway_service.dart';
// import '../../service/shipping_addresses_service.dart';
// import '../../service/shipping_zone_service.dart';
// import '../../service/user_profile_service.dart';
// import '../utils/constant_styles.dart';

// class RazorpayPayment {
//   final _razorpay = Razorpay();
//   late BuildContext context;

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     // Do something when payment succeeds
//     print(response);
//     verifySignature(
//       signature: response.signature,
//       paymentId: response.paymentId,
//       orderId: response.orderId,
//     );
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     print(response);
//     // Do something when payment fails
//     snackBar(context, 'Payment failed');
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print(response);
//     // Do something when an external wallet is selected
//     snackBar(context, 'Payment via wallet');
//   }

// // create order
//   void createOrder(BuildContext context) async {
//     this.context = context;
//     final userData =
//         Provider.of<UserProfileService>(context, listen: false).userProfileData;
//     final cartData = Provider.of<CartDataService>(context, listen: false);
//     final shippingAddress =
//         Provider.of<ShippingAddressesService>(context, listen: false);
//     final shippingZone =
//         Provider.of<ShippingZoneService>(context, listen: false);
//     final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
//     final selectrdGateaway =
//         Provider.of<PaymentGateawayService>(context, listen: false)
//             .selectedGateaway!;
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//       _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//       _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//     });
//     String username = "rzp_test_qfnlVh6GDZoveL";
//     String password = "1BKI89076hFeXRsbGuSaj29C";
//     if (selectrdGateaway.apiKey == null || selectrdGateaway.apiSecret == null) {
//       snackBar(context, 'Invalid developer keys');
//       return;
//     }
//     // String username = selectrdGateaway.apiKey;
//     // String password = selectrdGateaway.apiSecret;
//     String basicAuth =
//         'Basic ${base64Encode(utf8.encode('$username:$password'))}';

//     Map<String, dynamic> body = {
//       "amount": ((shippingZone.taxMoney(context) +
//                   shippingZone.shippingCost +
//                   cartData.calculateSubtotal() -
//                   cuponData.cuponDiscount) *
//               100)
//           .toInt()
//           .toString(),
//       "currency": "USD",
//       "receipt": "rcptid_11"
//     };
//     var res = await http.post(
//       Uri.https(
//           "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
//       headers: <String, String>{
//         "Content-Type": "application/json",
//         'authorization': basicAuth,
//       },
//       body: jsonEncode(body),
//     );
//     print(res.body);
//     if (res.statusCode == 200) {
//       final checkoutInfo = Provider.of<CheckoutService>(context, listen: false);
//       final orderId = checkoutInfo.checkoutModel.id;
//       openGateway(
//           jsonDecode(res.body)['id'],
//           ((shippingZone.taxMoney(context) +
//                       shippingZone.shippingCost +
//                       cartData.calculateSubtotal() -
//                       cuponData.cuponDiscount) *
//                   100)
//               .toInt()
//               .toString());
//     }
//     print(res.statusCode);
//   }

//   openGateway(String orderId, String amount) {
//     print(amount);
//     final userData =
//         Provider.of<UserProfileService>(context, listen: false).userProfileData;
//     var options = {
//       // 'key': Provider.of<PaymentGateawayService>(context, listen: false)
//       //     .selectedGateaway!
//       //     .apiKey,
//       'key': "rzp_test_qfnlVh6GDZoveL",
//       'amount': amount, //in the smallest currency sub-unit.
//       'name': userData.name,
//       "currency": "USD",
//       'order_id': orderId, // Generate order_id using Orders API
//       // 'description': 'Fine T-Shirt',
//       'timeout': 60 * 5, // in seconds // 5 minutes
//       'prefill': {
//         'contact': userData.phone,
//         'email': userData.email,
//       }
//     };
//     _razorpay.open(options);
//   }

//   verifySignature({
//     String? signature,
//     String? paymentId,
//     String? orderId,
//   }) async {
//     Map<String, dynamic> body = {
//       'razorpay_signature': signature,
//       'razorpay_payment_id': "rzp_test_qfnlVh6GDZoveL",
//       'razorpay_order_id': orderId,
//     };

//     var parts = [];
//     body.forEach((key, value) {
//       parts.add('${Uri.encodeQueryComponent(key)}='
//           '${Uri.encodeQueryComponent(value)}');
//     });
//     var formData = parts.join('&');
//     var res = await http.post(
//       Uri.https(
//         "10.0.2.2", // my ip address , localhost
//         "rzp_test_qfnlVh6GDZoveL",
//       ),
//       headers: {
//         "Content-Type": "application/x-www-form-urlencoded", // urlencoded
//       },
//       body: formData,
//     );

//     print(res.body);
//     if (res.statusCode == 200) {
//       snackBar(context, 'Payment Successfull');
//     }
//   }
// }

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
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
import '../../service/checkout_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/user_profile_service.dart';

class RazorpayPayment extends StatelessWidget {
  RazorpayPayment({Key? key}) : super(key: key);
  String? url;
  String? paynentID;
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
            // if (snapshot.hasError) {
            //   print(snapshot.error);
            //   return const Center(
            //     child: Text('Loding failed.'),
            //   );
            // }
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
                    Navigator.of(context).pop();
                    return;
                  }
                  // await showDialog(
                  //     context: context,
                  //     builder: (ctx) {
                  //       return AlertDialog(
                  //         title: Text('Payment failed!'),
                  //         content: Text('Payment has been cancelled.'),
                  //         actions: [
                  //           Spacer(),
                  //           TextButton(
                  //             onPressed: () => Navigator.of(context).pop(),
                  //             child: Text(
                  //               'Ok',
                  //               style: TextStyle(color: cc.primaryColor),
                  //             ),
                  //           )
                  //         ],
                  //       );
                  //     });
                  // Navigator.of(context).pop();
                }
                // },
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

  Future<void> waitForIt(BuildContext context) async {
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
    // if (selectedGateaway.merchantId == null ||
    //     selectedGateaway.merchantKey == null) {
    //   snackBar(context, 'Invalid developer keys');
    // }
    final uri = Uri.parse('https://api.razorpay.com/v1/payment_links');
    String username = "rzp_test_qfnlVh6GDZoveL";
    String password = "1BKI89076hFeXRsbGuSaj29C";
    // final username = selectedGateaway.serverKey;
    // final password = selectedGateaway.clientKey;
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": basicAuth,
      // Above is API server key for the Midtrans account, encoded to base64
    };
    final checkoutInfo = Provider.of<CheckoutService>(context, listen: false);
    final orderId = checkoutInfo.checkoutModel.id;
    print(orderId);
    // final orderId = Random().nextInt(23000).toInt();
    final response = await http.post(uri,
        headers: header,
        body: jsonEncode({
          "amount": amount,
          "currency": "USD",
          "accept_partial": false,
          "reference_id": orderId.toString(),
          "description": "Grenmart Payment",
          "customer": {
            "name": userData.name,
            "contact": userData.phone,
            "email": userData.email
          },
          // "notify": {"sms": true, "email": true},
          "notes": {"policy_name": "Grenmart"},
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      this.url = jsonDecode(response.body)['short_url'];
      this.paynentID = jsonDecode(response.body)['id'];
      print(url);
      return;
    }
    snackBar(context, 'Connection failed');
    // print(response.statusCode);
    // if (response.statusCode == 201) {
    // this.url =
    //     'https://sandbox.payfast.co.za/eng/process?merchant_id=${selectedGateaway.merchantId}&merchant_key=${selectedGateaway.merchantKey}&amount=$amount&item_name=GrenmartGroceries';
    // //   return;
    // // }

    // return true;
  }

  Future<bool> verifyPayment(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.body.contains('Payment Completed'));
    return response.body.contains('Payment Completed');
  }
}
