import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:kayo_package/views/widget/alert/datetime_picker/date_format.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/dialog_utils.dart';
import 'package:omt/utils/log_utils.dart';

class LabelManagementViewModel extends BaseViewModelRefresh<dynamic> {
  int currentStep = 1;
  TextEditingController controller = TextEditingController();

  String searchKey = "";

  // NVR通道信息
  // List<Map<String, String>> nvrInfo = [];
  List<IdNameValue> dataList = [];

  @override
  void initState() async {
    super.initState();
    // nvrInfo = [
    //   {"序列号": "1", "名称": "开工", "操作": ""},
    //   {"序列号": "2", "名称": "完工", "操作": ""},
    // ];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
    requestList();
  }

  void requestList() {
    HttpQuery.share.labelManagementService.getLabelList(searchKey,
        onSuccess: (a) {
      dataList = a ?? [];
      notifyListeners();
    }, onError: (e) {});
  }

  addEventAction(String name) {
    LogUtils.info(msg: name);
    return;
    HttpQuery.share.labelManagementService.create("", onSuccess: (a) {
      notifyListeners();
    }, onError: (e) {});
  }

  searchEventAction() {
    searchKey = controller.text;
    requestList();
  }

  editEventAction(int index, String name) {
    HttpQuery.share.labelManagementService.edit(index, name, onSuccess: (a) {
      dataList.removeAt(index);
      notifyListeners();
    }, onError: (e) {});
  }
}
