import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/device_detail_ai_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/device_detail_ai_entity.g.dart';

@JsonSerializable()
class DeviceDetailAiEntity {
	DeviceDetailAiData? data;

	DeviceDetailAiEntity();

	factory DeviceDetailAiEntity.fromJson(Map<String, dynamic> json) => $DeviceDetailAiEntityFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailAiEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DeviceDetailAiData {
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
	String? ip;
	@JSONField(name: "program_version")
	String? programVersion;
	@JSONField(name: "identity_version")
	String? identityVersion;
	@JSONField(name: "camera_device_code")
	String? cameraDeviceCode;
	@JSONField(name: "iot_connect_status")
	String? iotConnectStatus;
	@JSONField(name: "server_host")
	String? serverHost;
	@JSONField(name: "node_id")
	String? nodeId;
	String? mac;

	DeviceDetailAiData();

	factory DeviceDetailAiData.fromJson(Map<String, dynamic> json) => $DeviceDetailAiDataFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailAiDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}