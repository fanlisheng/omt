import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'device_add_viewmodel.dart';

class AddBatteryExchangeViewModel extends BaseViewModelRefresh<dynamic> {
  final DeviceType deviceType;
  final StepNumber stepNumber;
  final bool isInstall;//是安装 默认否
  AddBatteryExchangeViewModel(this.deviceType, this.stepNumber, this.isInstall);

  // 容量80
  bool isCapacity80 = true;

  List<String> portNumber = ["5口", "8口"];
  String? selectedPortNumber;

  List<String> supplyMethod = ["POE", "DC", "AC"];
  String? selectedSupplyMethod;

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

}
