import 'dart:ui';

import 'package:omt/bean/common/id_name_value.dart';

class PaintYolo {
  IdNameValue? type;
  Rect? rect;

  PaintYolo({this.type, this.rect});

  @override
  String toString() {
    return '${type?.nameShow}';
  }
}
