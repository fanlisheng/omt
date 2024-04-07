import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/camera/camera_entity.dart';
import 'package:omt/bean/common/code_data.dart';


CameraHttpEntity $CameraHttpEntityFromJson(Map<String, dynamic> json) {
  final CameraHttpEntity cameraHttpEntity = CameraHttpEntity();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    cameraHttpEntity.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    cameraHttpEntity.message = message;
  }
  final CommonPageData? page = jsonConvert.convert<CommonPageData>(
      json['page']);
  if (page != null) {
    cameraHttpEntity.page = page;
  }
  final List<CameraInfoEntity>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<CameraInfoEntity>(e) as CameraInfoEntity)
      .toList();
  if (data != null) {
    cameraHttpEntity.data = data;
  }
  return cameraHttpEntity;
}

Map<String, dynamic> $CameraHttpEntityToJson(CameraHttpEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['page'] = entity.page?.toJson();
  data['data'] = entity.data?.map((v) => v.toJson()).toList();
  return data;
}

extension CameraHttpEntityExtension on CameraHttpEntity {
  CameraHttpEntity copyWith({
    int? code,
    String? message,
    CommonPageData? page,
    List<CameraInfoEntity>? data,
  }) {
    return CameraHttpEntity()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..page = page ?? this.page
      ..data = data ?? this.data;
  }
}

CameraInfoEntity $CameraInfoEntityFromJson(Map<String, dynamic> json) {
  final CameraInfoEntity cameraInfoEntity = CameraInfoEntity();
  final String? gb_id = jsonConvert.convert<String>(json['gb_id']);
  if (gb_id != null) {
    cameraInfoEntity.gb_id = gb_id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    cameraInfoEntity.name = name;
  }
  final String? parent_id = jsonConvert.convert<String>(json['parent_id']);
  if (parent_id != null) {
    cameraInfoEntity.parent_id = parent_id;
  }
  final String? lat = jsonConvert.convert<String>(json['lat']);
  if (lat != null) {
    cameraInfoEntity.lat = lat;
  }
  final String? lng = jsonConvert.convert<String>(json['lng']);
  if (lng != null) {
    cameraInfoEntity.lng = lng;
  }
  final String? pic = jsonConvert.convert<String>(json['pic']);
  if (pic != null) {
    cameraInfoEntity.pic = pic;
  }
  final String? ip_address = jsonConvert.convert<String>(json['ip_address']);
  if (ip_address != null) {
    cameraInfoEntity.ip_address = ip_address;
  }
  final String? rect_data = jsonConvert.convert<String>(json['rect_data']);
  if (rect_data != null) {
    cameraInfoEntity.rect_data = rect_data;
  }
  final int? online = jsonConvert.convert<int>(json['online']);
  if (online != null) {
    cameraInfoEntity.online = online;
  }
  final int? ptz_type = jsonConvert.convert<int>(json['ptz_type']);
  if (ptz_type != null) {
    cameraInfoEntity.ptz_type = ptz_type;
  }
  final String? channel_info = jsonConvert.convert<String>(
      json['channel_info']);
  if (channel_info != null) {
    cameraInfoEntity.channel_info = channel_info;
  }
  final String? point_name = jsonConvert.convert<String>(json['point_name']);
  if (point_name != null) {
    cameraInfoEntity.point_name = point_name;
  }
  return cameraInfoEntity;
}

Map<String, dynamic> $CameraInfoEntityToJson(CameraInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['gb_id'] = entity.gb_id;
  data['name'] = entity.name;
  data['parent_id'] = entity.parent_id;
  data['lat'] = entity.lat;
  data['lng'] = entity.lng;
  data['pic'] = entity.pic;
  data['ip_address'] = entity.ip_address;
  data['rect_data'] = entity.rect_data;
  data['online'] = entity.online;
  data['ptz_type'] = entity.ptz_type;
  data['channel_info'] = entity.channel_info;
  data['point_name'] = entity.point_name;
  return data;
}

extension CameraInfoEntityExtension on CameraInfoEntity {
  CameraInfoEntity copyWith({
    String? gb_id,
    String? name,
    String? parent_id,
    String? lat,
    String? lng,
    String? pic,
    String? ip_address,
    String? rect_data,
    int? online,
    int? ptz_type,
    String? channel_info,
    String? point_name,
  }) {
    return CameraInfoEntity()
      ..gb_id = gb_id ?? this.gb_id
      ..name = name ?? this.name
      ..parent_id = parent_id ?? this.parent_id
      ..lat = lat ?? this.lat
      ..lng = lng ?? this.lng
      ..pic = pic ?? this.pic
      ..ip_address = ip_address ?? this.ip_address
      ..rect_data = rect_data ?? this.rect_data
      ..online = online ?? this.online
      ..ptz_type = ptz_type ?? this.ptz_type
      ..channel_info = channel_info ?? this.channel_info
      ..point_name = point_name ?? this.point_name;
  }
}