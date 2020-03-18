import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/modal_title.dart';
import 'package:luckyfruit/theme/public/secondary_text.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';

// 5倍或10倍奖励弹窗
class TimesRewardWidget extends StatelessWidget {
  final Function onOk;
  final Function onCancel;
  final int typeOfTimes;

  static const TYPE_5_TIMES = 1;
  static const TYPE_10_TIMES = 2;

  TimesRewardWidget({Key key, this.typeOfTimes, this.onOk, this.onCancel})
        // : assert(typeOfTimes > 0 && typeOfTimes < 3,"传入的TimesRewardWidget的type不合法：$typeOfTimes"),
        :super(key: key);


  @override
  Widget build(BuildContext context) {
    String title;
    String imageUrl;

    if (typeOfTimes == TYPE_10_TIMES) {
      title = "10x Treasure Chest";
      imageUrl = "assets/image/lucky_wheel_10x_treasure.png";
    } else {
      title = "5x Treasure Chest";
      imageUrl = "assets/image/lucky_wheel_5x_treasure.png";
    }

    return Column(children: [
      ModalTitle(title),
      Container(height: ScreenUtil().setWidth(24)),
      Image.asset(
        imageUrl,
        width: ScreenUtil().setWidth(295),
        height: ScreenUtil().setWidth(243),
      ),
      Container(height: ScreenUtil().setWidth(60)),
      SecondaryText(
        "Get rich, next time the reward will be ten times!",
        color: MyTheme.blackColor,
      ),
      Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setWidth(60),
          ),
          child: AdButton(
            btnText: 'Get it',
            onCancel: () {
              onCancel();
            },
            onOk: () {
              onOk();
            },
            tips: null,
          )),
    ]);
  }
}
