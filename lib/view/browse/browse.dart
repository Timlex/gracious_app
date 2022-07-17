import 'package:flutter/material.dart';

import '../auth/custom_text_field.dart';
import '../home/product_card.dart';
import '../search/filter_option.dart';
import '../utils/constant_colors.dart';

class Browse extends StatelessWidget {
  static const routeName = 'browse';
  Browse({Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();
  List<String> categories = [
    'Fruits',
    'Cooking',
    'Backing',
    'Snacks',
    'Drinks',
  ];
  List<String> units = [
    'Bottle',
    'Kg',
    'Piece',
    'Dozen',
    'Pound',
    'Litre',
  ];

  List<String> priceRange = ['Lowest', 'Highest', 'Random'];

  String selectedCategorie = 'Cooking';
  String selectedUnit = 'Dozen';
  String selectedPriceRange = 'Lowest';

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width / 3.3;
    double cardHeight = MediaQuery.of(context).size.height / 4.9;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: CustomTextField(
            'Search your need here',
            TextEditingController(),
            leadingImage: 'assets/images/icons/search_normal.png',
          ),
        ),
        const SizedBox(height: 15),
        const Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Text(
            'Filter by:',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterOption('ALl Categories', selectedCategorie, categories),
                FilterOption('ALl Units', selectedUnit, units),
                FilterOption('Price Range', selectedPriceRange, priceRange),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: GridView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: cardWidth / cardHeight,
              // crossAxisSpacing: 8,
              // mainAxisSpacing: 12
            ),
            children: [
              ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                  discountAmount: 220, margin: null),
              ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                  discountAmount: 220, margin: null),
              ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                  discountAmount: 220, margin: null),
              ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                  discountAmount: 220, margin: null),
              ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                  discountAmount: 220, margin: null),
              ProductCard('Fresh Fruits', 240, 'assets/images/product1.png',
                  discountAmount: 220, margin: null),
            ],
          ),
        ),
      ],
    );
  }
}
