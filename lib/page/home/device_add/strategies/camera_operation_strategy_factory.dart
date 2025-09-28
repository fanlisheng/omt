import '../view_models/add_camera_viewmodel.dart';
import 'camera_operation_strategy.dart';
import 'install_camera_strategy.dart';
import 'add_camera_strategy.dart';
import 'replace_camera_strategy.dart';

/// 相机操作策略工厂
/// 根据操作类型创建相应的策略实例
class CameraOperationStrategyFactory {
  /// 私有构造函数，防止实例化
  CameraOperationStrategyFactory._();

  /// 根据操作类型创建策略
  /// 
  /// [operationType] 操作类型枚举
  /// 返回对应的策略实例
  static CameraOperationStrategy createStrategy(CameraOperationType operationType) {
    switch (operationType) {
      case CameraOperationType.install:
        return InstallCameraStrategy();
      case CameraOperationType.add:
        return AddCameraStrategy();
      case CameraOperationType.replace:
        return ReplaceCameraStrategy();
    }
  }

  /// 根据pNodeCode自动选择策略
  /// 
  /// [pNodeCode] 节点代码，不为空时选择添加策略，为空时选择安装策略
  /// 返回对应的策略实例
  static CameraOperationStrategy createStrategyByPNodeCode(String pNodeCode) {
    if (pNodeCode.isNotEmpty) {
      return AddCameraStrategy();
    } else {
      return InstallCameraStrategy();
    }
  }

  /// 获取所有可用的策略类型
  /// 返回策略名称列表，用于调试和日志
  static List<String> getAllStrategyNames() {
    return [
      InstallCameraStrategy().strategyName,
      AddCameraStrategy().strategyName,
      ReplaceCameraStrategy().strategyName,
    ];
  }
}