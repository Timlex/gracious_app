import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:money_formatter/money_formatter.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List categories = [
    'Fruits',
    'Cooking',
    'Backing',
    'Snacks',
    'Drinks',
  ];
  List units = [
    'Bottle',
    'Kg',
    'Piece',
    'Dozen',
    'Pound',
    'Litre',
  ];

  String selectedCategorie = 'Cooking';
  String selectedUnit = 'Dozen';
  RangeValues _currentRangeValues = RangeValues(1045, 3100);

  @override
  Widget build(BuildContext context) {
    MoneyFormatter startRange =
        MoneyFormatter(amount: _currentRangeValues.start);
    MoneyFormatter endRange = MoneyFormatter(amount: _currentRangeValues.end);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: categories
                .map((e) => GestureDetector(
                    onTap: () {
                      if (e == selectedCategorie) {
                        return;
                      }
                      setState(() {
                        selectedCategorie = e;
                      });
                    },
                    child: filterOption(e, e == selectedCategorie)))
                .toList(),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: textFieldTitle('All Units', fontSize: 13),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Row(
            children: units
                .map((e) => GestureDetector(
                    onTap: () {
                      if (e == selectedUnit) {
                        return;
                      }
                      setState(() {
                        selectedUnit = e;
                      });
                    },
                    child: filterOption(e, e == selectedUnit)))
                .toList(),
          ),
        ),
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
      RangeSlider(
        values: _currentRangeValues,
        max: 3500,

        // divisions: 5,
        activeColor: cc.primaryColor,

        inactiveColor: cc.lightPrimery3,
        labels: RangeLabels(
          _currentRangeValues.start.round().toString(),
          _currentRangeValues.end.round().toString(),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            _currentRangeValues = values;
          });
        },
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: textFieldTitle('Average Rating', fontSize: 13),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 25.0),
        child: RatingBar.builder(
          itemSize: 24,
          initialRating: 3,
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
            print(rating);
          },
        ),
      ),
      const SizedBox(height: 40),
      Padding(
        padding: const EdgeInsets.all(10),
        child: customRowButton('Reset Filter', 'Apply Filter', () {
          Navigator.of(context).pop();
        }, () {
          Navigator.of(context).pop();
        }),
      ),
      const SizedBox(height: 10),
    ]);
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