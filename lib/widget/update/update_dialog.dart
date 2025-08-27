import 'dart:io';
import 'package:flutter/material.dart';
import '../../bean/update/update_info.dart';
import '../../http/service/update/update_service.dart';
import '../../theme.dart';
import '../../utils/color_utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.system_update,
            color: AppTheme().color,
            size: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            '发现新版本',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 版本信息
            Row(
              children: [
                const Text(
                  '当前版本：',
                  style: TextStyle(fontSize: 14),
                ),
                FutureBuilder(
                  future: _updateService.getCurrentVersion(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.version,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return const Text('获取中...', style: TextStyle(fontSize: 14));
                  },
                ),
                const SizedBox(width: 20),
                const Text(
                  '最新版本：',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  widget.updateInfo.version,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme().color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 更新日志
            const Text(
              '更新内容：',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorUtils.colorBackgroundLine,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: ColorUtils.colorGrayLight),
              ),
              child: SingleChildScrollView(
                child: Text(
                  widget.updateInfo.changelog.isEmpty
                      ? '暂无更新说明'
                      : widget.updateInfo.changelog,
                  style: const TextStyle(fontSize: 12, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 下载进度
            if (_isDownloading) ...[
              Row(
                children: [
                  const Text('下载进度：', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Text(
                    '${(_downloadProgress * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme().color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _downloadProgress,
                backgroundColor: ColorUtils.colorGrayLight,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme().color),
              ),
              const SizedBox(height: 16),
            ],

            // 下载完成提示
            if (_downloadCompleted) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorUtils.colorGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: ColorUtils.colorGreen),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: ColorUtils.colorGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '下载完成！点击安装按钮重启应用并安装更新',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorUtils.colorGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      actions: [
        // 取消按钮（非强制更新时显示）
        if (!widget.updateInfo.forceUpdate && !_isDownloading)
          TextButton(
            onPressed: () {
              widget.onCancel?.call();
              Navigator.of(context).pop();
            },
            child: const Text('稍后再说'),
          ),

        // 下载/安装按钮
        ElevatedButton(
          onPressed: (_isDownloading || _isInstalling) ? null : _handleAction,
          child: Text(_getActionButtonText()),
        ),
      ],
    );
  }

  String _getActionButtonText() {
    if (_isDownloading) {
      return '下载中...';
    } else if (_isInstalling) {
      return '安装中...'; // Show "Installing..." when installing
    } else if (_downloadCompleted) { // If download is complete, but not yet installing
      return '立即安装 (将关闭应用)';
    } else {
      return '立即更新';
    }
  }

  void _handleAction() async {
    if (_downloadCompleted) {
      // 安装更新（带详细错误提示）
      await _installWithFeedback();
    } else {
      // 开始下载
      _startDownload();
    }
  }

  void _startDownload() async {
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

    setState(() {
      _isDownloading = false;
      if (success) {
        _downloadCompleted = true;
        // 下载完成后自动解压
        _extractAndCheck();
      }
    });

    if (!success) {
      // 显示下载失败提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('下载失败，请检查网络连接后重试'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // 解压并检查.exe文件
  void _extractAndCheck() async {
    try {
      // 显示解压提示
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('正在解压更新包...'),
            backgroundColor: Colors.blue,
          ),
        );
      }

      // 解压ZIP包
      final extractSuccess = await _updateService.extractUpdatePackage();

      if (extractSuccess) {
        // 检查是否有.exe文件（Windows）或其他平台安装介质
        bool found = false;
        if (Platform.isWindows) {
          found = await _updateService.existsByExtension('.exe');
        } else if (Platform.isMacOS) {
          // mac 可以只做提示：解压成功，点击安装后尝试 open
          found = true;
        } else {
          found = true;
        }

        if (found) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('解压完成，安装介质已就绪'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('解压完成，但未找到安装程序(.exe文件)'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('解压失败，请检查文件完整性'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('解压过程出错: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _installWithFeedback() async {
    setState(() {
      _isInstalling = true; // Set installing state
    });
    try {
      // 检查平台支持
      if (!Platform.isWindows) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('当前平台不支持自动安装: ${Platform.operatingSystem}'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Windows: 先确保存在 .exe
      final hasExe = await _updateService.existsByExtension('.exe');
      if (!hasExe) {
        throw Exception('未找到安装程序(.exe)。请检查ZIP内容是否包含安装包。');
      }

      // 显示确认对话框
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('确认安装'),
          content: const Text(
            '即将开始安装更新，安装过程中应用将自动关闭。\n\n'
            '安装完成后，请重新启动应用以使用新版本。\n\n'
            '是否继续？'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('取消'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('确认安装'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        setState(() {
          _isInstalling = false;
        });
        return;
      }

      final ok = await _updateService.installUpdate();
      if (!ok) {
        throw Exception('安装程序未能启动。可能被系统或安全软件拦截。');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('正在启动安装程序，应用将自动关闭...'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('安装失败：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInstalling = false; // Reset installing state
        });
      }
    }
  }

  @override
  void dispose() {
    // 如果下载未完成，清理下载文件
    if (!_downloadCompleted) {
      _updateService.cleanupDownload();
    }
    super.dispose();
  }
}
