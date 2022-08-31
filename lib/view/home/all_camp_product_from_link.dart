import 'package:flutter/material.dart';
import 'package:gren_mart/service/product_card_data_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:provider/provider.dart';

import '../utils/constant_name.dart';
import '../utils/constant_styles.dart';
import 'product_card.dart';

class ALLCampProductFromLink extends StatelessWidget {
  static const routeName = 'all product from link';
  const ALLCampProductFromLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeData =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    final id = routeData[0];
    double cardWidth = screenWidth / 3.3;
    double cardHeight = screenHight / 4.9 < 165 ? 130 : screenHight / 4.9;
    return Scaffold(
      appBar: AppBars().appBarTitled('', () {
        Navigator.of(context).pop();
      }),
      body: FutureBuilder(
        future: Provider.of<ProductCardDataService>(context, listen: false)
            .fetchCapmaignPageProductData(id: id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingProgressBar();
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Loading failed!',
                style: TextStyle(color: cc.greyHint),
              ),
            );
          }
          if (snapshot.hasData) {
            return Center(
              child: Text(
                'Loading failed!',
                style: TextStyle(color: cc.greyHint),
              ),
            );
          }
          return Consumer<ProductCardDataService>(
              builder: (context, pcService, child) {
            return newMethod(
                cardWidth, cardHeight, pcService.campaignPageProductList);
          });
        },
      ),
    );
  }

  Widget newMethod(double cardWidth, double cardHeight, List<dynamic> data) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          // 'No data has been found!',
          'No product found',
          style: TextStyle(color: cc.greyHint),
        ),
      );
    } else {
      return GridView.builder(
        // controller: controller,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.only(left: 20, top: 15),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: cardWidth / cardHeight,
          crossAxisSpacing: 12,
          // mainAxisSpacing: 12
        ),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final e = data[index];
          // if (srData.resultMeta!.lastPage >= pageNo) {
          return ProductCard(e.prdId, e.title, e.price, e.discountPrice,
              e.campaignPercentage.toDouble(), e.imgUrl, e.isCartAble);
          // }
          // else {
          //   return const Center(
          //     child: Text('No more product fonund'),
          //   );
          // }
          // else if (srData.resultMeta!.lastPage > pageNo) {
          //   return const Center(
          //       child: Text('No more product available!'));
          // }
        },
      );
    }
  }
}