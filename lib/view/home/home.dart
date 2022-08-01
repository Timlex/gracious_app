import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/service/navigation_bar_helper_service.dart';
import 'package:gren_mart/service/poster_campaign_slider_service.dart';
import 'package:gren_mart/service/product_card_data_service.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/view/home/dod_card.dart';
import 'package:gren_mart/view/home/product_card.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'poster_card.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Provider.of<NavigationBarHelperService>(context, listen: false)
                    .setNavigationIndex(1);
              },
              onChanged: (value) {
                Provider.of<NavigationBarHelperService>(context, listen: false)
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
          SizedBox(
            height: 170,
            width: double.infinity,
            child: Consumer<PosterCampaignSliderService>(
                builder: (context, posterData, child) {
              return posterData.posterDataList.isEmpty
                  ? loadingProgressBar()
                  : Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return PosterCard(
                          posterData.posterDataList[index].title,
                          'Shop now',
                          posterData.posterDataList[index].description,
                          () {},
                          posterData.posterDataList[index].image,
                        );
                      },
                      itemCount: posterData.posterDataList.length,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      autoplay: true,
                    );
            }),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: seeAllTitle('Fetured products'),
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
                    )
                  : loadingProgressBar();
            }),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            scrollDirection: Axis.horizontal,
            child: Consumer<PosterCampaignSliderService>(
                builder: (context, pcData, child) {
              return pcData.campaignDataList.isEmpty
                  ? loadingProgressBar()
                  : Row(
                      children: [
                        const SizedBox(width: 20),
                        ...pcData.campaignDataList.map((e) {
                          print(e.title);
                          return DODCard(e.title, e.buttonText, () {}, e.image);
                        }).toList()
                      ],
                    );
            }),
          ),
          const SizedBox(height: 20),
          Consumer<ProductCardDataService>(builder: (context, campInfo, child) {
            return Padding(
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
                          SlideCountdown(
                            showZeroValue: true,
                            textStyle: TextStyle(
                                color: cc.orange, fontWeight: FontWeight.w500),
                            decoration: BoxDecoration(
                                color: cc.pureWhite,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  width: .7,
                                  color: cc.orange,
                                )),
                            duration: DateTime.now()
                                .difference(campInfo.campaignInfo!.endDate),
                          ),
                          // DealTimer(DateTime.now().add(const Duration(minutes: 2)), 'h'),
                          // DealTimer(DateTime.now().add(const Duration(minutes: 2)), 'm'),
                          // DealTimer(DateTime.now().add(const Duration(minutes: 2)), 's'),
                        ],
                      )
                    : loadingProgressBar());
          }),
          const SizedBox(height: 20),
          SizedBox(
            height: screenHight / 3.7,
            child: Consumer<ProductCardDataService>(
                builder: (context, products, child) {
              return products.campaignCardProductList.isNotEmpty
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
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
