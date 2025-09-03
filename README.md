https://juejin.cn/post/7359577911991730211?searchId=20240628164549F867BBBB40C37B6A1C48


cargo install flutter_rust_bridge_codegen

flutter_rust_bridge_codegen integrate

flutter_rust_bridge_codegen generate


git push origin master && git push gitee master


# omt

Operation and maintenance tools

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


功能：根据图片 UI 设计生成 Flutter 页面
说明：
- 输入一张设计图（URL 或描述）
- 输出 Flutter Widget 代码，布局、颜色、字体与设计图尽量一致
- 页面要响应式，兼容不同屏幕尺寸
- 尽量使用 Column/Row/Stack 等布局控件
  属性：
- imageUrl: String，设计图 URL
- title: String，可选，页面标题
- padding: EdgeInsets?，外层间距
  输出要求：
- 包含 Scaffold、AppBar（可选）、主要布局 Widget
- 支持 Flutter >=3.13, Dart null-safety
- 代码可直接 copy-paste
  示例：


功能：实现特定功能
说明：
- 编写具体功能逻辑方法或服务类
- 支持异步操作、网络请求、状态管理
  属性：
- params: Map<String, dynamic>，输入参数
- callback: Function?，操作完成回调
  输出要求：
- 包含完整方法签名、返回类型
- 支持 Flutter >=3.13, Dart null-safety
- 包含必要的错误处理
  示例：


功能：根据图片 UI 设计生成 Flutter 页面
说明：
- 输入一张设计图（URL 或描述）
- 输出 Flutter Widget 代码，布局、颜色、字体与设计图尽量一致
- 页面要响应式，兼容不同屏幕尺寸
- 尽量使用 Column/Row/Stack 等布局控件
  属性：
- imageUrl: String，设计图 URL
- title: String，可选，页面标题
- padding: EdgeInsets?，外层间距
  输出要求：
- 包含 Scaffold、AppBar（可选）、主要布局 Widget
- 支持 Flutter >=3.13, Dart null-safety
- 代码可直接 copy-paste
  示例：
