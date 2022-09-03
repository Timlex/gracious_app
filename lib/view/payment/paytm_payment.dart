import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:provider/provider.dart';
import '../../service/payment_gateaway_service.dart';

class PaytTmPayment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PaytTmPaymentState();
  }
}

class _PaytTmPaymentState extends State<PaytTmPayment> {
  String mid = "sdfas",
      orderId = "55654",
      amount = "999",
      txnToken = "lskfiuhfiw4sahfhef84hfiuh98erthei";
  String result = "sfsf";
  bool isStaging = false;
  bool isApiCallInprogress = false;
  String callbackUrl = "xgenious.com";
  bool restrictAppInvoke = false;
  bool enableAssist = true;
  @override
  void initState() {
    print("initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedMethod =
        Provider.of<PaymentGateawayService>(context, listen: false)
            .selectedGateaway;
    mid = selectedMethod!.merchantMid.toString();
    return Card(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              // EditText('Merchant ID', mid, onChange: (val) => mid = val),
              // EditText('Order ID', orderId, onChange: (val) => orderId = val),
              // EditText('Amount', amount, onChange: (val) => amount = val),
              // EditText('Transaction Token', txnToken,
              //     onChange: (val) => txnToken = val),
              // EditText('CallBack URL', callbackUrl, onChange: (val) => callbackUrl = val),
              Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: Theme.of(context).buttonColor,
                      value: isStaging,
                      onChanged: (bool? val) {
                        setState(() {
                          isStaging = val!;
                        });
                      }),
                  Text("Staging")
                ],
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                      activeColor: Theme.of(context).buttonColor,
                      value: restrictAppInvoke,
                      onChanged: (bool? val) {
                        setState(() {
                          restrictAppInvoke = val!;
                        });
                      }),
                  Text("Restrict AppInvoke")
                ],
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: isApiCallInprogress
                      ? null
                      : () {
                          _startTransaction();
                        },
                  child: Text('Start Transcation'),
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: Text("Message : "),
              ),
              Container(
                child: Text(result),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startTransaction() async {
    if (txnToken.isEmpty) {
      print('txnToken is Empty');
      return;
    }
    var sendMap = <String, dynamic>{
      "mid": mid,
      "orderId": orderId,
      "amount": amount,
      "txnToken": txnToken,
      "callbackUrl": callbackUrl,
      "isStaging": isStaging,
      "restrictAppInvoke": restrictAppInvoke,
      "enableAssist": enableAssist
    };
    print(sendMap);
    try {
      var response = AllInOneSdk.startTransaction(mid, orderId, amount,
          txnToken, callbackUrl, isStaging, restrictAppInvoke, enableAssist);
      response.then((value) {
        print(value);
        setState(() {
          result = value.toString();
        });
      }).catchError((onError) {
        if (onError is PlatformException) {
          setState(() {
            result = onError.message.toString() +
                " \n  " +
                onError.details.toString();
          });
        } else {
          setState(() {
            result = onError.toString();
          });
        }
      });
    } catch (err) {
      result = err.toString();
    }
  }
}
