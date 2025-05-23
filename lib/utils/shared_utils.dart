import 'dart:collection';
import 'dart:async';

import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/user/user_login/user_login_data.dart';
import 'package:omt/utils/json_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uuid/uuid.dart';

export 'package:fluttertoast/fluttertoast.dart';

///  smart_community
///  common.utils
///
///  Created by kayoxu on 2019/6/1.
///  Copyright © 2019 kayoxu. All rights reserved.

class SharedUtils {
  static const String _shared_host = '_shared_host';
  static const String _shared_host_web = '_shared_host_web';
  static const String _shared_host_file = '_shared_host_file';
  static const String _shared_host_socket = '_shared_host_socket';
  static const String _shared_udid = '_shared_udid';
  static const String _shared_control_ip = '_shared_control_ip';
  static const String _shared_user_info_data = '_shared_user_info_data';
  static const String _shared_the_auth = '_shared_the_auth';

  static String networkMac = '';


  static setHost(String data) {
    return set(_shared_host, data);
  }

  static Future<String> getHostWeb() async {
    return await getString(_shared_host_web) ?? '';
  }

  static setHostWeb(String data) {
    return set(_shared_host_web, data);
  }

  static Future<String> getHost() async {
    return await getString(_shared_host) ?? '';
  }

  static setUserInfo(UserInfoData data) {
    return set(_shared_user_info_data, JsonUtils.toJson(data));
  }

  static Future<UserInfoData?> getUserInfo() async {
    try {
      var s = await getString(_shared_user_info_data) ?? '{}';
      return JsonUtils.getBeanSync<UserInfoData>(s);
    } catch (e) {
      return null;
    }
  }

  static setTheUserPermission(UserPermission data) {
    return set(_shared_the_auth, JsonUtils.toJson(data));
  }

  static Future<UserPermission?> getTheUserPermission() async {
    try {
      var s = await getString(_shared_the_auth) ?? '{}';
      return JsonUtils.getBeanSync<UserPermission>(s);
    } catch (e) {
      return null;
    }
  }

  static Future<String> getUDID() async {
    var s = await getString(_shared_udid);
    if (BaseSysUtils.empty(s)) {
      var uuid = const Uuid();
      var v1 = uuid.v1().replaceAll('-', '');
      s = v1;
      await set(_shared_udid, v1);
    }
    return s ?? '';
  }

  static setHostFile(String data) {
    return set(_shared_host_file, data);
  }

  static Future<String> getHostFile() async {
    return await getString(_shared_host_file) ?? '';
  }

  static setHostSocket(String data) {
    return set(_shared_host_socket, data);
  }

  static Future<String> getHostSocket() async {
    return await getString(_shared_host_socket) ?? '';
  }

  static setControlIP(String data) {
    return set(_shared_control_ip, data);
  }

  static Future<String> getControlIP() async {
    return await getString(_shared_control_ip) ?? '';
  }

  ////获取历史数据
  static Future<List<String>> getHistory(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = prefs.getStringList(key) ?? [];
    return string;
  }

  //搜索历史数据
  static setHistory(data, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, data);
  }

  static Future clear() async {
    clearForKey(_shared_user_info_data);
    clearForKey(_shared_the_auth);

    return Future.value(1);
  }

  ///base
  static set(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = prefs.getString(key);
    return string ?? '';
  }

  static Future<bool?> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = prefs.getBool(key);
    return string;
  }

  static setBool(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static setList(String key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  static Future<List<String>> getStringList(String key,
      {bool hashSet = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = prefs.getStringList(key) ?? [];

    if (hashSet) {
      string = HashSet.of(string).toList();
    }

    return string;
  }

  static delete(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static clearForKey(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
