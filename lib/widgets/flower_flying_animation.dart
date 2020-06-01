/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-29 19:35:46
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-01 15:47:19
 */

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/utils/position.dart';
import './fly_anica.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FlowerFlyingAnimation extends StatelessWidget {
  static Offset getPhonePositionInfoWithGlobalKey(GlobalKey globalKey) {
    Offset offset = Offset(0, 0);
    RenderBox renderBox = globalKey.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TreeGroup, Tuple2<TreePoint, int>>(
        builder: (_, data, __) {
          TreePoint flowerPoint = data.item1;

          int number = data.item2;
          Offset offsetSt;
          Offset offsetEnd =
              getPhonePositionInfoWithGlobalKey(Consts.globalKeyFlowerPosition);

          if (flowerPoint != null) {
            offsetSt = getPhonePositionInfoWithGlobalKey(
                Consts.treeGroupGlobalKey[flowerPoint.y][flowerPoint.x]);
            // );
          }

          return number != 0 && flowerPoint != null
              ? Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    width: ScreenUtil().setWidth(1080),
                    height: ScreenUtil().setHeight(1920),
                    // color: Colors.red,
                    child: FlyGroup(
                      onFinish: () {
                        TreeGroup moneyGroup =
                            Provider.of<TreeGroup>(context, listen: false);
                        moneyGroup.flowerPoint = null;
                      },
                      count: number,
                      endPos: Position(
                          x: offsetEnd.dx + ScreenUtil().setWidth(40),
                          y: offsetEnd.dy + ScreenUtil().setWidth(40)),
                      startCenter: Position(
                          x: offsetSt.dx + ScreenUtil().setWidth(180),
                          y: offsetSt.dy + ScreenUtil().setWidth(180)),
                      radius: ScreenUtil().setWidth(20),
                      animateTime: Duration(milliseconds: 1500),
                      child: Image.asset(
                        'assets/image/flower/img_flower.png',
                        width: ScreenUtil().setWidth(40),
                        height: ScreenUtil().setWidth(41),
                      ),
                    ),
                  ))
              : Container();
        },
        selector: (context, provider) =>
            Tuple2(provider.flowerPoint, provider.animationUseflower));
  }
}
