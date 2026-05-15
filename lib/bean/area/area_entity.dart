import 'dart:convert';

class AreaEntity {
  List<AreaData>? data;

  AreaEntity({this.data});

  factory AreaEntity.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List?;
    List<AreaData>? data;
    if (dataList != null) {
      data = dataList.map((i) => AreaData.fromJson(i)).toList();
    }
    return AreaEntity(data: data);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    if (this.data != null) {
      map['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AreaData {
  String? areaCode;
  String? fullName;

  AreaData({this.areaCode, this.fullName});

  factory AreaData.fromJson(Map<String, dynamic> json) {
    return AreaData(
      areaCode: json['area_code'],
      fullName: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['area_code'] = this.areaCode;
    map['full_name'] = this.fullName;
    return map;
  }
}
