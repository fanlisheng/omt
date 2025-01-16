import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_tools/network_tools.dart';
import 'package:omt/utils/hikvision_utils.dart';

import '../bean/home/home_page/local_device_entity.dart';

class DeviceUtils {
  // 扫描所有活动主机并返回一个列表的 ActiveHost
  static Future<List<ActiveHost>> scanDevices({required bool Function() shouldStop}) async {
    List<ActiveHost> activeHostList = [];
    final info = NetworkInfo();
    String? address = await info.getWifiIP();
    if (address == null) return activeHostList;

    final String subnet = address.substring(0, address.lastIndexOf('.'));

    try {
      final stream = HostScannerService.instance.getAllPingableDevices(subnet,
          progressCallback: (progress) {
            // 进度回调，可以根据需要更新UI等
            print('进度: $progress%');
          });

      // 监听扫描结果
      await for (var host in stream) {
        if (shouldStop()) {
          print("扫描被终止");
          break; // 提前退出扫描
        }
        activeHostList.add(host);
      }
    } catch (e) {
      print('错误信息: $e');
    }

    // 返回扫描结果
    return activeHostList;
  }

  // 扫描设备列表，并执行设备详细信息获取
  static Future<List<LocalDeviceEntity>> scanDevicesAndFetchInfo(
      List<ActiveHost> activeHosts, {required bool Function() shouldStop}) async {
    List<Future<void>> tasks = [];
    List<LocalDeviceEntity> infoList = [];

    for (var host in activeHosts) {
      tasks.add(Future<void>(() async {
        if (shouldStop()) {
          print("扫描被终止");
          return; // 如果需要停止，直接返回
        }

        try {
          final result = await hikvisionDeviceInfo(ipAddress: host.address);
          // 如果 result 为空，则跳过当前循环，继续下一次扫描
          if (result != null) {
            infoList.add(result);
          }
        } catch (e) {
          // 捕获异常，确保扫描任务不会因为某个设备失败而中断
          print('获取IP信息失败: ${host.address}, Error: $e');
        }
      }));
    }

    // 并发执行所有设备扫描任务
    await Future.wait(tasks);

    return infoList;
  }

  // 扫描设备并获取信息，步骤分开：先扫描活动主机，再获取设备信息
  static Future<List<LocalDeviceEntity>> scanAndFetchDevicesInfo({required bool Function() shouldStop}) async {
    // 第一步：扫描活动主机
    List<ActiveHost> activeHostList = await scanDevices(shouldStop: shouldStop);

    // 第二步：根据扫描到的设备进行详细信息获取
    if (activeHostList.isNotEmpty) {
      return scanDevicesAndFetchInfo(activeHostList, shouldStop: shouldStop);
    }

    return [];
  }
}

