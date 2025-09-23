import 'package:flutter/material.dart';
import 'package:kayo_package/kayo_package.dart';

/// 全局上下文工具类
/// 用于统一获取全局 context，避免上下文不一致问题
/// 
/// Created by fanlisheng on 2024-06-13
class ContextUtils {
  /// 单例模式
  static ContextUtils get instance => _getInstance();
  static ContextUtils? _instance;

  ContextUtils._internal();

  static ContextUtils _getInstance() {
    _instance ??= ContextUtils._internal();
    return _instance!;
  }

  /// 获取全局 context
  /// 使用 KayoPackage.share.navigatorKey 获取全局 context
  /// 如果获取失败则返回 null
  BuildContext? getGlobalContext() {
    try {
      return KayoPackage.share.navigatorKey.currentState?.overlay?.context;
    } catch (e) {
      debugPrint('获取全局 context 失败: $e');
      return null;
    }
  }

  /// 获取全局 context，如果为空则抛出异常
  /// 在确定 context 一定存在的情况下使用
  BuildContext getGlobalContextOrThrow() {
    final context = getGlobalContext();
    if (context == null) {
      throw Exception('全局 context 为空');
    }
    return context;
  }
}