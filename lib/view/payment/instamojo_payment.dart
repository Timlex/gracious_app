import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';

import '../../service/cart_data_service.dart';
import '../../service/checkout_service.dart';
import '../../service/cupon_discount_service.dart';
import '../../service/payment_gateaway_service.dart';
import '../../service/shipping_addresses_service.dart';
import '../../service/shipping_zone_service.dart';
import '../../service/user_profile_service.dart';

class InstamojoPayment extends StatefulWidget {
  const InstamojoPayment({
    Key? key,
  }) : super(key: key);

  @override
  _InstamojoPaymentState createState() => _InstamojoPaymentState();
}

bool isLoading = true; //this can be declared outside the class

class _InstamojoPaymentState extends State<InstamojoPayment> {
  late String selectedUrl;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    createRequest(); //creating the HTTP request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              isLoading = true;
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.blueGrey,
        title: const Text("Pay"),
      ),
      body: WillPopScope(
        onWillPop: () {
          isLoading = true;
          return Future.value(true);
        },
        child: Container(
          child: Center(
            child: isLoading
                ? //check loadind status
                const CircularProgressIndicator() //if true
                : InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: Uri.tryParse(selectedUrl),
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {},
                    onProgressChanged:
                        (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                    onUpdateVisitedHistory: (_, Uri? uri, __) {
                      String url = uri.toString();
                      // print(uri);
                      // uri containts newly loaded url
                      if (mounted) {
                        if (url.contains('https://www.google.com/')) {
                          //Take the payment_id parameter of the url.
                          String? paymentRequestId =
                              uri?.queryParameters['payment_id'];
                          // print("value is: " +paymentRequestId);
                          //calling this method to check payment status
                          _checkPaymentStatus(paymentRequestId!);
                        }
                      }
                    },
                  ),
          ),
        ),
      ),
    );
  }

  _checkPaymentStatus(String id) async {
    // var header = {
    //       "Accept": "application/json",
    //       "Content-Type": "application/x-www-form-urlencoded",
    //       "X-Api-Key": "test_b678a7048c8a9e5f69663c2e4fa",
    //       "X-Auth-Token": "test_41af76995b230611b2c3b72b8cc"
    //     };
    final selectrdGateaway =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway!;
    var header = {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "X-Api-Key": selectrdGateaway.publicKey as String,
      "X-Auth-Token": selectrdGateaway.secretKey as String
    };

    var response = await http.get(
        Uri.parse("https://test.instamojo.com/api/1.1/payments/$id/"),
        headers: header);

    var realResponse = json.decode(response.body);
    print(realResponse);
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        print('instamojo payment successfull');

        // Provider.of<PlaceOrderService>(context, listen: false)
        //     .makePaymentSuccess(context);

//payment is successful.
      } else {
        print('failed');
//payment failed or pending.
      }
    } else {
      print("PAYMENT STATUS FAILED");
    }
  }

  Future createRequest() async {
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
        .toInt()
        .toString();
    final checkoutInfo = Provider.of<CheckoutService>(context, listen: false);
    final orderId = checkoutInfo.checkoutModel.id;
    Map<String, String> body = {
      "amount": amount, //amount to be paid
      "purpose": "Grenmart",
      "buyer_name": userData.name,
      "email": userData.email,
      "allow_repeated_payments": "true",
      "send_email": "true",
      "phone": '2135632145',
      "send_sms": "false",
      "redirect_url": "https://www.xgenious.com/",
      //Where to redirect after a successful payment.
      "webhook": "https://www.xgenious.com/",
    };
//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http.post(
        Uri.parse("https://test.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": "test_b678a7048c8a9e5f69663c2e4fa",
          "X-Auth-Token": "test_41af76995b230611b2c3b72b8cc"
        },
        body: body);
    print(jsonDecode(resp.body));
    if (jsonDecode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      setState(() {
        isLoading = false; //setting state to false after data loaded

        selectedUrl =
            json.decode(resp.body)["payment_request"]['longurl'].toString() +
                "?embed=form";
      });
      print(json.decode(resp.body)['message'].toString());
//If something is wrong with the data we provided to
//create the Payment_Request. For Example, the email is in incorrect format, the payment_Request creation will fail.
    }
  }
}
