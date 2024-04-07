import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/bean/common/id_name_value.dart';
import 'package:omt/utils/color_utils.dart';
import 'package:omt/utils/log_utils.dart';

class IdNamePickerWidget extends StatefulWidget {
  String placeholder;

  List<IdNameValue> points;

  ValueChanged<IdNameValue?>? onDataPick;

  IdNamePickerWidget(
      {super.key,
      required this.points,
      required this.placeholder,
      this.onDataPick});

  @override
  State<IdNamePickerWidget> createState() => _IdNamePickerWidgetState();

  static show(
      {required BuildContext context,
      String title = '请选择',
      String placeholder = '请选择',
      String okBtnText = '确定',
      ValueChanged<IdNameValue?>? onDataPick,
      required List<IdNameValue> points}) {
    IdNameValue? sd;

    showDialog<String>(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(title),
        content: SizedBox(
          height: 50,
          child: IdNamePickerWidget(
            points: points,
            placeholder: placeholder,
            onDataPick: (data) {
              sd = data;
            },
          ),
        ),
        actions: [
          Button(
            child: Text(okBtnText),
            onPressed: () {
              if (null != sd) {
                Navigator.pop(context);
                onDataPick?.call(sd);
              } else {
                LoadingUtils.showToast(data: placeholder);
              }
            },
          ),
          FilledButton(
            child: const Text(
              '取消',
              style: TextStyle(color: ColorUtils.colorWhite),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _IdNamePickerWidgetState extends State<IdNamePickerWidget> {
  final asbKey = GlobalKey<AutoSuggestBoxState>(
    debugLabel: 'Manually controlled AutoSuggestBox IdNamePickerWidget',
  );

  FocusNode focusNode = FocusNode();
  IdNameValue? selectedPoint;
  String sgText = '';

  void _onFocusChange() {
    if (focusNode.hasFocus) {
      if (asbKey.currentState?.isOverlayVisible != true) {
        setState(() {
          asbKey.currentState?.showOverlay();
        });
      }
    } else {
      if (BaseSysUtils.empty(sgText) && null != selectedPoint) {
        onPointSelected(null);
      }
    }
  }

  void onPointSelected(AutoSuggestBoxItem<IdNameValue>? item) {
    setState(() {
      selectedPoint = item?.value;
      widget.onDataPick?.call(item?.value);
    });
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoSuggestBox<IdNameValue>(
      placeholder: widget.placeholder,
      key: asbKey,
      items: widget.points.map((e) {
        return AutoSuggestBoxItem<IdNameValue>(
            value: e,
            label: e.name ?? '',
            child: TextView(
              e.name,
              maxLine: 1,
              color: ColorUtils.colorBlackLite,
              size: 12,
            ),
            onFocusChange: (focused) {
              if (focused) {
                // debugPrint('Focused $e -- ${model.asbKey.currentState?.widget.controller?.text}',);
              }
            });
      }).toList(),
      focusNode: focusNode,
      onSelected: (item) {
        onPointSelected(item);
      },
      onChanged: (text, TextChangedReason r) {
        if (r == TextChangedReason.cleared) {
          onPointSelected(null);
        }
        sgText = text;
        LogUtils.info(tag: 'TextChangedReason', msg: r.toString());
      },
    );
  }
}
