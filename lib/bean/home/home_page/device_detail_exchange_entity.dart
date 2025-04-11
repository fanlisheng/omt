import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/device_detail_exchange_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/device_detail_exchange_entity.g.dart';

@JsonSerializable()
class DeviceDetailExchangeEntity {
	DeviceDetailExchangeData? data;

	DeviceDetailExchangeEntity();

	factory DeviceDetailExchangeEntity.fromJson(Map<String, dynamic> json) => $DeviceDetailExchangeEntityFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailExchangeEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DeviceDetailExchangeData {
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
	@JSONField(name: "interface_num")
	int? interfaceNum;
	@JSONField(name: "power_method")
	String? powerMethod;
	@JSONField(name: "node_id")
	String? nodeId;

	DeviceDetailExchangeData();

	factory DeviceDetailExchangeData.fromJson(Map<String, dynamic> json) => $DeviceDetailExchangeDataFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailExchangeDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}