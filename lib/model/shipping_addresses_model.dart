// To parse this JSON data, do
//
//     final shippingAddresses = shippingAddressesFromJson(jsonString);

import 'dart:convert';

ShippingAddressesModel shippingAddressesFromJson(String str) =>
    ShippingAddressesModel.fromJson(json.decode(str));

String shippingAddressesToJson(ShippingAddressesModel data) =>
    json.encode(data.toJson());

class ShippingAddressesModel {
  ShippingAddressesModel({
    required this.data,
  });

  List<Datum> data;

  factory ShippingAddressesModel.fromJson(Map<String, dynamic> json) =>
      ShippingAddressesModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.address,
    required this.userId,
  });

  int id;
  String name;
  String address;
  int userId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "user_id": userId,
      };
}
