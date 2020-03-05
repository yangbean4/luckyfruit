/**
 * 这个是用了两个controller
 */
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/theme/elliptical_widget.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/config/app.dart';

const num TreeAnimationTime = AnimationConfig.TreeAnimationTime;

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
  Animation<double> treeAnimation;
  AnimationController treeAnimationController;
  Animation<double> goldAnimation;
  AnimationController goldAnimationController;
  // 控制是否显示 金币
  bool showGold = false;
  Timer timer;
  bool isDispose;
  @override
  void initState() {
    super.initState();
    isDispose = false;
    treeAnimationController = new AnimationController(
      duration: Duration(milliseconds: 1000 * TreeAnimationTime ~/ 8),
      vsync: this,
    );
    final CurvedAnimation treeCurve = new CurvedAnimation(
        parent: treeAnimationController, curve: Curves.easeIn);

    goldAnimationController = new AnimationController(
      // 树放大的时候开始动画,与树的动画时间一致
      duration: Duration(milliseconds: 1000 * TreeAnimationTime ~/ 8),
      vsync: this,
    );
    final CurvedAnimation goldCurve = new CurvedAnimation(
        parent: goldAnimationController, curve: Curves.easeIn);

    goldAnimation = new Tween(begin: 1.0, end: 0.2).animate(goldCurve)
      ..addStatusListener((status) {
        // 金币动画结束时隐藏金币
        if (status == AnimationStatus.completed) {
          setState(() {
            showGold = false;
          });
          goldAnimationController.value = 0.0;
        }
      });

    treeAnimation = new Tween(begin: 1.0, end: 1.1).animate(treeCurve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          treeAnimationController.reverse();
        }
        // 树的动画开始时显示金币且金币动画开始执行
        if (status == AnimationStatus.forward) {
          setState(() {
            showGold = true;
          });
          goldAnimationController.forward();
        } else {
          setState(() {
            showGold = false;
          });
        }
      });

    const period = const Duration(seconds: TreeAnimationTime);
    Future.delayed(Duration(seconds: Random().nextInt(TreeAnimationTime ~/ 2)))
        .then((e) {
      Timer.periodic(period, (_timer) {
        if (!isDispose) {
          timer = _timer;
          treeAnimationController?.forward();
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
    treeAnimationController.dispose();
    goldAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            child: AnimatedBuilder(
                animation: treeAnimation,
                builder: (BuildContext context, Widget child) {
                  return TreeWidget(
                    tree: widget.tree,
                    imgHeight: ScreenUtil().setWidth(140 * treeAnimation.value),
                    imgWidth: ScreenUtil().setWidth(200 * treeAnimation.value),
                    labelWidth: ScreenUtil().setWidth(60),
                    primary: true,
                  );
                }),
          ),
          showGold
              ? AnimatedBuilder(
                  animation: goldAnimation,
                  builder: (BuildContext context, Widget child) {
                    return Positioned(
                        top: ScreenUtil().setWidth(30 * goldAnimation.value),
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
                                            widget.tree.gold *
                                                TreeAnimationTime,
                                            fixed: 0),
                                    style: TextStyle(
                                      color: MyTheme.secondaryColor,
                                      fontSize: ScreenUtil().setWidth(22),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                            ],
                          ),
                        ));
                  })
              : Container(),
        ],
      ),
    );
  }
}
