import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/common/name_value.dart';

NameValue $NameValueFromJson(Map<String, dynamic> json) {
  final NameValue nameValue = NameValue();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    nameValue.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    nameValue.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    nameValue.value = value;
  }
  final String? valueColor = jsonConvert.convert<String>(json['valueColor']);
  if (valueColor != null) {
    nameValue.valueColor = valueColor;
  }
  final String? classs = jsonConvert.convert<String>(json['classs']);
  if (classs != null) {
    nameValue.classs = classs;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    nameValue.url = url;
  }
  final String? uuid = jsonConvert.convert<String>(json['uuid']);
  if (uuid != null) {
    nameValue.uuid = uuid;
  }
  final String? path = jsonConvert.convert<String>(json['path']);
  if (path != null) {
    nameValue.path = path;
  }
  return nameValue;
}

Map<String, dynamic> $NameValueToJson(NameValue entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['valueColor'] = entity.valueColor;
  data['classs'] = entity.classs;
  data['url'] = entity.url;
  data['uuid'] = entity.uuid;
  data['path'] = entity.path;
  return data;
}

extension NameValueExtension on NameValue {
  NameValue copyWith({
    int? id,
    String? name,
    String? value,
    String? valueColor,
    String? classs,
    String? url,
    String? uuid,
    String? path,
  }) {
    return NameValue()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..valueColor = valueColor ?? this.valueColor
      ..classs = classs ?? this.classs
      ..url = url ?? this.url
      ..uuid = uuid ?? this.uuid
      ..path = path ?? this.path;
  }
}