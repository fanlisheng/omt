import 'package:flutter/widgets.dart';
import 'package:kayo_package/views/widget/base/clickable.dart';

import '../../utils/color_utils.dart';
import '../../utils/intent_utils.dart';


class DNavigationView extends StatelessWidget {
  final String title;
  final String titlePass;

  const DNavigationView({
    super.key,
    required this.title,
    required this.titlePass,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Clickable(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: ColorUtils.colorGreen,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),

            child: const Text(
              "返回",
              style: TextStyle(fontSize: 12, color: ColorUtils.colorGreen),
            ),
          ),
          onTap: () {
            IntentUtils.share.pop(context);
          },
        ),
        const SizedBox(width: 12),
        Text(
          titlePass,
          style: TextStyle(
            fontSize: 12,
            color: ColorUtils.colorWhite.withOpacity(0.5),
          ),
        ),
        Text(title,
            style:
            const TextStyle(fontSize: 12, color: ColorUtils.colorWhite))
      ],
    );
  }
}