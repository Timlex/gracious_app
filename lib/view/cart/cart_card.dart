import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/model/carts.dart';
import 'package:gren_mart/model/products.dart';

import '../utils/constant_styles.dart';

class CartCard extends StatefulWidget {
  final String id;
  CartCard(this.id, {Key? key}) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    final cartItem = Products().products.firstWhere(
          (element) => element.id == widget.id,
        );
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
      onDismissed: (direction) {},
      key: Key(widget.id),
      child: SizedBox(
        height: 75,
        child: Column(
          children: [
            ListTile(
              leading: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.asset(
                  cartItem.image[0],
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
                        Text(
                          cartItem.title,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 13),
                        Text(
                          '\$220',
                          style: TextStyle(
                              color: cc.primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
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
                    child: Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(33, 208, 47, 68),
                          ),
                          child: IconButton(
                              // padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/images/icons/minus.svg',
                                color: const Color.fromARGB(255, 208, 47, 68),
                              )),
                        ),
                        Expanded(
                            child: Text(
                          CartData()
                              .cartList
                              .firstWhere((element) => element.id == widget.id)
                              .quantity
                              .toString(),
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
                            color: Color.fromARGB(39, 0, 177, 6),
                          ),
                          child: IconButton(
                              onPressed: () => {},
                              icon: SvgPicture.asset(
                                'assets/images/icons/add.svg',
                                color: cc.primaryColor,
                              )),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (() {}),
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
            if (!(CartData().cartList.last.id == cartItem.id)) const Divider(),
          ],
        ),
      ),
    );
  }
}
