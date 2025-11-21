import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/one_picture/one_picture/one_picture_data_entity.dart';
import 'package:omt/generated/json/base/json_convert_content.dart';
import 'package:omt/http/http_query.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/device_utils.dart';
import 'package:omt/utils/json_utils.dart';
import 'package:omt/utils/log_utils.dart';
import 'package:omt/utils/shared_utils.dart';
import 'package:omt/utils/sys_utils.dart';

import '../../../router_utils.dart';
import '../../../utils/intent_utils.dart';
import '../../home/device_add/view_models/device_add_viewmodel.dart';
import '../../home/device_detail/view_models/device_detail_viewmodel.dart';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'dart:math' as math;

class OnePictureViewModel extends BaseViewModelRefresh<OnePictureDataData?> {
  String? instanceName;
  String? instanceId;
  int? gateId;
  int? passId;

  OnePictureViewModel(this.instanceId, this.gateId, this.passId,
      this.instanceName, this.onePictureHttpData);

  final TransformationController transformationController =
  TransformationController();

  final GlobalKey graphKey = GlobalKey();
  final GlobalKey interactiveKey = GlobalKey();
  bool hasFitted = false;
  Size? viewportSize;
  double minScale = 0.1;
  double maxScale = 2.0;

  Graph graph = Graph();

  SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..bendPointShape = CurvedBendPointShape(curveLength: 6)
    ..coordinateAssignment = CoordinateAssignment.Center;

  OnePictureDataData? onePictureHttpData;
  OnePictureDataData? theOnePictureDataData;
  OnePictureDataData? theHoverOnePictureDataData;

  Map<String, OnePictureDataData> dataMap = {};
  int currentIndex = 0;

  bool cannotTap() {
    return instanceId == null && gateId == null && passId == null;
  }

  @override
  void initState() async {
    super.initState();

    DeviceUtils.getNetworkMac(onData: (data) {
      if (SharedUtils.networkMac != data) {
        SharedUtils.networkMac = data ?? '';
        reInitData();
      }
    });

    reInitData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      transformationController.value = vmath.Matrix4.identity()
        ..scale(0.7, 0.7, 0.7);
    });
  }

  void setViewport(Size size) {
    viewportSize = size;
  }

  Size? _graphSize() {
    return graphKey.currentContext?.size;
  }

  void _setTransform(vmath.Matrix4 m) {
    transformationController.value = m;
  }

  void fitToViewport(Size viewport) {
    final child = _graphSize();
    if (child == null || child.width == 0 || child.height == 0) {
      return;
    }
    final sx = viewport.width / child.width;
    final sy = viewport.height / child.height;
    final scale = math.min(sx, sy).clamp(minScale, maxScale).toDouble();
    final tx = (viewport.width - child.width * scale) / 2;
    final ty = (viewport.height - child.height * scale) / 2;
    final m = vmath.Matrix4.identity()
      ..translate(tx, ty)
      ..scale(scale, scale, scale);
    _setTransform(m);
  }

  void tryFitOnce(Size viewport) {
    if (hasFitted) return;
    hasFitted = true;
    fitToViewport(viewport);
  }

  /// 核心修复：指定屏幕点(focalPoint)进行定点缩放
  /// 解决了平移后缩放漂移的问题
  void _zoomToPoint(double targetScale, ui.Offset focalPoint) {
    final matrix = transformationController.value;
    final double currentScale = matrix.storage[0];
    final double tx = matrix.storage[12];
    final double ty = matrix.storage[13];

    // 1. 限制缩放范围
    double newScale = targetScale.clamp(minScale, maxScale).toDouble();

    // 2. 计算鼠标指向的内容在“原始画布”上的坐标 (Scene Point)
    // 场景坐标 = (屏幕坐标 - 平移量) / 当前缩放比例
    double sceneX = (focalPoint.dx - tx) / currentScale;
    double sceneY = (focalPoint.dy - ty) / currentScale;

    // 3. 计算新的平移量，使得该内容点在缩放后依然位于鼠标下方
    // 新平移量 = 屏幕坐标 - 场景坐标 * 新缩放比例
    double newTx = focalPoint.dx - sceneX * newScale;
    double newTy = focalPoint.dy - sceneY * newScale;

    // 4. 应用新矩阵
    transformationController.value = vmath.Matrix4.identity()
      ..translate(newTx, newTy)
      ..scale(newScale, newScale, newScale);
  }

  /// 按钮放大
  void zoomIn() {
    final currentScale = transformationController.value.storage[0];
    final targetScale = currentScale * 1.2;

    // 以视口中心为缩放点
    final center = viewportSize != null
        ? ui.Offset(viewportSize!.width / 2, viewportSize!.height / 2)
        : ui.Offset.zero;

    _zoomToPoint(targetScale, center);
  }

  /// 按钮缩小
  void zoomOut() {
    final currentScale = transformationController.value.storage[0];
    final targetScale = currentScale * 0.8;

    final center = viewportSize != null
        ? ui.Offset(viewportSize!.width / 2, viewportSize!.height / 2)
        : ui.Offset.zero;

    _zoomToPoint(targetScale, center);
  }

  /// 鼠标滚轮缩放
  void zoomWheelAt(double dy, ui.Offset local) {
    final currentScale = transformationController.value.storage[0];
    // 向上滚放大，向下滚缩小
    final targetScale = dy > 0 ? currentScale * 0.8 : currentScale * 1.2;

    // 传入鼠标当前位置作为缩放锚点
    _zoomToPoint(targetScale, local);
  }

  void setupOnePictureHttpData() {
    if (null != onePictureHttpData) {
      OnePictureDataData data = onePictureHttpData!;
      currentIndex = 0;
      onePictureHttpData = data;
      dataMap.clear();
      OnePictureDataData? opd;
      _setDataMap(data);
      opd = _dealHttpData(data);
      setDataToGraph(opd);
      theOnePictureDataData = opd;
      notifyListeners();

      Timer(Duration(milliseconds: 500), () {
        notifyListeners();
      });
    }
  }

  void reInitData() {
    graph = Graph();
    builder = SugiyamaConfiguration()
      ..nodeSeparation = (50)
      ..levelSeparation = (70)
      ..bendPointShape = CurvedBendPointShape(curveLength: 6)
      ..coordinateAssignment = CoordinateAssignment.Center;
    onePictureHttpData = null;
    theOnePictureDataData = null;
    currentIndex = 0;
    dataMap.clear();
    notifyListeners();
    requestData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  loadData({onSuccess, onCache, onError}) async {
  }

  void requestData() {
    if (instanceId == null) {
      return;
    }
    HttpQuery.share.onePictureService.deviceTree(
        instanceId: instanceId!,
        gateId: gateId,
        passId: passId,
        onSuccess: (data) {
          currentIndex = 0;
          onePictureHttpData = data;
          dataMap.clear();
          OnePictureDataData? opd;
          if (null == data && null == gateId && null == passId) {
            opd = OnePictureDataData()
              ..name = instanceName ?? '未知'
              ..type = OnePictureType.SL.index
              ..id = '-99'
              ..nextList = [
                OnePictureDataData()
                  ..name = '未发现绑定设备'
                  ..type = OnePictureType.OTHER.index
                  ..id = '-99'
              ];
            _setDataMap(opd);
            setArrowBorder(opd);
          } else if (null == data) {
            opd = OnePictureDataData()
              ..name = '未发现绑定设备'
              ..type = OnePictureType.OTHER.index
              ..id = '-99';
            _setDataMap(opd);
          } else {
            _setDataMap(data);
            opd = _dealHttpData(data);
          }
          setDataToGraph(opd);
          theOnePictureDataData = opd;
          notifyListeners();
          Timer(Duration(milliseconds: 500), () {
            notifyListeners();
          });
        },
        onCache: (data) {},
        onError: (e) {});
  }

  void _setDataMap(OnePictureDataData? data) {
    if (null != data?.type || null != data?.nodeCode) {
      dataMap[_getNodeId(data)] = data!;
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

          var wlList = data.children.where((e) {
            return e.type == OnePictureType.YXWL.index ||
                e.type == OnePictureType.LYQ.index;
          }).toList();
          var jhjList = data.children.where((e) {
            return e.type == OnePictureType.JHJ.index;
          }).toList();

          if (notJckList.isNotEmpty && gdsbList.isEmpty) {
            if (data.addEmptyNode) {
              data.children.add(OnePictureDataData()
                ..type = OnePictureType.GDSB.index
                ..unknown = true
                ..children = [
                  OnePictureDataData()
                    ..type = OnePictureType.SD.index
                    ..name = '电源未知'
                ]);
            }
            if (dyxList.isEmpty) {
              if (data.addEmptyNode) {
                data.children.add(OnePictureDataData()
                  ..type = OnePictureType.DYX.index
                  ..unknown = true
                  ..name = '电源箱未知');
              }
            }
          }
          if (notJckList.isNotEmpty && wlList.isEmpty) {
            if (data.addEmptyNode) {
              data.children.add(OnePictureDataData()
                ..type = OnePictureType.YXWL.index
                ..unknown = true
                ..children = [
                  OnePictureDataData()
                    ..type = OnePictureType.YXWL.index
                    ..name = '未知网路'
                ]);
            }
          }
          if (notJckList.isNotEmpty && jhjList.isEmpty) {
            if (data.addEmptyNode) {
              data.children.add(OnePictureDataData()
                ..type = OnePictureType.JHJ.index
                ..unknown = true
                ..children = [
                  OnePictureDataData()
                    ..type = OnePictureType.JHJ.index
                    ..name = '未知交换机'
                ]);
            }
          }
        }

        if (data.children.isNotEmpty) {
          var jckElements = data.children
              .where((e) => e.type == OnePictureType.JCK.index)
              .toList();
          data.children.removeWhere((e) => e.type == OnePictureType.JCK.index);
          if (jckElements.isNotEmpty) {
            data.children.insert(0, jckElements[0]);
          }
          if (jckElements.length > 1) {
            for (var i = 1; i < jckElements.length; i++) {
              var jckElement = jckElements[i];
              data.children.add(jckElement);
            }
          }
        }

        var elementsToMoveToEnd = data.children
            .where((e) =>
        e.type == OnePictureType.LYQ.index ||
            e.type == OnePictureType.YXWL.index)
            .toList();

        data.children.removeWhere((e) =>
        e.type == OnePictureType.LYQ.index ||
            e.type == OnePictureType.YXWL.index);

        data.children.addAll(elementsToMoveToEnd);
      } else if (data.type == OnePictureType.JCK.index) {
        var wlList = data.children.where((e) {
          return e.type == OnePictureType.YXWL.index ||
              e.type == OnePictureType.LYQ.index;
        }).toList();
        var jhjList = data.children.where((e) {
          return e.type == OnePictureType.JHJ.index;
        }).toList();

        var otherList = data.children.where((e) {
          return e.type != OnePictureType.AISB.index &&
              e.type != OnePictureType.SXT.index &&
              e.type != OnePictureType.NVR.index;
        }).toList();

        if (otherList.isNotEmpty) {
          if (wlList.isEmpty) {
            if (data.addEmptyNode) {
              data.children.add(OnePictureDataData()
                ..type = OnePictureType.YXWL.index
                ..unknown = true
                ..children = [
                  OnePictureDataData()
                    ..type = OnePictureType.YXWL.index
                    ..name = '未知网路'
                ]);
            }
          }
          if (jhjList.isEmpty) {
            if (data.addEmptyNode) {
              data.children.add(OnePictureDataData()
                ..type = OnePictureType.JHJ.index
                ..unknown = true
                ..children = [
                  OnePictureDataData()
                    ..type = OnePictureType.JHJ.index
                    ..name = '未知交换机'
                ]);
            }
          }
        }

        var elementsToMoveToEnd = data.children
            .where((e) =>
        e.type == OnePictureType.LYQ.index ||
            e.type == OnePictureType.YXWL.index)
            .toList();

        data.children.removeWhere((e) =>
        e.type == OnePictureType.LYQ.index ||
            e.type == OnePictureType.YXWL.index);

        data.children.addAll(elementsToMoveToEnd);
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

  String _getNodeId(OnePictureDataData? data) =>
      '${data?.type}_${data?.nodeCode ?? ''}';

  void _pruneEmptyJck(OnePictureDataData node) {
    if (node.children.isNotEmpty) {
      for (var child in node.children) {
        _pruneEmptyJck(child);
      }
      node.children.removeWhere(
              (e) => e.type == OnePictureType.JCK.index && e.children.isEmpty);
    }
  }

  OnePictureDataData? _dealHttpData(OnePictureDataData? data) {
    if (data == null) {
      return null;
    }

    if (data.children.isNotEmpty) {
      for (var item in data.children) {
        _pruneEmptyJck(item);
      }
      data.children.removeWhere(
              (e) => e.type == OnePictureType.JCK.index && e.children.isEmpty);
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
    if (opd.type == OnePictureType.DM.index) {
      if (opd.children.isNotEmpty) {
        for (var child in opd.children) {
          child.parent = opd;
        }
      }
    }

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
      if (opd.type == OnePictureType.GDSB.index) {
        if (opd.children.isNotEmpty) {
          for (var c in opd.children) {
            c.idParent = opd.id;
            c.nodeCodeParent = opd.nodeCode;
          }
        }
      }

      for (var child in opd.children) {
        if (child.type == OnePictureType.GDSB.index) {
          if (child.children.isNotEmpty) {
            for (var c in child.children) {
              c.idParent = child.id;
              c.nodeCodeParent = child.nodeCode;
            }
          }
        }

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
        for (var child in jck) {
          setNextList(child);
        }
      } else {
        if (gdsb.isNotEmpty) {
          opd.children = gdsb;
          if (dyx.isNotEmpty) {
            opd.children[0].nextList.addAll(dyx);
            _powerSub(opd.children[0].nextList[0],
                jck: jck, lyq: lyq, nvr: nvr, jhj: jhj, yxwl: yxwl, aisb: aisb);
          } else {
            _powerSub(opd.children[0],
                jck: jck, lyq: lyq, nvr: nvr, jhj: jhj, yxwl: yxwl, aisb: aisb);
          }
        } else if (dyx.isNotEmpty) {
          opd.children = dyx;
          _powerSub(opd.children[0],
              jck: jck, lyq: lyq, nvr: nvr, jhj: jhj, yxwl: yxwl, aisb: aisb);
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
                jck: jck,
                lyq: lyq,
                nvr: nvr,
                jhj: jhj,
                yxwl: yxwl,
                aisb: aisb,
                sxt: sxt);
          } else {
            _powerSub(opd.children[0],
                jck: jck,
                lyq: lyq,
                nvr: nvr,
                jhj: jhj,
                yxwl: yxwl,
                aisb: aisb,
                sxt: sxt);
          }
        } else if (dyx.isNotEmpty) {
          opd.children = dyx;
          _powerSub(opd.children[0],
              jck: jck.isEmpty && opd.type == OnePictureType.JCK.index
                  ? jckf == null
                  ? []
                  : [jckf]
                  : jck,
              lyq: lyq,
              yxwl: yxwl,
              jhj: jhj,
              aisb: aisb,
              sxt: sxt);
        } else {
          if (jckf != null) {
            opd.children.add(jckf);
          } else if (opd.type == OnePictureType.JCK.index) {
            opd.children.addAll(jck);
          }
          if (lyq.isNotEmpty) {
            opd.children.addAll(lyq);
          }
          if (aisb.isNotEmpty) {
            opd.children.addAll(aisb);
          }
          if (sxt.isNotEmpty) {
            opd.children.addAll(sxt);
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
      var nodeRoot = parentNode ?? Node.Id(_getNodeId(opd));
      if (opd.nextList.isNotEmpty) {
        OnePictureDataData? jhj;
        List<OnePictureDataData> jhjTargetList = [];
        List<OnePictureDataData> lyqList = [];

        var jhjList = opd.nextList
            .where((element) => element.type == OnePictureType.JHJ.index);

        for (var next in opd.nextList) {
          if (next.type == OnePictureType.JHJ.index &&
              opd.nextList.length > 1) {
            jhj = next;
          } else {
            var nodeNext = Node.Id(_getNodeId(next));
            graph.addEdge(nodeRoot, nodeNext,
                paint: Paint()
                  ..strokeWidth = 2
                  ..color = (opd.unknown &&
                      (next.type == OnePictureType.DYX.index ||
                          next.type == OnePictureType.SD.index ||
                          next.type == OnePictureType.DC.index ||
                          next.type == OnePictureType.GDSB.index))
                      ? ColorUtils.transparent
                      : opd.lineColor.toColor(),
                arrowTitle:
                next.showName == true ? next.showNameText(arrow: true) : '',
                arrowTitleColor: ColorUtils.colorBlackLite.dark);
            doSetDataToGraph(graph, next, parentNode: nodeNext);

            if (jhjList.isNotEmpty &&
                (next.type == OnePictureType.LYQ.index ||
                    next.type == OnePictureType.YXWL.index)) {
              lyqList.add(next);
            } else {
              jhjTargetList.add(next);
            }
          }
          haNode = true;
        }
        if (jhj != null && jhjTargetList.isNotEmpty) {
          var nodeRoot = Node.Id(_getNodeId(jhj));
          for (var next in jhjTargetList) {
            var nodeNext = Node.Id(_getNodeId(next));
            graph.addEdge(nodeNext, nodeRoot,
                paint: Paint()
                  ..strokeWidth = 2
                  ..style = PaintingStyle.fill
                  ..color = jhj.unknown
                      ? ColorUtils.transparent
                      : jhj.lineColor.toColor(),
                showArrow: false,
                type: 0,
                dash: false);
          }
        }

        if (lyqList.isNotEmpty && jhj != null) {
          var nodeNext = Node.Id(_getNodeId(jhj));
          for (var root in lyqList) {
            var nodeRoot = Node.Id(_getNodeId(root));
            graph.addEdge(nodeRoot, nodeNext,
                paint: Paint()
                  ..strokeWidth = 2
                  ..style = PaintingStyle.fill
                  ..color = root.lineColor.toColor(),
                showArrow: false,
                type: 2,
                dash: false);
          }
        }
      }
    }
    return haNode;
  }

  void onTapItem(OnePictureDataData? data) {
    if (cannotTap()) {
      return;
    }
    if (data?.unknown == true) {
      return;
    }
    if (null == data?.nodeCode ||
        data?.type == OnePictureType.SL.index ||
        data?.type == OnePictureType.DM.index ||
        data?.type == OnePictureType.JCK.index) {
      return;
    }

    String nodeId = data?.id ?? "";

    if (nodeId.isEmpty) return;
    DeviceType? type = DeviceUtils.getDeviceTypeFromInt(data?.type ?? 0);

    if ((data?.type == OnePictureType.DC.index) ||
        (data?.type == OnePictureType.SD.index)) {
      nodeId = data?.idParent ?? "";
      type = DeviceType.power;
    }
    if ((data?.type == OnePictureType.GDSB.index)) {
      type = DeviceType.power;
    }

    if (type == null ||
        data?.type == OnePictureType.LYQ.index ||
        data?.type == OnePictureType.YXWL.index) {
      type = DeviceType.router;
    }
    DeviceDetailViewModel model = DeviceDetailViewModel(
      deviceType: type,
      nodeId: nodeId,
    );
    IntentUtils.share.push(context,
        routeName: RouterPage.DeviceDetailScreen,
        data: {"data": model})?.then((value) {
      if (IntentUtils.share.isResultOk(value)) {
        requestData();
      }
    });
  }

  void onTapItemNew(OnePictureDataData? data) {
    if (data == null || cannotTap()) {
      return;
    }
    IntentUtils.share.push(context,
        routeName: RouterPage.DeviceAddPage,
        data: {"pNodeCode": data.nodeCode})?.then((value) {
      if (IntentUtils.share.isResultOk(value)) {
        requestData();
      }
    });
  }

  void _powerSub(OnePictureDataData opd,
      {List<OnePictureDataData>? jck,
        List<OnePictureDataData>? lyq,
        List<OnePictureDataData>? nvr,
        List<OnePictureDataData>? jhj,
        List<OnePictureDataData>? yxwl,
        List<OnePictureDataData>? aisb,
        List<OnePictureDataData>? sxt}) {
    if (jck?.isNotEmpty == true) {
      opd.nextList.insert(0, jck![0]);
    }

    if (nvr?.isNotEmpty == true) {
      opd.nextList.addAll(nvr!);
    }
    if (aisb?.isNotEmpty == true) {
      opd.nextList.addAll(aisb!);
    }
    if (sxt?.isNotEmpty == true) {
      opd.nextList.addAll(sxt!);
    }
    if (jhj?.isNotEmpty == true) {
      if (jhj!.length > 1) {
        var father =
        jhj[0].copyWith(children: jhj, sameTypeData: true, name: '');
        opd.nextList.add(father);
        dataMap[_getNodeId(father)] = father;
        for (var child in jhj) {
          opd.nextList.remove(child);
        }
      } else {
        opd.nextList.addAll(jhj!);
      }
    }

    if ((jck?.length ?? 0) > 1) {
      for (var i = 1; i < jck!.length; i++) {
        var jckElement = jck[i];
        opd.nextList.add(jckElement);
      }
    }

    if (yxwl?.isNotEmpty == true) {
      opd.nextList.addAll(yxwl!);
    }
    if (lyq?.isNotEmpty == true) {
      opd.nextList.addAll(lyq!);
    }
  }

  void setHover(OnePictureDataData? oData) {
    if (oData == null) {
      theHoverOnePictureDataData = null;
      notifyListeners();
    } else if (theHoverOnePictureDataData != oData) {
      theHoverOnePictureDataData = oData;
      notifyListeners();
    }
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