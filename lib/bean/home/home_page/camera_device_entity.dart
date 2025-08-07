import 'package:fluent_ui/fluent_ui.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'dart:convert';

import 'device_detail_ai_entity.dart';

// @JsonSerializable()
//
class CameraDeviceEntity {
  bool? isOpen = false;
  String? rtsp;
  String? code;

  String? mac;
  String? ip;

  //不允许编辑
  bool readOnly = false;
  bool isAddEnd = false; //添加完成的标识
  DeviceDetailAiData? selectedAi; //对应的ai设备
  late final player = Player();
  late var videoController = VideoController(player);
  TextEditingController rtspController = TextEditingController();
  //设备名称
  TextEditingController deviceNameController = TextEditingController();
  TextEditingController videoIdController = TextEditingController();

  // 进/出口选项
  IdNameValue? selectedEntryExit;

  //摄像头类型
  IdNameValue? selectedCameraType;

  //是否纳入监管
  IdNameValue? selectedRegulation;

  CameraDeviceEntity({
    this.rtsp,
    this.code,
    // this.name,
    // this.type,
    // this.entryExit,
    // this.isRegulation,
    // this.id,
    this.isOpen,
  });


  @override
  String toString() {
    return jsonEncode(this);
  }

}
