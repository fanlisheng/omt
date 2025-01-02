import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/user/ver_info.dart';

VerInfo $VerInfoFromJson(Map<String, dynamic> json) {
  final VerInfo verInfo = VerInfo();
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    verInfo.url = url;
  }
  final String? version = jsonConvert.convert<String>(json['version']);
  if (version != null) {
    verInfo.version = version;
  }
  final String? description = jsonConvert.convert<String>(json['description']);
  if (description != null) {
    verInfo.description = description;
  }
  return verInfo;
}

Map<String, dynamic> $VerInfoToJson(VerInfo entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['url'] = entity.url;
  data['version'] = entity.version;
  data['description'] = entity.description;
  return data;
}

extension VerInfoExtension on VerInfo {
  VerInfo copyWith({
    String? url,
    String? version,
    String? description,
  }) {
    return VerInfo()
      ..url = url ?? this.url
      ..version = version ?? this.version
      ..description = description ?? this.description;
  }
}

VerInfoRet $VerInfoRetFromJson(Map<String, dynamic> json) {
  final VerInfoRet verInfoRet = VerInfoRet();
  final VerInfo? data = jsonConvert.convert<VerInfo>(json['data']);
  if (data != null) {
    verInfoRet.data = data;
  }
  return verInfoRet;
}

Map<String, dynamic> $VerInfoRetToJson(VerInfoRet entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.toJson();
  return data;
}

extension VerInfoRetExtension on VerInfoRet {
  VerInfoRet copyWith({
    VerInfo? data,
  }) {
    return VerInfoRet()
      ..data = data ?? this.data;
  }
}