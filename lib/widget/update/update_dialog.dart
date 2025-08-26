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
          onPressed: _isDownloading ? null : _handleAction,
          child: Text(_getActionButtonText()),
        ),
      ],
    );
  }

  String _getActionButtonText() {
    if (_isDownloading) {
      return '下载中...';
    } else if (_downloadCompleted) {
      return '立即安装';
    } else {
      return '立即更新';
    }
  }

  void _handleAction() async {
    if (_downloadCompleted) {
      // 安装更新
      await _updateService.installUpdate();
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
        // 检查是否有.exe文件
        final hasExe = await _updateService.existsByExtension('.exe');

        if (hasExe) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('解压完成，找到安装程序！'),
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

  @override
  void dispose() {
    // 如果下载未完成，清理下载文件
    if (!_downloadCompleted) {
      _updateService.cleanupDownload();
    }
    super.dispose();
  }
}
