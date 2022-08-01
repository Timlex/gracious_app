import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gren_mart/model/cart_data.dart';
import 'package:gren_mart/model/favorite_data.dart';
import 'package:gren_mart/model/product_data.dart';
import 'package:gren_mart/view/details/product_details.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final int _id;
  final String title;
  final int price;
  final double campaignPercentage;
  final String imgUrl;
  final int discountPrice;
  final bool isCartable;

  EdgeInsetsGeometry? margin;

  ProductCard(
    this._id,
    this.title,
    this.price,
    this.discountPrice,
    this.campaignPercentage,
    this.imgUrl,
    this.isCartable, {
    Key? key,
    this.margin = const EdgeInsets.only(right: 18),
  }) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetails.routeName, arguments: [_id]);
      },
      child: Container(
        width: screenWidth / 2.57,
        height: screenHight / 3.7,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: cc.pureWhite,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: screenHight / 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: cc.whiteGrey),
                  child:
                      // Hero(
                      //   tag: product.id,
                      //   child:
                      ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    //  const BorderRadius.only(
                    //     topLeft: Radius.circular(10),
                    //     topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imgUrl,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/skelleton.png',
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  // ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 13),
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    color: cc.pureWhite,
                  ),
                  child: Text(
                    'New',
                    style: TextStyle(
                        color: cc.blackColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                if (campaignPercentage > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 35),
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      color: cc.orange,
                    ),
                    child: Text(
                      campaignPercentage.toString(),
                      style: TextStyle(
                          color: cc.pureWhite,
                          fontSize: 10,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                Consumer<FavoriteData>(builder: (context, favoriteData, child) {
                  return Positioned(
                      right: 0,
                      child:
                          favoriteIcon(favoriteData.isfavorite(_id.toString()),
                              onPressed: () => favoriteData.toggleFavorite(
                                    _id.toString(),
                                    product: Product(
                                        id: _id.toString(),
                                        title: title,
                                        amount: price.toDouble(),
                                        discountPecentage:
                                            campaignPercentage.toDouble(),
                                        image: [imgUrl]),
                                  )));
                })
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  discAmountRow(discountPrice, price),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pushReplacementNamed(Auth.routeName);
                    },
                    child: Consumer<CartData>(
                      builder: (context, cartData, child) {
                        return GestureDetector(
                          onTap: isCartable
                              ? () {
                                  cartData.addCartItem(
                                    _id.toString(),
                                    Product(
                                        id: _id.toString(),
                                        title: title,
                                        amount: price.toDouble(),
                                        discountPecentage:
                                            campaignPercentage.toDouble(),
                                        image: [imgUrl]),
                                  );
                                }
                              : (() {}),
                          child: child,
                        );
                      },
                      child: Container(
                          height: 40,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: ConstantColors().primaryColor,
                            ),
                          ),
                          child: Text(
                            'Add to cart',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ConstantColors().primaryColor,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
