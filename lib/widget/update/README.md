# 应用自更新系统

这是一个完整的Flutter应用自更新系统，支持Windows、macOS和Linux平台。

## 功能特性

- ✅ 自动版本检查
- ✅ 手动版本检查
- ✅ 更新弹窗显示
- ✅ 下载进度显示
- ✅ 强制更新支持
- ✅ 多平台安装支持
- ✅ 本地更新信息缓存
- ✅ 模拟API测试支持

## 系统架构

```
UpdateManager (更新管理器)
    ↓
UpdateService (更新服务)
    ↓
UpdateDialog (更新弹窗UI)
    ↓
UpdateInfo (更新信息模型)
```

## 使用方法

### 1. 在应用启动时自动检查更新

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final UpdateManager _updateManager = UpdateManager();

  @override
  void initState() {
    super.initState();
    // 应用启动后自动检查更新
    _updateManager.checkUpdateOnStartup(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('我的应用')),
      body: Center(child: Text('应用内容')),
    );
  }
}
```

### 2. 手动检查更新

```dart
ElevatedButton(
  onPressed: () {
    _updateManager.checkUpdateManually(context);
  },
  child: Text('检查更新'),
)
```

### 3. 配置版本检查API

在 `lib/services/update_service.dart` 中修改：

```dart
// 检查更新
Future<UpdateInfo?> checkForUpdate({bool useMock = false}) async {
  try {
    if (useMock) {
      // 使用模拟API进行测试
      // ...
    }
    
    // 替换为你的实际版本检查API
    final response = await _dio.get('https://your-api.com/version/check');
    
    if (response.statusCode == 200) {
      final updateInfo = UpdateInfo.fromJson(response.data);
      // ...
    }
  } catch (e) {
    print('检查更新失败: $e');
  }
  return null;
}
```

## API响应格式

版本检查API需要返回以下JSON格式：

```json
{
  "version": "1.1.0",
  "downloadUrl": "https://example.com/downloads/app_v1.1.0.exe",
  "changelog": "更新日志内容...",
  "forceUpdate": false,
  "fileSize": 52428800,
  "md5": "a1b2c3d4e5f6g7h8i9j0"
}
```

### 字段说明

- `version`: 新版本号
- `downloadUrl`: 更新包下载地址
- `changelog`: 更新日志
- `forceUpdate`: 是否强制更新
- `fileSize`: 文件大小（字节）
- `md5`: 文件MD5校验值

## 平台支持

### Windows
- 下载.exe安装包
- 启动安装程序并退出应用
- 下次启动时已是新版本

### macOS
- 下载.dmg文件
- 打开DMG文件并退出应用
- 用户手动安装

### Linux
- 下载.deb包
- 使用dpkg安装并退出应用
- 下次启动时已是新版本

## 测试

### 使用模拟API测试

```dart
// 使用模拟API检查更新
final updateInfo = await _updateService.checkForUpdate(useMock: true);
```

### 模拟不同更新场景

- 普通更新：`MockUpdateApi.getMockUpdateResponse()`
- 强制更新：`MockUpdateApi.getMockForceUpdateResponse()`
- 无更新：`MockUpdateApi.getMockNoUpdateResponse()`

## 注意事项

1. **权限要求**：确保应用有足够的权限下载和安装文件
2. **网络安全**：使用HTTPS下载更新包，验证文件完整性
3. **用户体验**：避免在应用启动时立即检查更新，建议延迟2-3秒
4. **错误处理**：妥善处理网络错误、下载失败等异常情况
5. **平台差异**：不同平台的安装方式可能不同，需要分别处理

## 依赖包

确保在 `pubspec.yaml` 中添加以下依赖：

```yaml
dependencies:
  dio: ^5.4.0
  path_provider: ^2.1.1
  package_info_plus: ^8.0.0
  shared_preferences: ^2.2.2
```

## 示例代码

查看 `update_example.dart` 文件了解完整的使用示例。 