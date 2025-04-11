import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/device_detail_power_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/device_detail_power_entity.g.dart';

@JsonSerializable()
class DeviceDetailPowerEntity {
	DeviceDetailPowerData? data;

	DeviceDetailPowerEntity();

	factory DeviceDetailPowerEntity.fromJson(Map<String, dynamic> json) => $DeviceDetailPowerEntityFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailPowerEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DeviceDetailPowerData {
	@JSONField(name: "instance_name")
	String? instanceName;
	@JSONField(name: "gate_name")
	String? gateName;
	@JSONField(name: "pass_name")
	String? passName;
	@JSONField(name: "label_name")
	String? labelName;
	@JSONField(name: "power_type")
	String? powerType;
	@JSONField(name: "battery_capacity")
	int? batteryCapacity;
	@JSONField(name: "node_id")
	String? nodeId;

	DeviceDetailPowerData();

	factory DeviceDetailPowerData.fromJson(Map<String, dynamic> json) => $DeviceDetailPowerDataFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailPowerDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}