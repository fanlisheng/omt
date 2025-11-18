/// HTTP 缓存管理器
/// 提供通用的缓存机制，支持任意类型的数据缓存
class HttpCacheManager {
  static final HttpCacheManager _instance = HttpCacheManager._internal();

  factory HttpCacheManager() {
    return _instance;
  }

  HttpCacheManager._internal();

  // 缓存存储 Map
  final Map<String, dynamic> _cacheMap = {};

  /// 获取缓存数据
  T? getCache<T>(String key) {
    return _cacheMap[key] as T?;
  }

  /// 设置缓存数据
  void setCache<T>(String key, T value) {
    _cacheMap[key] = value;
  }

  /// 清除指定缓存
  void clearCache(String key) {
    _cacheMap.remove(key);
  }

  /// 清除所有缓存
  void clearAllCache() {
    _cacheMap.clear();
  }

  /// 检查缓存是否存在
  bool hasCache(String key) {
    return _cacheMap.containsKey(key);
  }
}
