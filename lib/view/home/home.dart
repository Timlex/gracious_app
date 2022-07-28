import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/model/product_data.dart';
import 'package:gren_mart/service/navigation_bar_helper_service.dart';
import 'package:gren_mart/service/poster_slider_service.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/view/home/dow_card.dart';
import 'package:gren_mart/view/home/product_card.dart';
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
    Provider.of<PosterSliderService>(context, listen: false).fetchPosters();
    // final productData = Provider.of<Products>(context, listen: false).products;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
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
            child: Consumer<PosterSliderService>(
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
            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                    .map((e) => ProductCard(
                          e.id,
                        ))
                    .toList()
              ],
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(
                  width: 18,
                ),
                DODCard('Fresh Products', 'Shop now', () {},
                    'assets/images/basket.png'),
                DODCard('Vegetable Collection', 'Shop now', () {},
                    'assets/images/basket.png'),
                DODCard('One Month Whole', 'Shop now', () {},
                    'assets/images/basket.png'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                // const SizedBox(width: 18),
                const Text(
                  'Deal of the week',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),

                const Spacer(),
                SlideCountdown(
                  showZeroValue: true,
                  textStyle:
                      TextStyle(color: cc.orange, fontWeight: FontWeight.w500),
                  decoration: BoxDecoration(
                      color: cc.pureWhite,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        width: .7,
                        color: cc.orange,
                      )),
                  duration: const Duration(days: 2),
                ),
                // DealTimer(DateTime.now().add(const Duration(minutes: 2)), 'h'),
                // DealTimer(DateTime.now().add(const Duration(minutes: 2)), 'm'),
                // DealTimer(DateTime.now().add(const Duration(minutes: 2)), 's'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(
                  width: 18,
                ),
                ...Products()
                    .products
                    .map((e) => ProductCard(
                          e.id,
                        ))
                    .toList()
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
