import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/view/details/product_details.dart';
import '../../view/utils/constant_name.dart';
import 'package:provider/provider.dart';

import '../../service/cart_data_service.dart';
import '../utils/constant_styles.dart';

class CartTile extends StatelessWidget {
  final int id;
  final String name;
  final String image;
  final int quantity;
  final int price;
  int discountPrice;
  CartTile(
    this.id,
    this.name,
    this.image,
    this.quantity,
    this.price,
    this.discountPrice, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(discountPrice);
    final carts = Provider.of<CartDataService>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        color: cc.pink,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Spacer(),
            Text(
              'Delete',
              style: TextStyle(color: cc.pureWhite, fontSize: 17),
            ),
            const SizedBox(width: 15),
            SvgPicture.asset(
              'assets/images/icons/trash.svg',
              height: 22,
              width: 22,
              color: cc.pureWhite,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        carts.deleteCartItem(id);
      },
      key: Key(id.toString()),
      child: SizedBox(
        height: screenWidth / 4.3,
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(ProductDetails.routeName, arguments: [id]);
              },
              leading: Container(
                  height: screenWidth / 4.3,
                  width: screenWidth / 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    //  const BorderRadius.only(
                    //     topLeft: Radius.circular(10),
                    //     topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: image,
                      placeholder: (context, url) => Image.asset(
                        'assets/images/skelleton.png',
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: screenWidth / 2.5,
                          child: Text(
                            name,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        const SizedBox(height: 13),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            '\$${discountPrice == 0 ? price : discountPrice}',
                            style: TextStyle(
                                color: cc.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: cc.pureWhite,
                        border: Border.all(
                            width: .4, color: cc.greyTextFieldLebel)),
                    height: 48,
                    width: 105,
                    child: Consumer<CartDataService>(
                        builder: (context, cart, child) {
                      return Row(
                        children: [
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(33, 208, 47, 68),
                            ),
                            child: IconButton(
                                // padding: EdgeInsets.zero,
                                onPressed: () {
                                  cart.minusItem(id);
                                },
                                icon: SvgPicture.asset(
                                  'assets/images/icons/minus.svg',
                                  color: const Color.fromARGB(255, 208, 47, 68),
                                )),
                          ),
                          Expanded(
                              child: Text(
                            quantity.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xff475467),
                                fontWeight: FontWeight.w600),
                          )),
                          Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(39, 0, 177, 6),
                            ),
                            child: IconButton(
                                onPressed: () => cart.addItem(id),
                                icon: SvgPicture.asset(
                                  'assets/images/icons/add.svg',
                                  color: cc.primaryColor,
                                )),
                          ),
                        ],
                      );
                    }),
                  ),
                  GestureDetector(
                    onTap: (() {
                      carts.deleteCartItem(id);
                    }),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: SvgPicture.asset(
                        'assets/images/icons/trash.svg',
                        height: 22,
                        width: 22,
                        color: const Color(0xffFF4065),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // if (!(CartData().cartList.values.last.id == id))
            const Divider(),
          ],
        ),
      ),
    );
  }
}
