// To parse this JSON data, do
//
//     final campaignProductModel = campaignProductModelFromJson(jsonString);

import 'dart:convert';

CampaignProductModel campaignProductModelFromJson(String str) =>
    CampaignProductModel.fromJson(json.decode(str));

String campaignProductModelToJson(CampaignProductModel data) =>
    json.encode(data.toJson());

class CampaignProductModel {
  CampaignProductModel({
    required this.subcategories,
  });

  List<Subcategory> subcategories;

  factory CampaignProductModel.fromJson(Map<String, dynamic> json) =>
      CampaignProductModel(
        subcategories: List<Subcategory>.from(
            json["subcategories"].map((x) => Subcategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "subcategories":
            List<dynamic>.from(subcategories.map((x) => x.toJson())),
      };
}

class Subcategory {
  Subcategory({
    required this.id,
    required this.title,
    this.image,
    required this.categoryId,
    this.imageUrl,
  });

  int id;
  String title;
  String? image;
  int categoryId;
  String? imageUrl;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        categoryId: json["category_id"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "category_id": categoryId,
        "image_url": imageUrl,
      };
}
