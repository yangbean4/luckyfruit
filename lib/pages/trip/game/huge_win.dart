import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/gold_text.dart';
import 'package:luckyfruit/theme/public/modal_title.dart';
import 'package:luckyfruit/theme/public/secondary_text.dart';

// Huge Win奖励弹窗
class LuckyWheelWinResultWindow extends StatelessWidget {
  final int winType;

  static const TYPE_BIG_WIN = 1;
  static const TYPE_BIG_WIN_10X = 2;
  static const TYPE_MEGE_WIN = 3;
  static const TYPE_MEGE_WIN_10X = 4;
  static const TYPE_HUGE_WIN = 5;
  static const TYPE_HUGE_WIN_10X = 6;
  static const TYPE_JACKPOT_WIN = 7;
  static const TYPE_JACKPOT_WIN_10X = 8;

  LuckyWheelWinResultWindow({Key key, this.winType})
      : assert(winType > 0 && winType < 9,
            "传入的LuckyWheelWinResultWindow的type不合法：$winType"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ModalTitle("Congratulations"),
      Container(height: ScreenUtil().setWidth(45)),
      Image.asset(
        'assets/image/more_gold.png',
        width: ScreenUtil().setWidth(268),
        height: ScreenUtil().setWidth(133),
      ),
      Container(height: ScreenUtil().setWidth(66)),
      SecondaryText(
        getDescString(),
        color: MyTheme.blackColor,
      ),
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(44),
          bottom: ScreenUtil().setWidth(60),
        ),
        child: GoldText("1078.98t"),
      ),
    ]);
  }

  String getDescString() {
    String desc;
    switch (winType) {
      case TYPE_BIG_WIN:
        desc = "You've got 15min earnings";
        break;
      case TYPE_BIG_WIN:
        desc = "You've got 15min X10 earnings";
        break;
      case TYPE_MEGE_WIN:
        desc = "You've got 30min earnings";
        break;
      case TYPE_MEGE_WIN_10X:
        desc = "You've got 30min X10 earnings";
        break;
      case TYPE_HUGE_WIN:
        desc = "You've got 45min earnings";
        break;
      case TYPE_HUGE_WIN_10X:
        desc = "You've got 45min X10 earnings";
        break;
      case TYPE_JACKPOT_WIN:
        desc = "You've got 60min earnings";
        break;
      case TYPE_JACKPOT_WIN_10X:
        desc = "You've got 60min X10 earnings";
        break;
      default:
    }
    return desc;
  }
}
