import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gren_mart/model/favorite_data.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class FavoriteTile extends StatelessWidget {
  final String id;

  FavoriteTile(this.id, {Key? key}) : super(key: key);

  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteData>(builder: (context, favoriteData, child) {
      final favoriteItem = favoriteData.favoriteItems.values
          .toList()
          .firstWhere((element) => element!.id == id);
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
          favoriteData.deleteFavoriteItem(id);
        },
        key: Key(id),
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
                    favoriteItem!.image[0],
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
                            '\$${favoriteItem.amount}',
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
                        favoriteData.deleteFavoriteItem(id);
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
    });
  }
}
