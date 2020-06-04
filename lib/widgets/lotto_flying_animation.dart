/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-28 16:31:06
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-04 15:01:57
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/utils/position.dart';
import './fly_anica.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class LottoFlyingAnimation extends StatelessWidget {
  static Offset getPhonePositionInfoWithGlobalKey() {
    Offset offset = Offset(0, 0);
    RenderBox renderBox =
        Consts.globalKeyLottoBtn.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    print("goldPosition:localToGlobal ${offset}");
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TreeGroup, int>(
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
                        TreeGroup treeGroup =
                            Provider.of<TreeGroup>(context, listen: false);
                        treeGroup.lottoAnimationNumber = 0;
                      },
                      count: number,
                      endPos: Position(
                          x: offset.dx + ScreenUtil().setWidth(50),
                          y: offset.dy + ScreenUtil().setWidth(50)),
                      startCenter: Position(
                          x: ScreenUtil().setWidth(540),
                          y: ScreenUtil().setHeight(1000)),
                      radius: ScreenUtil().setWidth(200),
                      animateTime: Duration(milliseconds: 1500),
                      child: Image.asset(
                        'assets/image/lotto_tickets_icon.png',
                        width: ScreenUtil().setWidth(136),
                        height: ScreenUtil().setWidth(105),
                      ),
                    ),
                  ))
              : Container();
        },
        selector: (context, provider) => provider.lottoAnimationNumber);
  }
}
