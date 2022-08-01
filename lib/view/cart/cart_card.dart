import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/model/cart_data.dart';
import 'package:gren_mart/view/utils/constant_name.dart';
import 'package:provider/provider.dart';

import '../utils/constant_styles.dart';

class CartCard extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final int quantity;
  final double price;
  const CartCard(
    this.id,
    this.name,
    this.image,
    this.quantity,
    this.price, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final carts = Provider.of<CartData>(context, listen: false);
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
      key: Key(id),
      child: SizedBox(
        height: screenWidth / 4.3,
        child: Column(
          children: [
            ListTile(
              leading: Container(
                height: screenWidth / 4.3,
                width: screenWidth / 7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          child: Text(
                            name,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 13),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            '\$$price',
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
                    child: Consumer<CartData>(builder: (context, cart, child) {
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
