import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/extension/_index_extension.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:file_picker/file_picker.dart';

/// 升级方式选择弹窗
class UpgradeMethodDialog extends StatelessWidget {
  final String title;
  final VoidCallback? onLocalUpgrade;
  final VoidCallback? onOnlineUpgrade;

  const UpgradeMethodDialog({
    super.key,
    required this.title,
    this.onLocalUpgrade,
    this.onOnlineUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('请选择升级方式：'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Clickable(
                  onTap: () {
                    Navigator.of(context).pop();
                    onLocalUpgrade?.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: ColorUtils.colorGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '本地上传升级',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorUtils.colorWhite,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Clickable(
                  onTap: () {
                    Navigator.of(context).pop();
                    onOnlineUpgrade?.call();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: "#2F94DD".toColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '在线升级',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorUtils.colorWhite,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Button(
          child: const Text('取消'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

/// 文件选择和上传进度弹窗
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

/// 升级失败弹窗
class UpgradeFailureDialog extends StatelessWidget {
  final String title;
  final String reason;
  final String iconPath;
  final VoidCallback? onRetry;

  const UpgradeFailureDialog({
    super.key,
    required this.title,
    required this.reason,
    this.iconPath = 'assets/home/ic_failure.png',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            width: 48,
            height: 48,
          ),
          const SizedBox(height: 16),
          Text(
            '升级失败',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ColorUtils.colorRed,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '失败原因：$reason',
            style: const TextStyle(
              fontSize: 14,
              color: ColorUtils.colorGreenLiteLite,
            ),
          ),
        ],
      ),
      actions: [
        Button(
          child: const Text('取消'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onRetry?.call();
          },
          child: const Text('重新升级'),
        ),
      ],
    );
  }
}