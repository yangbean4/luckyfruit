/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-29 19:26:46
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-03 15:25:33
 */
import 'package:flutter/material.dart';

class OpacityAnimation extends StatefulWidget {
  final Widget child;
  final Duration animateTime;
  final void Function() onFinish;
  final void Function() onForwardFinish;

  OpacityAnimation({
    Key key,
    this.child,
    this.animateTime = const Duration(milliseconds: 200),
    this.onFinish,
    this.onForwardFinish,
  }) : super(key: key);

  @override
  __OpacityAnimationState createState() => __OpacityAnimationState();
}

class __OpacityAnimationState extends State<OpacityAnimation>
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

    animation = new Tween(begin: 0.0, end: 1.0).animate(curve);
    runAnimation();
  }

  Future<void> runAnimation() async {
    await controller?.forward();
    if (widget.onForwardFinish != null) {
      widget.onForwardFinish();
    }
    await controller.reverse();
    if (widget.onFinish != null) {
      widget.onFinish();
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
          print('-------------------${animation.value}');
          return Opacity(opacity: animation.value, child: child);
        },
      ),
    );
  }
}
