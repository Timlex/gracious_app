import 'package:flutter/material.dart';
import 'package:gren_mart/model/favorites.dart';
import 'package:gren_mart/view/favorite/favorite_tile.dart';
import 'package:provider/provider.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Consumer<FavoriteData>(builder: (context, favoriteData, child) {
        return Column(
          children: favoriteData.favoriteItems.values.map((e) {
            print(e!.title);
            return FavoriteTile(e.id);
          }).toList(),
        );
      }),
    );
  }
}
