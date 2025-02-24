import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/device_detail_power_box_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/device_detail_power_box_entity.g.dart';

@JsonSerializable()
class DeviceDetailPowerBoxEntity {
	DeviceDetailPowerBoxData? data;

	DeviceDetailPowerBoxEntity();

	factory DeviceDetailPowerBoxEntity.fromJson(Map<String, dynamic> json) => $DeviceDetailPowerBoxEntityFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailPowerBoxEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DeviceDetailPowerBoxData {
	@JSONField(name: "instance_name")
	String? instanceName;
	@JSONField(name: "gate_name")
	String? gateName;
	@JSONField(name: "pass_name")
	String? passName;
	@JSONField(name: "label_name")
	String? labelName;
	@JSONField(name: "device_code")
	String? deviceCode;
	@JSONField(name: "iot_connect_status")
	String? iotConnectStatus;
	@JSONField(name: "battery_voltage")
	int? batteryVoltage;
	@JSONField(name: "battery_capacity")
	int? batteryCapacity;
	@JSONField(name: "power_status")
	String? powerStatus;
	@JSONField(name: "work_time")
	String? workTime;
	@JSONField(name: "inlet_temperature")
	int? inletTemperature;
	@JSONField(name: "outlet_temperature")
	int? outletTemperature;
	String? version;
	@JSONField(name: "dc_interfaces")
	List<DeviceDetailPowerBoxDataDcInterfaces>? dcInterfaces;

	DeviceDetailPowerBoxData();

	factory DeviceDetailPowerBoxData.fromJson(Map<String, dynamic> json) => $DeviceDetailPowerBoxDataFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailPowerBoxDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DeviceDetailPowerBoxDataDcInterfaces {
	int? id;
	@JSONField(name: "interface_num")
	int? interfaceNum;
	@JSONField(name: "status_text")
	String? statusText;
	int? voltage;
	int? current;
	@JSONField(name: "connect_device")
	String? connectDevice;

	DeviceDetailPowerBoxDataDcInterfaces();

	factory DeviceDetailPowerBoxDataDcInterfaces.fromJson(Map<String, dynamic> json) => $DeviceDetailPowerBoxDataDcInterfacesFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailPowerBoxDataDcInterfacesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}