/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-29 19:26:46
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-04 20:58:10
 */
import 'package:flutter/material.dart';

class ExpandAnimation extends StatefulWidget {
  final Widget child;
  final Duration animateTime;
  final void Function() onFinish;
  final int count;
  ExpandAnimation({
    Key key,
    this.child,
    this.animateTime = const Duration(milliseconds: 200),
    this.onFinish,
    this.count = 0,
  }) : super(key: key);

  @override
  __ExpandAnimationState createState() => __ExpandAnimationState();
}

class __ExpandAnimationState extends State<ExpandAnimation>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.animateTime, vsync: this)
      ..value = 0.0;
    final CurvedAnimation curve =
        new CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation = new Tween(begin: 0.8, end: 1.1).animate(curve);
    runAnimation();
  }

  Future<void> runAnimation() async {
    int _count = widget.count;
    while (_count-- != 0) {
      await controller?.forward();
      if (_count == widget.count - 1 && widget.onFinish != null) {
        widget.onFinish();
      }
      await controller?.reverse();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GrowTransition(child: widget.child, animation: animation);
  }
}

class _GrowTransition extends StatelessWidget {
  _GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return new Center(
      child: new AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget _) {
          return Transform.scale(scale: animation?.value ?? 0, child: child);
        },
      ),
    );
  }
}
