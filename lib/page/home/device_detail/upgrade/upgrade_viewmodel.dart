import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/kayo_package_utils.dart';
import 'package:omt/http/service/upgrade/upgrade_service.dart';
import 'package:kayo_package/utils/loading_utils.dart';
import 'package:omt/http/service/home/home_page/home_page_service.dart';
import 'package:omt/http/service/fileService/fileService.dart';
import 'package:omt/utils/context_utils.dart';

import '../../../../widget/upgrade_dialog.dart';

/// 升级ViewModel
class UpgradeViewModel extends ChangeNotifier {
  final UpgradeService _upgradeService = UpgradeService();

  String? _deviceCode;
  String? _deviceIp;
  bool _isUpgrading = false;
  bool _isDownloading = false;
  Timer? _statusCheckTimer;
  Timer? _timeoutTimer; // 添加超时定时器
  bool _isLocalUpgradeMode = false; // 标记是否为本地升级模式

  bool get isUpgrading => _isUpgrading;

  bool get isDownloading => _isDownloading;

  void setDeviceInfo(String deviceCode, String deviceIp) {
    _deviceCode = deviceCode;
    _deviceIp = deviceIp;
  }

  /// 开始下载流程
  void startDownload(
      String upgradeType, String downloadUrl) {
    // 防止多次点击下载
    if (_isDownloading) {
      LoadingUtils.showToast(data: '正在下载中，请稍等...');
      return;
    }

    if (downloadUrl.isEmpty) {
      LoadingUtils.showToast(data: '下载链接不能为空');
      return;
    }

    // 设置下载状态
    _isDownloading = true;
    notifyListeners();

    // 获取文件名
    String fileName = downloadUrl.split('/').last;
    if (fileName.isEmpty) {
      fileName = 'upgrade_file_${DateTime.now().millisecondsSinceEpoch}';
    }

    // 获取全局context
    final context = ContextUtils.instance.getGlobalContext();
    if (context == null) {
      LoadingUtils.showToast(data: '获取上下文失败');
      _isDownloading = false;
      notifyListeners();
      return;
    }
    
    // 调用FileService进行下载并选择保存位置
    FileService().downloadWithSaveDialog(
      context,
      downloadUrl,
      fileName: fileName,
      loading: '正在下载升级文件，请稍等...',
      loadingFail: '下载失败，请检查网络连接后重试',
      onSuccess: (savedPath) {
        // 重置下载状态
        _isDownloading = false;
        notifyListeners();
        LoadingUtils.showToast(data: '文件已保存至: $savedPath');
      },
      onCancel: () {
        // 重置下载状态
        _isDownloading = false;
        notifyListeners();
        LoadingUtils.showToast(data: '已取消下载');
      },
    );
  }

  /// 开始升级流程
  void startUpgrade( String upgradeType) {
    LoadingUtils.show();
    // 防止多次点击触发多个重叠的弹窗
    if (_isUpgrading) {
      return;
    }

    if (_deviceCode == null || _deviceIp == null) {
      LoadingUtils.showToast(data: '设备信息不完整');
      return;
    }

    // 设置升级状态为true，防止重复点击
    _isUpgrading = true;
    notifyListeners();

    // 获取全局context
    final context = ContextUtils.instance.getGlobalContext();
    if (context == null) {
      LoadingUtils.showToast(data: '获取上下文失败');
      _isUpgrading = false;
      notifyListeners();
      return;
    }
    
    // 请求接口检查是否可以在线升级
    _checkOnlineUpgradeStatus(context, upgradeType);
  }

  /// 检查是否可以在线升级
  void _checkOnlineUpgradeStatus(BuildContext context, String upgradeType) {
    _upgradeService.checkOnlineUpgradeStatus(
      deviceIp: _deviceIp!,
      onSuccess: (data) {
        LoadingUtils.dismiss();
        // 解析返回的状态
        int status = data?['status'] ?? 2; // 默认为2（不可在线升级）

        if (status == 1) {
          // status=1 可以在线升级，显示升级方式选择弹窗
          // 检查工控机连通性
          _checkControllerConnectivity(context, upgradeType);
        } else {
          // status=2 不可以在线升级，默认本地上传升级
          _showFileUploadDialog(context, upgradeType);
        }
      },
      onError: (error) {
        // 请求失败，显示提示并阻止继续操作
        LoadingUtils.showToast(data: '无法连接工控机!');
        // 防止多次点击导致弹窗重叠
        _isUpgrading = false;
        notifyListeners();
      },
    );
  }

  /// 检查工控机连通性
  void _checkControllerConnectivity(BuildContext context, String upgradeType) {
    _upgradeService.checkControllerConnectivity(
      host: _deviceIp!,
      onSuccess: (isConnected) {
        if (isConnected) {
          // 连通，显示升级方式选择弹窗
          _showUpgradeMethodDialog(context, upgradeType);
        } else {
          // 不连通，默认本地上传升级
          _showFileUploadDialog(context, upgradeType);
        }
      },
      onError: (error) {
        // 连接失败，默认本地上传升级
        _isUpgrading = false;
        notifyListeners();
        _showFileUploadDialog(context, upgradeType);
      },
    );
  }

  /// 显示升级方式选择弹窗
  void _showUpgradeMethodDialog(BuildContext context, String upgradeType) {
    String title = upgradeType == 'program' ? '主程版本升级' : '识别版本升级';

    // 重置升级状态，允许用户关闭弹窗后重新操作
    _isUpgrading = false;
    notifyListeners();

    // 在显示对话框前检查context是否仍然有效
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context1) => UpgradeMethodDialog(
          title: title,
          onLocalUpgrade: () {
            if (context.mounted) {
              _showFileUploadDialog(context1, upgradeType);
            }
          },
          onOnlineUpgrade: () {
            if (context.mounted) {
              _startOnlineUpgrade(context1, upgradeType);
            }
          },
        ),
      );
    }
  }

  /// 显示文件上传弹窗
  void _showFileUploadDialog(BuildContext context, String upgradeType) {
    String title = upgradeType == 'program' ? '主程版本升级' : '识别版本升级';
    String? selectedFilePath;

    // 重置升级状态，允许用户关闭弹窗后重新操作
    _isUpgrading = false;
    notifyListeners();

    // 在显示对话框前检查context是否仍然有效
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => FileUploadDialog(
          title: title,
          onFileSelected: (filePath) {
            selectedFilePath = filePath;
          },
          onConfirm: () {
            if (context.mounted && selectedFilePath != null) {
              _startLocalUpgrade(context, upgradeType, selectedFilePath!);
            }
          },
        ),
      );
    }
  }

  /// 开始本地上传升级
  void _startLocalUpgrade(
      BuildContext context, String upgradeType, String filePath) {
    _isUpgrading = true;
    _isLocalUpgradeMode = true; // 标记为本地升级模式
    notifyListeners();

    _upgradeService.uploadUpgradeFile(
      deviceIp: _deviceIp!,
      filePath: filePath,
      upgradeType: upgradeType,
      onSuccess: (data) {
        // 上传成功，开始等待升级
        _startWaitingUpgrade(context, upgradeType);
      },
      onError: (error) {
        _isUpgrading = false;
        notifyListeners();
        // 在使用Navigator前检查context是否仍然有效
        if (context.mounted) {
          Navigator.of(context).pop(); // 关闭上传弹窗
          _showUpgradeFailureDialog(context, upgradeType, error);
        }
      },
      onProgress: (progress) {
        // 更新上传进度
      },
    );
  }

  /// 开始在线升级
  void _startOnlineUpgrade(BuildContext context, String upgradeType) {
    _isUpgrading = true;
    _isLocalUpgradeMode = false; // 标记为在线升级模式
    notifyListeners();

    if (_deviceCode == null) {
      LoadingUtils.showToast(data: '设备信息不完整');
      _isUpgrading = false;
      notifyListeners();
      return;
    }

    // 显示正在升级的对话框
    String title = upgradeType == 'program' ? '主程版本升级' : '识别版本升级';
    // 在显示对话框前检查context是否仍然有效
    if (context.mounted) {
      // 显示升级进度对话框
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => UpgradeProgressDialog(
          title: title,
          showCloseButton: false, // 升级过程中不显示关闭按钮
        ),
      );
    }

    // 根据升级类型调用不同的接口
    if (upgradeType == 'program') {
      // 调用升级AI设备主程版本接口
      HomePageService().upgradeAiDeviceProgram(
        deviceCode: _deviceCode!,

        onSuccess: (data) {

          _startWaitingUpgrade(context, upgradeType);
        },
        onError: (error) {

          _isUpgrading = false;
          notifyListeners();
          Navigator.of(context).pop(); // 关闭等待弹窗
          _showUpgradeFailureDialog(context, upgradeType, error);
        },
      );
    } else if (upgradeType == 'identity') {
      // 调用升级AI设备识别版本接口
      HomePageService().upgradeAiDeviceIdentity(
        deviceCode: _deviceCode!,

        onSuccess: (data) {

          _startWaitingUpgrade(context, upgradeType);
        },
        onError: (error) {

          _isUpgrading = false;
          notifyListeners();
          Navigator.of(context).pop(); // 关闭等待弹窗
          _showUpgradeFailureDialog(context, upgradeType, error);
        },
      );
    }
  }

  /// 开始等待升级
  void _startWaitingUpgrade(BuildContext context, String upgradeType) {

    
    _isUpgrading = true;
    notifyListeners();

    print(
        '_startWaitingUpgrade: 开始等待升级 - upgradeType=$upgradeType, context.mounted=${context.mounted}');

    // 注意：不再显示对话框，因为在 _startOnlineUpgrade 方法中已经显示了

    // 设置15秒总超时（确保比ping超时时间长）
    _timeoutTimer = Timer(const Duration(seconds: 15), () {
      print('_startWaitingUpgrade: 15秒总超时触发');
      

      
      if (_isUpgrading && context.mounted) {
        // 取消所有可能的定时器
        _statusCheckTimer?.cancel();

        // 确保关闭进度对话框并显示错误界面
        print('_startWaitingUpgrade: 调用_onUpgradeFailure显示超时错误');
        _onUpgradeFailure(context, upgradeType, '升级总超时，请检查设备状态');
      } else {
        print(
            '_startWaitingUpgrade: 超时时_isUpgrading=${_isUpgrading}, context.mounted=${context.mounted}');

        // 即使状态不是升级中，也尝试显示失败对话框
        if (context.mounted) {
          print('_startWaitingUpgrade: 尝试显示超时错误');
          _onUpgradeFailure(context, upgradeType, '升级总超时，请检查设备状态');
        }
      }
    });

    // 1秒后开始ping设备
    Future.delayed(const Duration(seconds: 1), () {

      
      // 获取全局context
      final context = ContextUtils.instance.getGlobalContext();
      if (context == null) {
        print('获取上下文失败，无法开始ping设备');
        return;
      }
      _startPingDevice(context, upgradeType);
    });
  }

  /// 开始ping设备
  void _startPingDevice(BuildContext context, String upgradeType) {

    Timer? pingTimer;
    int pingCount = 0;
    const maxPingAttempts = 5; // 最多ping 6次（12秒）

    pingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {

      pingCount++;

      if (pingCount > maxPingAttempts) {
        timer.cancel();
        // ping超时时直接调用失败处理
        print('Ping设备超时，显示失败界面');
        if (context.mounted) {
          _onUpgradeFailure(context, upgradeType, "设备连接超时，请检查设备网络状态");
        }
        return;
      }

      // 使用命令行ping替代HTTP请求模拟ping
      bool isReachable = true;
      try {
        final isWindows = Platform.isWindows;
        final List<String> arguments = isWindows
            ? ['-n', '1', '-w', '1000', _deviceIp!]
            : ['-c', '1', '-W', '1', _deviceIp!];
        final result = await Process.run('ping', arguments);

        isReachable = result.exitCode == 0;
      } catch (e) {
        print('Ping 错误: $e');

        // isReachable = false;
      }

      if (isReachable) {
        timer.cancel();
        print('_startPingDevice: ping通了');
        // ping通后，区分升级类型处理
        _handlePingSuccess(context, upgradeType);

      }
    });
  }

  /// 处理ping成功后的逻辑
  void _handlePingSuccess(BuildContext context, String upgradeType) {
    // 判断是否为本地升级
    // 本地升级：ping通就直接成功
    // 在线升级：继续走验证流程
    if (_isLocalUpgrade()) {
      // 本地升级，ping通就直接成功
      print('_handlePingSuccess: 本地升级，ping通直接成功');
      _onUpgradeSuccess(context, upgradeType);
    } else {
      // 在线升级，继续检查升级状态
      print('_handlePingSuccess: 在线升级，继续验证');
      if (upgradeType == 'program') {
        // 如果是升级主程，延迟3秒
        Future.delayed(Duration(seconds: 3), () {
          _startCheckUpgradeStatus(context, upgradeType);
        });
      } else {
        _startCheckUpgradeStatus(context, upgradeType);
      }
    }
  }

  /// 判断是否为本地升级
  bool _isLocalUpgrade() {
    return _isLocalUpgradeMode;
  }

  /// 开始检查升级状态
  void _startCheckUpgradeStatus(BuildContext context, String upgradeType) {

    final homePageService = HomePageService();

    // 首先检查context是否有效
    if (!context.mounted) {
      print('_startCheckUpgradeStatus: context已失效，无法继续');
      _isUpgrading = false;
      notifyListeners();
      return;
    }

    if (_deviceCode != null && _deviceIp != null) {
      try {
        print('_startCheckUpgradeStatus: 开始检查升级状态 - upgradeType=$upgradeType');
        homePageService.checkEventStatusAi(
          // 不再需要传递eventId参数
          udid: _deviceCode!,
          deviceIp: _deviceIp!,

          onSuccess: (success) {
            print(
                'checkEventStatusAi.onSuccess: success=$success, context.mounted=${context.mounted}');
            _isUpgrading = false;
            notifyListeners();
            // Navigator.of(context).pop(); // 关闭等待弹窗
            if (success) {
              // 验证成功
              if (context.mounted) {
                _onUpgradeSuccess(context, upgradeType);
              } else {
                print('checkEventStatusAi.onSuccess: context已失效，无法显示成功对话框');
                notifyListeners();
              }
            } else {
              // 验证失败
              if (context.mounted) {
                _onUpgradeFailure(context, upgradeType, "升级失败!");
              } else {
                print('checkEventStatusAi.onSuccess: context已失效，无法显示失败对话框');
                notifyListeners();
              }
            }
          },
          onError: (error) {
            _isUpgrading = false;
            notifyListeners();
            Navigator.of(context).pop(); // 关闭等待弹窗
            print(
                'checkEventStatusAi.onError: error=$error, context.mounted=${context.mounted}');
            if (context.mounted) {
              _onUpgradeFailure(context, upgradeType, "升级出错: $error");
            } else {
              print('checkEventStatusAi.onError: context已失效，无法显示错误对话框');
            }
          },
          // 添加重试回调
          // retryCallback: () {
          //   // 重试逻辑，可以在这里添加重试次数限制
          //   print(
          //       'checkEventStatusAi重试回调被触发, context.mounted=${context.mounted}');
          //   Future.delayed(const Duration(seconds: 2), () {
          //     if (_isUpgrading && context.mounted) {
          //       print('执行重试: _startCheckUpgradeStatus');
          //       _startCheckUpgradeStatus(context, upgradeType);
          //     } else {
          //       print(
          //           '重试条件不满足: _isUpgrading=${_isUpgrading}, context.mounted=${context.mounted}');
          //       // 如果状态已经不是升级中，但context仍然有效，显示失败对话框
          //       if (context.mounted) {
          //         _onUpgradeFailure(context, upgradeType, '升级状态检查失败，请重试');
          //       } else {
          //         print('重试回调: context已失效，无法显示失败对话框');
          //         _isUpgrading = false;
          //         notifyListeners();
          //       }
          //     }
          //   });
          // },
        );
      } catch (e) {
        // 捕获可能的异常
        print(
            '_startCheckUpgradeStatus异常: $e, context.mounted=${context.mounted}');
        if (context.mounted) {
          _onUpgradeFailure(context, upgradeType, "升级异常: $e");
        } else {
          print('异常处理: context已失效，无法显示异常对话框');
          _isUpgrading = false;
          notifyListeners();
        }
      }
    } else {
      // 设备代码为空，无法继续
      print(
          '_startCheckUpgradeStatus: 设备代码为空，无法继续, context.mounted=${context.mounted}');
      if (context.mounted) {
        _onUpgradeFailure(context, upgradeType, "设备信息不完整，无法验证升级状态");
      } else {
        print('设备代码为空处理: context已失效，无法显示错误对话框');
        _isUpgrading = false;
        notifyListeners();
      }
    }
  }

  /// 升级成功
  void _onUpgradeSuccess(BuildContext context, String upgradeType) {
    _isUpgrading = false;
    _isLocalUpgradeMode = false; // 重置升级模式标记
    notifyListeners();

    // 在使用Navigator前检查context是否仍然有效
    if (context.mounted) {
      Navigator.of(context).pop(); // 关闭等待弹窗
      _showUpgradeSuccessDialog(context, upgradeType);
    }
  }

  /// 显示升级成功弹窗
  void _showUpgradeSuccessDialog(BuildContext context, String upgradeType) {
    String title = upgradeType == 'program' ? '主程版本升级' : '识别版本升级';

    // 在显示对话框前检查context是否仍然有效
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => UpgradeResultDialog(
          title: title,
          isSuccess: true,
          onConfirm: () {
            // 升级成功后的处理逻辑
          },
        ),
      );
    }
  }

  /// 升级失败
  void _onUpgradeFailure(BuildContext context, String upgradeType, String error) {
    _isUpgrading = false;
    _isLocalUpgradeMode = false; // 重置升级模式标记
    notifyListeners();

    print(
        '_onUpgradeFailure被调用: upgradeType=$upgradeType, error=$error, context.mounted=${context.mounted}');
        


    // 在使用Navigator前检查context是否仍然有效
    if (!context.mounted) {
      print('_onUpgradeFailure: context已销毁，无法显示升级失败对话框');
      return;
    }

    // 安全地关闭等待弹窗
    try {
      // 检查是否有对话框正在显示
      if (ModalRoute.of(context)?.isCurrent == false) {

        print('_onUpgradeFailure: 关闭等待弹窗');
        Navigator.of(context).pop(); // 关闭等待弹窗
      } else {
        print('_onUpgradeFailure: 没有对话框需要关闭');
      }
    } catch (e) {
      print('_onUpgradeFailure: 关闭等待弹窗时出错 - $e');
    }

    // 再次检查context是否仍然有效
    if (!context.mounted) {
      print('_onUpgradeFailure: 关闭对话框后context已销毁，无法显示升级失败对话框');
      return;
    }

    // 显示失败对话框，添加延迟确保弹窗关闭后再显示
    // 减少延迟时间，避免context在此期间被销毁
    print('_onUpgradeFailure: 延迟200毫秒后显示失败对话框');
    Future.delayed(Duration(milliseconds: 200), () {

      
      print('_onUpgradeFailure: 延迟结束，检查context.mounted=${context.mounted}');
      if (context.mounted) {
        print('_onUpgradeFailure: 显示失败对话框');
        _showUpgradeFailureDialog(context, upgradeType, error);
      } else {
        print('_onUpgradeFailure: 延迟后context已销毁，无法显示失败对话框');
      }
    });
  }

  /// 显示升级失败弹窗
  void _showUpgradeFailureDialog(
      BuildContext context, String upgradeType, String reason) {
    String title = upgradeType == 'program' ? '主程版本升级失败' : '识别版本升级失败';

    // 打印日志，帮助调试
    print(
        '_showUpgradeFailureDialog: 准备显示升级失败对话框 - upgradeType=$upgradeType, reason=$reason, context.mounted=${context.mounted}');

    // 在显示对话框前检查context是否仍然有效
    if (!context.mounted) {
      print('_showUpgradeFailureDialog: context已销毁，无法显示对话框');
      _isUpgrading = false;
      notifyListeners();
      return;
    }

    print('_showUpgradeFailureDialog: 显示对话框 - title=$title');

    // 安全地显示对话框
    try {
      showDialog(
        context: context,
        barrierDismissible: false, // 防止用户点击外部关闭对话框
        builder: (dialogContext) => UpgradeResultDialog(
          title: title,
          isSuccess: false,
          errorDetails: reason,
          onRetry: () {
            print(
                '_showUpgradeFailureDialog.onRetry: 用户点击重试按钮 - upgradeType=$upgradeType');
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
              // 延迟执行重试，确保对话框已关闭
              Future.delayed(Duration(milliseconds: 100), () {

                
                print(
                    '_showUpgradeFailureDialog.onRetry: 延迟后执行重试 - context.mounted=${context.mounted}');
                if (context.mounted) {
                  // 重新开始升级流程
                  startUpgrade( upgradeType);
                } else {
                  print(
                      '_showUpgradeFailureDialog.onRetry: 延迟后context已销毁，无法执行重试');
                }
              });
            }
          },
          // 确保onConfirm回调被设置，即使失败时也能关闭对话框
          onConfirm: () {
            print('_showUpgradeFailureDialog.onConfirm: 用户点击确认按钮');
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
              _isUpgrading = false;
              notifyListeners();
            }
          },
        ),
      ).then((_) {
        print('_showUpgradeFailureDialog: 对话框已关闭');
      });
      print('_showUpgradeFailureDialog: 升级失败对话框显示方法已调用');
    } catch (e) {
      print('_showUpgradeFailureDialog: 显示对话框时出错 - $e');
      _isUpgrading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _statusCheckTimer?.cancel();
    super.dispose();
  }
}
