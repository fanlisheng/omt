import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/Video_Connect_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/Video_Connect_entity.g.dart';

@JsonSerializable()
class VideoConnectEntity {
  @JSONField(name: "tcp_addr")
  String? tcpAddr;
  @JSONField(name: "http_addr")
  String? httpAddr;
  String? key;
  String? secret;
  String? auth;

  VideoConnectEntity();

  factory VideoConnectEntity.fromJson(Map<String, dynamic> json) =>
      $VideoConnectEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoConnectEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoInfoEntity {
  VideoInfoCamEntity? webcam;
  VideoInfoRectEntity? rect1;
  VideoInfoRectEntity? rect2;
  VideoInfoRectEntity? rect3;
  VideoInfoRectEntity? rect4;
  VideoInfoOtherEntity? other;
  
  VideoInfoEntity();

  factory VideoInfoEntity.fromJson(Map<String, dynamic> json) =>
      $VideoInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoInfoEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoInfoCamEntity {
  String? name;
  String? value;
  String? rtsp;

  /// 1进场 2 出场
  int? in_out;
  String? nvr;

  VideoInfoCamEntity();

  factory VideoInfoCamEntity.fromJson(Map<String, dynamic> json) =>
      $VideoInfoCamEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoInfoCamEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

@JsonSerializable()
class VideoInfoRectEntity {
  int? x;
  int? y;
  int? width;
  int? height;

  VideoInfoRectEntity();

  factory VideoInfoRectEntity.fromJson(Map<String, dynamic> json) =>
      $VideoInfoRectEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoInfoRectEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
@JsonSerializable()
class VideoInfoOtherEntity {
  int? time_interval;
  // 0:无，1:左，2:右
  int? offset;


  VideoInfoOtherEntity();

  factory VideoInfoOtherEntity.fromJson(Map<String, dynamic> json) =>
      $VideoInfoOtherEntityFromJson(json);

  Map<String, dynamic> toJson() => $VideoInfoOtherEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
