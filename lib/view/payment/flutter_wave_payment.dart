import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';

class FlutterWavePayment {
  void makePayment(BuildContext context, String email, String amount) async {
    try {
      Flutterwave flutterwave = Flutterwave.forUIPayment(
          context: context,
          encryptionKey: "FLWSECK_TEST4734027149f5",
          publicKey: "FLWPUBK_TEST-e8d4cd5462fb381c4163ba7f7f746a98-X",
          currency: "NGN",
          amount: amount,
          email: "fake@gmail.com",
          fullName: "Destiny Ed",
          txRef: "_ref!44152654",
          isDebugMode: true,
          phoneNumber: "0123456789",
          acceptCardPayment: true,
          acceptUSSDPayment: true,
          acceptAccountPayment: true,
          acceptFrancophoneMobileMoney: false,
          acceptGhanaPayment: false,
          acceptMpesaPayment: true,
          acceptRwandaMoneyPayment: false,
          acceptUgandaPayment: false,
          acceptZambiaPayment: false);

      final response = await flutterwave.initializeForUiPayments();

      if (response == null) {
        print("Transaction Failed");
      } else {
        ///
        if (response.status == "success") {
          print(response.data);
          print(response.message);
        } else {
          print(response.message);
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
