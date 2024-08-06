import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/common/code_data.dart';

CodeMessageData $CodeMessageDataFromJson(Map<String, dynamic> json) {
  final CodeMessageData codeMessageData = CodeMessageData();
  final dynamic id = json['id'];
  if (id != null) {
    codeMessageData.id = id;
  }
  final dynamic code = json['code'];
  if (code != null) {
    codeMessageData.code = code;
  }
  final dynamic message = json['message'];
  if (message != null) {
    codeMessageData.message = message;
  }
  return codeMessageData;
}

Map<String, dynamic> $CodeMessageDataToJson(CodeMessageData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['code'] = entity.code;
  data['message'] = entity.message;
  return data;
}

extension CodeMessageDataExtension on CodeMessageData {
  CodeMessageData copyWith({
    dynamic id,
    dynamic code,
    dynamic message,
  }) {
    return CodeMessageData()
      ..id = id ?? this.id
      ..code = code ?? this.code
      ..message = message ?? this.message;
  }
}

CommonPageData $CommonPageDataFromJson(Map<String, dynamic> json) {
  final CommonPageData commonPageData = CommonPageData();
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    commonPageData.total = total;
  }
  final int? page = jsonConvert.convert<int>(json['page']);
  if (page != null) {
    commonPageData.page = page;
  }
  final int? limit = jsonConvert.convert<int>(json['limit']);
  if (limit != null) {
    commonPageData.limit = limit;
  }
  return commonPageData;
}

Map<String, dynamic> $CommonPageDataToJson(CommonPageData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['total'] = entity.total;
  data['page'] = entity.page;
  data['limit'] = entity.limit;
  return data;
}

extension CommonPageDataExtension on CommonPageData {
  CommonPageData copyWith({
    int? total,
    int? page,
    int? limit,
  }) {
    return CommonPageData()
      ..total = total ?? this.total
      ..page = page ?? this.page
      ..limit = limit ?? this.limit;
  }
}
