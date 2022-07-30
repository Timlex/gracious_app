// To parse this JSON data, do
//
//     final signUpModel = signUpModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel signUpModelFromJson(String str) =>
    UserProfileModel.fromJson(json.decode(str));

String signUpModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
  UserProfileModel({
    required this.userDetails,
  });

  UserDetails userDetails;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      UserProfileModel(
        userDetails: UserDetails.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
        "user_details": userDetails.toJson(),
      };
}

class UserDetails {
  UserDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.emailVerified,
    this.emailVerifyToken,
    required this.phone,
    this.address,
    this.state,
    this.city,
    this.zipcode,
    required this.country,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.facebookId,
    this.googleId,
    this.profileImageUrl,
    required this.shipping,
  });

  int id;
  String name;
  String email;
  String username;
  String emailVerified;
  dynamic emailVerifyToken;
  String phone;
  dynamic address;
  dynamic state;
  dynamic city;
  dynamic zipcode;
  Country country;
  dynamic image;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic facebookId;
  dynamic googleId;
  dynamic profileImageUrl;
  List<dynamic> shipping;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        username: json["username"],
        emailVerified: json["email_verified"],
        emailVerifyToken: json["email_verify_token"],
        phone: json["phone"],
        address: json["address"],
        state: json["state"],
        city: json["city"],
        zipcode: json["zipcode"],
        country: Country.fromJson(json["country"]),
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        facebookId: json["facebook_id"],
        googleId: json["google_id"],
        profileImageUrl: json["profile_image_url"],
        shipping: List<dynamic>.from(json["shipping"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "username": username,
        "email_verified": emailVerified,
        "email_verify_token": emailVerifyToken,
        "phone": phone,
        "address": address,
        "state": state,
        "city": city,
        "zipcode": zipcode,
        "country": country.toJson(),
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "facebook_id": facebookId,
        "google_id": googleId,
        "profile_image_url": profileImageUrl,
        "shipping": List<dynamic>.from(shipping.map((x) => x)),
      };
}

class Country {
  Country({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
