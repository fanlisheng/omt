import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/home/home_page/device_detail_exchange_entity.dart';
import '../../../../http/http_query.dart';

class DetailBatteryExchangeViewModel extends BaseViewModelRefresh<dynamic> {

  DeviceDetailExchangeData deviceInfo = DeviceDetailExchangeData();

  @override
  void initState() async {
    super.initState();
    HttpQuery.share.homePageService.deviceDetailExchange(
        nodeCode: "562#6175-2#2-4#1",
        onSuccess: (DeviceDetailExchangeData? a) {
          deviceInfo = a ?? DeviceDetailExchangeData();
          notifyListeners();
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

}
