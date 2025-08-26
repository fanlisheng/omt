import 'package:flutter/material.dart';
import '../../http/service/update/app_optimizer.dart';
import '../../theme.dart';
import '../../utils/color_utils.dart';

class AppOptimizerWidget extends StatefulWidget {
  const AppOptimizerWidget({super.key});

  @override
  State<AppOptimizerWidget> createState() => _AppOptimizerWidgetState();
}

class _AppOptimizerWidgetState extends State<AppOptimizerWidget> {
  final AppOptimizer _appOptimizer = AppOptimizer();

  Map<String, dynamic> _appInfo = {};
  List<Map<String, dynamic>> _optimizableFiles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final appInfo = await _appOptimizer.getAppSizeInfo();
      final optimizableFiles = await _appOptimizer.getOptimizableFiles();

      setState(() {
        _appInfo = appInfo;
        _optimizableFiles = optimizableFiles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('加载应用信息失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('应用优化管理'),
        backgroundColor: AppTheme().color,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAppInfo,
            tooltip: '刷新',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 应用基本信息
                  _buildAppInfoCard(),
                  const SizedBox(height: 20),

                  // 优化建议
                  _buildOptimizationCard(),
                  const SizedBox(height: 20),

                  // 可优化文件列表
                  _buildOptimizableFilesCard(),
                  const SizedBox(height: 20),

                  // 操作按钮
                  _buildActionButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildAppInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme().color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  '应用基本信息',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('应用名称', _appInfo['appName'] ?? '未知'),
            _buildInfoRow('版本号', _appInfo['version'] ?? '未知'),
            _buildInfoRow('构建号', _appInfo['buildNumber'] ?? '未知'),
            _buildInfoRow('包名', _appInfo['packageName'] ?? '未知'),
            _buildInfoRow('平台', _appInfo['platform'] ?? '未知'),
            _buildInfoRow('系统版本', _appInfo['osVersion'] ?? '未知'),
            _buildInfoRow('应用大小', _formatFileSize(_appInfo['appSize'] ?? 0)),
            _buildInfoRow('应用路径', _appInfo['appPath'] ?? '未知'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizationCard() {
    final strategy = _appOptimizer.getUpdateStrategy();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_fix_high,
                  color: AppTheme().color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  '优化策略建议',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStrategyRow('更新策略', strategy['strategy']),
            _buildStrategyRow('压缩方式', strategy['compression']),
            _buildStrategyRow('增量更新', strategy['deltaUpdate'] ? '启用' : '禁用'),
            const SizedBox(height: 16),
            const Text(
              '文件过滤规则:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: (strategy['fileFilter'] as List).map((pattern) {
                return Chip(
                  label: Text(pattern),
                  backgroundColor: AppTheme().color.withOpacity(0.1),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              '排除模式:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: (strategy['excludePatterns'] as List).map((pattern) {
                return Chip(
                  label: Text(pattern),
                  backgroundColor: Colors.orange.withOpacity(0.1),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              '优化建议:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...(strategy['recommendations'] as List).map((rec) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(rec)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOptimizableFilesCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_open,
                  color: AppTheme().color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  // '可优化文件 (${_optimizableFiles.length})',
                  "可优化文件",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_optimizableFiles.isEmpty)
              const Center(
                child: Text(
                  '没有发现可优化的文件',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: _optimizableFiles.length,
                  itemBuilder: (context, index) {
                    final file = _optimizableFiles[index];
                    return ListTile(
                      leading: Icon(
                        _getFileIcon(file['extension']),
                        color: _getFileColor(file['extension']),
                      ),
                      title: Text(
                        file['name'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        '${file['extension']} • ${file['sizeFormatted']}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () => _showFileInfo(file),
                        tooltip: '文件信息',
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '优化操作',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _cleanupCache,
                  icon: const Icon(Icons.cleaning_services),
                  label: const Text('清理缓存'),
                ),
                ElevatedButton.icon(
                  onPressed: _analyzeAppSize,
                  icon: const Icon(Icons.analytics),
                  label: const Text('分析应用大小'),
                ),
                ElevatedButton.icon(
                  onPressed: _exportReport,
                  icon: const Icon(Icons.download),
                  label: const Text('导出报告'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme().color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case '.dll':
      case '.so':
      case '.dylib':
        return Icons.extension;
      case '.framework':
      case '.bundle':
        return Icons.folder;
      case '.exe':
        return Icons.play_arrow;
      case '.log':
        return Icons.description;
      case '.cache':
        return Icons.cached;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String extension) {
    switch (extension.toLowerCase()) {
      case '.dll':
      case '.so':
      case '.dylib':
        return Colors.blue;
      case '.framework':
      case '.bundle':
        return Colors.green;
      case '.exe':
        return Colors.orange;
      case '.log':
        return Colors.red;
      case '.cache':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showFileInfo(Map<String, dynamic> file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('文件信息: ${file['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('路径: ${file['path']}'),
            Text('大小: ${file['sizeFormatted']}'),
            Text('类型: ${file['extension']}'),
            Text('可优化: ${file['canOptimize'] ? '是' : '否'}'),
          ],
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

  Future<void> _cleanupCache() async {
    try {
      final success = await _appOptimizer.cleanupCache();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('缓存清理成功'),
            backgroundColor: Colors.green,
          ),
        );
        _loadAppInfo(); // 重新加载信息
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('没有发现可清理的缓存'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('清理缓存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _analyzeAppSize() {
    // 这里可以添加更详细的应用大小分析
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('应用大小分析功能开发中...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _exportReport() {
    // 这里可以添加导出优化报告功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('导出报告功能开发中...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
