import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/home/home_front.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';

class PaymentStatusView extends StatefulWidget {
  static const routeName = 'pament status';
  bool isError;
  PaymentStatusView(this.isError, {Key? key}) : super(key: key);

  @override
  State<PaymentStatusView> createState() => _PaymentStatusViewState();
}

class _PaymentStatusViewState extends State<PaymentStatusView> {
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars().appBarTitled('', () => Navigator.of(context).pop(),
          hasButton: true, hasElevation: false),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(17.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Image.asset(widget.isError
                          ? 'assets/images/payment_error.png'
                          : 'assets/images/payment_success.png'),
                    ),
                    const SizedBox(height: 45),
                    Text(
                      widget.isError ? 'Opps!' : 'Payment successful!',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: ConstantColors().titleTexts,
                      ),
                    ),
                    const SizedBox(height: 15),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: widget.isError
                            ? 'We\'re getting problems with your payment methods and we couldn\'t proceed your order '
                            : 'Your order has been successful! You\'ll receive ordered items in 3-5 days. Your order ID  is ',
                        style: TextStyle(
                          fontSize: 13,
                          color: ConstantColors().greyParagraph,
                        ),
                        children: widget.isError
                            ? null
                            : <TextSpan>[
                                TextSpan(
                                    text: ' #2385489',
                                    style: TextStyle(color: cc.primaryColor)),
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!widget.isError)
                  customBorderButton(
                    'Back to home',
                    () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeFront()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                customContainerButton(
                    widget.isError ? 'Back to home' : 'Track your order',
                    widget.isError
                        ? MediaQuery.of(context).size.width - 50
                        : 180, () {
                  setState(() {
                    widget.isError = !(widget.isError);
                  });
                }),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
