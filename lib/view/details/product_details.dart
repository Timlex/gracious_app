import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/details/animated_box.dart';
import 'package:gren_mart/view/details/plus_minus_cart.dart';
import 'package:gren_mart/view/intro/dot_indicator.dart';
import 'package:gren_mart/view/intro/intro.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';

import '../../model/products.dart';
import '../home/product_card.dart';
import '../intro/intro_helper.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = 'product details screen';
  ProductDetails({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();
  int itemCount = 1;

  @override
  Widget build(BuildContext context) {
    final keyData = ModalRoute.of(context)!.settings.arguments as List;

    final key = keyData[0];
    // final productList =
    //     Provider.of<Products>(context, listen: false) as List<Product>;
    final product = Products().products.firstWhere((e) => e.id == key);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 1,
                  foregroundColor: cc.greyHint,
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Image.asset(
                          product.image[index],
                          fit: BoxFit.cover,
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
                  actions: [
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: favoriteIcon(size: 18)),
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
                                  discAmountRow(220, product.amount),
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
                                    allowHalfRating: true,
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
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: seeAllTitle('Fetured products'),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 18,
                            ),
                            ...Products()
                                .products
                                .map((e) => ProductCard(e.title, e.amount,
                                    'assets/images/product1.png',
                                    discountAmount: 220))
                                .toList()

                            // ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                            //     discountAmount: 220),
                            // ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                            //     discountAmount: 220),
                            // ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                            //     discountAmount: 220)
                          ],
                        ),
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
                left: 23,
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
