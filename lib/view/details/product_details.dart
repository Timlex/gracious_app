import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/service/favorite_data_service.dart';
import 'package:gren_mart/service/product_details_service.dart';
import 'package:gren_mart/view/details/animated_box.dart';
import 'package:gren_mart/view/details/plus_minus_cart.dart';
import 'package:gren_mart/view/intro/dot_indicator.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../service/product_card_data_service.dart';
import '../home/home_front.dart';
import '../home/product_card.dart';
import '../utils/constant_name.dart';
import '../utils/image_view.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = 'product details screen';
  ProductDetails({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();
  int itemCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider.of<ProductDetailsService>(context).productDetails == null
          ? loadingProgressBar()
          : Consumer<ProductDetailsService>(
              builder: (context, pdService, child) {
              final product = pdService.productDetails!.product;
              return Column(
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
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            ImageView(
                                          product.productGalleryImage.isEmpty
                                              ? product.image
                                              : product
                                                  .productGalleryImage[index],
                                          id: product.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Image.asset(
                                        'assets/images/skelleton.png'),
                                    imageUrl: product
                                            .productGalleryImage.isEmpty
                                        ? ''
                                        : product.productGalleryImage[index],
                                    errorWidget: (context, errorText, error) =>
                                        Image.network(product.image),
                                  ),
                                );
                              },
                              itemCount: product.productGalleryImage.isEmpty
                                  ? 1
                                  : product.productGalleryImage.length,
                              pagination: SwiperCustomPagination(
                                builder: (BuildContext context,
                                    SwiperPluginConfig config) {
                                  return Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      (product.productGalleryImage
                                                              .isEmpty
                                                          ? 1
                                                          : product
                                                              .productGalleryImage
                                                              .length);
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
                            onTap: (() => Navigator.of(context)
                                .pushReplacementNamed(HomeFront.routeName)),
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
                                      favoriteData
                                          .isfavorite(product.id.toString()),
                                      size: 18, onPressed: () {
                                    favoriteData.toggleFavorite(
                                      product.id,
                                      product.title,
                                      product.price,
                                      product.salePrice,
                                      product.image,
                                    );
                                  }
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 60,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: screenWidth / 2,
                                            child: Text(
                                              product.title,
                                              style: const TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          const SizedBox(height: 17),
                                          discAmountRow(
                                              product.salePrice, product.price),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth / 3,
                                      height: 60,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          RatingBar.builder(
                                            itemSize: 17,
                                            initialRating: pdService
                                                    .productDetails!
                                                    .avgRating ??
                                                0,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
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
                                            'In Stock (${product.inventory.stockCount.toString()})',
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

                              AnimatedBox(
                                'Description',
                                {'1': product.description},
                                pdService.descriptionExpand,
                                onPressed: pdService.toggleDescriptionExpande,
                              ),
                              AnimatedBox(
                                'Additional Informationn',
                                pdService.setAditionalInfo(),
                                pdService.aDescriptionExpand,
                                onPressed: pdService.toggleADescriptionExpande,
                              ),
                              // const AnimatedBox('Additional Informationn',
                              //     'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numqum eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'),
                              // const AnimatedBox('Review',
                              //     'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numqum eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'),

                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: seeAllTitle(context, 'Fetured products'),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: screenHight / 3.7 < 221
                                    ? 170
                                    : screenHight / 3.7,
                                child: Consumer<ProductCardDataService>(
                                    builder: (context, products, child) {
                                  return products
                                          .featuredCardProductsList.isNotEmpty
                                      ? ListView.builder(
                                          physics: const BouncingScrollPhysics(
                                              parent:
                                                  AlwaysScrollableScrollPhysics()),
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: products
                                              .featuredCardProductsList.length,
                                          itemBuilder: (context, index) =>
                                              ProductCard(
                                            products
                                                .featuredCardProductsList[index]
                                                .prdId,
                                            products
                                                .featuredCardProductsList[index]
                                                .title,
                                            products
                                                .featuredCardProductsList[index]
                                                .price,
                                            products
                                                .featuredCardProductsList[index]
                                                .discountPrice,
                                            products
                                                .featuredCardProductsList[index]
                                                .campaignPercentage
                                                .toDouble(),
                                            products
                                                .featuredCardProductsList[index]
                                                .imgUrl,
                                            products
                                                .featuredCardProductsList[index]
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
                      child: PlusMinusCart(
                          itemCount, product.salePrice, product.salePrice))
                ],
              );
            }),
    );
  }
}
