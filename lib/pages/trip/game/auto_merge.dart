import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import './game.dart' show PositionLT;
import 'package:luckyfruit/config/app.dart';

class AutoMerge extends StatefulWidget {
  // 开始的位置
  final PositionLT startPosition;
  // 结束的位置
  final PositionLT endPosition;
  final Widget child;
  // 动画结束的回调
  final Function onFinish;
  final double begin;
  final double end;
  final Duration animateTime;
  AutoMerge({
    Key key,
    this.startPosition,
    this.endPosition,
    this.child,
    this.onFinish,
    this.begin = 0,
    this.end = 1,
    this.animateTime =
        const Duration(milliseconds: AnimationConfig.AutoMergeTime),
  }) : super(key: key);

  @override
  _AutoMergeState createState() => _AutoMergeState();
}

class _AutoMergeState extends State<AutoMerge> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.animateTime, vsync: this)
      ..value = 0.0;
    // ..fling(velocity: 0.1);
    final CurvedAnimation curve =
        new CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation = new Tween(begin: widget.begin, end: widget.end).animate(curve);

    _run();
  }

  _run() async {
    await controller.forward();
    controller.dispose();
    widget?.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return _GrowTransition(
        child: widget.child,
        startPosition: widget.startPosition,
        endPosition: widget.endPosition,
        animation: animation);

    // return AnimatedBuilder(
    //   animation: animation,
    //  builder: (context, Widget child) {
    //     return _GrowTransition(animation:animation,child: widget.child,);
    //   },
    // );
  }
}

class _GrowTransition extends StatelessWidget {
  _GrowTransition(
      {this.child, this.animation, this.startPosition, this.endPosition})
      : xSpace = endPosition.left - startPosition.left,
        ySpace = endPosition.top - startPosition.top;

  final Widget child;
  final Animation<double> animation;
  // 开始的位置
  final PositionLT startPosition;
  // 结束的位置
  final PositionLT endPosition;

  final num xSpace;
  final num ySpace;

  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget child) {
          return Positioned(
              left: ScreenUtil()
                  .setWidth(startPosition.left + xSpace * animation.value),
              top: ScreenUtil()
                  .setWidth(startPosition.top + ySpace * animation.value),
              child: child);
        },
        child: child);
  }
}
