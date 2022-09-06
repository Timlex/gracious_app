import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/view/home/all_camp_product_from_link.dart';
import '../../service/navigation_bar_helper_service.dart';
import '../../service/poster_campaign_slider_service.dart';
import '../../service/product_card_data_service.dart';
import '../../service/search_result_data_service.dart';
import '../../view/auth/custom_text_field.dart';
import 'campaign_card.dart';
import '../../view/home/product_card.dart';
import '../../view/utils/constant_name.dart';
import '../../view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'poster_card.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(screenWidth);
    Provider.of<PosterCampaignSliderService>(context, listen: false)
        .fetchPosters();
    Provider.of<PosterCampaignSliderService>(context, listen: false)
        .fetchCampaigns();
    // final productData = Provider.of<Products>(context, listen: false).products;
    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              'Search your need here',
              leadingImage: 'assets/images/icons/search_normal.png',
              onFieldSubmitted: (value) {
                Provider.of<SearchResultDataService>(context, listen: false)
                    .resetSerch();
                Provider.of<SearchResultDataService>(context, listen: false)
                    .fetchProductsBy(pageNo: '1');
                Provider.of<NavigationBarHelperService>(context, listen: false)
                    .setNavigationIndex(1);
              },
              onChanged: (value) {
                Provider.of<SearchResultDataService>(context, listen: false)
                    .setSearchText(value);
              },
            ),

            // child: GestureDetector(
            //   onTap: () {
            //     Navigator.of(context).pushNamed(SearchView.routeName);
            //   },
            //   child: Container(
            //     height: 44,
            //     width: double.infinity,
            //     margin: const EdgeInsets.symmetric(vertical: 7),
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(
            //         color: cc.greyBorder,
            //         width: 1,
            //       ),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         const SizedBox(
            //           width: 10,
            //         ),
            //         SizedBox(
            //           height: 25,
            //           child:
            //               Image.asset('assets/images/icons/search_normal.png'),
            //         ),
            //         const SizedBox(
            //           width: 10,
            //         ),
            //         Text(
            //           'Search your needs here',
            //           style: TextStyle(color: cc.greyHint),
            //         )
            //       ],
            //     ),
            //   ),
            // ),
          ),
          const SizedBox(height: 20),
          Consumer<PosterCampaignSliderService>(
              builder: (context, posterData, child) {
            return posterData.posterDataList.isEmpty
                ? const SizedBox()
                : SizedBox(
                    height: screenHight / 4.8,
                    width: double.infinity,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return PosterCard(
                          posterData.posterDataList[index].title,
                          posterData.posterDataList[index].buttonText,
                          posterData.posterDataList[index].description,
                          () {
                            if (posterData.posterDataList[index].campaign !=
                                null) {
                              print('campaign');
                              Navigator.of(context).pushNamed(
                                  ALLCampProductFromLink.routeName,
                                  arguments: [
                                    posterData.posterDataList[index].campaign
                                        .toString()
                                  ]);
                            }
                            if (posterData.posterDataList[index].category !=
                                null) {
                              Provider.of<SearchResultDataService>(context,
                                      listen: false)
                                  .resetSerch();
                              Provider.of<SearchResultDataService>(context,
                                      listen: false)
                                  .setCategoryId(posterData
                                      .posterDataList[index].category
                                      .toString());
                              Provider.of<SearchResultDataService>(context,
                                      listen: false)
                                  .fetchProductsBy(pageNo: '1');
                              Provider.of<NavigationBarHelperService>(context,
                                      listen: false)
                                  .setNavigationIndex(1);
                            }
                          },
                          posterData.posterDataList[index].image,
                          (posterData.posterDataList[index].campaign != null ||
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
          if (Provider.of<ProductCardDataService>(context)
              .featuredCardProductsList
              .isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: seeAllTitle(
                  context,
                  'Fetured products',
                  Provider.of<ProductCardDataService>(context)
                      .featuredCardProductsList),
            ),
          const SizedBox(height: 10),
          Consumer<ProductCardDataService>(builder: (context, products, child) {
            return products.featuredCardProductsList.isNotEmpty
                ? SizedBox(
                    height: screenHight / 3.4 < 221 ? 195 : screenHight / 3.4,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: const EdgeInsets.only(left: 20),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: products.featuredCardProductsList.length,
                      itemBuilder: (context, index) => ProductCard(
                        products.featuredCardProductsList[index].prdId,
                        products.featuredCardProductsList[index].title,
                        products.featuredCardProductsList[index].price,
                        products.featuredCardProductsList[index].discountPrice,
                        products
                            .featuredCardProductsList[index].campaignPercentage
                            .toDouble(),
                        products.featuredCardProductsList[index].imgUrl,
                        products.featuredCardProductsList[index].isCartAble,
                      ),
                    ))
                : const SizedBox();
          }),
          // const SizedBox(height: 20),
          if (Provider.of<ProductCardDataService>(context)
              .featuredCardProductsList
              .isNotEmpty)
            SingleChildScrollView(
              padding: EdgeInsets.only(left: 20),
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
                            () {
                              if (e.campaign != null) {
                                Navigator.of(context).pushNamed(
                                    ALLCampProductFromLink.routeName,
                                    arguments: [e.campaign.toString()]);
                                return;
                              }
                              if (e.category != null) {
                                Provider.of<SearchResultDataService>(context,
                                        listen: false)
                                    .resetSerch();
                                Provider.of<SearchResultDataService>(context,
                                        listen: false)
                                    .setCategoryId(e.category.toString());
                                Provider.of<SearchResultDataService>(context,
                                        listen: false)
                                    .fetchProductsBy(pageNo: '1');
                                Provider.of<NavigationBarHelperService>(context,
                                        listen: false)
                                    .setNavigationIndex(1);
                              }
                            },
                            e.image,
                            e.campaign != null || e.category != null,
                            camp: e.campaign,
                            cat: e.category,
                          );
                        }).toList(),
                      );
              }),
            ),
          const SizedBox(height: 20),
          Consumer<ProductCardDataService>(builder: (context, campInfo, child) {
            return (campInfo.campaignCardProductList.isNotEmpty &&
                    campInfo.featuredCardProductsList.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: campInfo.campaignInfo != null
                        ? Row(
                            children: [
                              // const SizedBox(width: 18),
                              Text(
                                campInfo.campaignInfo!.title,
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w600),
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
              return (products.campaignCardProductList.isNotEmpty &&
                      products.featuredCardProductsList.isNotEmpty)
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
                        products
                            .campaignCardProductList[index].campaignPercentage,
                        products.campaignCardProductList[index].imgUrl,
                        products.campaignCardProductList[index].isCartAble,
                      ),
                    )
                  : loadingProgressBar();
            }),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
