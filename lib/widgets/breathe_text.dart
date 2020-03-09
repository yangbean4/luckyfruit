import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:luckyfruit/config/app.dart';

class BreatheAnimation extends StatefulWidget {
  final Widget child;
  //
  final double begin;
  final double end;
  final Duration timeInterval;
  final Duration animateTime;
  BreatheAnimation({
    Key key,
    this.child,
    this.begin = 1.0,
    this.end = 1.1,
    this.timeInterval = const Duration(
        milliseconds: 1000 * AnimationConfig.TreeAnimationTime ~/ 5),
    this.animateTime = const Duration(milliseconds: 600),
  }) : super(key: key);

  @override
  _BreatheAnimationState createState() => _BreatheAnimationState();
}

class _BreatheAnimationState extends State<BreatheAnimation>
    with TickerProviderStateMixin {
  AnimationController controller;
  Timer timer;
  bool isDispose;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    isDispose = false;
    controller = AnimationController(duration: widget.animateTime, vsync: this)
      ..value = 0.0;
    // ..fling(velocity: 0.1);
    final CurvedAnimation curve =
        new CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    animation = new Tween(begin: widget.begin, end: widget.end).animate(curve);
    Timer.periodic(widget.timeInterval, (_timer) {
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
