import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';
import '../../bean/update/update_info.dart';
import '../../http/service/update/update_service.dart';
import '../../theme.dart';
import '../../utils/color_utils.dart';
import '../../utils/context_utils.dart';

class UpdateDialog extends StatefulWidget {
  final UpdateInfo updateInfo;
  final VoidCallback? onCancel;

  const UpdateDialog({
    super.key,
    required this.updateInfo,
    this.onCancel,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final UpdateService _updateService = UpdateService();
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  bool _downloadCompleted = false;
  bool _isInstalling = false;

  BuildContext _snackContext() {
    final overlayCtx = ContextUtils.instance.getGlobalContext();
    return overlayCtx ?? context;
  }

  void _showSnack(String msg, Color color, {int seconds = 3}) {
    LoadingUtils.showInfo(data: msg);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = screenSize.width > 600 ? 500.0 : screenSize.width * 0.9;
    final dialogHeight = screenSize.height > 700
        ? (_isDownloading ? 400.0 : 358.0)
        : screenSize.height * 0.7;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // 顶部蓝色渐变区域
            Container(
              height: 136,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/home/ic_update_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // 标题和关闭按钮
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '新版本，抢先体验',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'v${widget.updateInfo.version}版本上线啦',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF202020),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 关闭按钮
                  Visibility(
                    visible: widget.updateInfo.forceUpdate != true,
                    child: Positioned(
                      top: 0,
                      right: 6,
                      child: GestureDetector(
                        onTap: () {
                          widget.onCancel?.call();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.close,
                            color: Color(0xFF999999),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // 白色内容区域
            Expanded(
              flex: 256,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '本次更新：',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // 更新内容列表
                    Container(
                      width: double.infinity,
                      height: 80,
                      child: SingleChildScrollView(
                        child: Text(
                          widget.updateInfo.changelog.isEmpty
                              ? '暂无更新说明'
                              : widget.updateInfo.changelog,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // 下载进度区域
                    if (_isDownloading) ...[
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: _downloadProgress,
                        backgroundColor: const Color(0xFFE5E5E5),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4ABCD0)),
                        minHeight: 6,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            '下载进度：',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(_downloadProgress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4ABCD0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 底部按钮区域
                    _isDownloading
                        ? _buildDownloadingButtons()
                        : _buildNormalButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF44C5C4),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 版本记录按钮
        Container(
          width: 110,
          height: 32,
          child: OutlinedButton(
            onPressed: () {
              // 版本记录功能
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              '版本记录',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF44C5C4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // 立即安装按钮
        Container(
          width: 110,
          height: 32,
          child: ElevatedButton(
            onPressed: _startDownload,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF44C5C4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              elevation: 0,
            ),
            child: const Text(
              '立即安装',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadingButtons() {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4ABCD0), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextButton(
        onPressed: () async {
          // 取消下载
          await _updateService.cancelDownload();
          setState(() {
            _isDownloading = false;
            _downloadProgress = 0.0;
          });
        },
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF4ABCD0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: const Text(
          '取消下载',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showVersionHistory() {
    // 显示版本历史记录对话框
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('版本记录'),
        content: const Text('这里显示版本历史记录...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  String _getActionButtonText() {
    if (_isDownloading) {
      return '下载中...';
    } else if (_isInstalling) {
      return '安装中...';
    } else if (_downloadCompleted) {
      return '立即安装';
    } else {
      return '立即安装';
    }
  }

  void _handleAction() async {
    if (_downloadCompleted) {
      // 安装更新
      await _installWithFeedback();
    } else {
      // 开始下载
      _startDownload();
    }
  }

  Future<void> _startDownload() async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    final success = await _updateService.downloadUpdate(
      widget.updateInfo,
      (progress) {
        setState(() {
          _downloadProgress = progress;
        });
      },
    );

    // 先更新下载状态
    setState(() {
      _isDownloading = false;
      _downloadCompleted = success;
    });

    if (success) {
      // ✅ 等待提取和检查完成
      await _extractAndCheck();
      // ✅ 再执行提取完成后的逻辑
      _showSnack('提取完成', Colors.green);
      await _installWithFeedback();
    } else if (_updateService.cancelToken?.isCancelled != true) {
      // ✅ 下载失败且不是取消
      _showSnack('下载失败，请检查网络连接后重试', Colors.red);
    }
  }

  Future<void> _extractAndCheck() async {
    try {
      _showSnack('正在解压更新包...', Colors.blue, seconds: 2);

      final extractSuccess = await _updateService.extractUpdatePackage();

      if (extractSuccess) {
        bool found = false;

        if (Platform.isWindows) {
          found = await _updateService.existsByExtension('.exe');
        } else {
          found = true;
        }

        if (found) {
          _showSnack('解压完成，安装介质已就绪', Colors.green, seconds: 2);
        } else {
          _showSnack('解压完成，但未找到安装程序 (.exe 文件)', Colors.orange);
        }
      } else {
        _showSnack('解压失败，请检查文件完整性', Colors.red);
      }
    } catch (e) {
      _showSnack('解压过程出错: $e', Colors.red);
    }
  }

  Future<void> _installWithFeedback() async {
    setState(() {
      _isInstalling = true;
    });
    try {
      if (!Platform.isWindows) {
        _showSnack('当前平台不支持自动安装，请在Windows系统上使用此功能', Colors.red);
        setState(() {
          _isInstalling = false;
        });
        return;
      }

      final hasExe = await _updateService.existsByExtension('.exe');
      if (!hasExe) {
        _showSnack('未找到安装程序(.exe)。请检查ZIP内容是否包含安装包。', Colors.red);
        setState(() {
          _isInstalling = false;
        });
        return;
      }

      final ok = await _updateService.installUpdate();
      if (!ok) {
        _showSnack('安装程序未能启动。可能被系统或安全软件拦截，或者安装脚本创建失败。', Colors.red);
        setState(() {
          _isInstalling = false;
        });
        return;
      }

      _showSnack('正在启动安装程序，应用将自动关闭...', Colors.green, seconds: 2);
    } catch (e) {
      _showSnack('安装失败：$e', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isInstalling = false;
        });
      }
    }
  }

  // 测试脚本创建（用于诊断）
  Future<void> _testScriptCreation() async {
    try {
      _showSnack('开始测试脚本创建...', Colors.blue);
      
      final result = await _updateService.testScriptCreation();
      
      // 显示测试结果
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('脚本测试结果'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('平台: ${result['platform'] ?? 'unknown'}'),
                  Text('Windows: ${result['isWindows'] ?? false}'),
                  Text('应用目录: ${result['appDir'] ?? 'unknown'}'),
                  Text('应用目录存在: ${result['appDirExists'] ?? false}'),
                  Text('脚本创建: ${result['scriptCreated'] ?? false}'),
                  Text('脚本路径: ${result['scriptPath'] ?? 'unknown'}'),
                  Text('脚本存在: ${result['scriptExists'] ?? false}'),
                  Text('脚本大小: ${result['scriptSize'] ?? 0} 字节'),
                  Text('CMD可用: ${result['cmdAvailable'] ?? false}'),
                  Text('工作目录可写: ${result['workDirWritable'] ?? false}'),
                  if (result['error'] != null) 
                    Text('错误: ${result['error']}', style: const TextStyle(color: Colors.red)),
                  if (result['scriptFirstLine'] != null)
                    Text('脚本首行: ${result['scriptFirstLine']}'),
                  if (result['testCommand1'] != null)
                    Text('测试命令1: ${result['testCommand1']}'),
                  if (result['testCommand2'] != null)
                    Text('测试命令2: ${result['testCommand2']}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('关闭'),
              ),
            ],
          ),
        );
      }
      
      if (result['success'] == true) {
         _showSnack('脚本测试完成，请查看项目目录/logs/文件夹中的日志获取详细信息', Colors.green);
       } else {
         _showSnack('脚本测试失败: ${result['error'] ?? '未知错误'}', Colors.red);
       }
      
    } catch (e) {
      _showSnack('测试脚本创建失败: $e', Colors.red);
    }
  }
}
