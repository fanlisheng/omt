import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/log_utils.dart';

import '../../../../bean/home/home_page/device_detail_ai_entity.dart';
import '../../../../http/http_query.dart';
import '../../device_add/view_models/device_add_viewmodel.dart';

class DeviceDetailViewModel extends BaseViewModelRefresh<dynamic> {
  final int id;
  late final DeviceType deviceType;
  final String nodeCode;

  DeviceDetailViewModel({
    required this.id,
    required this.deviceType,
    required this.nodeCode,
  });




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

  ///确定电源类型
// confirmPowerEventAction() {
//   if (portType.isNotEmpty && (battery || batteryMains)) {
//     LogUtils.info(msg: "confirmPowerEventAction");
//   }
// }
}
