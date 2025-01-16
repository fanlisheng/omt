import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';

class InstallDeviceViewModel extends BaseViewModelRefresh<dynamic> {
  int currentStep = 1;

  List<String> stepTitles = [];

  //实例
  String selectedInstall = "";
  List installList = [];

  //大门编号
  String selectedGateNumber = "";
  List gateNumberList = [];

  @override
  void initState() async {
    super.initState();
    stepTitles = [
      "绑定实例",
      "添加AI设备",
      "添加摄像头",
      "添加NVR（选填）",
      "添加电源箱（选填）",
      "添加电源及其它"
    ];
    installList = ["实例1", "实例2"];
    gateNumberList = ["大门1", "大门2"];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  //上一步
  backStepEventAction() {
    if (currentStep <= 0) return;
    currentStep = currentStep - 1;
    notifyListeners();
  }

  //下一步
  nextStepEventAction() {
    if (currentStep < 6) {
      currentStep = currentStep + 1;
    } else {
      //完成
    }
    notifyListeners();
  }
}
