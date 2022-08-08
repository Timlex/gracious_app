import 'package:flutter/material.dart';
import 'package:gren_mart/service/search_result_data_service.dart';
import 'package:gren_mart/view/utils/app_bars.dart';
import 'package:provider/provider.dart';

import '../utils/constant_colors.dart';
import '../utils/constant_name.dart';
import '../utils/constant_styles.dart';
import 'product_card.dart';

class AllProducts extends StatelessWidget {
  AllProducts({Key? key}) : super(key: key);
  ConstantColors cc = ConstantColors();

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double cardWidth = screenWidth / 3.3;
    double cardHeight = screenHight / 4.9;
    controller.addListener((() => scrollListener(context)));
    return Scaffold(
      appBar: AppBars().appBarTitled('All Products', () {
        Navigator.of(context).pop();
      }),
      body:
          Consumer<SearchResultDataService>(builder: (context, srData, child) {
        return Column(
          children: [
            Expanded(
              child: srData.resultMeta != null
                  ? newMethod(cardWidth, cardHeight, srData)
                  : FutureBuilder(
                      future: showTimout(),
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loadingProgressBar();
                        }
                        snackBar(context, 'Timeout!');
                        return Center(
                          child: Text(
                            'Something went wrong!',
                            style: TextStyle(color: cc.greyHint),
                          ),
                        );
                      }),
                    ),
            ),
            if (srData.isLoading) loadingProgressBar()
          ],
        );
      }),
    );
  }

  Widget newMethod(
      double cardWidth, double cardHeight, SearchResultDataService srData) {
    if (srData.noProduct) {
      return Center(
        child: Text(
          'No data has been found!',
          style: TextStyle(color: cc.greyHint),
        ),
      );
    } else {
      return GridView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.only(left: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: cardWidth / cardHeight,
          crossAxisSpacing: 12,
          // mainAxisSpacing: 12
        ),
        itemCount: srData.searchResult.length,
        itemBuilder: (context, index) {
          final e = srData.searchResult[index];
          // if (srData.resultMeta!.lastPage >= pageNo) {
          return ProductCard(e.prdId, e.title, e.price, e.discountPrice,
              e.campaignPercentage, e.imgUrl, e.isCartAble);
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

  scrollListener(BuildContext context) {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      Provider.of<SearchResultDataService>(context, listen: false)
          .setIsLoading(true);

      Provider.of<SearchResultDataService>(context, listen: false)
          .fetchProductsBy(
              pageNo:
                  Provider.of<SearchResultDataService>(context, listen: false)
                      .pageNumber
                      .toString())
          .then((value) {
        if (value != null) {
          snackBar(context, value);
        }
      });
      Provider.of<SearchResultDataService>(context, listen: false).nextPage();
    }
  }

  Future<bool> showTimout() async {
    await Future.delayed(const Duration(seconds: 10));
    return true;
  }
}
