import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart ' as http;

import '../../service/cart_data_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/payment_gateaway_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/user_profile_service.dart';
import '../utils/constant_styles.dart';

class MercadoPagoPayment {
  String? token;
  late BuildContext context;
  // String publicKey = "TEST-0a3cc78a-57bf-4556-9dbe-2afa06347769";
  // String accessToken =
  //     "TEST-4644184554273630-070813-7d817e2ca1576e75884001d0755f8a7a-786499991";

  startCheckout(BuildContext context) async {
    this.context = context;
    //   final selectrdGateaway =
    //       Provider.of<PaymentGateawayService>(context, listen: false)
    //           .selectedGateaway!;
    //   if (selectrdGateaway.clientId == null ||
    //       selectrdGateaway.clientSecret == null) {
    //     snackBar(context, 'Invalid developer keys');
    //   }

    //   var result = await getToken(context);

    //   if (result == true) {
    //     print('mercado token is $token');
    //     var res = await MercadoPagoMobileCheckout.startCheckout(
    //       selectrdGateaway.clientId as String,
    //       token ?? '',
    //     );
    //     print(res);
    //     if (res.result == 'done') {
    //       // Provider.of<PlaceOrderService>(context, listen: false)
    //       //     .makePaymentSuccess(context);
    //     } else {
    //       print('payment failed');
    //       snackBar(context, 'Payment Failed');
    //     }
    //   } else {
    //     //token getting failed
    //   }
    // }

    // Future<bool> getToken(BuildContext context) async {
    //   final userData =
    //       Provider.of<UserProfileService>(context, listen: false).userProfileData;
    //   final cartData = Provider.of<CartDataService>(context, listen: false);
    //   final shippingAddress =
    //       Provider.of<ShippingAddressesService>(context, listen: false);
    //   final shippingZone =
    //       Provider.of<ShippingZoneService>(context, listen: false);
    //   final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
    //   final selectrdGateaway =
    //       Provider.of<PaymentGateawayService>(context, listen: false)
    //           .selectedGateaway!;
    //   final amount = (shippingZone.taxMoney(context) +
    //           shippingZone.shippingCost +
    //           cartData.calculateSubtotal() -
    //           cuponData.cuponDiscount)
    //       .toInt()
    //       .toString();

    //   // if (pProvider.isOnline == 0) {
    //   //   amount = double.parse(
    //   //       bcProvider.totalPriceAfterAllcalculation.toStringAsFixed(2));
    //   // } else {
    //   //   amount = double.parse(bcProvider
    //   //       .totalPriceOnlineServiceAfterAllCalculation
    //   //       .toStringAsFixed(2));
    //   // }
    //   var header = {
    //     //if header type is application/json then the data should be in jsonEncode method
    //     "Accept": "application/json",
    //     "Content-Type": "application/json"
    //   };

    //   var data = jsonEncode({
    //     "items": [
    //       {
    //         "title": "Grenmart",
    //         "description": "Qixer cart item",
    //         "quantity": 6,
    //         "currency_id": "ARS",
    //         "unit_price": 555
    //       }
    //     ],
    //     "payer": {"email": 'user@user.com'}
    //   });

    //   var response = await http.post(
    //       Uri.parse(
    //           'https://api.mercadopago.com/checkout/preferences?access_token=${selectrdGateaway.clientSecret}'),
    //       headers: header,
    //       body: data);

    //   print(response.body);
    //   if (response.statusCode == 201) {
    //     token = jsonDecode(response.body)['id'];

    //     return true;
    //   } else {
    //     print('token get failed');
    //     return false;
    //   }
  }
}
