import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/home/home_page/device_detail_exchange_entity.dart';
import '../../../../http/http_query.dart';
import '../../../../utils/intent_utils.dart';
import '../../../remove/widgets/remove_dialog_page.dart';

class DetailBatteryExchangeViewModel extends BaseViewModelRefresh<dynamic> {
  final String nodeId;

  DetailBatteryExchangeViewModel(this.nodeId);

  DeviceDetailExchangeData deviceInfo = DeviceDetailExchangeData();

  @override
  void initState() async {
    super.initState();
    HttpQuery.share.homePageService.deviceDetailExchange(
        nodeId: nodeId,
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

  //修改
  editAction(){

  }


  //删除
  removeAction(){
    RemoveDialogPage.showAndSubmit(
      context: context!,
      instanceId: deviceInfo.instanceId ?? "",
      removeIds: [(deviceInfo.nodeId ?? "0").toInt()],
      onSuccess: () {
        IntentUtils.share.popResultOk(context!);
      },
    );
  }

}
