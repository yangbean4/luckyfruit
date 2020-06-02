/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-28 16:31:06
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-01 19:21:15
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/utils/position.dart';
import './fly_anica.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class PhoneFlyingAnimation extends StatelessWidget {
  static Offset getPhonePositionInfoWithGlobalKey() {
    Offset offset = Offset(0, 0);
    RenderBox renderBox =
        Consts.globalKeyPhonePosition.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    print("goldPosition:localToGlobal ${offset}");
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MoneyGroup, int>(
        builder: (_, number, __) {
          Offset offset = getPhonePositionInfoWithGlobalKey();
          return number != 0
              ? Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: ScreenUtil().setWidth(1080),
                    height: ScreenUtil().setHeight(1920),
                    // color: Colors.red,
                    child: FlyGroup(
                      onFinish: () {
                        MoneyGroup moneyGroup =
                            Provider.of<MoneyGroup>(context, listen: false);
                        moneyGroup.showPhoneAnimation = 0;
                      },
                      count: number,
                      endPos: Position(
                          x: offset.dx + ScreenUtil().setWidth(50),
                          y: offset.dy + ScreenUtil().setWidth(50)),
                      startCenter: Position(
                          x: ScreenUtil().setWidth(540),
                          y: ScreenUtil().setHeight(1200)),
                      radius: ScreenUtil().setWidth(200),
                      animateTime: Duration(milliseconds: 1500),
                      child: Image.asset(
                        'assets/image/phone11.png',
                        width: ScreenUtil().setWidth(83),
                        height: ScreenUtil().setWidth(114),
                      ),
                    ),
                  ))
              : Container();
        },
        selector: (context, provider) => provider.showPhoneAnimation);
  }
}
