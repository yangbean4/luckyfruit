import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/gold_text.dart';
import 'package:luckyfruit/theme/public/modal_title.dart';
import 'package:luckyfruit/utils/index.dart';

// Huge Win奖励弹窗
class LuckyWheelWinResultWindow extends StatelessWidget {
  final int winType;
  final num coinNum;

  static const TYPE_BIG_WIN = 1;
  static const TYPE_BIG_WIN_5X = 2;
  static const TYPE_BIG_WIN_10X = 3;
  static const TYPE_MEGE_WIN = 4;
  static const TYPE_MEGE_WIN_5X = 5;
  static const TYPE_MEGE_WIN_10X = 6;
  static const TYPE_HUGE_WIN = 7;
  static const TYPE_HUGE_WIN_5X = 8;
  static const TYPE_HUGE_WIN_10X = 9;
  static const TYPE_JACKPOT_WIN = 10;
  static const TYPE_JACKPOT_WIN_5X = 11;
  static const TYPE_JACKPOT_WIN_10X = 12;

  LuckyWheelWinResultWindow({Key key, this.winType, this.coinNum})
      : assert(winType > 0 && winType < 13,
            "传入的LuckyWheelWinResultWindow的type不合法：$winType"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ModalTitle("Awesome"),
      Container(height: ScreenUtil().setWidth(40)),
      Image.asset(
        'assets/image/coin_full_bag.png',
        width: ScreenUtil().setWidth(268),
        height: ScreenUtil().setWidth(133),
      ),
      Container(height: ScreenUtil().setWidth(15)),
      RichText(
        text: TextSpan(
          text: "You've got",
          style: TextStyle(
              fontSize: ScreenUtil().setSp(50),
              color: MyTheme.blackColor,
              fontFamily: FontFamily.regular,
              fontWeight: FontWeight.w400),
          children: <TextSpan>[
            TextSpan(
                text: getDescString(),
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    fontFamily: FontFamily.regular,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFAC1E))),
            TextSpan(
                text: 'earnings',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(50),
                    color: MyTheme.blackColor,
                    fontFamily: FontFamily.regular,
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(38),
          bottom: ScreenUtil().setWidth(45),
        ),
        child: GoldText(
          Util.formatNumber(coinNum),
          textSize: 66,
          iconSize: 72,
        ),
      ),
    ]);
  }

  String getDescString() {
    String desc;
    switch (winType) {
      case TYPE_BIG_WIN:
        desc = " 15min ";
        break;
      case TYPE_BIG_WIN_5X:
        desc = " 5X15min ";
        break;
      case TYPE_BIG_WIN_10X:
        desc = " 10X15min ";
        break;
      case TYPE_MEGE_WIN:
        desc = " 30min ";
        break;
      case TYPE_MEGE_WIN_5X:
        desc = " 5X30min ";
        break;
      case TYPE_MEGE_WIN_10X:
        desc = " 10X30min ";
        break;
      case TYPE_HUGE_WIN:
        desc = " 45min ";
        break;
      case TYPE_HUGE_WIN_5X:
        desc = " 5X45min ";
        break;
      case TYPE_HUGE_WIN_10X:
        desc = " 10X45min ";
        break;
      case TYPE_JACKPOT_WIN:
        desc = " 60min ";
        break;
      case TYPE_JACKPOT_WIN_5X:
        desc = " 5X60min ";
        break;
      case TYPE_JACKPOT_WIN_10X:
        desc = " 10X60min ";
        break;
      default:
    }
    return desc;
  }
}
