import 'dart:convert';

import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/code_data.g.dart';

@JsonSerializable()
class CodeMessageData {
  var id;
  var code;
  var message;

  CodeMessageData();

  factory CodeMessageData.fromJson(Map<String, dynamic> json) =>
      $CodeMessageDataFromJson(json);

  Map<String, dynamic> toJson() => $CodeMessageDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
