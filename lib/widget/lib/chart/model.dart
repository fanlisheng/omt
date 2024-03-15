import 'package:flutter/material.dart';

///
///  open_pit_mine
///  model.dart
///
///  Created by kayoxu on 2020/9/16 at 2:32 PM
///  Copyright © 2020 kayoxu. All rights reserved.
///

class ChartData {
  dynamic x;
  num? y1;
  num? y2;
  num? y3;
  Color? color;
  Color? color1;
  Color? color2;
  String? desc;

  ChartData(
      {this.color,
      this.color1,
      this.color2,
      this.x,
      this.y1,
      this.y2,
      this.y3,
      this.desc});
}
