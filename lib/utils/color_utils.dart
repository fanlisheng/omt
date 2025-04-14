import 'package:flutter/material.dart';

///  kayo_plugin
///  lib.common.utils
///
///  Created by kayoxu on 2019-06-11 16:09.
///  Copyright © 2019 kayoxu. All rights reserved.

class ColorUtils {
  static const int colorPrimaryColor = 0xFF3D7EFF;
  static const Color colorPrimary = Color(0xFF3D7EFF);
  static const Color colorPrimaryLight = Color(0xFF3D7EFF);
  static const Color colorPrimaryDark = Color(0xFF3D7EFF);

  static const Color colorAccent = Color(0xFF3D7EFF);
  static const Color colorAccentLite = Color(0xFF88B8FD);
  static const Color transparent = Color(0x00000000);

  static const Color colorBlue = Color(0xFF3D7EFF);
  // static const Color colorGreen = Color(0xFF3FC6BD);
  static const Color colorGreen = Color(0xFF3FC6BD);
  static const Color colorBrown = Color(0xFF8B4513);
  static const Color colorBlueLight = Color(0xFF03A9F4);
  static const Color colorGreenLite = Color(0xFF9BBCBA);
  static const Color colorGreenLiteLite = Color(0xFFF3FFFF);
  static const Color colorGreenDark = Color(0xFF007319);
  static const Color colorYellow = Color(0xFFFF9137);
  static const Color colorRed = Color(0xFFFF6160);

  static const Color colorBlueLite = Color(0xFF556C91);

  // static const Color colorGreenLite = Color(0xFF26CA83);
  static const Color colorYellowLite = Color(0xFFC59E60);

  // static const Color colorRedLite = Color(0xFFFF6160);

//  渐变色
  static const Color colorBlueGradient = Color(0xFF06A7FF);
  static const Color colorBlueGradient2 = Color(0xFF40D6FF);
  static const Color colorGreenGradient = Color(0xFF26CA83);
  static const Color colorGreenGradient2 = Color(0xFF8EEBC3);
  static const Color colorYellowGradient = Color(0xFFFF9137);
  static const Color colorYellowGradient2 = Color(0xFFFFB732);
  static const Color colorYellowGradient3 = Color(0xFFFFB87B);
  static const Color colorRedGradient = Color(0xFFFF6160);
  static const Color colorRedGradient2 = Color(0xFFFF8773);
  static const Color colorRedGradientStart = Color(0xFFFF5542);
  static const Color colorRed2 = Color(0xFFFF5052);
  static const Color colorRedGradientEnd = Color(0xFFFF8C29);

  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorWindow = Color(0xFFF6F7FB);
  static const Color colorCCC = Color(0xFFCCCCCC);
  static const Color shadowColor = Color(0xFFA1B7E1);

  static const Color colorLine = Color(0xFFEBEBEB);
  static const Color colorIcon = Color(0xFF747887);

  static const Color colorBlack = Color(0xff333333);
  static const Color colorBlackLite = Color(0xFF666666);
  static const Color colorBlackLiteLite = Color(0xFF999999);
  static const Color colorBlackRader = Color(0xFFF0F0F0);
  static const Color colorBgSearch = Color(0xFFF7F9FB);

  static const Color colorGray = Color(0xFFF9F9F8);
  static const Color colorTitleBg = Color(0xFFFAFAFA);
  static const Color colorTitleBgs = Color(0xFFF3F8FF);
  static const Color colorInputBg = Color(0xFFF6F5F5);
  static const Color colorBorder = Color(0xFFE6E6E6);
  static const Color colorItemLine = Color(0xFFEBEBEB);
  static const Color colorTimeBg = Color(0xFFF1F1F1);
  static const Color colorSeparator = Color(0x80E8E8E8);
  static const Color colorGra = Color(0x80FFE8D5);
  static const Color colorGrayLight = Color(0xFFcccccc);


  static const Color colorBackground = Color(0xFF3B3F3F);
  static const Color colorBackgroundLine = Color(0xFF4E5353);

  static const MaterialColor primarySwatch = MaterialColor(
    colorPrimaryColor,
    <int, Color>{
      50: colorPrimaryLight,
      100: colorPrimaryLight,
      200: colorPrimaryLight,
      300: colorPrimaryLight,
      400: colorPrimaryLight,
      500: colorPrimary,
      600: colorPrimaryDark,
      700: colorPrimaryDark,
      800: colorPrimaryDark,
      900: colorPrimaryDark,
    },
  );
}

class RadiusUtils {
  static const double radius4 = 4;
  static const double radius8 = 8;
  static const double radius12 = 12;
}

class TextStyleUtils {
  ///登录注册页标题、导航标题、重要文本
  static TextStyle? get title => const TextStyle(
      color: ColorUtils.colorBlack, fontSize: SizeUtils.fontSize17);

  static TextStyle? get titleBold => const TextStyle(
      color: ColorUtils.colorBlack,
      fontSize: SizeUtils.fontSize17,
      fontWeight: FontWeight.bold);
}

class SizeUtils {
  static const double fontSize24 = 24;

  ///登录注册页标题、导航标题、重要文本
  static const double fontSize17 = 17;

  ///列表标题、卡片内一级内容
  static const double fontSize15 = 15;

  ///选项标题、二级文本
  static const double fontSize13 = 13;

  ///次要文本
  static const double fontSize12 = 12;

  ///标签内文本、辅助文本、提示性文本
  static const double fontSize11 = 11;

  ///垂直外边距
  static const double marginVertical = 20;

  ///水平外边距
  static const double marginHorizontal = 20;

  ///内边距
  static const double padding = 15;

  ///内边距
  static const double paddingVertical = 6;
  static const double paddingHorizontal = 16;

  static const double padding2 = 2;
  static const double padding4 = 4;
}


