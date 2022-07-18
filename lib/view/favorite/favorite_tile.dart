import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/model/favorites.dart';
import 'package:gren_mart/model/products.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';

class FavoriteTile extends StatefulWidget {
  final String id;

  FavoriteTile(this.id, {Key? key}) : super(key: key);

  @override
  State<FavoriteTile> createState() => _FavoriteTileState();
}

class _FavoriteTileState extends State<FavoriteTile> {
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    final favoriteItem =
        Products().products.firstWhere((e) => e.id == widget.id);
    return Dismissible(
      dragStartBehavior: DragStartBehavior.start,
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
        FavoriteData().deleteFavorite(widget.id);
        print(FavoriteData().favoriteList.length.toString());
      },
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
                  favoriteItem.image[0],
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
                          favoriteItem.title,
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
                  GestureDetector(
                    onTap: (() {
                      FavoriteData().deleteFavorite(widget.id);
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
            // if (!(CartData().cartList.last == ele)) const Divider(),
          ],
        ),
      ),
    );
    ;
  }
}
