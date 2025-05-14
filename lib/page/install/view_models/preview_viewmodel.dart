import 'dart:async';
import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/mvvm/base/base_view_model.dart';
import 'package:omt/http/http_query.dart';

import '../../../bean/one_picture/one_picture/one_picture_data_entity.dart';
import '../../../generated/json/base/json_convert_content.dart';
import '../../home/device_add/view_models/add_ai_viewmodel.dart';
import '../../home/device_add/view_models/add_battery_exchange_viewmodel.dart';
import '../../home/device_add/view_models/add_camera_viewmodel.dart';
import '../../home/device_add/view_models/add_nvr_viewmodel.dart';
import '../../home/device_add/view_models/add_power_box_viewmodel.dart';
import '../../../bean/common/id_name_value.dart';
import '../../home/device_add/view_models/add_power_viewmodel.dart';
import '../../one_picture/one_picture/one_picture_page.dart';

class PreviewViewModel extends BaseViewModel {
  OnePictureDataData? onePictureDataData;

  final GlobalKey<OnePicturePageState> picturePageKey = GlobalKey();

  // 处理所有viewModel数据并构建 OnePictureDataData 对象
  void buildPreviewData({
    required StrIdNameValue? selectedInstance,
    required IdNameValue? selectedDoor,
    // required IdNameValue? selectedInOut,
    required AddAiViewModel aiViewModel,
    required AddCameraViewModel cameraViewModel,
    required AddNvrViewModel nvrViewModel,
    required AddPowerBoxViewModel powerBoxViewModel,
    required AddPowerViewModel powerViewModel,
  }) {
    if (selectedInstance == null || selectedDoor == null) {
      return;
    }

    try {
      Map<String, dynamic> powersMap = AddPowerViewModel.getPowersMap(powerViewModel);
      Map<String, dynamic> powerBoxes = AddPowerBoxViewModel.getPowerBoxes(powerBoxViewModel);
      Map<String, dynamic> network = AddPowerViewModel.getNetwork(powerViewModel);
      Map<String, dynamic> nvr = AddNvrViewModel.getNvr(nvrViewModel);
      List<Map<String, dynamic>> routers = [];
      List<Map<String, dynamic>> wiredNetworks = [];
      if (network["type"] == 6) {
        routers.add(network);
      } else {
        wiredNetworks.add(network);
      }

      HttpQuery.share.installService.installPreview(
          instanceId: selectedInstance.id ?? "",
          gateId: selectedDoor.id ?? 0,
          powers: [powersMap],
          powerBoxes: [powerBoxes],
          routers: routers,
          wiredNetworks: wiredNetworks,
          nvrs: [nvr],
          switches: AddPowerViewModel.getSwitches(powerViewModel),
          onSuccess: (data) {
            onePictureDataData = data;
            notifyListeners();
            Timer(Duration(milliseconds: 200), () {
              picturePageKey.currentState
                  ?.refreshWithData(data: onePictureDataData);
              notifyListeners();
            });
          });
    } catch (e) {
      print("Error building OnePictureDataData: $e");
    }
  }

  Map<String, dynamic> _getPowersMap(AddPowerViewModel powerViewModel) {
    List<int> items = [];
    int? batteryCap = (powerViewModel.battery == false)
        ? null
        : (powerViewModel.isCapacity80 ? 80 : 160);

    if (powerViewModel.batteryMains) {
      items.add(1);
    }
    if (batteryCap != null) {
      items.add(2);
    }
    Map<String, dynamic> params = {
      "PowerType": items,
      "pass_id": powerViewModel.selectedPowerInOut!.id!,
    };
    if (batteryCap != null) {
      params["battery_capacity"] = batteryCap;
    }
    return params;
  }

  Map<String, dynamic> _getPowerBoxes(AddPowerBoxViewModel powerBoxViewModel) {
    String deviceCode =
        powerBoxViewModel.selectedDeviceDetailPowerBox!.deviceCode!;
    int passId = powerBoxViewModel.selectedPowerBoxInOut!.id!;

    Map<String, dynamic> params = {
      "device_code": deviceCode,
      "pass_id": passId,
    };
    return params;
  }

  Map<String, dynamic> _getNetwork(AddPowerViewModel powerViewModel) {
    int passId = powerViewModel.selectedPowerInOut!.id!;
    int type = powerViewModel.selectedRouterType!.id!;
    String mac = powerViewModel.mac!;
    String ip = powerViewModel.routerIpController.text;

    Map<String, dynamic> params = {
      "ip": ip,
      "type": type,
      "mac": mac,
      "pass_id": passId,
    };
    return params;
  }

  Map<String, dynamic> _getNvr(AddNvrViewModel nvrViewModel) {
    int passId = nvrViewModel.selectedNarInOut!.id!;
    String mac = nvrViewModel.selectedNvr!.mac ?? "";
    String ip = nvrViewModel.selectedNvr?.ip ?? "";

    Map<String, dynamic> params = {
      "ip": ip,
      "mac": mac,
      "pass_id": passId,
    };
    return params;
  }

  List<Map<String, dynamic>> _getSwitches(AddPowerViewModel powerViewModel) {
    List<Map<String, dynamic>> paramsList = [];
    for (ExchangeDeviceModel exchange in powerViewModel.exchangeDevices) {
      Map<String, dynamic> params = {
        "interface_num": exchange.selectedPortNumber.toInt(),
        "power_method": exchange.selectedSupplyMethod,
        "pass_id": powerViewModel.selectedPowerInOut?.id,
      };
      paramsList.add(params);
    }

    return paramsList;
  }
}
