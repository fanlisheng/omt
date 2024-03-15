import 'dart:convert';
import 'dart:ui';

import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/name_value.g.dart';

///  tfblue_flutter_module
///  bean.common
///
///  Created by kayoxu on 2019-06-10 17:05.
///  Copyright © 2019 kayoxu. All rights reserved.

@JsonSerializable()
class NameValue {
  int? id;
  String? name;
  String? value;
  String? valueColor;
  String? classs;
  String? url;

  String? uuid;
  String? path;

  String getUrl() {
    return 'file/${id}/${uuid}';
  }

  NameValue({
    this.id,
    this.name,
    this.value,
    this.url,
    this.path,
    this.uuid,
    this.valueColor,
  });

  factory NameValue.fromJson(Map<String, dynamic> json) =>
      $NameValueFromJson(json);

  Map<String, dynamic> toJson() => $NameValueToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
