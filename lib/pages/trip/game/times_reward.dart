import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/userInfo.dart';
import 'package:luckyfruit/provider/user_model.dart';

import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/secondary_text.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:provider/provider.dart';

// 5倍或10倍奖励弹窗
class TimesRewardWidget extends StatelessWidget {
  final Function onOk;
  final Function onCancel;
  final int typeOfTimes;

  static const TYPE_5_TIMES = 1;
  static const TYPE_10_TIMES = 2;

  TimesRewardWidget({Key key, this.typeOfTimes, this.onOk, this.onCancel})
      // : assert(typeOfTimes > 0 && typeOfTimes < 3,"传入的TimesRewardWidget的type不合法：$typeOfTimes"),
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    String imageUrl;
    String desc;

    if (typeOfTimes == TYPE_10_TIMES) {
      title = "10x";
      imageUrl = "assets/image/lucky_wheel_10x_treasure.png";
      desc = "Keep it going!\n10X Rwards next turn";
    } else {
      title = "5x";
      imageUrl = "assets/image/lucky_wheel_5x_treasure.png";
      desc = "Keep it going!\n5X Rwards next turn";
    }

    return Column(children: [
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                text: title,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(70),
                    fontFamily: FontFamily.bold,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFAC1E))),
            TextSpan(
                text: ' Reward',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(70),
                    color: MyTheme.blackColor,
                    fontFamily: FontFamily.bold,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      Container(height: ScreenUtil().setWidth(24)),
      Image.asset(
        imageUrl,
        width: ScreenUtil().setWidth(295),
        height: ScreenUtil().setWidth(243),
      ),
      Container(height: ScreenUtil().setWidth(24)),
      Text(
        desc,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: ScreenUtil().setWidth(46),
          fontFamily: FontFamily.regular,
          color: MyTheme.blackColor,
        ),
      ),
      Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(45),
          ),
          child: Selector<UserModel, UserInfo>(
              selector: (context, provider) => provider.userInfo,
              builder: (_, UserInfo userInfo, __) {
                return AdButton(
                  ad_code: '213',
                  adUnitIdFlag: 2,
                  btnText: 'Got it',
                  adIconPath: "assets/image/ad_icon_white.png",
                  colorsOnBtn: <Color>[
                    Color(0xffF1D34E),
                    Color(0xffF59A22),
                  ],
                  onCancel: () {
                    onCancel();
                  },
                  onOk: () {
                    onOk();
                  },
                  tips:
                      "Number of videos reset at 12am&12pm (${userInfo.ad_times} times left)",
                );
              })),
    ]);
  }
}
