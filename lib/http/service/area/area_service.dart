import 'package:flutter/cupertino.dart';
import 'package:omt/bean/area/area_entity.dart';
import 'package:omt/http/api.dart';
import 'package:omt/http/http_manager.dart';

class AreaService {
  get _areas => '${API.share.host}api/moat/areas';

  getAreas({
    ValueChanged<List<AreaData>?>? onSuccess,
    ValueChanged<String>? onError,
  }) async {
    HttpManager.share.httpGet(
      await _areas,
      {},
    ).then((resultData) {
      if (resultData != null && resultData.code == 200) {
        List<AreaData>? data;
        if (resultData.data is List) {
          data = (resultData.data as List).map((i) => AreaData.fromJson(i)).toList();
        }
        if (onSuccess != null) {
          onSuccess(data);
        }
      } else {
        if (onError != null) {
          onError(resultData?.msg ?? 'Error');
        }
      }
    }).catchError((e) {
      if (onError != null) {
        onError(e.toString());
      }
    });
  }
}
