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
    required this.categories,
  });

  List<Category> categories;

  factory CampaignProductModel.fromJson(Map<String, dynamic> json) =>
      CampaignProductModel(
        categories: List<Category>.from(
            json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    required this.id,
    required this.title,
    this.image,
    this.imageUrl,
  });

  int id;
  String title;
  String? imageUrl;
  String? image;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "image_url": imageUrl,
      };
}
