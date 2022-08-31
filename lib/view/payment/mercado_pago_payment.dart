import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart ' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../service/cart_data_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/payment_gateaway_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/user_profile_service.dart';
import '../utils/app_bars.dart';
import '../utils/constant_styles.dart';

class MercadopagoPayment extends StatelessWidget {
  MercadopagoPayment({Key? key}) : super(key: key);
  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled('', () {
        Navigator.of(context).pop();
      }),
      body: FutureBuilder(
          future: getPaymentUrl(context),
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

  Future<dynamic> getPaymentUrl(BuildContext context) async {
    final userData =
        Provider.of<UserProfileService>(context, listen: false).userProfileData;
    final cartData = Provider.of<CartDataService>(context, listen: false);
    final shippingAddress =
        Provider.of<ShippingAddressesService>(context, listen: false);
    final shippingZone =
        Provider.of<ShippingZoneService>(context, listen: false);
    final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
    final amount = (shippingZone.taxMoney(context) +
            shippingZone.shippingCost +
            cartData.calculateSubtotal() -
            cuponData.cuponDiscount)
        .toInt();
    final selectrdGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    if (selectrdGateaway.clientId == null ||
        selectrdGateaway.clientSecret == null) {
      snackBar(context, 'Invalid developer keys');
    }
    var header = {
      "Accept": "application/json",
      "Content-Type": "application/json"
    };

    var data = jsonEncode({
      "items": [
        {
          "title": "Grenmart",
          "description": "Grenmart cart item",
          "quantity": 1,
          "currency_id": "ARS",
          "unit_price": amount
        }
      ],
      "payer": {"email": 'user@user.com'}
    });

    var response = await http.post(
        Uri.parse(
            'https://api.mercadopago.com/checkout/preferences?access_token=${selectrdGateaway.clientSecret}'),
        headers: header,
        body: data);

    // print(response.body);
    if (response.statusCode == 201) {
      this.url = jsonDecode(response.body)['init_point'];

      return;
    }
    return '';
  }
}


// class MercadoPagoService {
//   // String publicKey = "TEST-0a3cc78a-57bf-4556-9dbe-2afa06347769";
//   // String accessToken =
//   //     "TEST-4644184554273630-070813-7d817e2ca1576e75884001d0755f8a7a-786499991";

//   // startCheckout(BuildContext context) async {
//   //   final userData =
//   //       Provider.of<UserProfileService>(context, listen: false).userProfileData;
//   //   final cartData = Provider.of<CartDataService>(context, listen: false);
//   //   final shippingAddress =
//   //       Provider.of<ShippingAddressesService>(context, listen: false);
//   //   final shippingZone =
//   //       Provider.of<ShippingZoneService>(context, listen: false);
//   //   final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
//   //   final amount = (shippingZone.taxMoney(context) +
//   //           shippingZone.shippingCost +
//   //           cartData.calculateSubtotal() -
//   //           cuponData.cuponDiscount)
//   //       .toInt();
//   //   final selectrdGateaway =
//   //       Provider.of<PaymentGateawayService>(context, listen: false)
//   //           .selectedGateaway!;
//   //   if (selectrdGateaway.clientId == null ||
//   //       selectrdGateaway.clientSecret == null) {
//   //     snackBar(context, 'Invalid developer keys');
//   //   }

//   //   // if (pProvider.isOnline == 0) {
//   //   //   amount = double.parse(
//   //   //       bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2));
//   //   // } else {
//   //   //   amount = double.parse(bcProvider
//   //   //       .totalPriceOnlineServiceAfterAllCalculation
//   //   //       .toStringAsFixed(2));
//   //   // }
//   //   var header = {
//   //     //if header type is application/json then the data should be in jsonEncode method
//   //     "Accept": "application/json",
//   //     "Content-Type": "application/json"
//   //   };

//   //   var data = jsonEncode({
//   //     "items": [
//   //       {
//   //         "title": "Grenmart",
//   //         "description": "Grenmart cart item",
//   //         "quantity": 1,
//   //         "currency_id": "ARS",
//   //         "unit_price": amount
//   //       }
//   //     ],
//   //     "payer": {"email": 'user@user.com'}
//   //   });

//   //   var response = await http.post(
//   //       Uri.parse(
//   //           'https://api.mercadopago.com/checkout/preferences?access_token=${selectrdGateaway.clientSecret}'),
//   //       headers: header,
//   //       body: data);

//   //   // print(response.body);
//   //   if (response.statusCode == 201) {
//   //     final url = jsonDecode(response.body)['init_point'];

//   //     return;
//   //   }
//     // var result = await getToken(context);
//     // print(url);
//     // if (result == null) {
//     //   return;
//     // }
//     // return '';

//     // if (result == true) {
//     //   print('mercado token is $token');
//     //   var res = await MercadoPagoMobileCheckout.startCheckout(
//     //     selectrdGateaway.clientId as String,
//     //     token ?? '',
//     //   );
//     //   print(res);
//     //   if (res.result == 'done') {
//     //     // Provider.of<PlaceOrderService>(context, listen: false)
//     //     //     .makePaymentSuccess(context);
//     //   } else {
//     //     print('payment failed');
//     //     snackBar(context, 'Payment Failed');
//     //   }
//     // } else {
//     //   //token getting failed
//     // }
//   }

//   // Future getToken(BuildContext context) async {
//   //   final userData =
//   //       Provider.of<UserProfileService>(context, listen: false).userProfileData;
//   //   final cartData = Provider.of<CartDataService>(context, listen: false);
//   //   final shippingAddress =
//   //       Provider.of<ShippingAddressesService>(context, listen: false);
//   //   final shippingZone =
//   //       Provider.of<ShippingZoneService>(context, listen: false);
//   //   final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
//   //   final selectrdGateaway =
//   //       Provider.of<PaymentGateawayService>(context, listen: false)
//   //           .selectedGateaway!;
//   //   final amount = (shippingZone.taxMoney(context) +
//   //           shippingZone.shippingCost +
//   //           cartData.calculateSubtotal() -
//   //           cuponData.cuponDiscount)
//   //       .toInt();

//   //   // if (pProvider.isOnline == 0) {
//   //   //   amount = double.parse(
//   //   //       bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2));
//   //   // } else {
//   //   //   amount = double.parse(bcProvider
//   //   //       .totalPriceOnlineServiceAfterAllCalculation
//   //   //       .toStringAsFixed(2));
//   //   // }
//   //   var header = {
//   //     //if header type is application/json then the data should be in jsonEncode method
//   //     "Accept": "application/json",
//   //     "Content-Type": "application/json"
//   //   };

//   //   var data = jsonEncode({
//   //     "items": [
//   //       {
//   //         "title": "Grenmart",
//   //         "description": "Grenmart cart item",
//   //         "quantity": 1,
//   //         "currency_id": "ARS",
//   //         "unit_price": amount
//   //       }
//   //     ],
//   //     "payer": {"email": 'user@user.com'}
//   //   });

//   //   var response = await http.post(
//   //       Uri.parse(
//   //           'https://api.mercadopago.com/checkout/preferences?access_token=${selectrdGateaway.clientSecret}'),
//   //       headers: header,
//   //       body: data);

//   //   // print(response.body);
//   //   if (response.statusCode == 201) {
//   //     url = jsonDecode(response.body)['init_point'];

//   //     return;
//   //   } else {
//   //     print('token get failed');
//   //     return false;
//   //   }
//   // }
// }
