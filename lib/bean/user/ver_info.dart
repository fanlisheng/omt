import 'package:omt/generated/json/base/json_field.dart';
import 'dart:convert';
import 'package:omt/generated/json/ver_info.g.dart';

@JsonSerializable()
class VerInfo {
  String? url;
  String? version;
  String? description;

  VerInfo();

  factory VerInfo.fromJson(Map<String, dynamic> json) => $VerInfoFromJson(json);

  Map<String, dynamic> toJson() => $VerInfoToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VerInfoRet {
  VerInfo? data;

  VerInfoRet();

  factory VerInfoRet.fromJson(Map<String, dynamic> json) =>
      $VerInfoRetFromJson(json);

  Map<String, dynamic> toJson() => $VerInfoRetToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
