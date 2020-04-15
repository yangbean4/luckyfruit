import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/pages/trip/other/fly_animation.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:provider/provider.dart';

import 'money_num_fade.dart';

class MoneyFlyingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Selector<MoneyGroup, bool>(
          builder: (_, show, __) {
            return show
                ? Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: ScreenUtil().setWidth(1080),
                      height: ScreenUtil().setWidth(1300),
                      // color: Colors.red,
                      child: FlyGroup(
                        onFinish: () {
                          MoneyGroup moneyGroup =
                              Provider.of<MoneyGroup>(context, listen: false);
                          moneyGroup.setShowDollarImgTrans = false;
                          moneyGroup.setShowDollarAmountFading = true;
                        },
                        count: 20,
                        endPos: Position(
                            x: ScreenUtil().setWidth(80),
                            y: ScreenUtil().setWidth(50)),
                        startCenter: Position(
                            x: ScreenUtil().setWidth(540),
                            y: ScreenUtil().setWidth(600)),
                        radius: ScreenUtil().setWidth(200),
                        animateTime: Duration(milliseconds: 1500),
                        child: Image.asset(
                          'assets/image/bg_dollar.png',
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setWidth(100),
                        ),
                        type: PositionType.Type_Bottom,
                      ),
                    ))
                : Container();
          },
          selector: (context, provider) => provider.showDollarImgTrans),
      Selector<MoneyGroup, bool>(
          builder: (_, show, __) {
            return show ? MoneyAmountFadingWidget() : Container();
          },
          selector: (context, provider) => provider.showDollarAmountFading),
    ]);
  }
}