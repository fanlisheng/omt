import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:omt/bean/common/code_data.dart';

import '../../../bean/common/id_name_value.dart';
import '../../api.dart';
import '../../http_manager.dart';

class LabelManagementService {
  get _labelList => '${API.share.host}api/label/list';

  get _create => '${API.share.host}api/label/create';

  get _delete => '${API.share.host}api/label/delete';

  get _edit => '${API.share.host}api/label/edit';

  getLabelList(
    String name, {
    required ValueChanged<List<StrIdNameValue>?>? onSuccess,
    ValueChanged<List<StrIdNameValue>?>? onCache,
    required ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<List<StrIdNameValue>>(
      await _labelList,
      {"page": 0, "limit": 0, "name": name},
      method: 'GET',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  create(
    String name, {
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    required ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _create,
      {"name": name},
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  delete(
    int id, {
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    required ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _delete,
      {"id": id},
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }

  edit(
    String id,
    String name, {
    required ValueChanged<CodeMessageData?> onSuccess,
    ValueChanged<CodeMessageData?>? onCache,
    required ValueChanged<String>? onError,
  }) async {
    HttpManager.share.doHttpPost<CodeMessageData>(
      await _edit,
      {"id": id, "name": name},
      method: 'POST',
      autoHideDialog: true,
      autoShowDialog: true,
      onSuccess: onSuccess,
      onCache: onCache,
      onError: onError,
    );
  }
}
