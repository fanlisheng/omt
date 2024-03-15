import 'package:omt/generated/json/base/json_field.dart';
import 'dart:convert';

import 'package:omt/generated/json/location_data_entity.g.dart';

@JsonSerializable()
class LocationData {
  double? lat;
  double? lng;
  double? alt;
  String? address;
  String? name;

  LocationData({this.lat, this.lng, this.alt, this.address, this.name});

  LocationData.init({double? lat, double? lng, String? address, String? name}) {
    this.lat = lat;
    this.lng = lng;
    this.address = address;
    this.name = name;
  }

  factory LocationData.fromJson(Map<String, dynamic> json) =>
      $LocationDataFromJson(json);

  Map<String, dynamic> toJson() => $LocationDataToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
