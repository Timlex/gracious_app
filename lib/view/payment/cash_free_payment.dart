import 'dart:convert';
import 'dart:math';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../service/cart_data_service.dart';
import '../../service/checkout_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/payment_gateaway_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/user_profile_service.dart';
import '../utils/constant_styles.dart';

class CashFreePayment {
  late BuildContext context;

  Future doPayment(BuildContext context) async {
    this.context = context;
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
    final amount = (shippingZone.taxMoney(context) +
            shippingZone.shippingCost +
            cartData.calculateSubtotal() -
            cuponData.cuponDiscount)
        .toInt()
        .toString();

    if (selectrdGateaway.appId == null || selectrdGateaway.secretKey == null) {
      snackBar(context, 'Invalid developer keys');
      return;
    }

    final url = Uri.parse("https://test.cashfree.com/api/v2/cftoken/order");
    final checkoutInfo = Provider.of<CheckoutService>(context, listen: false);
    final orderId = checkoutInfo.checkoutModel.id;

    final response = await http.post(url,
        headers: {
          // "x-client-id": "223117f0ebd2772a15e84c769e711322",
          // "x-client-secret": "TEST75a084e42a1f6123c576b69de6042430f95219d7",
          "x-client-id": selectrdGateaway.appId as String,
          "x-client-secret": selectrdGateaway.secretKey as String,
        },
        body: jsonEncode({
          "orderId": "${orderId}",
          "orderAmount": amount,
          "orderCurrency": "INR"
        }));
    print(jsonDecode(response.body)['cftoken']);
    if (200 == 200) {
      print(amount);
      Map<String, dynamic> inputParams = {
        "orderId": "${orderId}",
        "orderAmount": amount,
        "customerName": userData.name,
        "orderCurrency": "INR",
        "appId": selectrdGateaway.appId as String,
        "customerPhone": shippingAddress.selectedAddress!.phone,
        "customerEmail": userData.email,
        "stage": "TEST",
        // "color1": "#00B106",
        // "color2": "#ffffff",
        "tokenData": jsonDecode(response.body)['cftoken'],
        // "tokenData":
        //     "c39JCN4MzUIJiOicGbhJCLiQ1VKJiOiAXe0Jye.D49JyMmdzNxQmZmRzYwMjNiojI0xWYz9lIsMTOyMDNzQjN2EjOiAHelJCLiQ0UVJiOik3YuVmcyV3QyVGZy9mIsISNyUjI6ICduV3btFkclRmcvJCLiEDN2YjNiojIklkclRmcvJye.CW3ctYcUTPPE_oIuBaOZZ0hyxQ0_6FrEJdCTDKaqHQeEfHLCYimeq5GTIH6TBluSB2",
      };
      // print(inputParams);
      final result = await CashfreePGSDK.doPayment(inputParams);
      // print(result!['txMsg']);
    }
  }
}
