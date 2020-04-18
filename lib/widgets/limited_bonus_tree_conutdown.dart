import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/count_down.dart';
import 'package:luckyfruit/widgets/layer.dart';

class LimitedBonusTreeConutdownWidget extends StatelessWidget {
  final Tree tree;

  LimitedBonusTreeConutdownWidget(this.tree);

  @override
  Widget build(BuildContext context) {
    return CountdownFormatted(
        duration: Duration(seconds: tree.duration),
        onFinish: () {
          print("限时分红树倒计时完成");
          Layer.limitedTimeBonusTreeEndUp(tree);
        },
        builder: (context, Duration duration) {
          print("限时分红树倒计时: ${duration.inSeconds}");

          tree.duration = duration.inSeconds;
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFF6AD66A),
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil().setWidth(12)),
              ),
            ),
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(8),
                horizontal: ScreenUtil().setWidth(14)),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/image/icon_bonus_tree_count_down.png',
                  width: ScreenUtil().setWidth(27),
                  height: ScreenUtil().setWidth(30),
                ),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Text(
                  Util.formatCountDownTimer(duration),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      height: 1,
                      fontFamily: FontFamily.semibold,
                      fontSize: ScreenUtil().setSp(28),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        });
  }
}
