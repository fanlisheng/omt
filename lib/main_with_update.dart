import 'package:flutter/material.dart';
import 'widget/update/update_manager.dart';
import 'widget/update/update_example.dart';
import 'theme.dart';

void main() {
  runApp(const MyAppWithUpdate());
}

class MyAppWithUpdate extends StatelessWidget {
  const MyAppWithUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OMT - 运维工具',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePageWithUpdate(),
    );
  }
}

class MyHomePageWithUpdate extends StatefulWidget {
  const MyHomePageWithUpdate({super.key});

  @override
  State<MyHomePageWithUpdate> createState() => _MyHomePageWithUpdateState();
}

class _MyHomePageWithUpdateState extends State<MyHomePageWithUpdate> {
  final UpdateManager _updateManager = UpdateManager();

  @override
  void initState() {
    super.initState();
    // 应用启动后自动检查更新（延迟2秒）
    // _updateManager.checkUpdateOnStartup(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OMT 运维工具'),
        backgroundColor: AppTheme().color,
        actions: [
          // 在应用栏添加检查更新按钮
          IconButton(
            icon: const Icon(Icons.system_update),
            onPressed: () {
              _updateManager.checkUpdateOnStartup(context);
            },
            tooltip: '检查更新',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎信息
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '欢迎使用 OMT 运维工具',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '这是一个集成了自动更新系统的运维工具应用。',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 更新系统说明
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.system_update,
                          color: AppTheme().color,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '自动更新系统',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '• 应用启动时自动检查更新\n'
                      '• 支持强制更新和可选更新\n'
                      '• 显示详细的更新日志\n'
                      '• 后台下载更新包\n'
                      '• 自动安装并重启应用\n'
                      '• 支持 Windows、macOS、Linux',
                      style: TextStyle(height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _updateManager.checkUpdateManually(context);
                          },
                          child: const Text('立即检查更新'),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            // 导航到更新示例页面
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const UpdateExamplePage(),
                              ),
                            );
                          },
                          child: const Text('更新系统演示'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 应用功能
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '应用功能',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '• 设备管理\n'
                      '• 监控面板\n'
                      '• 日志分析\n'
                      '• 系统配置\n'
                      '• 用户管理',
                      style: TextStyle(height: 1.6),
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

// 更新系统演示页面
class UpdateExamplePage extends StatelessWidget {
  const UpdateExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('更新系统演示'),
        backgroundColor: AppTheme().color,
      ),
      body: const Center(
        child: Text(
          '这里可以展示更新系统的各种功能演示\n'
          '包括版本检查、下载进度、安装过程等',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
} 