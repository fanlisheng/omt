import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/device_detail_nvr_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/device_detail_nvr_entity.g.dart';

@JsonSerializable()
class DeviceDetailNvrEntity {
	DeviceDetailNvrData? data;

	DeviceDetailNvrEntity();

	factory DeviceDetailNvrEntity.fromJson(Map<String, dynamic> json) => $DeviceDetailNvrEntityFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailNvrEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DeviceDetailNvrData {
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
	String? mac;
	List<DeviceDetailNvrDataChannels>? channels;

	DeviceDetailNvrData();

	factory DeviceDetailNvrData.fromJson(Map<String, dynamic> json) => $DeviceDetailNvrDataFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailNvrDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class DeviceDetailNvrDataChannels {
	int? id;
	@JSONField(name: "channel_num")
	int? channelNum;
	@JSONField(name: "record_status")
	String? recordStatus;
	@JSONField(name: "signal_status")
	String? signalStatus;
	@JSONField(name: "updated_at")
	String? updatedAt;

  DeviceDetailNvrDataChannels(
      {this.id,
        this.channelNum,
        this.recordStatus,
        this.signalStatus,
        this.updatedAt});

	factory DeviceDetailNvrDataChannels.fromJson(Map<String, dynamic> json) => $DeviceDetailNvrDataChannelsFromJson(json);

	Map<String, dynamic> toJson() => $DeviceDetailNvrDataChannelsToJson(this);

  @override
	String toString() {
		return jsonEncode(this);
	}
}