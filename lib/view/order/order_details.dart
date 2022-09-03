import 'package:flutter/material.dart';
import 'package:gren_mart/service/order_details_service.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/text_themes.dart';
import '../../view/order/order_details_tile.dart';
import 'package:provider/provider.dart';

import '../utils/app_bars.dart';
import '../utils/constant_styles.dart';

class OrderDetails extends StatelessWidget {
  final String tracker;
  const OrderDetails(this.tracker, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final tracker =
    // (ModalRoute.of(context)!.settings.arguments! as List)[0] as String;
    return Scaffold(
      appBar: AppBars().appBarTitled(tracker, () {
        Navigator.of(context).pop();
      }),
      body: FutureBuilder(
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
                    padding: const EdgeInsets.only(left: 20),
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
                          width: screenWidth / 2.5,
                          padding: const EdgeInsets.only(left: 15),
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
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.only(top: 10),
                      itemCount: odService
                          .orderDetailsModel.orderInfo.orderDetails.length,
                      itemBuilder: (context, index) {
                        final productItem =
                            odService.orderDetailsModel.product[index];
                        final e = odService
                            .orderDetailsModel.orderInfo.orderDetails.values
                            .toList()[0][index];
                        return OrderDetailsTile(
                          productItem.title,
                          e.attributes.price.toDouble(),
                          e.quantity,
                          productItem.image,
                          ' (' +
                              (e.attributes.size == null
                                  ? ''
                                  : 'Size: ${e.attributes.size!.capitalize()}. ') +
                              (e.attributes.colorName == null
                                  ? ''
                                  : 'Color: ${e.attributes.colorName!.capitalize()}. ') +
                              (e.attributes.sauce == null
                                  ? ''
                                  : 'Sauce: ${e.attributes.sauce!.capitalize()}. ') +
                              (e.attributes.mayo == null
                                  ? ''
                                  : 'Mayo: ${e.attributes.mayo!.capitalize()}. ') +
                              (e.attributes.cheese == null
                                  ? ''
                                  : 'Cheese: ${e.attributes.cheese!.capitalize()}.'
                                      '') +
                              (e.attributes.type == null
                                  ? ''
                                  : 'Type: ${e.attributes.type!.capitalize()}.'
                                      '') +
                              ') ',
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
                          trailing: '\$${{
                            odService
                                .orderDetailsModel.orderInfo.paymentMeta!.total
                          }}'),
                    ]),
                  ),
                ],
              );
            });
          }),
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
