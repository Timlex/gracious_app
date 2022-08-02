import 'package:flutter/material.dart';
import 'package:gren_mart/view/favorite/favorite_tile.dart';
import 'package:gren_mart/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../service/favorite_data_service.dart';

class FavoriteView extends StatelessWidget {
  FavoriteView({Key? key}) : super(key: key);
  ConstantColors cc = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Consumer<FavoriteDataService>(
          builder: (context, favoriteData, child) {
        return favoriteData.favoriteItems.isEmpty
            ? Center(
                child: Text(
                  'Add items to favorite',
                  style: TextStyle(color: cc.greyHint),
                ),
              )
            : ListView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: favoriteData.favoriteItems.values.map((e) {
                  return FavoriteTile(e.id);
                }).toList(),
              );
      }),
    );
  }
}
