// To parse this JSON data, do
//
//     final stateDropdownModel = stateDropdownModelFromJson(jsonString);

import 'dart:convert';

StateDropdownModel stateDropdownModelFromJson(String str) =>
    StateDropdownModel.fromJson(json.decode(str));

String stateDropdownModelToJson(StateDropdownModel data) =>
    json.encode(data.toJson());

class StateDropdownModel {
  StateDropdownModel({
    required this.state,
  });

  List<States> state;

  factory StateDropdownModel.fromJson(Map<String, dynamic> json) =>
      StateDropdownModel(
        state: List<States>.from(json["state"].map((x) => States.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "state": List<dynamic>.from(state.map((x) => x.toJson())),
      };
}

class States {
  States({
    required this.id,
    required this.name,
    required this.countryId,
  });

  int id;
  String name;
  int countryId;

  factory States.fromJson(Map<String, dynamic> json) => States(
        id: json["id"],
        name: json["name"],
        countryId: json["country_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_id": countryId,
      };
}
