import 'dart:core';
import 'package:flutter/material.dart';
import 'package:gren_mart/service/cart_data_service.dart';
import 'package:gren_mart/service/cupon_discount_service.dart';
import 'package:gren_mart/service/shipping_addresses_service.dart';
import 'package:gren_mart/service/shipping_zone_service.dart';
import 'package:gren_mart/service/user_profile_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../service/paypal_service.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;

  const PaypalPayment({required this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var checkoutUrl;
  var executeUrl;
  var accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      // try {
      accessToken = await services.getAccessToken();

      final transactions = getOrderParams(context);
      final res = await services.createPaypalPayment(transactions, accessToken);
      setState(() {
        checkoutUrl = res["approvalUrl"];
        executeUrl = res["executeUrl"];
      });
      // } catch (e) {
      //   print('not coming here===============================');
      //   print('exception: ' + e.toString());
      //   final snackBar = SnackBar(
      //     content: Text(e.toString()),
      //     duration: const Duration(seconds: 10),
      //     action: SnackBarAction(
      //       label: 'Close',
      //       onPressed: () {
      //         // Some code to undo the change.
      //         Navigator.pop(context);
      //       },
      //     ),
      //   );
      //   // ignore: deprecated_member_use
      //   _scaffoldKey.currentState!.showSnackBar(snackBar);
      // }
    });
  }

  // item name, price and quantity
  String itemName = 'iPhone X';
  String itemPrice = '1.99';
  int quantity = 1;

  Map<String, dynamic> getOrderParams(BuildContext context) {
    final userData =
        Provider.of<UserProfileService>(context, listen: false).userProfileData;
    final cartData = Provider.of<CartDataService>(context, listen: false);
    final shippingAddress =
        Provider.of<ShippingAddressesService>(context, listen: false);
    final shippingZone =
        Provider.of<ShippingZoneService>(context, listen: false);
    final cuponData = Provider.of<CuponDiscountService>(context, listen: false);
    List items = [];
    cartData.cartList.forEach((key, value) {
      items.add({
        "name": value.title,
        "quantity": value.quantity,
        "price": value.discountPrice != 0 ? value.discountPrice : value.price,
        "currency": "USD",
      });
    });
    // print(items);
    // print((shippingZone.taxMoney(context) +
    //         shippingZone.shippingCost +
    //         cartData.calculateSubtotal() -
    //         cuponData.cuponDiscount)
    //     .toStringAsFixed(2));

    // checkout invoice details
    // String totalAmount = '1.99';
    // String subTotalAmount = '1.99';
    // String shippingCost = '0';
    // int shippingDiscountCost = 0;
    // String userFirstName = 'Gulshan';
    // String userLastName = 'Yadav';
    // String addressCity = 'Delhi';
    // String addressStreet = 'Mathura Road';
    // String addressZipCode = '110014';
    // String addressCountry = 'India';
    // String addressState = 'Delhi';
    // String addressPhoneNumber = '+919990119091';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": (shippingZone.taxMoney(context) +
                    shippingZone.shippingCost +
                    cartData.calculateSubtotal() -
                    cuponData.cuponDiscount)
                .toStringAsFixed(2),
            "currency": "USD",
            "details": {
              "subtotal": cartData.calculateSubtotal().toStringAsFixed(2),
              "shipping":
                  (shippingZone.shippingCost + shippingZone.taxMoney(context))
                      .toStringAsFixed(2),
              "shipping_discount": cuponData.cuponDiscount.toStringAsFixed(2),
            }
          },
          // "description": "The payment transaction description.",
          // "payment_options": {
          //   "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          // },
          // "item_list": {
          //   "items": items,
          // "shipping_address": {
          //   "recipient_name": shippingAddress.selectedAddress!.name,
          //   "line1": shippingAddress.selectedAddress!.address,
          //   "line2": "",
          //   "city": shippingAddress.selectedAddress!.city,
          //   "country_code": "BD",
          //   "postal_code": shippingAddress.selectedAddress!.zipCode,
          //   "phone": shippingAddress.selectedAddress!.phone,
          //   "state": shippingAddress.selectedAddress!.stateId.toString(),
          // },
        }
        // }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": "return.example.com",
        "cancel_url": "cancel.example.com"
      }
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print(checkoutUrl);

    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBars().appBarTitled('', () {
          Navigator.pop(context);
        }),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              print(payerID);
              if (payerID != null) {
                services
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  widget.onFinish(id);
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
              Navigator.of(context).pop();
            }
            if (request.url.contains(cancelURL)) {
              Navigator.of(context).pop();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBars().appBarTitled('', () {
          Navigator.pop(context);
        }),
        body: Center(child: Container(child: loadingProgressBar())),
      );
    }
  }
}
