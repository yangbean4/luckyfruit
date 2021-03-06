import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/pages/trip/other/fly_animation.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class LottoGoldFlyingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<MoneyGroup, bool>(
        builder: (_, show, __) {
          Offset offset = Util.getTripIconInfoWithGlobalKey();
          return show
              ? Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: ScreenUtil().setWidth(1080),
                    height: ScreenUtil().setHeight(1920),
//                     color: Colors.red,
                    child: FlyGroup(
                      onFinish: () {
                        MoneyGroup moneyGroup =
                            Provider.of<MoneyGroup>(context, listen: false);
                        moneyGroup.hideGoldAnimation();
                      },
                      count: 20,
                      endPos: Position(
                          x: offset?.dx ?? 0,
                          y: offset?.dy ?? ScreenUtil().setWidth(1920)),
                      startCenter: Position(
                          x: ScreenUtil().setWidth(540),
                          y: ScreenUtil().setHeight(600)),
                      radius: ScreenUtil().setWidth(200),
                      animateTime: Duration(milliseconds: 1500),
                      child: Image.asset(
                        'assets/image/gold.png',
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setWidth(120),
                      ),
                      type: PositionType.Type_Top,
                    ),
                  ))
              : Container();
        },
        selector: (context, provider) => provider.showLottoGoldAnimation);
  }
}
