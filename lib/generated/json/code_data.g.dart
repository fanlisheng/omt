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