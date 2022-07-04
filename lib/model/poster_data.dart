class Poster {
  final String id;
  final String title;
  final String description;
  final String image;

  Poster(this.id, this.title, this.description, this.image);
}

class PosterData {
  final List<Poster> _posterData = [
    Poster('01', 'Save up to 30% off', 'Get best Deals and best offer from us.',
        'assets/images/man_with_grocery.png'),
    Poster('01', 'Save up to 30% off', 'Get best Deals and best offer from us.',
        'assets/images/man_with_grocery.png'),
    Poster('01', 'Save up to 30% off', 'Get best Deals and best offer from us.',
        'assets/images/man_with_grocery.png'),
  ];

  List<Poster> get posterData {
    return _posterData;
  }
}
