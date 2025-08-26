
class UpdateInfo {
  final String version;
  final String downloadUrl;
  final String changelog;
  late final bool forceUpdate;
  final int fileSize;
  final String md5;

  UpdateInfo({
    required this.version,
    required this.downloadUrl,
    required this.changelog,
    this.forceUpdate = false,
    this.fileSize = 0,
    this.md5 = '',
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) {
    final dynamic force = json['is_force_update'] ?? json['force_update'];
    bool forceVal;
    if (force is bool) {
      forceVal = force;
    } else if (force is num) {
      forceVal = force != 0;
    } else if (force is String) {
      forceVal = force.toLowerCase() == 'true' || force == '1';
    } else {
      forceVal = false;
    }

    final dynamic size = json['fileSize'] ?? json['size'] ?? 0;
    int sizeVal;
    if (size is int) {
      sizeVal = size;
    } else if (size is num) {
      sizeVal = size.toInt();
    } else if (size is String) {
      sizeVal = int.tryParse(size) ?? 0;
    } else {
      sizeVal = 0;
    }

    return UpdateInfo(
      version: (json['version'] ?? '').toString(),
      downloadUrl: (json['downloadUrl'] ?? json['url'] ?? '').toString(),
      changelog: (json['changelog'] ?? json['change_log'] ?? '').toString(),
      forceUpdate: forceVal,
      fileSize: sizeVal,
      md5: (json['md5'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'downloadUrl': downloadUrl,
      'changelog': changelog,
      'forceUpdate': forceUpdate,
      'fileSize': fileSize,
      'md5': md5,
    };
  }
}
