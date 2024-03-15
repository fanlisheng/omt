import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/common/linkage_data.dart';

LinkKage $LinkKageFromJson(Map<String, dynamic> json) {
  final LinkKage linkKage = LinkKage();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    linkKage.id = id;
  }
  final int? currentId = jsonConvert.convert<int>(json['currentId']);
  if (currentId != null) {
    linkKage.currentId = currentId;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    linkKage.name = name;
  }
  final bool? selected = jsonConvert.convert<bool>(json['selected']);
  if (selected != null) {
    linkKage.selected = selected;
  }
  final int? hierarchy = jsonConvert.convert<int>(json['hierarchy']);
  if (hierarchy != null) {
    linkKage.hierarchy = hierarchy;
  }
  final List<LinkKage>? value = (json['value'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<LinkKage>(e) as LinkKage).toList();
  if (value != null) {
    linkKage.value = value;
  }
  return linkKage;
}

Map<String, dynamic> $LinkKageToJson(LinkKage entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['currentId'] = entity.currentId;
  data['name'] = entity.name;
  data['selected'] = entity.selected;
  data['hierarchy'] = entity.hierarchy;
  data['value'] = entity.value?.map((v) => v.toJson()).toList();
  return data;
}

extension LinkKageExtension on LinkKage {
  LinkKage copyWith({
    int? id,
    int? currentId,
    String? name,
    bool? selected,
    int? hierarchy,
    List<LinkKage>? value,
  }) {
    return LinkKage()
      ..id = id ?? this.id
      ..currentId = currentId ?? this.currentId
      ..name = name ?? this.name
      ..selected = selected ?? this.selected
      ..hierarchy = hierarchy ?? this.hierarchy
      ..value = value ?? this.value;
  }
}

LinkKageType $LinkKageTypeFromJson(Map<String, dynamic> json) {
  final LinkKageType linkKageType = LinkKageType();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    linkKageType.id = id;
  }
  final LinkKage? linkKage = jsonConvert.convert<LinkKage>(json['linkKage']);
  if (linkKage != null) {
    linkKageType.linkKage = linkKage;
  }
  return linkKageType;
}

Map<String, dynamic> $LinkKageTypeToJson(LinkKageType entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['linkKage'] = entity.linkKage?.toJson();
  return data;
}

extension LinkKageTypeExtension on LinkKageType {
  LinkKageType copyWith({
    int? id,
    LinkKage? linkKage,
  }) {
    return LinkKageType()
      ..id = id ?? this.id
      ..linkKage = linkKage ?? this.linkKage;
  }
}