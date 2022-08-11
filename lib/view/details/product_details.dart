import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import '../../service/favorite_data_service.dart';
import '../../service/product_details_service.dart';
import '../../view/details/animated_box.dart';
import '../../view/details/plus_minus_cart.dart';
import '../../view/intro/dot_indicator.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../../service/product_card_data_service.dart';
import '../home/home_front.dart';
import '../home/product_card.dart';
import '../utils/constant_name.dart';
import '../utils/image_view.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = 'product details screen';
  ProductDetails({Key? key}) : super(key: key);
  List<Widget> colors = [];
  List<Widget> sauces = [];
  List<Widget> mayoes = [];
  List<Widget> cheeses = [];
  List<Widget> sizes = [];

  ConstantColors cc = ConstantColors();
  int itemCount = 1;

  @override
  Widget build(BuildContext context) {
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final id = routeData[0];

    return Scaffold(
        body: FutureBuilder(
      future: Provider.of<ProductDetailsService>(context, listen: false)
          .fetchProductDetails(id),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return loadingProgressBar();
        }
        if (Provider.of<ProductDetailsService>(context, listen: false)
                .productDetails ==
            null) {
          return const Center(child: Text('Loading failed!'));
        }

        final product =
            Provider.of<ProductDetailsService>(context, listen: false)
                .productDetails!
                .product;
        final pService = Provider.of<ProductDetailsService>(context);
        bool showAttribute =
            Provider.of<ProductDetailsService>(context, listen: false)
                .productDetails!
                .productInventorySet
                .isNotEmpty;

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
                                  builder: (BuildContext context) => ImageView(
                                    product.productGalleryImage.isEmpty
                                        ? product.image
                                        : product.productGalleryImage[index],
                                    id: product.id,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              child: CachedNetworkImage(
                                placeholder: (context, url) =>
                                    Image.asset('assets/images/skelleton.png'),
                                imageUrl: product.productGalleryImage.isEmpty
                                    ? product.image
                                    : product.productGalleryImage[index],
                                errorWidget: (context, errorText, error) =>
                                    Image.network(product.image),
                              ),
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
                                favoriteData.isfavorite(product.id.toString()),
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 60,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: screenWidth / 2,
                                      child: Text(
                                        product.title,
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      itemSize: 17,
                                      initialRating:
                                          (Provider.of<ProductDetailsService>(
                                                              context,
                                                              listen: false)
                                                          .productDetails!
                                                          .avgRating ??
                                                      0)
                                                  .toDouble() ??
                                              0.0,
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

                        if (showAttribute)
                          Consumer<ProductDetailsService>(
                              builder: (context, pdService, child) {
                            generateAttributeWidgets(pdService);
                            return !showAttribute
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (pService.sizeAttributes != {})
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text('Size:',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              const SizedBox(width: 5),
                                              ...sizes,
                                            ],
                                          ),
                                        const SizedBox(height: 15),
                                        if (pService.colorAttributes != {})
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text('Color:',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              const SizedBox(width: 5),
                                              ...colors,
                                            ],
                                          ),
                                        const SizedBox(height: 15),
                                        if (pdService.sauceAttributes != {})
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              if (showAttribute)
                                                const Text('Sauce:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              const SizedBox(width: 5),
                                              ...sauces,
                                            ],
                                          ),
                                        const SizedBox(height: 15),
                                        if (pdService.mayoAttributes != {})
                                          Row(
                                            children: [
                                              if (showAttribute)
                                                const Text('Mayo:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              const SizedBox(width: 5),
                                              ...mayoes,
                                            ],
                                          ),
                                        const SizedBox(height: 15),
                                        if (pdService.cheeseAttributes != {})
                                          Row(
                                            children: [
                                              if (showAttribute)
                                                const Text('Cheese:',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              const SizedBox(width: 5),
                                              ...cheeses,
                                            ],
                                          ),
                                      ],
                                    ),
                                  );
                          }),
                        AnimatedBox(
                          'Description',
                          {'1': product.description},
                          pService.descriptionExpand,
                          onPressed: pService.toggleDescriptionExpande,
                        ),
                        AnimatedBox(
                          'Additional Informationn',
                          pService.setAditionalInfo(),
                          pService.aDescriptionExpand,
                          onPressed: pService.toggleADescriptionExpande,
                        ),
                        // const AnimatedBox('Additional Informationn',
                        //     'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numqum eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'),
                        // const AnimatedBox('Review',
                        //     'Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numqum eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.'),

                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: seeAllTitle(context, 'Fetured products'),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height:
                              screenHight / 3.7 < 221 ? 170 : screenHight / 3.7,
                          child: Consumer<ProductCardDataService>(
                              builder: (context, products, child) {
                            return products.featuredCardProductsList.isNotEmpty
                                ? ListView.builder(
                                    physics: const BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    padding: const EdgeInsets.only(left: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: products
                                        .featuredCardProductsList.length,
                                    itemBuilder: (context, index) =>
                                        ProductCard(
                                      products.featuredCardProductsList[index]
                                          .prdId,
                                      products.featuredCardProductsList[index]
                                          .title,
                                      products.featuredCardProductsList[index]
                                          .price,
                                      products.featuredCardProductsList[index]
                                          .discountPrice,
                                      products.featuredCardProductsList[index]
                                          .campaignPercentage
                                          .toDouble(),
                                      products.featuredCardProductsList[index]
                                          .imgUrl,
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
                child: PlusMinusCart(
                    itemCount, product.salePrice, product.salePrice))
          ],
        );
      },
    ));
  }

  generateAttributeWidgets(
    ProductDetailsService pdService,
  ) {
    List<Widget> list0 = [];
    List<Widget> list1 = [];
    List<Widget> list2 = [];
    List<Widget> list3 = [];
    List<Widget> list4 = [];

    //   for (var element in list) {
    //     list0.add(
    //       GestureDetector(
    //         onTap: () {
    //           pdService.setProductInventorySet(pdService
    //               .productDetails!.productInventorySet
    //               .indexWhere((e) => e == element));
    //           pdService.setSelectedSauce(element);
    //         }on,
    //         child: Stack(
    //           children: [
    //             Container(
    //               margin: const EdgeInsets.only(right: 15),
    //               padding: const EdgeInsets.all(12),
    //               decoration: BoxDecoration(
    //                   // borderRadius: BorderRadius.circular(10),
    //                   color: element == selectedValue
    //                       ? cc.lightPrimery3
    //                       : cc.whiteGrey,
    //                   border: Border.all(
    //                       color: element == selectedValue
    //                           ? cc.primaryColor
    //                           : cc.greyHint,
    //                       width: .5)),
    //               child: Text(element.toString().capitalize()),
    //             ),
    //             if (!(element == selectedValue))
    //               Container(
    //                 color: Colors.white38,
    //               )
    //           ],
    //         ),
    //       ),
    //     );
    //   }
    //   return list0;
    // }
    int index = 0;

    print(index);
    bool isSelected = false;
    // bool isSelected = (element.sauce ==
    //     pdService.productDetails!
    //         .productInventorySet[pdService.selectedInventorySetIndex].sauce);
    final sizeKeys = pdService.sizeAttributes.keys;
    final colorKeys = pdService.colorAttributes.keys;
    final sauceKeys = pdService.sauceAttributes.keys;
    final mayoKeys = pdService.mayoAttributes.keys;
    final cheeseKeys = pdService.cheeseAttributes.keys;
    for (var elemnt in sauceKeys) {
      list0.add(
        GestureDetector(
          onTap: () {
            if (elemnt == pdService.selectedSauce) {
              return;
            }
            if (!pdService.isInSet(pdService.sauceAttributes[elemnt])) {
              pdService.clearSelection();
            }
            print(pdService.sauceAttributes[elemnt]);
            pdService.setProductInventorySet(pdService.sauceAttributes[elemnt]);
            pdService.setSelectedSauce(elemnt);
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: elemnt == pdService.selectedSauce
                        ? cc.lightPrimery3
                        : cc.whiteGrey,
                    border: Border.all(
                        color: elemnt == pdService.selectedSauce
                            ? cc.primaryColor
                            : cc.greyHint,
                        width: .5)),
                child: Text(elemnt.capitalize()),
              ),
              if (!pdService.isInSet(pdService.sauceAttributes[elemnt]))
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(12),
                  color: Colors.white60,
                  child: Text(
                    elemnt.capitalize(),
                    style: const TextStyle(color: Colors.transparent),
                  ),
                )
            ],
          ),
        ),
      );
    }

    for (var key in mayoKeys) {
      list1.add(
        GestureDetector(
          onTap: () {
            if (key == pdService.selectedMayo) {
              return;
            }
            if (!pdService.isInSet(pdService.mayoAttributes[key])) {
              pdService.clearSelection();
            }
            print(pdService.mayoAttributes[key]);
            pdService.setProductInventorySet(pdService.mayoAttributes[key]);
            pdService.setSelectedMayo(key);
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: key == pdService.selectedMayo
                        ? cc.lightPrimery3
                        : cc.whiteGrey,
                    border: Border.all(
                        color: key == pdService.selectedMayo
                            ? cc.primaryColor
                            : cc.greyHint,
                        width: .5)),
                child: Text(key.capitalize()),
              ),
              if (!pdService.isInSet(pdService.mayoAttributes[key]))
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(12),
                  color: Colors.white60,
                  child: Text(
                    key.capitalize(),
                    style: const TextStyle(color: Colors.transparent),
                  ),
                )
            ],
          ),
        ),
      );
    }

    for (var key in cheeseKeys) {
      list2.add(
        GestureDetector(
          onTap: () {
            if (key == pdService.selectedChese) {
              return;
            }
            if (!pdService.isInSet(pdService.cheeseAttributes[key])) {
              pdService.clearSelection();
            }
            pdService.setProductInventorySet(pdService.cheeseAttributes[key]);
            pdService.setSelectedCheese(key);
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: key == pdService.selectedChese
                        ? cc.lightPrimery3
                        : cc.whiteGrey,
                    border: Border.all(
                        color: key == pdService.selectedChese
                            ? cc.primaryColor
                            : cc.greyHint,
                        width: .5)),
                child: Text(key.capitalize()),
              ),
              if (!pdService.isInSet(pdService.cheeseAttributes[key]))
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(12),
                  color: Colors.white60,
                  child: Text(
                    key.capitalize(),
                    style: const TextStyle(color: Colors.transparent),
                  ),
                )
            ],
          ),
        ),
      );
    }

    for (var key in colorKeys) {
      final color = key.replaceAll('#', '0xff');
      list3.add(
        GestureDetector(
          onTap: () {
            if (key == pdService.selectedColor) {
              return;
            }
            if (!pdService.isInSet(pdService.colorAttributes[key])) {
              pdService.clearSelection();
            }
            pdService.setProductInventorySet(pdService.colorAttributes[key]);
            pdService.setSelectedColor(key);
          },
          child: Stack(
            children: [
              Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(int.parse(color)),
                  border: key == pdService.selectedColor
                      ? Border.all(color: cc.primaryColor, width: 2.5)
                      : null,
                ),
                // child: const Text('element.color!.capitalize()'),
              ),
              if (!pdService.isInSet(pdService.colorAttributes[key]))
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(12),
                  color: Colors.white60,
                  child: Text(
                    key.capitalize(),
                    style: const TextStyle(color: Colors.transparent),
                  ),
                )
            ],
          ),
        ),
      );
    }

    print(sizeKeys);
    for (var element in sizeKeys) {
      list4.add(
        GestureDetector(
          onTap: () {
            if (element == pdService.selectedSize) {
              return;
            }
            if (!pdService.isInSet(pdService.sizeAttributes[element])) {
              pdService.clearSelection();
            }
            pdService.setProductInventorySet(pdService.sizeAttributes[element]);
            pdService.setSelectedSize(element);
          },
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: element == pdService.selectedSize
                        ? cc.lightPrimery3
                        : cc.whiteGrey,
                    border: Border.all(
                        color: element == pdService.selectedSize
                            ? cc.primaryColor
                            : cc.greyHint,
                        width: .5)),
                child: Text(element.capitalize()),
              ),
              if (!pdService.isInSet(pdService.sizeAttributes[element]))
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(12),
                  color: Colors.white60,
                  child: Text(
                    element.capitalize(),
                    style: const TextStyle(color: Colors.transparent),
                  ),
                )
            ],
          ),
        ),
      );
    }
    index++;

    sauces = list0;
    mayoes = list1;
    cheeses = list2;
    colors = list3;
    sizes = list4;
  }
}
