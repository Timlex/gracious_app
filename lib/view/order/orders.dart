import 'package:flutter/material.dart';
import 'package:gren_mart/service/order_list_service.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import '../../view/auth/order_data.dart';
import '../../view/order/order_tile.dart';
import '../../view/utils/app_bars.dart';
import '../../view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatelessWidget {
  MyOrders({Key? key}) : super(key: key);
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderData>(context, listen: false).orderItem;
    return Scaffold(
      appBar: AppBars().appBarTitled('My orders', () {
        Navigator.of(context).pop();
      }),
      body: FutureBuilder(
          future: Provider.of<OrderListService>(context, listen: false)
              .fetchOrderList(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingProgressBar();
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Failed to load data.'),
              );
            }

            return Consumer<OrderListService>(
                builder: (context, oService, child) {
              if (oService.orderListModel.data.isEmpty) {
                return const Center(
                  child: Text('No order found.'),
                );
              }
              return ListView.separated(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: oService.orderListModel.data.length,
                itemBuilder: (context, index) {
                  final element = oService.orderListModel.data[index];
                  return OrderTile(
                    double.parse(element.totalAmount),
                    '#${element.orderId}',
                    element.createdAt,
                    element.status,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            });
          })),
    );
  }
}
