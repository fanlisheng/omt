import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:kayo_package/mvvm/base/base_view_model_refresh.dart';
import 'package:omt/bean/home/home_page/local_device_entity.dart';
import 'package:omt/utils/dialog_utils.dart';

class DismantleViewModel extends BaseViewModelRefresh<dynamic> {
  //实例
  String selectedInstall = "";
  List installList = [];
  //大门编号
  String selectedGateNumber = "";
  List gateNumberList = [];
  // 进/出口选项
  String selectedEntryExit = "";
  List entryExitList = ["显示进口", "出口", "共用进出口"];
  //拆除原因
  String selectedDismantleCause = "请选择拆除原因";
  List dismantleCauseList = ["业主通知", "运营通知", "其它"];
  //设备数据
  List<LocalDeviceEntity> dismantleDeviceList = [];
  List<LocalDeviceEntity> noDismantleDeviceList = [];

  TextEditingController controller = TextEditingController();

  //如果是搜索结果
  bool isSearchResult = false;

  @override
  void initState() async {
    super.initState();
    installList = ["实例1", "实例2"];
    gateNumberList = ["大门1", "大门2"];
    // dismantleDeviceList = [
    //   LocalDeviceEntity(
    //       deviceType: "测试", ipAddress: "192.168.12.16", selected: true),
    //   LocalDeviceEntity( selected: true),
    //   LocalDeviceEntity( selected: true),
    //   LocalDeviceEntity( selected: true)
    // ];
    // noDismantleDeviceList = [
    //   LocalDeviceEntity(),
    // ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) {
    ///网络请求
  }

  searchEventAction() {
    //判断 3个筛选，1.如果都没有提示 2.其它请求
    LoadingUtils.showToast(data: "至少选择一个筛选条件");
    isSearchResult = true;
    notifyListeners();
  }

  //拆除设备
  dismantleEventAction() async {
    final result = await DialogUtils.showContentDialog(
        context: context!,
        title: "拆除设备",
        content: "您确定拆除这些设备？",
        deleteText: "确定");
    if (result == '确定') {}
  }

  //选中
  selectedItemEventAction(bool selected, int index) {
    //selected == false 是点击选中的设备

    if (selected == false) {
      LocalDeviceEntity a = dismantleDeviceList[index];
      a.selected = false;
      dismantleDeviceList.remove(a);
      noDismantleDeviceList.add(a);
    } else {
      LocalDeviceEntity a = noDismantleDeviceList[index];
      a.selected = true;
      noDismantleDeviceList.remove(a);
      dismantleDeviceList.add(a);
    }
    notifyListeners();
  }

  // 更新拆除原因的方法
  void setDismantleCause(String cause) {
    selectedDismantleCause = cause;
    notifyListeners(); // 通知界面更新
  }
}
