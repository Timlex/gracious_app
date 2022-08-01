// To parse this JSON data, do
//
//     final subCategoryModel = subCategoryModelFromJson(jsonString);

import 'dart:convert';

SubCategoryModel subCategoryModelFromJson(String str) =>
    SubCategoryModel.fromJson(json.decode(str));

String subCategoryModelToJson(SubCategoryModel data) =>
    json.encode(data.toJson());

class SubCategoryModel {
  SubCategoryModel({
    required this.subcategories,
  });

  List<Subcategory> subcategories;

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
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
