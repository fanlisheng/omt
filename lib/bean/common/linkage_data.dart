import 'dart:convert';

import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/linkage_data.g.dart';

@JsonSerializable()
class LinkKage {
  int? id;
  int? currentId;
  String? name;
  bool? selected;
  int? hierarchy;
  List<LinkKage>? value;

  LinkKage();

  @override
  String toString() {
    return '$name';
  }

  factory LinkKage.fromJson(Map<String, dynamic> json) =>
      $LinkKageFromJson(json);

  Map<String, dynamic> toJson() => $LinkKageToJson(this);
}

@JsonSerializable()
class LinkKageType {
  int? id;
  LinkKage? linkKage;
  LinkKageType();
  factory LinkKageType.fromJson(Map<String, dynamic> json) =>
      $LinkKageTypeFromJson(json);

  Map<String, dynamic> toJson() => $LinkKageTypeToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
