import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/service/categories_data_service.dart';
import 'package:gren_mart/view/home/categories.dart';
import 'package:gren_mart/view/home/category_page.dart';
import 'package:gren_mart/view/home/category_product_page.dart';
import 'package:gren_mart/view/home/section_title.dart';

import '../../service/language_service.dart';
import '../../service/navigation_bar_helper_service.dart';
import '../../service/poster_campaign_slider_service.dart';
import '../../service/product_card_data_service.dart';
import '../../service/search_result_data_service.dart';
import 'all_products.dart';
import 'campaign_card.dart';
import '../../view/home/product_card.dart';
import '../../view/utils/constant_name.dart';
import '../../view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'poster_card.dart';

class Home extends StatelessWidget {
  Home({
    Key? key,
  }) : super(key: key);
  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    initiateDeviceSize(context);
    print(screenWidth);
    Provider.of<PosterCampaignSliderService>(context, listen: false)
        .fetchPosters();
    Provider.of<PosterCampaignSliderService>(context, listen: false)
        .fetchCampaigns();
    // final productData = Provider.of<Products>(context, listen: false).products;
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          snackBar(context, 'Press again to exit', backgroundColor: cc.orange);
          return false;
        }
        return true;
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Consumer<SearchResultDataService>(
                  builder: (context, srService, child) {
                return TextField(
                  style: TextStyle(color: cc.greyTextFieldLebel, fontSize: 13),
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 17),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: cc.primaryColor, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: cc.greyBorder, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: cc.orange, width: 1),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: cc.orange, width: 1),
                    ),
                    hintText: 'Search your need here',
                    hintStyle:
                        TextStyle(color: cc.greyTextFieldLebel, fontSize: 13),
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 25,
                            child: Image.asset(
                              'assets/images/icons/search_normal.png',
                            )),
                      ],
                    ),
                    suffixIcon: GestureDetector(
                      onTap: (() {
                        Provider.of<SearchResultDataService>(context,
                                listen: false)
                            .resetSerch();
                        Provider.of<SearchResultDataService>(context,
                                listen: false)
                            .fetchProductsBy(pageNo: '1');
                        Provider.of<NavigationBarHelperService>(context,
                                listen: false)
                            .setNavigationIndex(1);
                      }),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: cc.blackColor,
                        size: 17,
                      ),
                    ),
                  ),
                  onSubmitted: (_) {
                    Provider.of<SearchResultDataService>(context, listen: false)
                        .resetSerch();
                    Provider.of<SearchResultDataService>(context, listen: false)
                        .fetchProductsBy(pageNo: '1');
                    Provider.of<NavigationBarHelperService>(context,
                            listen: false)
                        .setNavigationIndex(1);
                  },
                  onChanged: (value) {
                    Provider.of<SearchResultDataService>(context, listen: false)
                        .setSearchText(value);
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            Consumer<PosterCampaignSliderService>(
                builder: (context, posterData, child) {
              return posterData.posterDataList.isEmpty
                  ? const SizedBox()
                  : SizedBox(
                      height: 175,
                      width: double.infinity,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return PosterCard(
                            posterData.posterDataList[index].title,
                            posterData.posterDataList[index].buttonText,
                            posterData.posterDataList[index].description,
                            posterData.posterDataList[index].image,
                            (posterData.posterDataList[index].campaign !=
                                    null ||
                                posterData.posterDataList[index].category !=
                                    null),
                            capm: posterData.posterDataList[index].campaign,
                            cat: posterData.posterDataList[index].category,
                          );
                        },
                        itemCount: posterData.posterDataList.length,
                        viewportFraction: 0.85,
                        scale: 0.92,
                        autoplay: true,
                      ),
                    );
            }),
            const SizedBox(height: 10),
            Consumer<ProductCardDataService>(
                builder: (context, pcService, child) {
              return pcService.featuredCardProductsList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: seeAllTitle(context, 'Fetured products',
                          onPressed: () {
                        Provider.of<SearchResultDataService>(context,
                                listen: false)
                            .resetSerch();
                        Provider.of<SearchResultDataService>(context,
                                listen: false)
                            .fetchProductsBy(pageNo: '1');
                        Navigator.of(context).pushNamed(AllProducts.routeName,
                            arguments: [pcService.featuredCardProductsList]);
                      }),
                    )
                  : SizedBox();
            }),
            const SizedBox(height: 10),
            Consumer<ProductCardDataService>(
                builder: (context, products, child) {
              return products.featuredCardProductsList.isNotEmpty
                  ? SizedBox(
                      height: screenHight / 3.4 < 221 ? 195 : screenHight / 3.6,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        padding: EdgeInsets.only(
                          left: LanguageService().rtl ? 0 : 20.0,
                          right: LanguageService().rtl ? 20 : 0,
                        ),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: products.featuredCardProductsList.length,
                        itemBuilder: (context, index) => ProductCard(
                          products.featuredCardProductsList[index].prdId,
                          products.featuredCardProductsList[index].title,
                          products.featuredCardProductsList[index].price,
                          products
                              .featuredCardProductsList[index].discountPrice,
                          products.featuredCardProductsList[index]
                              .campaignPercentage
                              .toDouble(),
                          products.featuredCardProductsList[index].imgUrl,
                          products.featuredCardProductsList[index].isCartAble,
                        ),
                      ))
                  : const SizedBox();
            }),
            Consumer<ProductCardDataService>(
                builder: (context, pcService, child) {
              return pcService.featuredCardProductsList.isNotEmpty
                  ? Consumer<CategoriesDataService>(
                      builder: (context, catService, child) {
                        return catService.categorydataList.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: seeAllTitle(context, 'Categories',
                                    onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      CategoryPage.routeName,
                                      arguments: [
                                        catService.categorydataList,
                                        'Categories'
                                      ]);
                                }),
                              )
                            : SizedBox();
                      },
                    )
                  : SizedBox();
            }),
            SizedBox(height: 10),
            FutureBuilder(
                future:
                    Provider.of<CategoriesDataService>(context, listen: false)
                        .fetchCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox();
                  }
                  return Consumer<CategoriesDataService>(
                    builder: (context, catService, child) {
                      return SizedBox(
                        height: 60,
                        child: ListView.builder(
                            padding: EdgeInsets.only(
                              left: LanguageService().rtl ? 0 : 20.0,
                              right: LanguageService().rtl ? 20 : 0,
                            ),
                            scrollDirection: Axis.horizontal,
                            itemCount: catService.categorydataList.length,
                            itemBuilder: (context, index) {
                              final element =
                                  catService.categorydataList[index];
                              return GestureDetector(
                                onTap: () {
                                  Provider.of<SearchResultDataService>(context,
                                          listen: false)
                                      .setCategoryId(element.id.toString(),
                                          notListen: true);
                                  Navigator.of(context).pushNamed(
                                      CategoryProductPage.routeName,
                                      arguments: [
                                        element.id.toString(),
                                        element.title
                                      ]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: LanguageService().rtl ? 10 : 0,
                                    right: LanguageService().rtl ? 0 : 10,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  constraints: BoxConstraints(maxWidth: 150),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: cc.greyBorder,
                                        width: 1,
                                      )),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          height: 42,
                                          width: 42,
                                          imageUrl: element.imageUrl ?? '',
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.category),
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 10,
                                      ),
                                      //Title
                                      Flexible(
                                        child: Text(
                                          element.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: cc.greyParagraph,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    },
                  );
                }),
            const SizedBox(height: 25),
            Consumer<ProductCardDataService>(
                builder: (context, pcService, child) {
              return pcService.featuredCardProductsList.isNotEmpty ||
                      pcService.featureNoData
                  ? SingleChildScrollView(
                      padding: EdgeInsets.only(
                          left: LanguageService().rtl ? 0 : 20,
                          right: LanguageService().rtl ? 20 : 0),
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      child: Consumer<PosterCampaignSliderService>(
                          builder: (context, pcData, child) {
                        return pcData.campaignDataList.isEmpty
                            ? const SizedBox()
                            : Row(
                                children: pcData.campaignDataList.map((e) {
                                  print(e.title);
                                  return CampaignCard(
                                    e.title,
                                    e.buttonText,
                                    e.image,
                                    e.campaign != null || e.category != null,
                                    camp: e.campaign,
                                    cat: e.category,
                                  );
                                }).toList(),
                              );
                      }),
                    )
                  : SizedBox();
            }),
            const SizedBox(height: 20),
            Consumer<ProductCardDataService>(
                builder: (context, campInfo, child) {
              return (campInfo.campaignCardProductList.isNotEmpty &&
                      (campInfo.featureNoData ||
                          campInfo.featuredCardProductsList.isNotEmpty))
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: campInfo.campaignInfo != null
                          ? Row(
                              children: [
                                // const SizedBox(width: 18),
                                Text(
                                  campInfo.campaignInfo!.title,
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600),
                                ),

                                const Spacer(),
                                if (campInfo.campaignInfo!.endDate != null)
                                  SlideCountdown(
                                    showZeroValue: true,
                                    textStyle: TextStyle(
                                        color: cc.orange,
                                        fontWeight: FontWeight.w500),
                                    decoration: BoxDecoration(
                                        color: cc.pureWhite,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                          width: .7,
                                          color: cc.orange,
                                        )),
                                    duration: DateTime.now().difference(campInfo
                                        .campaignInfo!.endDate as DateTime),
                                  ),
                              ],
                            )
                          : null)
                  : const SizedBox();
            }),
            const SizedBox(height: 20),
            SizedBox(
              height: screenHight / 3.4 < 221 ? 195 : screenHight / 3.4,
              child: Consumer<ProductCardDataService>(
                  builder: (context, products, child) {
                return ((products.campaignCardProductList.isNotEmpty) &&
                        (products.featureNoData ||
                            products.featuredCardProductsList.isNotEmpty))
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        padding: const EdgeInsets.only(left: 20),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: products.campaignCardProductList.length,
                        itemBuilder: (context, index) => ProductCard(
                          products.campaignCardProductList[index].prdId,
                          products.campaignCardProductList[index].title,
                          products.campaignCardProductList[index].price,
                          products.campaignCardProductList[index].discountPrice,
                          products.campaignCardProductList[index]
                              .campaignPercentage,
                          products.campaignCardProductList[index].imgUrl,
                          products.campaignCardProductList[index].isCartAble,
                        ),
                      )
                    : (products.campaignNoData
                        ? SizedBox()
                        : loadingProgressBar());
              }),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
