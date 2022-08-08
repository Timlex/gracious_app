import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/service/favorite_data_service.dart';
import 'package:gren_mart/view/details/animated_box.dart';
import 'package:gren_mart/view/details/plus_minus_cart.dart';
import 'package:gren_mart/view/intro/dot_indicator.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../model/product_data.dart';
import '../../service/product_card_data_service.dart';
import '../home/product_card.dart';
import '../intro/intro_helper.dart';
import '../utils/constant_name.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = 'product details screen';
  ProductDetails({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();
  int itemCount = 1;

  @override
  Widget build(BuildContext context) {
    final keyData = ModalRoute.of(context)!.settings.arguments as List;

    final key = keyData[0];
    final productData = Provider.of<Products>(context, listen: false);

    final product = productData.products.firstWhere((e) => e.id == key);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 1,
                  foregroundColor: cc.greyHint,
                  expandedHeight: screenWidth / 1.37,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return
                            // Hero(
                            //   tag: product.id,
                            //   child:
                            Image.asset(
                          product.image[index],
                          fit: BoxFit.cover,
                          // ),
                        );
                      },
                      itemCount: product.image.length,
                      pagination: SwiperCustomPagination(
                        builder:
                            (BuildContext context, SwiperPluginConfig config) {
                          return Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (int i = 0;
                                          i <= IntroHelper.introData.length;
                                          i++)
                                        (i == config.activeIndex
                                            ? DotIndicator(true)
                                            : DotIndicator(false))
                                    ]),
                              ));
                        },
                      ),
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: (() => Navigator.of(context).pop()),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/back_button.svg',
                            color: cc.blackColor,
                            height: 30,
                          ),
                        ]),
                  ),
                  actions: [
                    Consumer<FavoriteDataService>(
                        builder: (context, favoriteData, child) {
                      return Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: favoriteIcon(
                              favoriteData.isfavorite(product.id),
                              size: 18,
                              onPressed: () {}
                              // => favoriteData.toggleFavorite(
                              //     product.id,
                              //     product: product)
                              ));
                    }),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      const SizedBox(height: 20),

                      //title Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 17),
                                  discAmountRow(220, product.amount.toInt()),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RatingBar.builder(
                                    itemSize: 17,
                                    initialRating: 3,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    itemBuilder: (context, _) =>
                                        SvgPicture.asset(
                                      'assets/images/icons/star.svg',
                                      color: cc.orangeRating,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  const SizedBox(height: 17),
                                  Text(
                                    'In Stock (232)',
                                    style: TextStyle(
                                        color: cc.primaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      const AnimatedBox('Description',
                          'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numqum eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'),
                      const AnimatedBox('Additional Informationn',
                          'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numqum eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'),
                      const AnimatedBox('Review',
                          'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numqum eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'),

                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: seeAllTitle(context, 'Fetured products'),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: screenHight / 3.7,
                        child: Consumer<ProductCardDataService>(
                            builder: (context, products, child) {
                          return products.featuredCardProductsList.isNotEmpty
                              ? ListView.builder(
                                  physics: const BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  padding: const EdgeInsets.only(left: 20),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      products.featuredCardProductsList.length,
                                  itemBuilder: (context, index) => ProductCard(
                                    products
                                        .featuredCardProductsList[index].prdId,
                                    products
                                        .featuredCardProductsList[index].title,
                                    products
                                        .featuredCardProductsList[index].price,
                                    products.featuredCardProductsList[index]
                                        .discountPrice,
                                    products.featuredCardProductsList[index]
                                        .campaignPercentage
                                        .toDouble(),
                                    products
                                        .featuredCardProductsList[index].imgUrl,
                                    products.featuredCardProductsList[index]
                                        .isCartAble,
                                  ),
                                )
                              : loadingProgressBar();
                        }),
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              height: 90,
              padding: const EdgeInsets.only(
                left: 20,
                right: 23,
                top: 17,
                bottom: 7,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: cc.blackColor,
              ),
              child: PlusMinusCart(itemCount, product.amount, product.amount))
        ],
      ),
    );
  }
}
