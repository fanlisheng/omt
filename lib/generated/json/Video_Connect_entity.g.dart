import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/video/video_configuration/Video_Connect_entity.dart';

VideoConnectEntity $VideoConnectEntityFromJson(Map<String, dynamic> json) {
  final VideoConnectEntity videoConnectEntity = VideoConnectEntity();
  final String? tcpAddr = jsonConvert.convert<String>(json['tcp_addr']);
  if (tcpAddr != null) {
    videoConnectEntity.tcpAddr = tcpAddr;
  }
  final String? httpAddr = jsonConvert.convert<String>(json['http_addr']);
  if (httpAddr != null) {
    videoConnectEntity.httpAddr = httpAddr;
  }
  final String? key = jsonConvert.convert<String>(json['key']);
  if (key != null) {
    videoConnectEntity.key = key;
  }
  final String? secret = jsonConvert.convert<String>(json['secret']);
  if (secret != null) {
    videoConnectEntity.secret = secret;
  }
  final String? auth = jsonConvert.convert<String>(json['auth']);
  if (auth != null) {
    videoConnectEntity.auth = auth;
  }
  return videoConnectEntity;
}

Map<String, dynamic> $VideoConnectEntityToJson(VideoConnectEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['tcp_addr'] = entity.tcpAddr;
  data['http_addr'] = entity.httpAddr;
  data['key'] = entity.key;
  data['secret'] = entity.secret;
  data['auth'] = entity.auth;
  return data;
}

extension VideoConnectEntityExtension on VideoConnectEntity {
  VideoConnectEntity copyWith({
    String? tcpAddr,
    String? httpAddr,
    String? key,
    String? secret,
    String? auth,
  }) {
    return VideoConnectEntity()
      ..tcpAddr = tcpAddr ?? this.tcpAddr
      ..httpAddr = httpAddr ?? this.httpAddr
      ..key = key ?? this.key
      ..secret = secret ?? this.secret
      ..auth = auth ?? this.auth;
  }
}

VideoInfoEntity $VideoInfoEntityFromJson(Map<String, dynamic> json) {
  final VideoInfoEntity videoInfoEntity = VideoInfoEntity();
  final VideoInfoCamEntity? webcam =
      jsonConvert.convert<VideoInfoCamEntity>(json['webcam']);
  if (webcam != null) {
    videoInfoEntity.webcam = webcam;
  }
  final VideoInfoRectEntity? rect1 =
      jsonConvert.convert<VideoInfoRectEntity>(json['rect1']);
  if (rect1 != null) {
    videoInfoEntity.rect1 = rect1;
  }
  final VideoInfoRectEntity? rect2 =
      jsonConvert.convert<VideoInfoRectEntity>(json['rect2']);
  if (rect2 != null) {
    videoInfoEntity.rect2 = rect2;
  }
  final VideoInfoRectEntity? rect3 =
      jsonConvert.convert<VideoInfoRectEntity>(json['rect3']);
  if (rect3 != null) {
    videoInfoEntity.rect3 = rect3;
  }
  final VideoInfoRectEntity? rect4 =
      jsonConvert.convert<VideoInfoRectEntity>(json['rect4']);
  if (rect4 != null) {
    videoInfoEntity.rect4 = rect4;
  }
  final VideoInfoOtherEntity? other =
      jsonConvert.convert<VideoInfoOtherEntity>(json['other']);
  if (other != null) {
    videoInfoEntity.other = other;
  }
  return videoInfoEntity;
}

Map<String, dynamic> $VideoInfoEntityToJson(VideoInfoEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['webcam'] = entity.webcam?.toJson();
  data['rect1'] = entity.rect1?.toJson();
  data['rect2'] = entity.rect2?.toJson();
  data['rect3'] = entity.rect3?.toJson();
  data['rect4'] = entity.rect4?.toJson();
  data['other'] = entity.other?.toJson();
  return data;
}

extension VideoInfoEntityExtension on VideoInfoEntity {
  VideoInfoEntity copyWith({
    VideoInfoCamEntity? webcam,
    VideoInfoRectEntity? rect1,
    VideoInfoRectEntity? rect2,
    VideoInfoRectEntity? rect3,
    VideoInfoRectEntity? rect4,
    VideoInfoOtherEntity? other,
  }) {
    return VideoInfoEntity()
      ..webcam = webcam ?? this.webcam
      ..rect1 = rect1 ?? this.rect1
      ..rect2 = rect2 ?? this.rect2
      ..rect3 = rect3 ?? this.rect3
      ..rect4 = rect4 ?? this.rect4
      ..other = other ?? this.other;
  }
}

VideoInfoCamEntity $VideoInfoCamEntityFromJson(Map<String, dynamic> json) {
  final VideoInfoCamEntity videoInfoCamEntity = VideoInfoCamEntity();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    videoInfoCamEntity.name = name;
  }
  final String? value = jsonConvert.convert<String>(json['value']);
  if (value != null) {
    videoInfoCamEntity.value = value;
  }
  final String? rtsp = jsonConvert.convert<String>(json['rtsp']);
  if (rtsp != null) {
    videoInfoCamEntity.rtsp = rtsp;
  }
  final int? in_out = jsonConvert.convert<int>(json['in_out']);
  if (in_out != null) {
    videoInfoCamEntity.in_out = in_out;
  }
  final String? nvr = jsonConvert.convert<String>(json['nvr']);
  if (nvr != null) {
    videoInfoCamEntity.nvr = nvr;
  }
  return videoInfoCamEntity;
}

Map<String, dynamic> $VideoInfoCamEntityToJson(VideoInfoCamEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['value'] = entity.value;
  data['rtsp'] = entity.rtsp;
  data['in_out'] = entity.in_out;
  data['nvr'] = entity.nvr;
  return data;
}

extension VideoInfoCamEntityExtension on VideoInfoCamEntity {
  VideoInfoCamEntity copyWith({
    String? name,
    String? value,
    String? rtsp,
    int? in_out,
    String? nvr,
  }) {
    return VideoInfoCamEntity()
      ..name = name ?? this.name
      ..value = value ?? this.value
      ..rtsp = rtsp ?? this.rtsp
      ..in_out = in_out ?? this.in_out
      ..nvr = nvr ?? this.nvr;
  }
}

VideoInfoRectEntity $VideoInfoRectEntityFromJson(Map<String, dynamic> json) {
  final VideoInfoRectEntity videoInfoRectEntity = VideoInfoRectEntity();
  final int? x = jsonConvert.convert<int>(json['x']);
  if (x != null) {
    videoInfoRectEntity.x = x;
  }
  final int? y = jsonConvert.convert<int>(json['y']);
  if (y != null) {
    videoInfoRectEntity.y = y;
  }
  final int? width = jsonConvert.convert<int>(json['width']);
  if (width != null) {
    videoInfoRectEntity.width = width;
  }
  final int? height = jsonConvert.convert<int>(json['height']);
  if (height != null) {
    videoInfoRectEntity.height = height;
  }
  return videoInfoRectEntity;
}

Map<String, dynamic> $VideoInfoRectEntityToJson(VideoInfoRectEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['x'] = entity.x;
  data['y'] = entity.y;
  data['width'] = entity.width;
  data['height'] = entity.height;
  return data;
}

extension VideoInfoRectEntityExtension on VideoInfoRectEntity {
  VideoInfoRectEntity copyWith({
    int? x,
    int? y,
    int? width,
    int? height,
  }) {
    return VideoInfoRectEntity()
      ..x = x ?? this.x
      ..y = y ?? this.y
      ..width = width ?? this.width
      ..height = height ?? this.height;
  }
}

VideoInfoOtherEntity $VideoInfoOtherEntityFromJson(Map<String, dynamic> json) {
  final VideoInfoOtherEntity videoInfoOtherEntity = VideoInfoOtherEntity();
  final int? time_interval = jsonConvert.convert<int>(json['time_interval']);
  if (time_interval != null) {
    videoInfoOtherEntity.time_interval = time_interval;
  }
  final int? offset = jsonConvert.convert<int>(json['offset']);
  if (offset != null) {
    videoInfoOtherEntity.offset = offset;
  }
  return videoInfoOtherEntity;
}

Map<String, dynamic> $VideoInfoOtherEntityToJson(VideoInfoOtherEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['time_interval'] = entity.time_interval;
  data['offset'] = entity.offset;
  return data;
}

extension VideoInfoOtherEntityExtension on VideoInfoOtherEntity {
  VideoInfoOtherEntity copyWith({
    int? time_interval,
    int? offset,
  }) {
    return VideoInfoOtherEntity()
      ..time_interval = time_interval ?? this.time_interval
      ..offset = offset ?? this.offset;
  }
}
