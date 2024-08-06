import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/bean/common/location_data_entity.dart';

LocationData $LocationDataFromJson(Map<String, dynamic> json) {
  final LocationData locationData = LocationData();
  final double? lat = jsonConvert.convert<double>(json['lat']);
  if (lat != null) {
    locationData.lat = lat;
  }
  final double? lng = jsonConvert.convert<double>(json['lng']);
  if (lng != null) {
    locationData.lng = lng;
  }
  final double? alt = jsonConvert.convert<double>(json['alt']);
  if (alt != null) {
    locationData.alt = alt;
  }
  final String? address = jsonConvert.convert<String>(json['address']);
  if (address != null) {
    locationData.address = address;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    locationData.name = name;
  }
  return locationData;
}

Map<String, dynamic> $LocationDataToJson(LocationData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['lat'] = entity.lat;
  data['lng'] = entity.lng;
  data['alt'] = entity.alt;
  data['address'] = entity.address;
  data['name'] = entity.name;
  return data;
}

extension LocationDataExtension on LocationData {
  LocationData copyWith({
    double? lat,
    double? lng,
    double? alt,
    String? address,
    String? name,
  }) {
    return LocationData()
      ..lat = lat ?? this.lat
      ..lng = lng ?? this.lng
      ..alt = alt ?? this.alt
      ..address = address ?? this.address
      ..name = name ?? this.name;
  }
}
