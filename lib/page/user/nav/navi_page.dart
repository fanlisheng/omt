import 'package:fluent_ui/fluent_ui.dart';
import 'package:kayo_package/kayo_package.dart';
import 'package:omt/page/user/nav/navi_view_model.dart';
import 'package:omt/utils/color_utils.dart';

///
///  omt
///  navi_page.dart
///  导航页
///
///  Created by kayoxu on 2024-04-09 at 10:04:18
///  Copyright © 2024 .. All rights reserved.
///

class NaviPage extends StatelessWidget {
  const NaviPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<NaviViewModel>(
        model: NaviViewModel(),
        autoLoadData: true,
        builder: (context, model, child) {
          var width = BaseSysUtils.getWidth(context);
          var height = BaseSysUtils.getHeight(context);
          var blurW = width / 4 * 2;
          var blurH = height / 4 * 2;

          var gridCount = 3;

          var cardHeight = height / 3 * 2 / gridCount;
          var cardWidth = width / 3 * 2 / gridCount;

          var cardTextSize = 100.0;

          int cardTextMaxLength = 4;
          var ups = model.userInfoData?.userPermissions ?? [];
          if (!BaseSysUtils.empty(ups)) {
            for (var u in ups) {
              var l = (u.name ?? '').length;
              if (l > cardTextMaxLength) {
                cardTextMaxLength = l;
              }
            }
          }

          var cw = cardWidth / (cardTextMaxLength + 2);
          if (cardTextSize > cw) {
            cardTextSize = cw;
          }

          var child = Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: cardHeight * gridCount,
              width: cardWidth * gridCount,
              // color: ColorUtils.colorYellow,
              child: GridView.count(
                  crossAxisCount: gridCount,
                  crossAxisSpacing: cardWidth / 10,
                  mainAxisSpacing: cardWidth / 10,
                  children: (ups).map((e) {
                    return CardView(
                        radius: cardWidth / 20,
                        shadowRadius: cardWidth / 20,
                        bgColors: [
                          BaseSysUtils.randomColor().dark,
                          ColorUtils.colorAccent.dark
                        ],
                        colorAlignmentBegin: Alignment.topLeft,
                        colorAlignmentEnd: Alignment.bottomRight,
                        elevation: 0,
                        onPressed: () {
                       model.onTapItem(e);
                        },
                        child: TextView(
                          e.name,
                          color: ColorUtils.colorWhite.dark,
                          size: cardTextSize,
                          textAlign: TextAlign.center,
                          alignment: Alignment.center,
                        ));
                  }).toList()),
            ),
          );

          return Stack(alignment: Alignment.center, children: [
            Positioned(
                top: blurH / 4,
                left: 0,
                child: Container(
                  height: blurH,
                  width: blurW,
                  color: ColorUtils.colorRed.withOpacity(.5),
                )),
            Container(
              height: blurW * 3 / 2,
              width: blurW / 3,
              color: ColorUtils.colorYellow,
            ),
            Positioned(
                bottom: blurH / 4,
                right: 0,
                child: Container(
                  height: blurH,
                  width: blurW,
                  color: ColorUtils.colorAccent.withOpacity(.9),
                )),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(.5),
                child: Acrylic(
                  blurAmount: blurW / 5 * 2,
                  // elevation:1110,
                  luminosityAlpha: .9,
                  child: child,
                ),
              ),
            ),
          ]);
        });
  }
}
