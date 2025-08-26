import 'package:flutter/material.dart';
import '../../http/service/update/update_service.dart';
import '../../widget/update/update_manager.dart';
import '../../theme.dart';

class UpdateExample extends StatefulWidget {
  const UpdateExample({super.key});

  @override
  State<UpdateExample> createState() => _UpdateExampleState();
}

class _UpdateExampleState extends State<UpdateExample> {
  final UpdateManager _updateManager = UpdateManager();
  final UpdateService _updateService = UpdateService();
  String _currentVersion = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentVersion();
  }

  Future<void> _loadCurrentVersion() async {
    final packageInfo = await _updateService.getCurrentVersion();
    setState(() {
      _currentVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('应用更新示例'),
        backgroundColor: AppTheme().color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 当前版本信息
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '当前版本信息',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('版本号: $_currentVersion'),
                    const SizedBox(height: 8),
                    const Text('这是一个演示应用更新系统的示例页面'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 更新操作按钮
            const Text(
              '更新操作',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // 检查更新按钮
                ElevatedButton(
                  onPressed: () {
                    _updateManager.checkUpdateManually(context);
                  },
                  child: const Text('检查更新'),
                ),
                
                // 使用模拟API检查更新
                TextButton(
                  onPressed: () async {
                    try {
                      final updateInfo = await _updateService.checkForUpdate(useMock: true);
                      if (updateInfo != null && mounted) {
                        _updateManager.checkUpdateManually(context);
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('当前已是最新版本'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('检查更新失败: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('模拟检查更新'),
                ),
                
                // 检查本地更新信息
                TextButton(
                  onPressed: () {
                    _updateManager.checkLocalUpdateInfo(context);
                  },
                  child: const Text('检查本地更新'),
                ),
                
                // 重置更新检查状态
                TextButton(
                  onPressed: () {
                    _updateManager.resetUpdateCheck();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('已重置更新检查状态'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  },
                  child: const Text('重置更新状态'),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // 使用说明
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '使用说明',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '1. 应用启动时会自动检查更新（延迟2秒）\n'
                      '2. 点击"检查更新"按钮手动检查更新\n'
                      '3. 点击"模拟检查更新"使用模拟API测试\n'
                      '4. 如果发现新版本，会弹出更新对话框\n'
                      '5. 支持强制更新和可选更新\n'
                      '6. 下载完成后自动安装并重启应用',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 