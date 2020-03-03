import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/theme/elliptical_widget.dart';
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

class _TreeItemState extends State<TreeItem>
    with SingleTickerProviderStateMixin {
  Animation<double> treeAnimation;
  AnimationController treeAnimationController;
  Timer timer;
  @override
  void initState() {
    super.initState();
    treeAnimationController = new AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    final CurvedAnimation curve = new CurvedAnimation(
        parent: treeAnimationController, curve: Curves.easeIn);
    treeAnimation = new Tween(begin: 1.0, end: 1.1).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          treeAnimationController.reverse();
        }
      });

    const period = const Duration(seconds: 3);
    Timer.periodic(period, (_timer) {
      timer = _timer;
      treeAnimationController?.forward();
    });
  }

  @override
  dispose() {
    timer.cancel();
    treeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setWidth(205),
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
          )
        ],
      ),
    );
  }
}
