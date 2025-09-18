import 'dart:async';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:file_picker/file_picker.dart';

/// 基础对话框容器
class BaseUpgradeDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final double width;
  final double height;
  final VoidCallback? onClose;

  const BaseUpgradeDialog({
    super.key,
    required this.title,
    required this.child,
    required this.width,
    required this.height,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ),
      style: const ContentDialogThemeData(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
      ),
      content: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/device_detail/ic_upgrade_bg.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            // 标题
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // 关闭按钮
            Positioned(
              top: 6,
              right: 8,
              child: IconButton(
                icon: const Icon(
                  FluentIcons.chrome_close,
                  size: 20,
                  color: Color(0xFF85A3A1),
                ),
                onPressed: onClose ?? () => Navigator.of(context).pop(),
              ),
            ),
            // 内容区域
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              bottom: 0,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

/// 统一的升级按钮样式
class UpgradeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool hasBackground;

  const UpgradeButton({
    super.key,
    required this.text,
    this.onPressed,
    this.hasBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasBackground) {
      // 无背景样式，仅显示文字
      return Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      );
    }

    return SizedBox(
      width: 110,
      height: 32,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: ButtonState.all(
            onPressed != null ? "#4ECDC4".toColor() : Colors.grey,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// 升级方式选择弹窗
class UpgradeMethodDialog extends StatelessWidget {
  final String title;
  final VoidCallback? onLocalUpgrade;
  final VoidCallback? onOnlineUpgrade;
  final bool showOnlineUpgrade; // 是否显示在线升级选项

  const UpgradeMethodDialog({
    super.key,
    required this.title,
    this.onLocalUpgrade,
    this.onOnlineUpgrade,
    this.showOnlineUpgrade = true,
  });

  @override
  Widget build(BuildContext context) {
    // 如果不显示在线升级，直接调用本地升级
    if (!showOnlineUpgrade) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
        onLocalUpgrade?.call();
      });
    }

    return BaseUpgradeDialog(
      title: title,
      width: 460,
      height: 354,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 在线升级选项
            if (showOnlineUpgrade) ...[
              _buildUpgradeOption(
                iconPath: 'assets/device_detail/ic_upgrade_online.png',
                label: '在线升级',
                labelColor: const Color(0xFF14CA7C),
                onTap: () {
                  Navigator.of(context).pop();
                  onOnlineUpgrade?.call();
                },
              ),
              const SizedBox(width: 30),
            ],
            // 本地上传升级选项
            _buildUpgradeOption(
              iconPath: 'assets/device_detail/ic_upgrade_local.png',
              label: '本地上传升级',
              labelColor: "#2F94DD".toColor(),
              onTap: () {
                Navigator.of(context).pop();
                onLocalUpgrade?.call();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeOption({
    required String iconPath,
    required String label,
    required Color labelColor,
    required VoidCallback onTap,
  }) {
    return Clickable(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 图标
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Image.asset(
                iconPath,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            // 文字说明
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 升级进度弹窗
class UpgradeProgressDialog extends StatefulWidget {
  final String title;
  final String message;
  final double? progress;
  final VoidCallback? onCancel;
  final VoidCallback? onTimeout;

  const UpgradeProgressDialog({
    super.key,
    required this.title,
    this.message = '正在升级',
    this.progress,
    this.onCancel,
    this.onTimeout,
  });

  @override
  State<UpgradeProgressDialog> createState() => _UpgradeProgressDialogState();
}

class _UpgradeProgressDialogState extends State<UpgradeProgressDialog> {
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    // 启动10秒超时计时器
    _timeoutTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        widget.onTimeout?.call();
      }
    });
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseUpgradeDialog(
      title: widget.title,
      width: 470,
      height: 300,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 80x80 加载圈
          SizedBox(
            width: 70,
            height: 70,
            child: ProgressRing(
                strokeWidth: 8, backgroundColor: ColorUtils.colorBlackLiteLite),
          ),
          SizedBox(height: 20),
          // 正在升级按钮
          Text(
            '正在升级',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF14CC7E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// 升级结果弹窗（合并成功和失败）
class UpgradeResultDialog extends StatelessWidget {
  final String title;
  final bool isSuccess;
  final String? errorDetails;
  final VoidCallback? onConfirm;
  final VoidCallback? onRetry;

  const UpgradeResultDialog({
    super.key,
    required this.title,
    required this.isSuccess,
    this.errorDetails,
    this.onConfirm,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BaseUpgradeDialog(
      title: title,
      width: 470,
      height: isSuccess ? 350 : (errorDetails != null ? 350 : 350),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 结果图标
          const SizedBox(height: 30),
          // Icon(
          //   isSuccess ? FluentIcons.check_mark : FluentIcons.error_badge,
          //   size: 48,
          //   color: isSuccess ? Colors.green : Colors.red,
          // ),
          Image.asset(
            isSuccess
                ? 'assets/device_detail/ic_upgrade_success.gif'
                : 'assets/device_detail/ic_upgrade_failure.gif',
            width: 80,
            height: 80,
          ),
          const SizedBox(height: 20),
          // 结果文字
          Text(
            isSuccess ? '升级完成' : '升级失败',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color:
                  isSuccess ? const Color(0xFF14CC7E) : const Color(0xFFFF4D4F),
              fontWeight: FontWeight.w500,
            ),
          ),
          // 失败原因（多行）
          if (!isSuccess && errorDetails != null) ...[
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                errorDetails!,
                style: const TextStyle(
                  fontSize: 12,
                  color: ColorUtils.colorBlackLiteLite,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 30),
          // 底部按钮
          UpgradeButton(
            text: isSuccess ? '好的' : '重试',
            onPressed: () {
              Navigator.of(context).pop();
              if (isSuccess) {
                onConfirm?.call();
              } else {
                onRetry?.call();
              }
            },
          ),
        ],
      ),
    );
  }
}

/// 文件选择和上传进度弹窗（保留原有功能）
class FileUploadDialog extends StatefulWidget {
  final String title;
  final Function(String filePath)? onFileSelected;
  final VoidCallback? onConfirm;

  const FileUploadDialog({
    super.key,
    required this.title,
    this.onFileSelected,
    this.onConfirm,
  });

  @override
  State<FileUploadDialog> createState() => _FileUploadDialogState();
}

class _FileUploadDialogState extends State<FileUploadDialog> {
  String? selectedFilePath;
  bool isUploading = false;
  double uploadProgress = 0.0;
  bool isWaitingUpgrade = false;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUploading && !isWaitingUpgrade) ...[
            const Text('请选择升级文件：'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      selectedFilePath ?? '未选择文件',
                      style: TextStyle(
                        color: selectedFilePath != null
                            ? ColorUtils.colorGreenLiteLite
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Button(
                  child: const Text('选择文件'),
                  onPressed: _selectFile,
                ),
              ],
            ),
          ],
          if (isUploading) ...[
            const Text('正在上传文件...'),
            const SizedBox(height: 12),
            ProgressBar(value: uploadProgress),
            const SizedBox(height: 8),
            Text('${(uploadProgress * 100).toInt()}%'),
          ],
          if (isWaitingUpgrade) ...[
            const Row(
              children: [
                ProgressRing(),
                SizedBox(width: 12),
                Text('等待升级中...'),
              ],
            ),
          ],
        ],
      ),
      actions: [
        if (!isUploading && !isWaitingUpgrade) ...[
          Button(
            child: const Text('取消'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FilledButton(
            onPressed: selectedFilePath != null ? _confirmUpload : null,
            child: const Text('确认'),
          ),
        ],
      ],
    );
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFilePath = result.files.single.path;
      });
      widget.onFileSelected?.call(selectedFilePath!);
    }
  }

  void _confirmUpload() {
    setState(() {
      isUploading = true;
    });

    // 模拟上传进度
    _simulateUpload();

    widget.onConfirm?.call();
  }

  void _simulateUpload() {
    // 模拟上传进度
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted && isUploading) {
        setState(() {
          uploadProgress += 0.1;
          if (uploadProgress >= 1.0) {
            isUploading = false;
            isWaitingUpgrade = true;
          }
        });
        if (uploadProgress < 1.0) {
          _simulateUpload();
        }
      }
    });
  }

  void showWaitingUpgrade() {
    if (mounted) {
      setState(() {
        isUploading = false;
        isWaitingUpgrade = true;
      });
    }
  }
}
