import 'package:flutter/material.dart';
import 'package:gren_mart/model/favorites.dart';
import 'package:gren_mart/view/favorite/favorite_tile.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children:
            FavoriteData().favoriteList.map((e) => FavoriteTile(e.id)).toList(),
      ),
    );
  }
}
