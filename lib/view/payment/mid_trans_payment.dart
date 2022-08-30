// import 'package:gren_mart/view/utils/constant_styles.dart';
// import 'package:midtrans_sdk/midtrans_sdk.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:dotenv/dotenv.dart';

// import '../../service/cart_data_service.dart';
// import '../../service/cupon_discount_service.dart';
// import '../../service/payment_gateaway_service.dart';
// import '../../service/shipping_addresses_service.dart';
// import '../../service/shipping_zone_service.dart';
// import '../../service/user_profile_service.dart';

// class MidTransPayment {
//   late BuildContext context;
//   MidtransSDK? _midtransSdk;
//   final env = DotEnv(includePlatformEnvironment: true)..load();

//   Future startPayment(BuildContext context) async {
//     await initSDK();
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
//     final amount = (shippingZone.taxMoney(context) +
//             shippingZone.shippingCost +
//             cartData.calculateSubtotal() -
//             cuponData.cuponDiscount)
//         .toInt()
//         .toString();

//     _midtransSdk?.startPaymentUiFlow(
//       token: env['SNAP_TOKEN'],
//     );
//   }

//   Future<void> initSDK() async {
//     print('SB-Mid-client-iDuy-jKdZHkLjL_I');
//     _midtransSdk = await MidtransSDK.init(
//       config: MidtransConfig(
//         clientKey: 'SB-Mid-client-iDuy-jKdZHkLjL_I',
//         merchantBaseUrl: 'https://www.youtube.com/watch?v=YNRvx96ACz8&t=742s',
//         colorTheme: ColorTheme(
//           colorPrimary: cc.primaryColor,
//         ),
//       ),
//     );
//     print('came here- ----------------------');
//     _midtransSdk?.setUIKitCustomSetting(
//       skipCustomerDetailsPages: true,
//     );
//     _midtransSdk!.setTransactionFinishedCallback((result) {
//       print(result.toJson());
//     });
//   }
// }

// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:flutter/services.dart';
// import 'package:flutter_midtrans_payment/flutter_midtrans_payment.dart';

// class MidTransPayment extends StatefulWidget {
//   @override
//   _MidTransPaymentState createState() => _MidTransPaymentState();
// }

// class _MidTransPaymentState extends State<MidTransPayment> {
//   String _platformVersion = 'Unknown';

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     log("mulai");
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       platformVersion = await FlutterMidtransPayment.platformVersion;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Text('Running on: $_platformVersion\n'),
//               ElevatedButton(
//                   child: Text('Pay'),
//                   onPressed: () async {
//                     var midtransPayParam = MidtransPayParam();
//                     midtransPayParam.clientKey = "=";
//                     midtransPayParam.merchantBaseUrl = "";
//                     midtransPayParam.totalPrice = 0;
//                     midtransPayParam.orderId = "";
//                     midtransPayParam.selectedPaymentMethod =
//                         MidtransPaymentMethod.SHOPEEPAY.index;
//                     var result =
//                         await FlutterMidtransPayment.pay(midtransPayParam);
//                     log(result);
//                   }),
//               ElevatedButton(
//                   child: Text('Pay with token2'),
//                   onPressed: () async {
//                     log("start");
//                     var midtransPayParam = MidtransPayWithTokenParam();
//                     midtransPayParam.clientKey =
//                         "SB-Mid-client-iDuy-jKdZHkLjL_I";
//                     midtransPayParam.merchantBaseUrl =
//                         "https://kesan-api.bangun-kreatif.com";
//                     midtransPayParam.snapToken =
//                         "3143c741-3e24-4251-96e5-e5391cd19280";
//                     try {
//                       var result = await FlutterMidtransPayment.payWithToken(
//                           midtransPayParam);
//                       log('result');
//                       log(result.toString());
//                     } catch (err) {
//                       log(err.toString());
//                     }
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
