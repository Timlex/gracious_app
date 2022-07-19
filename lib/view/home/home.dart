import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/model/products.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/model/poster_data.dart';
import 'package:gren_mart/view/home/deal_timer.dart';
import 'package:gren_mart/view/home/dow_card.dart';
import 'package:gren_mart/view/home/product_card.dart';
import 'package:gren_mart/view/search/search.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'poster_card.dart';

class Home extends StatelessWidget {
  final TextEditingController? searchController;
  void Function()? onFieldSubmitted;
  Home({Key? key, this.searchController, this.onFieldSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              controller: searchController!,
              leadingImage: 'assets/images/icons/search_normal.png',
              onFieldSubmitted: (value) {
                onFieldSubmitted!();
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
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return PosterCard(
                  PosterData().posterData[index].title,
                  'Shop now',
                  PosterData().posterData[index].description,
                  () {},
                  PosterData().posterData[index].image,
                );
              },
              itemCount: PosterData().posterData.length,
              viewportFraction: 0.8,
              scale: 0.9,
              autoplay: true,
            ),
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
                        e.title, e.amount, 'assets/images/product1.png',
                        discountAmount: 220))
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                    discountAmount: 220),
                ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                    discountAmount: 220),
                ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                    discountAmount: 220)
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
