import 'package:flutter/material.dart';
import 'package:gren_mart/service/search_result_data_service.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/view/home/product_card.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../utils/constant_colors.dart';

class SearchView extends StatelessWidget {
  static const routeName = 'search';
  SearchView();

//   @override
//   State<SearchView> createState() => _SearchViewState();
// }

// class _SearchViewState extends State<SearchView> {
  ConstantColors cc = ConstantColors();

  ScrollController controller = ScrollController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    double cardWidth = screenWidth / 3.3;
    double cardHeight = screenHight / 4.9;
    controller.addListener((() => scrollListener(context)));

    // final routeData =
    //     ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return
        // Scaffold(
        // appBar: AppBars().appBarTitled('Search', () {
        //   Navigator.of(context).pop();
        // }, hasButton: true, hasElevation: true, actions: [
        //   IconButton(
        //       onPressed: () {
        //         showMaterialModalBottomSheet(
        //           context: context,
        //           builder: (context) => SingleChildScrollView(
        //             controller: ModalScrollController.of(context),
        //             child: FilterBottomSheet(),
        //           ),
        //         );
        //       },
        //       icon: SvgPicture.asset('assets/images/icons/filter_setting.svg'))
        // ]),
        // body:
        Consumer<SearchResultDataService>(builder: (context, srData, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: CustomTextField(
              'Search your need here',
              initialValue: srData.searchText,
              leadingImage: 'assets/images/icons/search_normal.png',
              onChanged: (value) {
                srData.setSearchText(value);
              },
              onFieldSubmitted: (value) {
                Provider.of<SearchResultDataService>(context, listen: false)
                    .resetSerch();
                Provider.of<SearchResultDataService>(context, listen: false)
                    .fetchProductsBy(pageNo: '1');
              },
            ),
          ),
          // const SizedBox(height: 15),
          // const Padding(
          //   padding: EdgeInsets.only(right: 20, left: 20),
          //   child: Text(
          //     'Filter by:',
          //     style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          //   ),
          // ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 20, left: 20),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceAround,
          //       children: [
          //         FilterOption('ALl Categories', selectedCategorie, categories),
          //         FilterOption('ALl Units', selectedUnit, units),
          //         FilterOption('Price Range', selectedPriceRange, priceRange),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: 15),
          Expanded(
            child: srData.resultMeta != null
                ? newMethod(cardWidth, cardHeight, srData)
                : FutureBuilder(
                    future: showTimout(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
          if (srData.isLoading) loadingProgressBar(),
          // if (srData.resultMeta!.lastPage < pageNo)
        ],
        // ),
      );
    });
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
