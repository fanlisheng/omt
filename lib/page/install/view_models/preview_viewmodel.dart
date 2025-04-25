import 'dart:convert';
import 'package:kayo_package/mvvm/base/base_view_model.dart';

import '../../../bean/one_picture/one_picture/one_picture_data_entity.dart';
import '../../home/device_add/view_models/add_ai_viewmodel.dart';
import '../../home/device_add/view_models/add_battery_exchange_viewmodel.dart';
import '../../home/device_add/view_models/add_camera_viewmodel.dart';
import '../../home/device_add/view_models/add_nvr_viewmodel.dart';
import '../../home/device_add/view_models/add_power_box_viewmodel.dart';
import '../../../bean/common/id_name_value.dart';

class PreviewViewModel extends BaseViewModel {
  OnePictureDataData? onePictureDataData;

  // 存储构建的JSON数据
  Map<String, dynamic>? previewJsonData;

  // 处理所有viewModel数据并构建JSON
  void buildPreviewData({
    required StrIdNameValue? selectedInstance,
    required IdNameValue? selectedDoor,
    required IdNameValue? selectedInOut,
    required AddAiViewModel aiViewModel,
    required AddCameraViewModel cameraViewModel,
    required AddNvrViewModel nvrViewModel,
    required AddPowerBoxViewModel powerBoxViewModel,
    required AddBatteryExchangeViewModel batteryExchangeViewModel,
  }) {
    if (selectedInstance == null || selectedDoor == null) {
      return;
    }

    // 创建进口和出口节点
    Map<String, dynamic> entranceNode = {
      // "id": "101",
      // "node_code": "sand#1-2#2-3#1",
      "type": 3,
      "type_text": "进口",
      "desc": "  ",
      "children": []
    };

    Map<String, dynamic> exitNode = {
      // "id": "102",
      // "node_code": "sand#1-2#2-3#2",
      "type": 3,
      "type_text": "出口",
      "desc": "  ",
      "children": []
    };

    // 根据选择的是进口还是出口，将设备添加到对应节点
    if (selectedInOut != null) {
      // 假设 selectedInOut.id = 1 表示进口，selectedInOut.id = 2 表示出口
      bool isEntrance = selectedInOut.id == 1;

      // 将能选择进出口的设备添加到对应的进口或出口节点中
      if (isEntrance) {
        // 添加到进口
        entranceNode["children"].addAll([
          {
            // "id": "11",
            // "node_code": "sand#1-2#2-3#1-10#0",
            "type": 10,
            "type_text": "AI设备",
            "desc": "  ",
            "children": _buildAiDeviceChildren(aiViewModel),
          },
          {
            // "id": "15",
            // "node_code": "sand#1-2#2-3#1-11#0",
            "type": 11,
            "type_text": "摄像头",
            "desc": "  ",
            "children": _buildCameraChildren(cameraViewModel),
          }
        ]);
      } else {
        // 添加到出口
        exitNode["children"].addAll([
          {
            // "id": "11",
            // "node_code": "sand#1-2#2-3#2-10#0",
            "type": 10,
            "type_text": "AI设备",
            "desc": "  ",
            "children": _buildAiDeviceChildren(aiViewModel),
          },
          {
            // "id": "15",
            // "node_code": "sand#1-2#2-3#2-11#0",
            "type": 11,
            "type_text": "摄像头",
            "desc": "  ",
            "children": _buildCameraChildren(cameraViewModel),
          }
        ]);
      }
    }

    // 构建基础JSON结构，共用设备直接加到大门节点
    Map<String, dynamic> jsonData = {
      "data": {
        // "id": selectedInstance.id,
        // "node_code": "sand#1",
        "type": 1,
        "type_text": selectedInstance.name,
        "desc": "  ",
        "children": [
          {
            // "id": selectedDoor.id.toString(),
            // "node_code": "sand#1-2#2",
            "type": 2,
            "type_text": selectedDoor.name,
            "desc": "  ",
            "children": [
              entranceNode,
              exitNode,
              {
                // "id": "5",
                // "node_code": "sand#1-2#2-4#0",
                "type": 4,
                "type_text": "供电设备",
                "desc": "  ",
                "children": [
                  {
                    // "id": "13",
                    // "node_code": "sand#1-2#2-4#0-12#0",
                    "type": 12,
                    "type_text": "市电",
                    "desc": "  ",
                    "children": []
                  },
                  {
                    // "id": "14",
                    // "node_code": "sand#1-2#2-4#0-13#0",
                    "type": 13,
                    "type_text": "电池",
                    "desc": "  ",
                    "children": _buildBatteryChildren(batteryExchangeViewModel),
                  }
                ]
              },
              {
                // "id": "6",
                // "node_code": "sand#1-2#2-5#0",
                "type": 5,
                "type_text": "电源箱",
                "desc": "  ",
                "children": _buildPowerBoxChildren(powerBoxViewModel),
              },
              {
                // "id": "7",
                // "node_code": "sand#1-2#2-6#0",
                "type": 6,
                "type_text": "路由器",
                "desc": "  ",
                "children": []
              },
              {
                // "id": "8",
                // "node_code": "sand#1-2#2-7#0",
                "type": 7,
                "type_text": "有线网络",
                "desc": "  ",
                "children": []
              },
              {
                // "id": "12",
                // "node_code": "sand#1-2#2-8#0",
                "type": 8,
                "type_text": "NVR",
                "desc": "  ",
                "children": _buildNvrChildren(nvrViewModel),
              },
              {
                // "id": "10",
                // "node_code": "sand#1-2#2-9#0",
                "type": 9,
                "type_text": "交换机",
                "desc": "  ",
                "children": []
              },
              {
                "id": "16",
                "node_code": "sand#1-2#2-9#1",
                "type": 9,
                "type_text": "交换机",
                "desc": "  ",
                "children": []
              }
            ]
          }
        ]
      }
    };

    // 保存构建好的JSON数据
    previewJsonData = jsonData;

    // 将JSON数据转换为OnePictureDataData对象
    _convertJsonToOnePictureData();

    // 通知UI更新
    notifyListeners();
  }

  // 构建AI设备子节点
  List<Map<String, dynamic>> _buildAiDeviceChildren(AddAiViewModel viewModel) {
    List<Map<String, dynamic>> children = [];
    // 从aiViewModel中提取AI设备数据
    if (viewModel.aiDeviceList.isNotEmpty) {
      for (var device in viewModel.aiDeviceList) {
        if (device.mac?.isNotEmpty ?? false) {
          children.add({
            // "id": device.deviceId ?? "",
            "node_code": "${device.mac}",
            "type": 10,
            "type_text": "AI设备",
            "desc": "IP: ${device.ip}, MAC: ${device.mac}",
            "children": []
          });
        }
      }
    }
    return children;
  }

  // 构建摄像头子节点
  List<Map<String, dynamic>> _buildCameraChildren(
      AddCameraViewModel viewModel) {
    List<Map<String, dynamic>> children = [];
    // 从cameraViewModel中提取摄像头数据
    if (viewModel.cameraDeviceList.isNotEmpty) {
      for (var camera in viewModel.cameraDeviceList) {
        if (camera.isAddEnd) {
          children.add({
            // "id": camera.deviceId ?? "",
            // "node_code": "${camera.ip}",
            "type": 11,
            "type_text": "摄像头",
            "desc": "IP: ${camera.ip}, RTSP: ${camera.rtsp}",
            "children": []
          });
        }
      }
    }
    return children;
  }

  // 构建NVR子节点
  List<Map<String, dynamic>> _buildNvrChildren(AddNvrViewModel viewModel) {
    List<Map<String, dynamic>> children = [];
    // 从nvrViewModel中提取NVR数据
    if (viewModel.nvrDeviceList.isNotEmpty) {
      for (var nvr in viewModel.nvrDeviceList) {
        if (nvr.ip?.isNotEmpty ?? false) {
          children.add({
            // "id": nvr.deviceId ?? "",
            // "node_code": "${nvr.ip}",
            "type": 8,
            "type_text": "NVR",
            "desc": "IP: ${nvr.ip}",
            "children": []
          });
        }
      }
    }
    return children;
  }

  // 构建电源箱子节点
  List<Map<String, dynamic>> _buildPowerBoxChildren(
      AddPowerBoxViewModel viewModel) {
    List<Map<String, dynamic>> children = [];
    // 从powerBoxViewModel中提取电源箱数据
    // if (viewModel.powerBoxDeviceList.isNotEmpty) {
    //   for (var powerBox in viewModel.powerBoxDeviceList) {
    //     if (powerBox.ip?.isNotEmpty ?? false) {
    //       children.add({
    //         "id": powerBox.deviceId ?? "",
    //         "node_code": "${powerBox.ip}",
    //         "type": 5,
    //         "type_text": "电源箱",
    //         "desc": "IP: ${powerBox.ip}",
    //         "children": []
    //       });
    //     }
    //   }
    // }
    return children;
  }

  // 构建电池交换设备子节点
  List<Map<String, dynamic>> _buildBatteryChildren(
      AddBatteryExchangeViewModel viewModel) {
    List<Map<String, dynamic>> children = [];
    // 从batteryExchangeViewModel中提取电池交换设备数据
    // if (viewModel.batteryDeviceList.isNotEmpty) {
    //   for (var battery in viewModel.batteryDeviceList) {
    //     if (battery.ip?.isNotEmpty ?? false) {
    //       children.add({
    //         "id": battery.deviceId ?? "",
    //         "node_code": "${battery.ip}",
    //         "type": 13,
    //         "type_text": "电池",
    //         "desc": "IP: ${battery.ip}",
    //         "children": []
    //       });
    //     }
    //   }
    // }
    return children;
  }

  // 将JSON数据转换为OnePictureDataData对象
  void _convertJsonToOnePictureData() {
    if (previewJsonData != null) {
      // 这里根据需要将JSON转换为OnePictureDataData对象
      // 具体实现依赖于OnePictureDataData的结构
      onePictureDataData = OnePictureDataData.fromJson(previewJsonData!);
      notifyListeners();
    }
  }

  // 获取JSON字符串
  String? getJsonString() {
    if (previewJsonData != null) {
      return jsonEncode(previewJsonData);
    }
    return null;
  }
}
