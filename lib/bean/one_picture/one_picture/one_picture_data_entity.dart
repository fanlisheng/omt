import 'package:omt/generated/json/base/json_field.dart';
import 'package:omt/generated/json/one_picture_data_entity.g.dart';
import 'dart:convert';
export 'package:omt/generated/json/one_picture_data_entity.g.dart';

@JsonSerializable()
class OnePictureDataEntity {
	int? code;
	String? message;
	OnePictureDataData? data;
	String? status;
	dynamic details;
	@JSONField(name: 'request_id')
	String? requestId;

	OnePictureDataEntity();

	factory OnePictureDataEntity.fromJson(Map<String, dynamic> json) => $OnePictureDataEntityFromJson(json);

	Map<String, dynamic> toJson() => $OnePictureDataEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class OnePictureDataData {
	String? id;
	String? name;
	@JSONField(name: 'node_code')
	String? nodeCode;
	int? type;
	@JSONField(name: 'type_text')
	String? typeText;
	String? desc;
	@JSONField(name: 'device_code')
	String? deviceCode;
	String? ip;
	String? mac;
	List<OnePictureDataDataChildren>? children;

	OnePictureDataData();

	factory OnePictureDataData.fromJson(Map<String, dynamic> json) => $OnePictureDataDataFromJson(json);

	Map<String, dynamic> toJson() => $OnePictureDataDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class OnePictureDataDataChildren {
	String? id;
	String? name;
	@JSONField(name: 'node_code')
	String? nodeCode;
	int? type;
	@JSONField(name: 'type_text')
	String? typeText;
	String? desc;
	@JSONField(name: 'device_code')
	String? deviceCode;
	String? ip;
	String? mac;
	List<OnePictureDataDataChildrenChildren>? children;

	OnePictureDataDataChildren();

	factory OnePictureDataDataChildren.fromJson(Map<String, dynamic> json) => $OnePictureDataDataChildrenFromJson(json);

	Map<String, dynamic> toJson() => $OnePictureDataDataChildrenToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class OnePictureDataDataChildrenChildren {
	String? id;
	String? name;
	@JSONField(name: 'node_code')
	String? nodeCode;
	int? type;
	@JSONField(name: 'type_text')
	String? typeText;
	String? desc;
	@JSONField(name: 'device_code')
	String? deviceCode;
	String? ip;
	String? mac;
	List<OnePictureDataDataChildrenChildrenChildren>? children;

	OnePictureDataDataChildrenChildren();

	factory OnePictureDataDataChildrenChildren.fromJson(Map<String, dynamic> json) => $OnePictureDataDataChildrenChildrenFromJson(json);

	Map<String, dynamic> toJson() => $OnePictureDataDataChildrenChildrenToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class OnePictureDataDataChildrenChildrenChildren {
	String? id;
	String? name;
	@JSONField(name: 'node_code')
	String? nodeCode;
	int? type;
	@JSONField(name: 'type_text')
	String? typeText;
	String? desc;
	@JSONField(name: 'device_code')
	String? deviceCode;
	String? ip;
	String? mac;
	List<dynamic>? children;

	OnePictureDataDataChildrenChildrenChildren();

	factory OnePictureDataDataChildrenChildrenChildren.fromJson(Map<String, dynamic> json) => $OnePictureDataDataChildrenChildrenChildrenFromJson(json);

	Map<String, dynamic> toJson() => $OnePictureDataDataChildrenChildrenChildrenToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}