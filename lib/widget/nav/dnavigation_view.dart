import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:kayo_package/kayo_package_utils.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';
import 'package:omt/routing/routes.dart';
import 'package:omt/test/test.dart';

import '../../utils/color_utils.dart';
import '../../utils/intent_utils.dart';

class DNavigationView extends StatelessWidget {
  final String title;
  final String titlePass;
  final Widget? rightWidget;
  final bool? hasReturn;
  final GestureTapCallback? onTap;

  const DNavigationView({
    super.key,
    required this.title,
    required this.titlePass,
    this.rightWidget,
    this.hasReturn,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if ((hasReturn ?? true) == true) ...[
          Clickable(
            onTap: onTap ??
                () {
                  IntentUtils.share.pop(context);
                  // GoRouter.of(context).pop();
                  // KayoPackage.share.navigatorKey.currentState!.canPop();
                  // if (KayoPackage.share.navigatorKey.currentState!.canPop() != false) {
                  //   KayoPackage.share.navigatorKey.currentState!.canPop();
                  // }
                },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: ColorUtils.colorGreen,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              child: const Text(
                "返回",
                style: TextStyle(fontSize: 12, color: ColorUtils.colorGreen),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Text(
          titlePass,
          style: TextStyle(
            fontSize: 12,
            color: ColorUtils.colorWhite.withOpacity(0.5),
          ),
        ),
        Text(title,
            style: const TextStyle(fontSize: 12, color: ColorUtils.colorWhite)),
        (rightWidget == null) ? Container() : rightWidget!,
      ],
    );
  }
}
