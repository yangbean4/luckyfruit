import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration timeInterval;
  final Duration animateTime;
  ShakeAnimation({
    Key key,
    this.child,
    this.timeInterval = const Duration(seconds: 10),
    this.animateTime = const Duration(milliseconds: 800),
  })  :
        // 由于动画是 往复两遍  所以 动画间隔应该大于动画时间的4倍
        assert(timeInterval > animateTime * 4),
        super(key: key);

  @override
  _ShakeAnimationState createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
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
    controller = AnimationController(duration: widget.animateTime, vsync: this)
      ..value = 0.0;
    // ..fling(velocity: 0.1);
    final CurvedAnimation curve =
        new CurvedAnimation(parent: controller, curve: _ShakeCurve());
    animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
    runAnimation();

    Timer.periodic(widget.timeInterval, (_timer) {
      if (!isDispose) {
        timer = _timer;
        // controller.value = 0.0;
        // controller?.forward();
        runAnimation();
      } else {
        timer?.cancel();
      }
    });
  }

  Future<void> runAnimation() async {
    await controller?.forward();
    await controller.reverse();
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
          builder: (BuildContext context, Widget child) {
            return new Transform.rotate(
                alignment: Alignment.center,
                angle: math.pi / 40 * (animation.value),
                child: child);
          },
          child: child),
    );
  }
}

class _ShakeCurve extends Curve {
  @override
  double transformInternal(double t) {
    final d = t * math.sin(t * math.pi * 2);
    return d;
  }
}
