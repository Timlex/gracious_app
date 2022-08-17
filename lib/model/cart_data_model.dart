class Cart {
  final int id;
  String title;
  int price;
  int discountPrice;
  double campaignPercentage;
  int quantity;
  String imgUrl;
  String? size;
  String? color;
  String? colorName;
  String? sauce;
  String? mayo;
  String? cheese;

  Cart(
    this.id,
    this.title,
    this.price,
    this.discountPrice,
    this.campaignPercentage,
    this.quantity,
    this.imgUrl, {
    this.size,
    this.color,
    this.colorName,
    this.sauce,
    this.mayo,
    this.cheese,
  });
}
