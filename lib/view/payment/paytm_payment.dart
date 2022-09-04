import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gren_mart/service/payment_gateaway_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

import '../../service/cart_data_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/user_profile_service.dart';

class PaytmPayment extends StatelessWidget {
  PaytmPayment(this.html, {Key? key}) : super(key: key);
  WebViewController? _controller;
  String? html;
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
              onWebViewCreated: (controller) {
                _controller = controller;
                controller.loadHtmlString(html as String);
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
    final userData =
        Provider.of<UserProfileService>(context, listen: false).userProfileData;
    final cartData = Provider.of<CartDataService>(context, listen: false);
    final shippingAddress =
        Provider.of<ShippingAddressesService>(context, listen: false);
    final shippingZone =
        Provider.of<ShippingZoneService>(context, listen: false);
    final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
    final selectrdGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    final shippingZoneData =
        Provider.of<ShippingZoneService>(context, listen: false);
    final amount = (shippingZone.taxMoney(context) +
        shippingZone.shippingCost +
        cartData.calculateSubtotal() -
        cuponData.cuponDiscount);
    // if (selectrdGateaway.serverKey == null ||
    //     selectrdGateaway.clientKey == null) {
    //   snackBar(context, 'Invalid developer keys');
    // }
    print('here');
    final url = Uri.parse(
        'https://zahid.xgenious.com/grenmart-api/api/v1/user/checkout-paytm');
    final selectedGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    final username = selectedGateaway.serverKey;
    final password = selectedGateaway.clientKey;
    final basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final header = {
      // "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": 'Bearer $globalUserToken',
      // Above is API server key for the Midtrans account, encoded to base64
    };
    List cartItemsId = [];
    Map cartItems = {};
    final orderId = Random().nextInt(23000).toInt();
    // final response = await http.post(url, headers: header, body:
    //     //   {
    //     //   "name": userData.name,
    //     //   "email": userData.email,
    //     //   "country": userData.country.toString(),
    //     //   "address": userData.address ?? "''",
    //     //   "city": userData.city ?? "",
    //     //   "state": userData.state.toString(),
    //     //   "zipcode": userData.zipcode.toString(),
    //     //   "phone": userData.phone.toString(),
    //     //   "shipping_address_id": "$orderId",
    //     //   "selected_payment_shipping_option":
    //     //       shippingZoneData.selectedOption!.id.toString(),
    //     //   "tax_amount": amount.toStringAsFixed(2),
    //     //   "coupon": cuponData.cuponDiscount > 0 ? cuponData.cuponText : "",
    //     //   "selected_payment_gateway": "",
    //     //   "bank_payment_input": "",
    //     //   "agree": "on",
    //     //   "sub_total": cartData.calculateSubtotal(),
    //     //   "products_ids": [],
    //     //   "all_cart_items": {},
    //     // }
    //     {
    //   "name": "Md Zahidul Islam",
    //   "email": "mdzahid.pro@gmail.com",
    //   "country": "24",
    //   "address": "Tongi Bazar Tongi",
    //   "city": "fasfafda",
    //   "state": "2",
    //   "zipcode": "12365",
    //   "phone": "214515544454",
    //   "shipping_address_id": "",
    //   "selected_payment_shipping_option": "8",
    //   "tax_amount": "12",
    //   "coupon": "zahid1234",
    //   "selected_payment_gateway": "8",
    //   "agree": "on",
    //   "sub_total": "14",
    //   "products_ids": "[105]",
    //   "all_cart_items": "{}",
    // });
    // print(response.statusCode);
    // if (response.statusCode == 200) {
    // //   html = response.body;
    //   return;
    // }

    return;
  }
}

Future<bool> verifyPayment(String url) async {
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  print(response.body.contains('successful'));
  return response.body.contains('successful');
}
