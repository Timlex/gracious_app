class Cart {
  final int id;
  String title;
  int price;
  int discountPrice;
  double campaignPercentage;
  int quantity;
  String imgUrl;

  Cart(
    this.id,
    this.title,
    this.price,
    this.discountPrice,
    this.campaignPercentage,
    this.quantity,
    this.imgUrl,
  );
}
