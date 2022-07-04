import 'package:flutter/material.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:gren_mart/model/poster_data.dart';
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
              ProductCard(
                'Fresh fruits',
                240,
                'assets/images/product1.png',
                discountAmount: 220,
              ),
              ProductCard(
                'Fresh fruits',
                240,
                'assets/images/product1.png',
                discountAmount: 220,
              ),
              ProductCard(
                'Fresh fruits',
                240,
                'assets/images/product1.png',
                discountAmount: 220,
              ),
            ],
          ),
        )
      ],
    );
  }
}
