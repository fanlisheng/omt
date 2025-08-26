import '../../../bean/update/update_info.dart';

class MockUpdateApi {
  // 模拟版本检查API响应 - ZIP格式
  static Map<String, dynamic> getMockUpdateResponse() {
    return {
      'version': '1.1.0',
      'downloadUrl': 'https://example.com/downloads/omt_update_v1.1.0.zip',
      'changelog': '''
• 应用优化：
  - 减少应用包大小
  - 优化系统文件结构
  - 清理不必要的缓存文件

• 性能改进：
  - 提升启动速度
  - 优化内存使用
  - 改进文件管理

• 更新策略：
  - 支持ZIP包更新
  - 自动解压安装
  - 智能文件检测
      ''',
      'forceUpdate': false,
      'fileSize': 52428800, // 50MB
      'md5': 'a1b2c3d4e5f6g7h8i9j0',
    };
  }

  // 模拟强制更新响应 - ZIP格式
  static Map<String, dynamic> getMockForceUpdateResponse() {
    return {
      'version': '1.2.0',
      'downloadUrl': 'http://106.75.154.221:8321/minio/file/0/2025/0826/0a46c7c1-f508-4c66-8679-45a666daef1c.zip',
      'changelog': '''
⚠️ 重要安全更新 - 强制安装

• 安全修复：
  - 修复严重安全漏洞
  - 更新加密算法
  - 加强数据保护

• 兼容性更新：
  - 支持最新操作系统
  - 修复兼容性问题

• 更新包格式：
  - ZIP压缩包
  - 包含安装程序
  - 自动解压安装
      ''',
      'forceUpdate': true,
      'fileSize': 78643200, // 75MB
      'md5': 'b2c3d4e5f6g7h8i9j0k1',
    };
  }

  // 模拟无更新响应
  static Map<String, dynamic> getMockNoUpdateResponse() {
    return {
      'version': '1.0.0',
      'downloadUrl': '',
      'changelog': '',
      'forceUpdate': false,
      'fileSize': 0,
      'md5': '',
    };
  }
} 