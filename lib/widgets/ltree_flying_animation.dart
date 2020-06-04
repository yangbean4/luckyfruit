/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-28 16:31:06
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-04 17:19:20
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/utils/position.dart';
import './fly_anica.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class TreeFlyingAnimation extends StatelessWidget {
  static Offset getPhonePositionInfoWithGlobalKey(GlobalKey globalKey) {
    Offset offset = Offset(0, 0);
    RenderBox renderBox = globalKey.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    return offset;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TreeGroup, Tree>(
        builder: (_, tree, __) {
          Offset offset;

          if (tree == null || tree?.x == null || tree?.y == null) {
            offset =
                getPhonePositionInfoWithGlobalKey(Consts.globalKeyWarehouse);
          } else {
            offset = getPhonePositionInfoWithGlobalKey(
                Consts.treeGroupGlobalKey[tree.y][tree.x]);
          }
          return tree != null
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
                        if (tree.x == null || tree.y == null) {
                          treeGroup.inWarehouse(tree);
                        } else {
                          treeGroup.addTree(tree: tree);
                        }
                        treeGroup.flowerMakeTree = null;
                      },
                      count: 1,
                      endPos: Position(
                          x: offset.dx + ScreenUtil().setWidth(50),
                          y: offset.dy + ScreenUtil().setWidth(50)),
                      startCenter: Position(
                          x: ScreenUtil().setWidth(540),
                          y: ScreenUtil().setHeight(1000)),
                      radius: ScreenUtil().setWidth(200),
                      animateTime: Duration(milliseconds: 1500),
                      child: Image.asset(
                        'assets/tree/bonus.png',
                        width: ScreenUtil().setWidth(136),
                        height: ScreenUtil().setWidth(105),
                      ),
                    ),
                  ))
              : Container();
        },
        selector: (context, provider) => provider.flowerMakeTree);
  }
}
