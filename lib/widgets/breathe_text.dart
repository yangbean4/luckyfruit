import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:luckyfruit/config/app.dart';

class BreatheText extends StatefulWidget {
  final Widget child;
  BreatheText({Key key, this.child}) : super(key: key);

  @override
  _BreatheTextState createState() => _BreatheTextState();
}

class _BreatheTextState extends State<BreatheText>
    with TickerProviderStateMixin {
  AnimationController controller;
  Timer timer;
  bool isDispose;
  int _milliseconds = 800;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    isDispose = false;
    controller = AnimationController(
        duration: Duration(milliseconds: _milliseconds), vsync: this)
      ..value = 0.0;
    // ..fling(velocity: 0.1);
    final CurvedAnimation curve =
        new CurvedAnimation(parent: controller, curve: Curves.bounceIn);

    animation = new Tween(begin: 1.0, end: 1.1).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

    const period = const Duration(seconds: AnimationConfig.TreeAnimationTime);
    Timer.periodic(period, (_timer) {
      if (!isDispose) {
        timer = _timer;
        runAnimation();
      } else {
        timer?.cancel();
      }
    });
  }

  Future<void> runAnimation() async {
    await controller?.forward();
    await controller.reverse();
  }

  @override
  void dispose() {
    isDispose = true;
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GrowTransition(child: widget.child, animation: animation);
  }
}

class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return new Center(
      child: new AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return new Transform.scale(
                alignment: Alignment.center,
                scale: animation.value,
                child: child);
          },
          child: child),
    );
  }
}
