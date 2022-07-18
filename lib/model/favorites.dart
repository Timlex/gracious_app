class Favorites {
  String id;
  Favorites(this.id);
}

class FavoriteData {
  final List<Favorites> _favoriteList = [
    Favorites('01'),
    Favorites('02'),
    Favorites('03'),
    Favorites('04'),
  ];

  List<Favorites> get favoriteList {
    return _favoriteList;
  }

  void deleteFavorite(String id) {
    _favoriteList.removeWhere((element) => element.id == id);
  }
}
