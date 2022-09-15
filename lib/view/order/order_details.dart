import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view/home/home_front.dart';
import '../../service/order_details_service.dart';
import '../../view/utils/constant_name.dart';
import '../../view/utils/text_themes.dart';
import '../../service/language_service.dart';
import '../../view/order/order_details_tile.dart';
import '../utils/app_bars.dart';
import '../utils/constant_styles.dart';

class OrderDetails extends StatelessWidget {
  final String tracker;
  bool? goHome;
  OrderDetails(this.tracker, {this.goHome = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final tracker =
    // (ModalRoute.of(context)!.settings.arguments! as List)[0] as String;
    return Scaffold(
      appBar: AppBars().appBarTitled(tracker, () {
        if (goHome!) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeFront()),
              (Route<dynamic> route) => false);
          return;
        }
        Navigator.of(context).pop();
      }),
      body: WillPopScope(
        onWillPop: () async {
          if (goHome!) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeFront()),
                (Route<dynamic> route) => false);
            return true;
          }
          Navigator.of(context).pop();
          return true;
        },
        child: FutureBuilder(
            future: Provider.of<OrderDetailsService>(context, listen: false)
                .fetchOrderDetails(tracker),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return loadingProgressBar();
              }
              if (!snapShot.hasData) {
                return const Center(
                  child: Text('Failed to load data.'),
                );
              }
              return Consumer<OrderDetailsService>(
                  builder: (context, odService, child) {
                final titleTextTheme =
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: LanguageService().rtl ? 0 : 20,
                          right: LanguageService().rtl ? 20 : 0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            // padding: const EdgeInsets.all(10),
                            child: Text(
                              'Image',
                              style: titleTextTheme,
                            ),
                          ),
                          Container(
                            width: screenWidth / 3,
                            padding: EdgeInsets.only(
                                left: LanguageService().rtl ? 0 : 15,
                                right: LanguageService().rtl ? 15 : 0),
                            child: Text(
                              'Name',
                              style: titleTextTheme,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 70,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Quantity',
                              style: titleTextTheme,
                            ),
                          ),
                          // const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(10),
                            // alignment: Alignment.center,
                            child: Text(
                              'Price',
                              style: titleTextTheme,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // if (odService.orderDetailsModel.product.length != 0)
                    odService.orderDetailsModel.product.isEmpty
                        ? Expanded(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text('Loading failed')],
                          ))
                        : Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              padding: const EdgeInsets.only(top: 10),
                              itemCount:
                                  odService.orderDetailsModel.product.length,
                              itemBuilder: (context, index) {
                                if ((odService
                                        .orderDetailsModel.product.length) <
                                    index + 1) {
                                  return SizedBox();
                                }
                                print(index);
                                print(
                                    odService.orderDetailsModel.product.length);
                                final productItem =
                                    odService.orderDetailsModel.product[index];
                                final e = odService.orderDetailsModel.orderInfo
                                        .orderDetails[
                                    productItem.id.toString()]![0];
                                final price = e.attributes['price'];
                                e.attributes.remove('price');
                                e.attributes.remove('price');
                                e.attributes.remove('type');
                                return OrderDetailsTile(
                                  productItem.title,
                                  productItem.price.toDouble(),
                                  e.quantity,
                                  productItem.image,
                                  e.attributes.toString() == '{}'
                                      ? ''
                                      : ' (' + e.attributes.toString() + ') ',
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                            ),
                          ),
                    Container(
                      // height: 200,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: cc.whiteGrey,
                      ),
                      child: Column(children: [
                        rows('Subtotal',
                            trailing:
                                '\$${odService.orderDetailsModel.orderInfo.paymentMeta!.subtotal}'),
                        const SizedBox(height: 15),
                        rows('Shipping',
                            trailing:
                                '\$${odService.orderDetailsModel.orderInfo.paymentMeta!.shippingCost}'),
                        const SizedBox(height: 15),
                        rows('Tax',
                            trailing:
                                '\$${odService.orderDetailsModel.orderInfo.paymentMeta!.taxAmount}'),
                        const SizedBox(height: 15),
                        rows('Discount',
                            trailing:
                                '-\$${odService.orderDetailsModel.orderInfo.paymentMeta!.couponAmount}'),
                        const SizedBox(height: 15),
                        const Divider(),
                        const SizedBox(height: 25),
                        rows('Total',
                            trailing:
                                '\$${odService.orderDetailsModel.orderInfo.paymentMeta!.total}'),
                        const SizedBox(height: 15),
                        rows('Payment status',
                            trailing: (odService.orderDetailsModel.orderInfo
                                    .paymentStatus as String)
                                .capitalize()),
                      ]),
                    ),
                  ],
                );
              });
            }),
      ),
    );
  }

  Widget rows(String leading, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          leading,
          style: TextThemeConstrants.paragraphText,
        ),
        if (trailing != null)
          Text(
            trailing,
            style: TextStyle(
                color: cc.greyParagraph,
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
