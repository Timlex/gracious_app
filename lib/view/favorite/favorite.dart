import 'package:flutter/material.dart';
import 'package:gren_mart/model/favorites.dart';
import 'package:gren_mart/view/favorite/favorite_tile.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class FavoriteView extends StatelessWidget {
  FavoriteView({Key? key}) : super(key: key);
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Consumer<FavoriteData>(builder: (context, favoriteData, child) {
        return favoriteData.favoriteItems.isEmpty
            ? Center(
                child: Text(
                  'Add items to favorite',
                  style: TextStyle(color: cc.greyHint),
                ),
              )
            : Column(
                children: favoriteData.favoriteItems.values.map((e) {
                  return FavoriteTile(e!.id);
                }).toList(),
              );
      }),
    );
  }
}
