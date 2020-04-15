import 'dart:async';
import 'dart:math';

import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/theme/public/elliptical_widget.dart';
import 'package:luckyfruit/theme/index.dart';

class TreeItem extends StatefulWidget {
  final Tree tree;
  TreeItem(
    this.tree, {
    Key key,
  }) : super(key: key);

  @override
  _TreeItemState createState() => _TreeItemState();
}

class _TreeItemState extends State<TreeItem> with TickerProviderStateMixin {
  AnimationController controller;

  // 控制是否显示 金币
  bool showGold = false;
  Timer timer;
  bool isDispose;
  @override
  void initState() {
    super.initState();
    isDispose = false;

    controller = AnimationController(
      duration:
          Duration(milliseconds: 1000 * AnimationConfig.TreeAnimationTime ~/ 8),
      vsync: this,
    );
    const period =
        Duration(milliseconds: 1000 ~/ AnimationConfig.TreeAnimationTime);
    Future.delayed(Duration(
            seconds: Random().nextInt(AnimationConfig.TreeAnimationTime ~/ 2)))
        .then((e) {
      Timer.periodic(period, (_timer) {
        if (!isDispose) {
          timer = _timer;
          controller.forward();
        } else {
          timer?.cancel();
        }
      });
    });
  }

  @override
  dispose() {
    isDispose = true;
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  // Future<void> runAction() async {
  //   await controller.forward().orCancel;
  //   // try {
  //   //   await controller.forward().orCancel;
  //   // } catch (e){

  //   // }
  //   // on TickerCanceled {
  //   //   print('1233');
  //   //   // the animation got canceled, probably because we were disposed
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return TreeAnimation(controller: controller, tree: widget.tree);
  }
}

class TreeAnimation extends StatelessWidget {
  TreeAnimation({Key key, this.controller, this.tree})
      // 放大树
      : enlargeSize = Tween<double>(
          begin: 1.0,
          end: 1.1,
        ).animate(CurvedAnimation(
            parent: controller, curve: Interval(0.0, 0.5, curve: Curves.ease))),
        // 金币的位置
        positionTop = Tween<double>(
          begin: 1.0,
          end: 0.2,
        ).animate(CurvedAnimation(
            parent: controller, curve: Interval(0.1, 0.5, curve: Curves.ease))),
        // // 金币淡入
        // fadeIn = Tween<double>(
        //   begin: 0.0,
        //   end: 1.0,
        // ).animate(CurvedAnimation(
        //     parent: controller, curve: Interval(0.0, 0.1, curve: Curves.ease))),
        // // 金币淡入
        // fadeOut = Tween<double>(
        //   begin: 1.0,
        //   end: 0.0,
        // ).animate(CurvedAnimation(
        //     parent: controller, curve: Interval(0.5, 0.6, curve: Curves.ease))),
        // // 缩小树
        // narrowSize = Tween<double>(
        //   begin: 1.0,
        //   end: 1.1,
        // ).animate(CurvedAnimation(
        //     parent: controller, curve: Interval(0.5, 0.0, curve: Curves.ease))),
        super(key: key);
  final Tree tree;
  final Animation<double> controller;
  final Animation<double> enlargeSize;
  final Animation<double> positionTop;

  // final Animation<double> narrowSize;
  // final Animation<double> fadeIn;
  // final Animation<double> fadeOut;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setWidth(240),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
              bottom: 0,
              left: ScreenUtil().setWidth(50),
              child: EllipticalWidget(
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setWidth(50),
                // color: MyTheme.darkGrayColor,
              )),
          Positioned(
              bottom: ScreenUtil().setWidth(10),
              child: TreeWidget(
                tree: tree,
                imgHeight: ScreenUtil().setWidth(168 * enlargeSize.value),
                imgWidth: ScreenUtil().setWidth(240 * enlargeSize.value),
                labelWidth: ScreenUtil().setWidth(60),
                primary: true,
              )),
          Positioned(
              top: ScreenUtil().setWidth(40 * positionTop.value),
              child: Container(
                width: ScreenUtil().setWidth(200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/image/gold.png',
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(40),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          left: ScreenUtil().setWidth(12),
                        ),
                        child: Text(
                          '+' +
                              Util.formatNumber(
                                  tree.gold * AnimationConfig.TreeAnimationTime,
                                  fixed: 0),
                          style: TextStyle(
                            color: MyTheme.secondaryColor,
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: _buildAnimation,
    );
  }
}
