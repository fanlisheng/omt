import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/device_detail_router_entity_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/device_detail_router_entity_entity.g.dart';

@JsonSerializable()
class DeviceDetailRouterEntity{
	DeviceDetailRouterData? data;

	DeviceDetailRouterEntity();

	factory DeviceDetailRouterEntity.fromJson(Map<String, dynamic> json) => $DeviceDetailRouterEntityFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailRouterEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DeviceDetailRouterData {
	@JSONField(name: 'instance_name')
	String? instanceName = '';
	@JSONField(name: 'gate_name')
	String? gateName = '';
	@JSONField(name: 'pass_name')
	String? passName = '';
	@JSONField(name: 'label_name')
	String? labelName = '';
	@JSONField(name: 'device_code')
	String? deviceCode = '';
	String? ip = '';
	String? mac = '';
	@JSONField(name: 'type_text')
	String? typeText = '';
	@JSONField(name: "node_id")
	String? nodeId;

	DeviceDetailRouterData();

	factory DeviceDetailRouterData.fromJson(Map<String, dynamic> json) => $DeviceDetailRouterDataFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailRouterDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}