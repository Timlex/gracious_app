import 'package:flutter/material.dart';
import 'package:gren_mart/model/cart_data.dart';
import 'package:gren_mart/model/favorite_data.dart';
import 'package:gren_mart/model/product_data.dart';
import 'package:gren_mart/view/details/product_details.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:gren_mart/view/utils/constant_styles.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final String _id;

  EdgeInsetsGeometry? margin;

  ProductCard(this._id,
      {Key? key, this.margin = const EdgeInsets.only(right: 18)})
      : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);

    final product = productData.products.firstWhere((e) => e.id == _id);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetails.routeName, arguments: [product.id]);
      },
      child: Container(
        width: 160,
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
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child:
                      // Hero(
                      //   tag: product.id,
                      //   child:
                      Image.asset(
                    product.image[0],
                    fit: BoxFit.cover,
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
                    '09.75%',
                    style: TextStyle(
                        color: cc.pureWhite,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Consumer<FavoriteData>(builder: (context, favoriteData, child) {
                  return Positioned(
                      right: 0,
                      child: favoriteIcon(
                        favoriteData.isfavorite(_id),
                        onPressed: () => favoriteData.toggleFavorite(
                          _id,
                          product: product,
                        ),
                      ));
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
                    product.title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  discAmountRow(
                      ((product.amount -
                          (product.amount / 100) * product.discountPecentage)),
                      product.amount),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pushReplacementNamed(Auth.routeName);
                    },
                    child: Consumer<CartData>(
                      builder: (context, cartData, child) {
                        return GestureDetector(
                          onTap: () {
                            cartData.addCartItem(
                              _id,
                              product,
                            );
                          },
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
