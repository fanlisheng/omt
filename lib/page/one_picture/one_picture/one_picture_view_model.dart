import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';
import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/json_utils.dart';

import '../../../router_utils.dart';
import '../../../utils/intent_utils.dart';
import '../../home/device_detail/view_models/device_detail_viewmodel.dart';

///
///  omt
///  one_picture_view_model.dart
///  一张图
///
///  Created by kayoxu on 2024-12-03 at 10:09:44
///  Copyright © 2024 .. All rights reserved.
///

class OnePictureViewModel extends BaseViewModelRefresh<OnePictureDataData?> {
  final String? instanceId;
  final int? gateId;
  final int? passId;

  OnePictureViewModel(this.instanceId, this.gateId, this.passId);

  final Graph graph = Graph();

  SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..bendPointShape = CurvedBendPointShape(curveLength: 6)
    ..coordinateAssignment = CoordinateAssignment.UpRight;

  OnePictureDataData? onePictureHttpData;

  Map<String, OnePictureDataData> dataMap = {};

  int currentIndex = 0;

  @override
  void initState() async {
    super.initState();
    builder
      ..nodeSeparation = (60)
      ..levelSeparation = (60)
      ..orientation = SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) async {
    // var userInfo = await SharedUtils.getUserInfo();
    if (instanceId == null) {
      return;
    }
    HttpQuery.share.onePictureService.deviceTree(
        // instanceId: "124#12812",
        instanceId: instanceId!,
        gateId: gateId,
        passId: passId,
        onSuccess: (data) {
          currentIndex = 0;
          onePictureHttpData = data;
          dataMap.clear();

          _setDataMap(data);

          OnePictureDataData? opd = _dealHttpData(data);

          setDataToGraph(opd);

          onSuccess?.call(opd);
        },
        onCache: (data) {
          // onePictureHttpData = data;
          // dataMap.clear();
          //
          // _setDataMap(data);
          //
          // OnePictureDataData? opd = _dealHttpData(data);
          //
          // setDataToGraph(opd);

          // onCache?.call(data);
        },
        onError: onError);
  }

  void _setDataMap(OnePictureDataData? data) {
    if (null != data?.type || null != data?.id) {
      dataMap['${data!.type}_${data.id}'] = data;
    }
    if (null != data?.children && data!.children.isNotEmpty) {
      if (data.type == OnePictureType.DM.index) {
        if (data.children.isNotEmpty) {
          var notJckList = data.children.where((e) {
            return e.type != OnePictureType.JCK.index;
          }).toList();

          var dyxList = data.children.where((e) {
            return e.type == OnePictureType.DYX.index;
          }).toList();

          var gdsbList = data.children.where((e) {
            return e.type == OnePictureType.GDSB.index;
          }).toList();

          if (notJckList.isNotEmpty && gdsbList.isEmpty) {
            data.children.add(OnePictureDataData()
              ..type = OnePictureType.GDSB.index
              ..unknown = true
              ..children = [
                OnePictureDataData()
                  ..type = OnePictureType.SD.index
                  ..name = '电源未知'
              ]);
            if (dyxList.isEmpty) {
              data.children.add(OnePictureDataData()
                ..type = OnePictureType.DYX.index
                ..unknown = true
                ..name = '电源箱未知');
            }
          }
        }
      }

      for (var item in data.children) {
        _setDataMap(item);
      }
    }
    if (null != data?.nextList && data!.nextList.isNotEmpty) {
      for (var item in data.nextList) {
        _setDataMap(item);
      }
    }
  }

  OnePictureDataData? _dealHttpData(OnePictureDataData? data) {
    if (data == null) {
      return null;
    }
    var opd = data.copyWith(nextList: []);
    setArrowBorder(opd);
    setJCK(opd, callback: (id, data) {
      dataMap[id] = data;
    });

    setNextList(opd);

    copySameTypeData(opd);

    return opd;
  }

  void setJCK(OnePictureDataData opd,
      {required Function(String id, OnePictureDataData data) callback}) {
    if (opd.children.isNotEmpty) {
      for (var child in opd.children) {
        if (child.type == OnePictureType.JCK.index && child.ignore == false) {
          child.ignore = true;
          child.setJCK(callback);
        } else {
          setJCK(child, callback: callback);
        }
      }
    }
  }

  void setArrowBorder(OnePictureDataData opd) {
    opd.setArrow();
    opd.setBorder();
    opd.setIcon();

    if (opd.children.isNotEmpty) {
      for (var child in opd.children) {
        setArrowBorder(child);
      }
    }
    if (opd.nextList.isNotEmpty) {
      for (var child in opd.nextList) {
        setArrowBorder(child);
      }
    }
  }

  void copySameTypeData(OnePictureDataData? opd) {
    if (opd?.children == null || opd!.children.isEmpty) {
      return;
    }

    Map<int, List<OnePictureDataData>> typeMap = {};
    List<OnePictureDataData> eData = [];

    for (var child in opd.children) {
      if (child.type == null || opd.sameTypeData == true) {
        continue;
      }

      if (child.type == OnePictureType.DM.index ||
          child.type == OnePictureType.GDSB.index ||
          child.type == OnePictureType.DYX.index ||
          child.type == OnePictureType.JCK.index) {
        eData.add(child);
        continue;
      }

      if (typeMap.containsKey(child.type)) {
        typeMap[child.type]!.add(child);
      } else {
        typeMap[child.type!] = [child];
      }
    }

    List<OnePictureDataData> childrenList =
        opd.sameTypeData == true ? opd.children : [];
    for (var type in typeMap.keys) {
      if (typeMap[type]!.length == 1) {
        childrenList.addAll(typeMap[type]!);
      } else if (typeMap[type]!.length > 1) {
        if (type == OnePictureType.JCK.index) {
          childrenList.addAll(typeMap[type]!);
        } else {
          var father =
              typeMap[type]![0].copyWith(children: [], sameTypeData: true);
          father.children.addAll(typeMap[type]!);
          childrenList.add(father);
        }
      }
    }
    if (childrenList.isNotEmpty) {
      for (var child in childrenList) {
        copySameTypeData(child);
      }
    }

    if (eData.isNotEmpty) {
      for (var child in eData) {
        copySameTypeData(child);
      }
      childrenList.addAll(eData);
    }

    opd.children = childrenList;
  }

  void setNextList(OnePictureDataData opd) {
    Map<int, List<OnePictureDataData>> typeMap = {};
    if (opd.children.isNotEmpty) {
      for (var child in opd.children) {
        if (child.type == null) {
          continue;
        }
        if (typeMap.containsKey(child.type)) {
          typeMap[child.type]!.add(child);
        } else {
          typeMap[child.type!] = [child];
        }
      }
    }

    List<OnePictureDataData> dm =
        typeMap.getOrNull<List<OnePictureDataData>>(OnePictureType.DM.index) ??
            [];
    List<OnePictureDataData> jck =
        typeMap.getOrNull<List<OnePictureDataData>>(OnePictureType.JCK.index) ??
            [];
    List<OnePictureDataData> gdsb = typeMap
            .getOrNull<List<OnePictureDataData>>(OnePictureType.GDSB.index) ??
        [];
    List<OnePictureDataData> dyx =
        typeMap.getOrNull<List<OnePictureDataData>>(OnePictureType.DYX.index) ??
            [];
    List<OnePictureDataData> lyq =
        typeMap.getOrNull<List<OnePictureDataData>>(OnePictureType.LYQ.index) ??
            [];
    List<OnePictureDataData> yxwl = typeMap
            .getOrNull<List<OnePictureDataData>>(OnePictureType.YXWL.index) ??
        [];
    List<OnePictureDataData> nvr =
        typeMap.getOrNull<List<OnePictureDataData>>(OnePictureType.NVR.index) ??
            [];
    List<OnePictureDataData> jhj =
        typeMap.getOrNull<List<OnePictureDataData>>(OnePictureType.JHJ.index) ??
            [];
    List<OnePictureDataData> aisb = typeMap
            .getOrNull<List<OnePictureDataData>>(OnePictureType.AISB.index) ??
        [];
    List<OnePictureDataData> sxt =
        typeMap.getOrNull<List<OnePictureDataData>>(OnePictureType.SXT.index) ??
            [];
    List<OnePictureDataData> sd =
        typeMap.getOrNull<List<OnePictureDataData>>(OnePictureType.SD.index) ??
            [];
    List<OnePictureDataData> dc =
        typeMap.getOrNull<List<OnePictureDataData>>(OnePictureType.DC.index) ??
            [];

    if (opd.type == OnePictureType.SL.index) {
      if (dm.isNotEmpty) {
        opd.nextList.addAll(dm);
        for (var p in opd.nextList) {
          setNextList(p);
        }
      }
    } else if (opd.type == OnePictureType.DM.index) {
      if (jck.isNotEmpty && jck[0].showBorder == true) {
        // opd.children = jck;
        for (var child in jck) {
          setNextList(child);
        }
      } else {
        if (gdsb.isNotEmpty) {
          opd.children = gdsb;
          if (dyx.isNotEmpty) {
            opd.children[0].nextList.addAll(dyx);
            _powerSub(opd.children[0].nextList[0],
                jck: jck, lyq: lyq, nvr: nvr, jhj: jhj, yxwl: yxwl);
          } else {
            _powerSub(opd.children[0],
                jck: jck, lyq: lyq, nvr: nvr, jhj: jhj, yxwl: yxwl);
          }
        } else if (dyx.isNotEmpty) {
          opd.children = dyx;
        } else if (jck.isNotEmpty) {
          opd.children = jck;
          for (var child in jck) {
            setNextList(child);
          }
        }
      }
    } else if (opd.type == OnePictureType.JCK.index) {
      if (opd.showBorder == true) {
        var jckf = getJckFather(opd, aisb, sxt, nvr);
        opd.children.clear();
        if (gdsb.isNotEmpty) {
          opd.children = gdsb;
          if (dyx.isNotEmpty) {
            opd.children[0].nextList.addAll(dyx);
            _powerSub(opd.children[0].nextList[0],
                jck: jck, lyq: lyq, nvr: nvr, jhj: jhj, yxwl: yxwl);
          } else {
            _powerSub(opd.children[0],
                jck: jck, lyq: lyq, nvr: nvr, jhj: jhj, yxwl: yxwl);
          }
        } else if (dyx.isNotEmpty) {
          opd.children = dyx;
          _powerSub(opd.children[0],
              jck: jckf == null ? [] : [jckf], lyq: lyq, yxwl: yxwl, jhj: jhj);
        } else {
          if (jckf != null) {
            opd.children.add(jckf);
          }
          if (lyq.isNotEmpty) {
            opd.children.addAll(lyq);
          }

          if (jhj.isNotEmpty) {
            opd.children.addAll(jhj);
          }
        }
      }
    }
  }

  void setDataToGraph(OnePictureDataData? opd) {
    doSetDataToGraph(graph, opd);
  }

  bool doSetDataToGraph(Graph graph, OnePictureDataData? opd,
      {Node? parentNode}) {
    bool haNode = false;
    if (null != opd) {
      var nodeRoot = parentNode ?? Node.Id('${opd.type}_${opd.id}');
      // var childList = opd.getChildList();
      if (opd.nextList.isNotEmpty) {
        OnePictureDataData? jhj;
        List<OnePictureDataData> jhjTargetList = [];

        for (var next in opd.nextList) {
          if (next.type == OnePictureType.JHJ.index &&
              opd.nextList.length > 1) {
            jhj = next;
          } else {
            var nodeNext = Node.Id('${next.type}_${next.id}');
            graph.addEdge(nodeRoot, nodeNext,
                paint: Paint()
                  ..color = opd.unknown
                      ? ColorUtils.transparent
                      : opd.lineColor.toColor());
            doSetDataToGraph(graph, next, parentNode: nodeNext);

            jhjTargetList.add(next);
          }

          haNode = true;
        }

        if (jhj != null && jhjTargetList.isNotEmpty) {
          var nodeRoot = Node.Id('${jhj.type}_${jhj.id}');
          for (var next in jhjTargetList) {
            var nodeNext = Node.Id('${next.type}_${next.id}');
            graph.addEdge(nodeNext, nodeRoot,
                paint: Paint()
                  ..color = jhj.unknown
                      ? ColorUtils.transparent
                      : jhj.lineColor.toColor(),
                showArrow: false);
          }
        }
      }
    }
    return haNode;
  }

  void onTapItem(OnePictureDataData? data) {
    if (data?.unknown == true) {
      if (data?.type == OnePictureType.DYX.index) {
        /// 电源箱未知
      } else if (data?.type == OnePictureType.SD.index ||
          data?.type == OnePictureType.DC.index) {
        /// 电源未知
      }
    }

    if (data == null ||
        (data.nodeCode ?? "").isEmpty ||
        DeviceUtils.getDeviceTypeFromInt(data.type ?? 0) == null) {
      return;
    }
    print('onTapItem ${data.id}');
    DeviceDetailViewModel model = DeviceDetailViewModel(
      deviceType: DeviceUtils.getDeviceTypeFromInt(data.type ?? 0)!,
      nodeCode: data.nodeCode!,
      // nodeCode: '124#12812-2#2-3#1-11#0',
    );
    IntentUtils.share.push(context,
        routeName: RouterPage.DeviceDetailScreen, data: {"data": model});
  }

  void onTapItemNew(OnePictureDataData? data) {
    print('onTapItemNew ${data?.id}');
  }
}

OnePictureDataData? getJckFather(
    OnePictureDataData opd,
    List<OnePictureDataData> aisb,
    List<OnePictureDataData> sxt,
    List<OnePictureDataData> nvr) {
  if (aisb.isNotEmpty || sxt.isNotEmpty || nvr.isNotEmpty) {
    var jckFather = opd.copyWith(children: []);
    if (aisb.isNotEmpty) {
      jckFather.children.addAll(aisb);
    }
    if (sxt.isNotEmpty) {
      jckFather.children.addAll(sxt);
    }
    if (nvr.isNotEmpty) {
      jckFather.children.addAll(nvr);
    }
    return jckFather;
  }
  return null;
}

void _powerSub(OnePictureDataData opd,
    {List<OnePictureDataData>? jck,
    List<OnePictureDataData>? lyq,
    List<OnePictureDataData>? nvr,
    List<OnePictureDataData>? jhj,
    List<OnePictureDataData>? yxwl}) {
  if (jck?.isNotEmpty == true) {
    opd.nextList.addAll(jck!);
  }
  if (lyq?.isNotEmpty == true) {
    opd.nextList.addAll(lyq!);
  }
  if (nvr?.isNotEmpty == true) {
    opd.nextList.addAll(nvr!);
  }
  if (jhj?.isNotEmpty == true) {
    opd.nextList.addAll(jhj!);
  }
  if (yxwl?.isNotEmpty == true) {
    opd.nextList.addAll(yxwl!);
  }
}
