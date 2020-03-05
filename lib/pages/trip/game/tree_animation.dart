import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/theme/elliptical_widget.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/config/app.dart';

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
                color: MyTheme.darkGrayColor,
              )),
          Positioned(
              bottom: ScreenUtil().setWidth(10),
              child: TreeWidget(
                tree: tree,
                imgHeight: ScreenUtil().setWidth(140 * enlargeSize.value),
                imgWidth: ScreenUtil().setWidth(200 * enlargeSize.value),
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
                            fontSize: ScreenUtil().setWidth(22),
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
