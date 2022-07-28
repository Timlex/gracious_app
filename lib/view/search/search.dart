import 'package:flutter/material.dart';
import 'package:gren_mart/service/navigation_bar_helper_service.dart';
import 'package:gren_mart/view/auth/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../../model/product_data.dart';
import '../home/product_card.dart';
import '../utils/constant_colors.dart';

class SearchView extends StatefulWidget {
  static const routeName = 'search';
  const SearchView();
  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
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
    // final routeData =
    //     ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return
        // Scaffold(
        // appBar: AppBars().appBarTitled('Search', () {
        //   Navigator.of(context).pop();
        // }, hasButton: true, hasElevation: true, actions: [
        //   IconButton(
        //       onPressed: () {
        //         showMaterialModalBottomSheet(
        //           context: context,
        //           builder: (context) => SingleChildScrollView(
        //             controller: ModalScrollController.of(context),
        //             child: FilterBottomSheet(),
        //           ),
        //         );
        //       },
        //       icon: SvgPicture.asset('assets/images/icons/filter_setting.svg'))
        // ]),
        // body:
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: CustomTextField(
            'Search your need here',
            initialValue:
                Provider.of<NavigationBarHelperService>(context, listen: false)
                    .serchText,
            leadingImage: 'assets/images/icons/search_normal.png',
            onChanged: (value) {
              Provider.of<NavigationBarHelperService>(context, listen: false)
                  .setSearchText(value);
            },
          ),
        ),
        // const SizedBox(height: 15),
        // const Padding(
        //   padding: EdgeInsets.only(right: 20, left: 20),
        //   child: Text(
        //     'Filter by:',
        //     style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        //   ),
        // ),
        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: Padding(
        //     padding: const EdgeInsets.only(right: 20, left: 20),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: [
        //         FilterOption('ALl Categories', selectedCategorie, categories),
        //         FilterOption('ALl Units', selectedUnit, units),
        //         FilterOption('Price Range', selectedPriceRange, priceRange),
        //       ],
        //     ),
        //   ),
        // ),
        const SizedBox(height: 15),
        Expanded(
          child: GridView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: cardWidth / cardHeight,
              crossAxisSpacing: 12,
              // mainAxisSpacing: 12
            ),
            children: Products()
                .products
                .map((e) => ProductCard(
                      e.id,
                    ))
                .toList(),
          ),
        ),
      ],
      // ),
    );
  }
}
