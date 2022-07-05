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
        CustomTextField(
          'Search your  need here',
          _searchController,
          leadingImage: 'assets/images/icons/search_normal.png',
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: PosterData()
                .posterData
                .map((e) => PosterCard(
                    e.title, 'Shop now', e.description, () {}, e.image))
                .toList(),
          ),
        ),
        const SizedBox(height: 10),
        seeAllTitle('Fetured products'),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
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
        Row(
          children: [
            const Text(
              'Deal of the week',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            DealTimer(DateTime.now().add(Duration(days: 2)), 'h'),
            DealTimer(DateTime.now().add(Duration(days: 2)), 'm'),
            DealTimer(DateTime.now().add(Duration(days: 2)), 's'),
          ],
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
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
