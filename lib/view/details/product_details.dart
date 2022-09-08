import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/service/cart_data_service.dart';
import 'package:gren_mart/view/details/review_box.dart';
import '../../service/common_service.dart';
import '../../service/favorite_data_service.dart';
import '../../service/product_details_service.dart';
import '../../view/details/animated_box.dart';
import '../../view/details/plus_minus_cart.dart';
import '../../view/intro/dot_indicator.dart';
import '../../view/utils/constant_colors.dart';
import '../../view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

import '../home/home_front.dart';
import '../home/product_card.dart';
import '../utils/constant_name.dart';
import '../utils/image_view.dart';
import '../utils/text_themes.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = 'product details screen';
  ProductDetails({Key? key}) : super(key: key);
  List<Widget> colors = [];
  List<Widget> sauces = [];
  List<Widget> mayoes = [];
  List<Widget> cheeses = [];
  List<Widget> sizes = [];
  TextStyle attributeTitleTheme =
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w600);

  ConstantColors cc = ConstantColors();
  int itemCount = 1;

  @override
  Widget build(BuildContext context) {
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final id = routeData[0];

    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Provider.of<ProductDetailsService>(context, listen: false)
              .clearProdcutDetails();
          Navigator.of(context).pushReplacementNamed(HomeFront.routeName);
          return true;
        },
        child: FutureBuilder(
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
                              return Hero(
                                tag: id,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            ImageView(
                                          pService.additionalInfoImage ??
                                              (product.productGalleryImage
                                                      .isEmpty
                                                  ? product.image
                                                  : product.productGalleryImage[
                                                      index]),
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
                                          Image.asset(
                                        'assets/images/skelleton.png',
                                        height: 200,
                                      ),
                                      imageUrl: pService.additionalInfoImage ??
                                          (product.productGalleryImage.isEmpty
                                              ? product.image
                                              : product
                                                  .productGalleryImage[index]),
                                      errorWidget:
                                          (context, errorText, error) =>
                                              Image.network(product.image),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: pService.additionalInfoImage != null
                                ? 1
                                : (product.productGalleryImage.isEmpty
                                    ? 1
                                    : product.productGalleryImage.length),
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
                                                    (pService.additionalInfoImage !=
                                                            null
                                                        ? 1
                                                        : (product
                                                                .productGalleryImage
                                                                .isEmpty
                                                            ? 1
                                                            : product
                                                                .productGalleryImage
                                                                .length));
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
                          onTap: (() {
                            Provider.of<ProductDetailsService>(context,
                                    listen: false)
                                .clearProdcutDetails();
                            Navigator.of(context)
                                .pushReplacementNamed(HomeFront.routeName);
                          }),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform(
                                  transform: rtl
                                      ? Matrix4.rotationY(pi)
                                      : Matrix4.rotationY(0),
                                  child: SvgPicture.asset(
                                    'assets/images/icons/back_button.svg',
                                    color: cc.blackColor,
                                    height: 30,
                                  ),
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
                                    product.salePrice,
                                    pService.productSalePrice,
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
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 19,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        const SizedBox(height: 17),
                                        discAmountRow(pService.productSalePrice,
                                            product.price),
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
                                          style: TextThemeConstrants.primary13,
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
                                // generateAttributeWidgets(pdService);
                                return !showAttribute
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: pdService.inventoryKeys
                                                .map((e) => Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 15),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              '${e.replaceFirst('_', ' ')}:',
                                                              style:
                                                                  attributeTitleTheme),
                                                          const SizedBox(
                                                              width: 10),
                                                          SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                                children: generateDynamicAttrribute(
                                                                    pdService,
                                                                    pdService
                                                                            .allAtrributes[
                                                                        e])),
                                                          )
                                                        ],
                                                      ),
                                                    ))
                                                .toList()),
                                      );
                              }),
                            AnimatedBox(
                              'Description',
                              {
                                '1': product.description.isEmpty
                                    ? 'No discription available.'
                                    : product.description
                              },
                              pService.descriptionExpand,
                              onPressed: pService.toggleDescriptionExpande,
                            ),
                            AnimatedBox(
                              'Additional Informationn',
                              pService.setAditionalInfo(),
                              pService.aDescriptionExpand,
                              onPressed: pService.toggleADescriptionExpande,
                            ),
                            ReviewBox(
                              pService.reviewExpand,
                              pService.productDetails!.product.id,
                              onPressed: pService.toggleReviewExpand,
                            ),
                            const SizedBox(height: 10),
                            if (pService
                                .productDetails!.relatedProducts.isNotEmpty)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: seeAllTitle(context, 'Related products',
                                    pService.productDetails!.relatedProducts),
                              ),
                            const SizedBox(height: 10),
                            if (pService
                                .productDetails!.relatedProducts.isNotEmpty)
                              SizedBox(
                                  height: screenHight / 3.4 < 221
                                      ? 200
                                      : screenHight / 3.4,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    padding: const EdgeInsets.only(left: 20),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: pService
                                        .productDetails!.relatedProducts.length,
                                    itemBuilder: (context, index) {
                                      final products = pService.productDetails!
                                          .relatedProducts[index];
                                      return ProductCard(
                                        products.prdId,
                                        products.title,
                                        products.price,
                                        products.discountPrice as int,
                                        (products.campaignPercentage)
                                            .toDouble(),
                                        products.imgUrl,
                                        false,
                                      );
                                    },
                                  )),
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
                      onTap: pService.cartAble
                          ? () {
                              print(pService.selecteInventorySet);
                              Provider.of<CartDataService>(context,
                                      listen: false)
                                  .addCartItem(
                                      product.id,
                                      product.title,
                                      product.salePrice,
                                      pService.productSalePrice,
                                      0.0,
                                      pService.quantity,
                                      pService.additionalInfoImage ??
                                          product.image,
                                      inventorySet:
                                          pService.selecteInventorySet == {}
                                              ? null
                                              : pService.selecteInventorySet);
                              snackBar(context, 'Product added to cart.');
                            }
                          : () {
                              snackBar(context, 'Please select a set.');
                            },
                    ))
              ],
            );
          },
        ),
      ),
    );
  }

  manageInventorySet(
    ProductDetailsService pdService,
    selectedValue,
  ) {
    final selectedInventorySetIndex = pdService.selectedInventorySetIndex;
    final allAtrributes = pdService.allAtrributes;
    setProductInventorySet(List<String>? value) {
      // print(
      //     selectedInventorySetIndex.toString() + 'inven........................');
      // print(value.toString() + 'val........................');

      if (selectedInventorySetIndex != value) {
        // if (value!.length == 1) {
        //   selectedInventorySetIndex = value;selectedValue
        // print(selectedInventorySetIndex);
        pdService.inventoryKeys.forEach((element) {
          if (selectedValue != null) {
            selectedValue = pdService.deselect(
                    value, allAtrributes[element]![selectedValue])
                ? selectedValue
                : null;
          }
        });
      }
      if (selectedInventorySetIndex.isEmpty) {
        pdService.selectedInventorySetIndex = value ?? [];

        return;
      }
      if (selectedInventorySetIndex.isNotEmpty &&
          selectedInventorySetIndex.length > value!.length) {
        pdService.selectedInventorySetIndex = value;
        return;
      }
    }
  }

  List<Widget> generateDynamicAttrribute(
      ProductDetailsService pdService, mapdata) {
    RegExp hex = RegExp(
        r'^#([\da-f]{3}){1,2}$|^#([\da-f]{4}){1,2}$|(rgb|hsl)a?\((\s*-?\d+%?\s*,){2}(\s*-?\d+%?\s*,?\s*\)?)(,\s*(0?\.\d+)?|1)?\)');

    List<Widget> list = [];
    String value = '';
    final keys = mapdata.keys;
    for (var elemnt in keys) {
      list.add(
        GestureDetector(
          onTap: () {
            if (pdService.selectedAttributes.contains(elemnt)) {
              return;
            }
            if (!pdService.isInSet(mapdata[elemnt])) {
              pdService.clearSelection();
            }
            pdService.setProductInventorySet(mapdata[elemnt]);
            value = elemnt;
            manageInventorySet(pdService, elemnt);
            pdService.addSelectedAttribute(elemnt);
            pdService.addAdditionalPrice();
          },
          child: hex.hasMatch(elemnt)
              ? colorBox(pdService, elemnt, mapdata)
              : Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: pdService.isASelected(elemnt)
                              ? cc.lightPrimery3
                              : cc.whiteGrey,
                          border: Border.all(
                              color: pdService.isASelected(elemnt)
                                  ? cc.primaryColor
                                  : cc.greyHint,
                              width: .5)),
                      child: Text(elemnt),
                    ),
                    if (!pdService.isInSet(mapdata[elemnt]))
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        padding: const EdgeInsets.all(12),
                        color: Colors.white60,
                        child: Text(
                          elemnt,
                          style: const TextStyle(color: Colors.transparent),
                        ),
                      )
                  ],
                ),
        ),
      );
    }
    return list;
  }

  Widget colorBox(ProductDetailsService pdService, value, mapdata) {
    final color = value.replaceAll('#', '0xff');
    return Stack(
      children: [
        Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.only(right: 15),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(int.parse(color)),
            border: pdService.isASelected(value)
                ? Border.all(color: cc.primaryColor, width: 2.5)
                : null,
          ),
          // child: const Text('element.color!.capitalize()'),
        ),
        if (!pdService.isInSet(mapdata[value]))
          Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(12),
            color: Colors.white60,
            child: Text(
              value,
              style: const TextStyle(color: Colors.transparent),
            ),
          )
      ],
    );
  }
}
