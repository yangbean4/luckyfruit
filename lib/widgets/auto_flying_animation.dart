/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-28 16:31:06
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-12 18:37:52
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/utils/position.dart';
import './fly_anica.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class AutoFlyingAnimation extends StatelessWidget {
  static Offset getPhonePositionInfoWithGlobalKey() {
    Offset offset = Offset(0, 0);
    RenderBox renderBox =
        Consts.globalKeyAutoMergeArea.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LuckyGroup, int>(
        builder: (_, number, __) {
          Offset ofStart;

          Offset offset = getPhonePositionInfoWithGlobalKey();
          if (number != 0) {
            ofStart = Util.getOffset(Consts.globalKeyAutoMergeSpin);
          }
          return number != 0
              ? Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: ScreenUtil().setWidth(1080),
                    height: ScreenUtil().setHeight(1920),
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    child: FlyGroup(
                      onFinish: () {
                        LuckyGroup luckyGroup =
                            Provider.of<LuckyGroup>(context, listen: false);
                        luckyGroup.autoStart();
                      },
                      count: 1,
                      endPos: Position(
                          x: offset?.dx ?? 0 + ScreenUtil().setWidth(100),
                          y: offset?.dy ?? 0 + ScreenUtil().setWidth(100)),
                      startCenter: Position(
                          x: ofStart.dx + ScreenUtil().setWidth(10),
                          y: ofStart.dy + ScreenUtil().setHeight(10)),
                      radius: ScreenUtil().setWidth(50),
                      animateTime: Duration(milliseconds: 1200),
                      child: Image.asset(
                        'assets/image/spin_auto.png',
                        width: ScreenUtil().setWidth(136),
                        height: ScreenUtil().setWidth(105),
                      ),
                    ),
                  ))
              : Container();
        },
        selector: (context, provider) =>
            provider.autoMergeDurationFromLuckyWheel);
  }
}
