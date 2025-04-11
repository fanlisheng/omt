import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/bean/home/home_page/device_entity.dart';
import 'package:omt/bean/home/home_page/device_unbound_entity.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/page/home/search_device/view_models/search_device_viewmodel.dart';
import 'package:omt/utils/log_utils.dart';
import '../../../one_picture/one_picture/one_picture_page.dart';
import 'dart:async';

class DeviceSearchService {
  static final DeviceSearchService _instance = DeviceSearchService._internal();

  factory DeviceSearchService() {
    return _instance;
  }

  DeviceSearchService._internal();

  // 获取实例列表
  Future<List<StrIdNameValue>> getInstanceList() async {
    final completer = Completer<List<StrIdNameValue>>();

    HttpQuery.share.homePageService.getInstanceList("5101",
        onSuccess: (List<StrIdNameValue>? data) {
      completer.complete(data ?? []);
    }, onError: (String error) {
      LogUtils.info(msg: "获取实例列表失败: $error");
      completer.complete([]);
    });

    return completer.future;
  }

  // 获取大门列表
  Future<List<IdNameValue>> getGateList() async {
    final completer = Completer<List<IdNameValue>>();

    HttpQuery.share.homePageService.getGateList(
        onSuccess: (List<IdNameValue>? data) {
      completer.complete(data ?? []);
    }, onError: (String error) {
      LogUtils.info(msg: "获取大门列表失败: $error");
      completer.complete([]);
    });

    return completer.future;
  }

  // 获取进出口列表
  Future<List<IdNameValue>> getInOutList() async {
    final completer = Completer<List<IdNameValue>>();

    HttpQuery.share.homePageService.getInOutList(
        onSuccess: (List<IdNameValue>? data) {
      completer.complete(data ?? []);
    }, onError: (String error) {
      LogUtils.info(msg: "获取进出口列表失败: $error");
      completer.complete([]);
    });

    return completer.future;
  }

  // 扫描设备并获取信息
  Future<List<DeviceEntity>> scanDevices(
      {required bool Function() shouldStop, String? deviceType}) async {
    return await DeviceUtils.scanAndFetchDevicesInfo(
        shouldStop: shouldStop, deviceType: deviceType);
  }

  // 上传设备扫描数据
  Future<DeviceScanResult> uploadScanData({
    required String instanceId,
    required List<DeviceEntity> deviceList,
  }) async {
    final completer = Completer<DeviceScanResult>();
    final result = DeviceScanResult(
      devices: [],
      unboundDevices: [],
      statistics: "",
    );

    HttpQuery.share.homePageService.deviceScan(
      instanceId: instanceId,
      deviceList: deviceList,
      onSuccess: (DeviceScanEntity? scanData) {
        result.devices = scanData?.devices ?? [];
        result.unboundDevices = scanData?.unboundDevices ?? [];
        result.statistics = _generateDeviceStatistics(scanData?.devices ?? []);
        completer.complete(result);
      },
      onError: (String error) {
        LogUtils.info(msg: "上传设备扫描数据失败: $error");
        completer.complete(result);
      },
    );

    return completer.future;
  }

  // 获取未绑定设备
  Future<DeviceUnboundResult> getUnboundDevices(
      {required String instanceId}) async {
    final completer = Completer<DeviceUnboundResult>();
    final result = DeviceUnboundResult(
      unboundDevices: [],
      statistics: "",
    );

    HttpQuery.share.homePageService.getUnboundDevices(
      instanceId: instanceId,
      onSuccess: (DeviceUnboundEntity? data) {
        result.unboundDevices = data?.unboundDevices ?? [];

        // 生成统计信息
        StringBuffer countStr = StringBuffer();
        for (DeviceUnboundAllCount item in data?.allCount ?? []) {
          countStr.write("${item.count}个${item.deviceTypeText} / ");
        }
        String statistics = countStr.toString();
        if (statistics.length > 2) {
          result.statistics = statistics.substring(0, statistics.length - 2);
        } else {
          result.statistics = statistics;
        }

        completer.complete(result);
      },
      onError: (String error) {
        LogUtils.info(msg: "获取未绑定设备失败: $error");
        completer.complete(result);
      },
    );

    return completer.future;
  }

  // 生成设备统计字符串
  String _generateDeviceStatistics(List<DeviceEntity>? deviceList) {
    if (deviceList == null || deviceList.isEmpty) return "暂无设备";

    // 定义设备类型对应关系
    final deviceTypeMap = {
      5: "电源箱",
      6: "路由器",
      8: "NVR",
      9: "交换机",
      10: "AI设备",
      11: "摄像头",
    };

    // 统计设备数量
    Map<int, int> deviceCount = {};
    for (var device in deviceList) {
      if (deviceTypeMap.containsKey(device.deviceType)) {
        deviceCount[device.deviceType!] =
            (deviceCount[device.deviceType] ?? 0) + 1;
      }
    }

    // 生成统计字符串
    List<String> stats = deviceCount.entries.map((entry) {
      String deviceName = deviceTypeMap[entry.key]!;
      return "${entry.value}个$deviceName";
    }).toList();

    return stats.join(" / ");
  }

  // 初始化设备搜索数据
  Future<DeviceSearchInitData> initSearchData() async {
    DeviceSearchInitData data = DeviceSearchInitData();

    // 并行加载数据
    Future<List<StrIdNameValue>> instancesFuture = getInstanceList();
    Future<List<IdNameValue>> doorsFuture = getGateList();
    Future<List<IdNameValue>> inOutFuture = getInOutList();

    // 等待所有数据加载完成
    List results =
        await Future.wait([instancesFuture, doorsFuture, inOutFuture]);

    data.instanceList = results[0] as List<StrIdNameValue>;
    data.doorList = results[1] as List<IdNameValue>;
    data.inOutList = results[2] as List<IdNameValue>;

    return data;
  }

  // 扫描设备和处理状态
  Future<DeviceSearchResult> scanAndProcessDevices({
    required String? instanceId,
    required bool Function() shouldStop,
  }) async {
    DeviceSearchResult result = DeviceSearchResult(
      state: DeviceSearchState.completed,
      devices: [],
      unboundDevices: [],
      statistics: "",
    );

    // 参数校验
    if (instanceId == null || instanceId.isEmpty) {
      result.state = DeviceSearchState.notSearched;
      return result;
    }

    // 扫描设备
    List<DeviceEntity> scannedDevices =
        await scanDevices(shouldStop: shouldStop);

    // 检查是否中断
    if (shouldStop()) {
      result.state = DeviceSearchState.notSearched;
      return result;
    }

    // 上传扫描结果
    DeviceScanResult scanResult = await uploadScanData(
      instanceId: instanceId,
      deviceList: scannedDevices,
    );

    // 更新结果
    result.devices = scanResult.devices;
    result.unboundDevices = scanResult.unboundDevices;
    result.statistics = scanResult.statistics;

    return result;
  }

  // 获取未绑定设备并处理状态
  Future<DeviceSearchResult> getUnboundDevicesWithState({
    required String? instanceId,
    required String? instanceName,
    required int? gateId,
    required int? passId,
    required GlobalKey<OnePicturePageState> picturePageKey,
  }) async {
    DeviceSearchResult result = DeviceSearchResult(
      state: DeviceSearchState.onePicturePage,
      devices: [],
      unboundDevices: [],
      statistics: "",
    );

    // 参数校验
    if (instanceId == null || instanceId.isEmpty) {
      result.state = DeviceSearchState.notSearched;
      return result;
    }

    // 获取未绑定设备
    DeviceUnboundResult unboundResult = await getUnboundDevices(
      instanceId: instanceId,
    );

    // 更新结果
    result.unboundDevices = unboundResult.unboundDevices;
    result.statistics = unboundResult.statistics;

    // 刷新一张图页面
    picturePageKey.currentState?.refresh(
      instanceName: instanceName,
      instanceId: instanceId,
      gateId: gateId,
      passId: passId,
    );

    return result;
  }
}

// 设备扫描结果
class DeviceScanResult {
  List<DeviceEntity> devices;
  List<DeviceEntity> unboundDevices;
  String statistics;

  DeviceScanResult({
    required this.devices,
    required this.unboundDevices,
    required this.statistics,
  });
}

// 未绑定设备结果
class DeviceUnboundResult {
  List<DeviceEntity> unboundDevices;
  String statistics;

  DeviceUnboundResult({
    required this.unboundDevices,
    required this.statistics,
  });
}

/// 设备搜索初始化数据
class DeviceSearchInitData {
  List<StrIdNameValue> instanceList = [];
  List<IdNameValue> doorList = [];
  List<IdNameValue> inOutList = [];
}

/// 设备搜索结果
class DeviceSearchResult {
  DeviceSearchState state;
  List<DeviceEntity> devices;
  List<DeviceEntity> unboundDevices;
  String statistics;

  DeviceSearchResult({
    required this.state,
    required this.devices,
    required this.unboundDevices,
    required this.statistics,
  });
}
