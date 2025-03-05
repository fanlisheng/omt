import 'package:flutter/material.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/one_picture_data_entity.g.dart';
import 'dart:convert';

import 'package:omt/utils/color_utils.dart';
export 'package:omt/generated/json/one_picture_data_entity.g.dart';

@JsonSerializable()
class OnePictureDataEntity {
  int? code;
  String? message;
  OnePictureDataData? data;
  String? status;
  dynamic details;
  @JSONField(name: 'request_id')
  String? requestId;

  OnePictureDataEntity();

  factory OnePictureDataEntity.fromJson(Map<String, dynamic> json) =>
      $OnePictureDataEntityFromJson(json);

  Map<String, dynamic> toJson() => $OnePictureDataEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}

/// 1 实例 2 大门 3 进出口 4 供电设备 5 电源箱 6 路由器 7 有线网络 8nvr 9 交换机 10 AI设备 11 摄像头 12市电 13 电池
enum OnePictureType {
  _,
  SL,
  DM,
  JCK,
  GDSB,
  DYX,
  LYQ,
  YXWL,
  NVR,
  JHJ,
  AISB,
  SXT,
  SD,
  DC
}

@JsonSerializable()
class OnePictureDataData {
  String? id;
  String? name;
  @JSONField(name: 'node_code')
  String? nodeCode;

  int? type;
  @JSONField(name: 'type_text')
  String? typeText;
  String? desc;
  @JSONField(name: 'device_code')
  String? deviceCode;
  String? ip;
  String? mac;
  bool sameTypeData = false;
  bool ignore = false;

  bool get showAddBtn {
     if ((type == OnePictureType.DM.index && children.length == 1) ||
        (type == OnePictureType.JCK.index && showBorder)) {
      return true;
    }
    return false;
  }

  @JSONField(serialize: false, deserialize: false)
  IconData? iconData;
  @JSONField(serialize: false, deserialize: false)
  String? icon;

  String? get showDesc {
    return ip.defaultStr(data: desc);
  }

  bool? get showName {
    bool show = false;
    if (type == OnePictureType.JCK.index) {
      show = true;
      if (children.isNotEmpty) {
        showBorder = false;
        for (var child in children) {
          if (child.type != OnePictureType.AISB.index &&
              child.type != OnePictureType.SXT.index &&
              child.type != OnePictureType.NVR.index) {
            show = false;
          }
        }
      }
    } else if (type == OnePictureType.DM.index) {
      show = true;
    }
    return show;
  }

  String? get showNameText {
    if (type == OnePictureType.GDSB.index
        // || type == OnePictureType.DYX.index
        // || type == OnePictureType.NVR.index
        // || type == OnePictureType.YXWL.index
        // || type == OnePictureType.LYQ.index
        ) {
      return '';
    } else if (type == OnePictureType.SXT.index) {
      return typeText.defaultStr(data: name);
    } else {
      return name.defaultStr(data: typeText);
    }
  }

  ///下一些节点
  List<OnePictureDataData> nextList = [];

  ///连接线颜色
  String? lineColor;

  /// 离线、在线无数据、录像异常
  String? errorTxt;

  /// 显示箭头
  bool showArrow = true;

  /// 显示双层边框
  bool showBorder = false;

  List<OnePictureDataData> children = [];

  OnePictureDataData();

  List<OnePictureDataData> getChildList() {
    if (type == OnePictureType.SL.index
        // || type == OnePictureType.DM.index
        ) {
      return [];
    }

    return children;
  }

  factory OnePictureDataData.fromJson(Map<String, dynamic> json) =>
      $OnePictureDataDataFromJson(json);

  Map<String, dynamic> toJson() => $OnePictureDataDataToJson(this);

  setArrow({String? color}) {
    if (color != null) {
      lineColor = color;
    } else {
      ///实例
      if (type == OnePictureType.SL.index) {
        lineColor = ColorUtils.colorGreen.toColorHex();

        ///供电设备
      } else if (type == OnePictureType.GDSB.index) {
        lineColor = ColorUtils.colorBrown.toColorHex();

        ///电源箱
      } else if (type == OnePictureType.DYX.index) {
        lineColor = ColorUtils.colorBrown.toColorHex();

        ///交换机
      } else if (type == OnePictureType.JHJ.index) {
        lineColor = ColorUtils.colorBlueLight.toColorHex();
        showArrow = false;
      } else {
        lineColor = ColorUtils.colorGra.toColorHex();
      }
    }
  }

  setJCK(Function(String id, OnePictureDataData data) callback) {
    if (type == OnePictureType.JCK.index) {
      if (children.isNotEmpty && showBorder) {
        List<OnePictureDataData> childList = [];
        List<OnePictureDataData> theList = [];
        for (var child in children) {
          if (child.type != OnePictureType.AISB.index &&
              child.type != OnePictureType.SXT.index &&
              child.type != OnePictureType.NVR.index) {
            theList.add(child);
          } else {
            childList.add(child);
          }
        }

        if (childList.isNotEmpty) {
          var id2 = '${id}_${BaseTimeUtils.nowTimestamp()}';
          var copyWith2 = copyWith(
              children: childList, showBorder: false, ignore: true, id: id2);
          callback('${type}_${id2}', copyWith2);

          theList.add(copyWith2);
        }
        children = theList;
      }
    }
  }

  setBorder({bool? showBorder}) {
    if (showBorder != null) {
      this.showBorder = showBorder;
    } else {
      ///大门
      if (type == OnePictureType.DM.index) {
        this.showBorder = true;

        /// 进出口
      } else if (type == OnePictureType.JCK.index) {
        if (children.isNotEmpty) {
          this.showBorder = false;
          for (var child in children) {
            if (child.type != OnePictureType.AISB.index &&
                child.type != OnePictureType.SXT.index &&
                child.type != OnePictureType.NVR.index) {
              this.showBorder = true;
              break;
            }
          }
        }
      } else {
        this.showBorder = false;
      }
    }
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  void setIcon() {
    if (type == OnePictureType.SL.index) {
      iconData = Icons.house;
    } else if (type == OnePictureType.DM.index) {
      iconData = Icons.door_sliding;
    } else if (type == OnePictureType.JCK.index) {
      iconData = Icons.transfer_within_a_station;
    } else if (type == OnePictureType.GDSB.index) {
      iconData = Icons.power_input;
    } else if (type == OnePictureType.DYX.index) {
      iconData = Icons.power;
    } else if (type == OnePictureType.LYQ.index) {
      iconData = Icons.router;
    } else if (type == OnePictureType.YXWL.index) {
      iconData = Icons.language_outlined;
    } else if (type == OnePictureType.NVR.index) {
      iconData = Icons.camera_outdoor_rounded;
    } else if (type == OnePictureType.JHJ.index) {
      iconData = Icons.route_rounded;
    } else if (type == OnePictureType.AISB.index) {
      iconData = Icons.rocket_launch;
    } else if (type == OnePictureType.SXT.index) {
      iconData = Icons.photo_camera_front;
    } else if (type == OnePictureType.SD.index) {
      iconData = Icons.power_input;
    } else if (type == OnePictureType.DC.index) {
      iconData = Icons.battery_std;
    } else {
      iconData = Icons.hourglass_empty;
    }
  }
}
