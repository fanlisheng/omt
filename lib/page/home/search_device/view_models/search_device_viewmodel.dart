import 'package:kayo_package/kayo_package.dart';
import 'package:multicast_dns/multicast_dns.dart';
import 'package:omt/router_utils.dart';
import 'package:omt/utils/intent_utils.dart';
import 'package:omt/utils/mac_address_utils.dart';
import '../../../../bean/home/home_page/local_device_entity.dart';
import '../../../../utils/hikvision_utils.dart';

///
///  omt
///  label_me_view_model.dart
///  数据标注
///
///  Created by kayoxu on 2024-04-15 at 16:39:19
///  Copyright © 2024 .. All rights reserved.
///
enum DeviceSearchState {
  notSearched, // 没搜索过
  searching, // 搜索中
  completed, // 搜索完成
}

class SearchDeviceViewModel extends BaseViewModelRefresh<dynamic> {
  //设备搜索状态
  DeviceSearchState searchState = DeviceSearchState.notSearched;

  String selectedExample = "请选择实例";
  String selectedDoor = "请选择大门编号";
  String selectedInOut = "请选择进/出口";

  //设备统计字段
  String deviceStatistics = "设备统计：1个AI设备 / 一个摄像头 / 一个NVR / 一个路由器";

  //扫描出的设备数据
  List<LocalDeviceEntity> deviceScanData = [];

  //没有绑定的数据
  List<LocalDeviceEntity> deviceNoBindingData = [];

  //扫描进度
  double scanRateValue = 0.0;

  MDnsClient client = MDnsClient();

  @override
  void initState() async {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  ///点击事件
  //搜索事件
  searchEventAction() {
    IntentUtils.share.push(context,
        routeName: RouterPage.DeviceAddPage, data: {"id": 0, "type": 1});
  }

  //开始扫描
  scanStartEventAction() async {
    searchState = DeviceSearchState.searching;
    deviceScanData = [];
    scanRateValue = 0.0;
    notifyListeners();

    client = MDnsClient();
    final List<String> serviceNames = [
      '_psia._tcp.local',
      '_workstation._tcp.local'
    ]; // 服务名称列表
    final Set<String> seenDevices = {}; // 用于记录已处理设备

    try {
      print('Starting mDNS client...');
      await client.start();

      // 遍历每个服务名称
      for (final serviceName in serviceNames) {
        await for (final PtrResourceRecord ptr
            in client.lookup<PtrResourceRecord>(
                ResourceRecordQuery.serverPointer(serviceName))) {
          print('Found service: ${ptr.domainName}');

          await for (final SrvResourceRecord srv
              in client.lookup<SrvResourceRecord>(
                  ResourceRecordQuery.service(ptr.domainName))) {
            print('Device hostname: ${srv.target}, port: ${srv.port}');

            await for (final IPAddressResourceRecord ip
                in client.lookup<IPAddressResourceRecord>(
                    ResourceRecordQuery.addressIPv4(srv.target))) {
              // 标准化设备字段
              final String target = srv.target.replaceAll(".local", "");
              final String ipAddress = ip.address.address;
              final String deviceKey = '$target-$ipAddress';

              // 检查是否已经处理过
              if (seenDevices.contains(deviceKey)) {
                continue; // 忽略已记录设备
              }
              seenDevices.add(deviceKey);

              if (serviceName == '_psia._tcp.local') {
                // 使用 hikvisionDeviceInfo 处理 HIKVISION 设备
                final result =
                    await hikvisionDeviceInfo(ipAddress: ip.address.address);
                if (result != null) {
                  deviceScanData.add(result);
                }
              } else {
                String? macAddress =
                    MacAddressHelper.getMacAddressWithString(ptr.domainName);
                // 默认的设备处理逻辑
                deviceScanData.add(
                  LocalDeviceEntity(
                      deviceType: target,
                      target: ptr.domainName,
                      ipAddress: ip.address.address,
                      macAddress: macAddress),
                );
              }
              deviceNoBindingData = deviceScanData;
              print('Device name: $target, IP address: ${ip.address}');
            }
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      client.stop();
      searchState = DeviceSearchState.completed;
      scanRateValue = 1.0;
      notifyListeners();
      print('mDNS client stopped. Final Progress: 100%');
    }
  }

  //扫描停止事件
  scanStopEventAction() async {
    searchState = DeviceSearchState.notSearched;
    notifyListeners();
    client.stop();
    await Future.delayed(Duration(seconds: 1)); // 等待网络缓存清理
  }

  //重新扫描
  scanAnewEventAction() {
    scanStopEventAction();
    scanStartEventAction();
  }

  //绑定
  bindEventAction() {
    IntentUtils.share.push(context,
        routeName: RouterPage.DeviceBindPage,
        data: {"data": deviceNoBindingData});
  }

  //所有服务
  discoverService() async {
    final MDnsClient client = MDnsClient();
    await client.start();

    // 扫描所有服务
    await for (final PtrResourceRecord ptrA in client.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_services._dns-sd._udp.local'))) {
      await for (final PtrResourceRecord ptr
          in client.lookup<PtrResourceRecord>(
              ResourceRecordQuery.serverPointer(ptrA.domainName))) {
        print('开始扫描 service: ${ptrA.domainName}');

        await for (final SrvResourceRecord srv
            in client.lookup<SrvResourceRecord>(
                ResourceRecordQuery.service(ptr.domainName))) {
          print('设备名字: ${srv.target}');

          await for (final IPAddressResourceRecord ip
              in client.lookup<IPAddressResourceRecord>(
                  ResourceRecordQuery.addressIPv4(srv.target))) {
            if (ip.address.address == "192.168.101.82") {
              print('设备IP是对的');
              client.stop();
              return;
            }
          }
        }
      }
    }

    client.stop();
  }

// LocalDeviceEntity getDeviceTypeInfo(LocalDeviceEntity info) {
//   if (info.domainName == null) return info;
//   if (info.domainName!.contains('DS-2CD') ||
//       info.domainName!.contains('DS-2DE')) {
//     info.type = "摄像头";
//   } else if (info.domainName!.contains('DS-76') ||
//       info.domainName!.contains('DS-77')) {
//     info.type = "DVR";
//   } else if (info.domainName!.contains('AI')) {
//     info.type = "AI 设备";
//   } else {
//     info.type = "未知设备";
//     return info;
//   }
//   return info;
// }
}
