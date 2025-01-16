import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';

class LabelManagementViewModel extends BaseViewModelRefresh<dynamic> {
  int currentStep = 1;
  TextEditingController controller = TextEditingController();

  // NVR通道信息
  List<Map<String, String>> nvrInfo = [];

  @override
  void initState() async {
    super.initState();
    nvrInfo = [
      {"序列号": "1", "名称": "开工", "操作": ""},
      {"序列号": "2", "名称": "完工", "操作": ""},
    ];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  addEventAction() {
    notifyListeners();
  }
  searchEventAction() {
    notifyListeners();
  }
  editEventAction(int index) {
    notifyListeners();
  }


}
