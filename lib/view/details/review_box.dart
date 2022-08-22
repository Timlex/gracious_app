import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/service/product_details_service.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../utils/constant_name.dart';
import '../utils/constant_styles.dart';

class ReviewBox extends StatelessWidget {
  bool expanded;
  void Function()? onPressed;
  ReviewBox(this.expanded, {this.onPressed, Key? key}) : super(key: key);

  // final reviewData = [
  //   {
  //     'username': 'Jack',
  //     'rating': 2,
  //     'comment': 'afasd sfdghfg hf hsfsjfkh',
  //     'date': DateTime(2022, 7, 15)
  //   },
  //   {
  //     'username': 'James',
  //     'rating': 5,
  //     'comment': 'afasd sfdghfg hf hsfsjfkh ha fhbfs shfsajf hsfjh;hsjfh',
  //     'date': DateTime(2022, 5, 15)
  //   },
  //   {
  //     'username': 'Joe',
  //     'rating': 3,
  //     'comment':
  //         'afasd sfdghfg hf hsfsjfkh ha fhbfs shfsajf hsfjh;hsjfhafasd sfdghfg hf hsfsjfkh ha fhbfs shfsajf hsfjh;hsjfh',
  //     'date': DateTime(2022, 3, 15)
  //   },
  // ];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: false,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          title: const Text(
            'Review',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          ),
          trailing: IconButton(
              icon: Icon(
                expanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: onPressed),
        ),
        if (expanded &&
            Provider.of<ProductDetailsService>(context)
                .productDetails!
                .userRatedAlready &&
            Provider.of<ProductDetailsService>(context)
                    .productDetails!
                    .userHasItem !=
                null)
          submitReview(),
        if (expanded)
          ...descriptions(Provider.of<ProductDetailsService>(context))
      ],
    );
  }

  List<Widget> descriptions(ProductDetailsService pService) {
    List<Widget> reviewList = [];
    for (var element in pService.productDetails!.product.rating!) {
      reviewList.add(Card(
        // color: cc.greyBorder,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(element.userId.toString(),
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: cc.greyParagraph)),
              const SizedBox(height: 10),
              RatingBar.builder(
                ignoreGestures: true,
                itemSize: 15,
                initialRating: (element.rating).toDouble(),
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                itemBuilder: (context, _) => SvgPicture.asset(
                  'assets/images/icons/star.svg',
                  color: cc.orangeRating,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              const SizedBox(height: 10),
              Text(element.reviewMsg,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    color: cc.greyParagraph,
                    fontSize: 14,
                  )),
              const SizedBox(height: 10),
              Text(timeago.format(element.createdAt),
                  style: TextStyle(color: cc.greyHint, fontSize: 12)),
              // const Divider(),
            ],
          ),
        ),
      ));
    }
    // for (var element in pService.productDetails!.ratings ?? []) {

    // }
    return reviewList;
  }

  Widget submitReview() {
    return Form(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: cc.whiteGrey),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Your rating',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: cc.greyParagraph)),
          const SizedBox(height: 10),
          RatingBar.builder(
            // ignoreGestures: true,
            itemSize: 17,
            initialRating: 1,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 1),
            itemBuilder: (context, _) => SvgPicture.asset(
              'assets/images/icons/star.svg',
              color: cc.orangeRating,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          const SizedBox(height: 10),
          Text('Your review',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: cc.greyParagraph)),
          const SizedBox(height: 10),
          SizedBox(
            height: screenHight / 7,
            // margin: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              maxLines: 4,
              controller: _controller,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Write yor feedback.',
                hintStyle: TextStyle(color: cc.greyHint, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: cc.greyBorder2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: cc.greyBorder2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: cc.primaryColor),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: cc.pink),
                ),
              ),
              onChanged: (value) {
                // tcService.setMessage(value);
              },
            ),
          ),
          const SizedBox(height: 30),
          customBorderButton('Submit', () {}, width: double.infinity),
          const SizedBox(height: 20),
        ],
      ),
    ));
  }
}
