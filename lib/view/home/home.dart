import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/model/poster_data.dart';
import 'package:gren_mart/view/home/deal_timer.dart';
import 'package:gren_mart/view/home/dow_card.dart';
import 'package:gren_mart/view/home/product_card.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'poster_card.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: CustomTextField(
            'Search your  need here',
            _searchController,
            leadingImage: 'assets/images/icons/search_normal.png',
          ),
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
              ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                  discountAmount: 220),
              ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                  discountAmount: 220),
              ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                  discountAmount: 220)
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
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(
            children: [
              const SizedBox(width: 18),
              const Text(
                'Deal of the week',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              DealTimer(DateTime.now().add(Duration(minutes: 2)), 'h'),
              DealTimer(DateTime.now().add(Duration(minutes: 2)), 'm'),
              DealTimer(DateTime.now().add(Duration(minutes: 2)), 's'),
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
    );
  }
}
