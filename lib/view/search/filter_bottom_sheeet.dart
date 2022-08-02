import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/service/categories_data_service.dart';
import 'package:gren_mart/service/search_result_data_service.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<CategoriesDataService>(context, listen: false)
        .fetchCategories();
    Provider.of<CategoriesDataService>(context, listen: false)
        .fetchSubCategories();
    MoneyFormatter startRange = MoneyFormatter(
        amount: Provider.of<SearchResultDataService>(context).rangevalue.start);
    MoneyFormatter endRange = MoneyFormatter(
        amount: Provider.of<SearchResultDataService>(context).rangevalue.end);
    return Consumer<CategoriesDataService>(builder: (context, catData, chaild) {
      return catData.subCategorydataList.isEmpty
          ? loadingProgressBar()
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(left: 25.0, top: 15),
                child: Text(
                  'Filter by:',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: textFieldTitle('All categories', fontSize: 13),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 25.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: catData.categorydataList.length,
                    itemBuilder: ((context, index) {
                      final e = catData.categorydataList[index];
                      // print(e.title);
                      final isSelected =
                          e.id.toString() == catData.selectedCategorieId;
                      return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              catData.setSelectedCategory('');
                              return;
                            }
                            catData.setSelectedCategory(e.id.toString());
                          },
                          child: filterOption(e.title, isSelected));
                    })),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: textFieldTitle('Sub-category', fontSize: 13),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 25.0),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: catData.subCategorydataList.length,
                    itemBuilder: ((context, index) {
                      final e = catData.subCategorydataList[index];
                      final isSelected =
                          e.id.toString() == catData.selectedSubCategorieId;
                      return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              catData.setSelectedSubCategory('');
                              return;
                            }
                            catData.setSelectedSubCategory(e.id.toString());
                          },
                          child: filterOption(e.title, isSelected));
                    })),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textFieldTitle('Filter Price', fontSize: 13),
                    Container(
                      margin: const EdgeInsets.only(top: 17),
                      child: Text('\$' +
                          startRange.output.withoutFractionDigits +
                          '-' +
                          '\$' +
                          endRange.output.withoutFractionDigits),
                    )
                  ],
                ),
              ),
              Consumer<SearchResultDataService>(
                  builder: (context, srData, child) {
                return RangeSlider(
                  values: srData.rangevalue,
                  max: 3500,

                  // divisions: 5,
                  activeColor: cc.primaryColor,

                  inactiveColor: cc.lightPrimery3,
                  labels: RangeLabels(
                    srData.rangevalue.start.round().toString(),
                    srData.rangevalue.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    srData.setRangeValues(values);
                  },
                );
              }),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: textFieldTitle('Average Rating', fontSize: 13),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Consumer<SearchResultDataService>(
                    builder: (context, srData, child) {
                  return RatingBar.builder(
                    itemSize: 24,
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                    itemBuilder: (context, _) => SvgPicture.asset(
                      'assets/images/icons/star.svg',
                      color: cc.orangeRating,
                    ),
                    onRatingUpdate: (rating) {
                      srData.setRating(rating.toInt());
                      print(rating);
                    },
                  );
                }),
              ),
              const SizedBox(height: 40),
              Consumer<SearchResultDataService>(
                  builder: (context, srData, child) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: customRowButton('Reset Filter', 'Apply Filter', () {
                    Provider.of<CategoriesDataService>(context, listen: false)
                        .setSelectedCategory('');
                    Provider.of<CategoriesDataService>(context, listen: false)
                        .setSelectedSubCategory('');
                    srData.resetSerchFilters();
                    srData.fetchProductsBy(pageNo: '1');
                    Navigator.of(context).pop();
                  }, () {
                    srData.setCategoryId(Provider.of<CategoriesDataService>(
                            context,
                            listen: false)
                        .selectedCategorieId
                        .toString());
                    srData.setSubCategoryId(Provider.of<CategoriesDataService>(
                            context,
                            listen: false)
                        .selectedSubCategorieId
                        .toString());
                    srData.resetSerch();
                    srData.fetchProductsBy(pageNo: '1');
                    Navigator.of(context).pop();
                  }),
                );
              }),
              const SizedBox(height: 10),
            ]);
    });
  }

  Widget filterOption(String text, bool isSelected) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? cc.primaryColor : cc.greyBorder,
            width: 1,
          ),
          color: isSelected ? cc.lightPrimery3 : null),
      child: Row(children: [
        Text(text, style: TextStyle(color: cc.greyHint, fontSize: 12)),
        const SizedBox(width: 5),
        SvgPicture.asset(
          isSelected
              ? 'assets/images/icons/selected_circle.svg'
              : 'assets/images/icons/deselected_circle.svg',
        )
      ]),
    );
  }
}
