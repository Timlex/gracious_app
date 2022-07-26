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

  List<State> state;

  factory StateDropdownModel.fromJson(Map<String, dynamic> json) =>
      StateDropdownModel(
        state: List<State>.from(json["state"].map((x) => State.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "state": List<dynamic>.from(state.map((x) => x.toJson())),
      };
}

class State {
  State({
    required this.id,
    required this.name,
    required this.countryId,
  });

  int id;
  String name;
  int countryId;

  factory State.fromJson(Map<String, dynamic> json) => State(
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
