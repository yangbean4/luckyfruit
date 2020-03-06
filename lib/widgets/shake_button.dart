import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class ShakeButton extends StatefulWidget {
  final Widget child;
  ShakeButton({Key key, this.child}) : super(key: key);

  @override
  _ShakeButtonState createState() => _ShakeButtonState();
}

class _ShakeButtonState extends State<ShakeButton>
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
        new CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

    const period = const Duration(seconds: 10);
    Timer.periodic(period, (_timer) {
      if (!isDispose) {
        timer = _timer;
        // controller.value = 0.0;
        // controller?.forward();
        runAnimation();
      } else {
        timer?.cancel();
      }
    });
    // controller?.forward();
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
            return new Transform.rotate(
                alignment: Alignment.center,
                angle: math.pi / 40 * (animation.value),
                child: child);
          },
          child: child),
    );
  }
}

class ShakeCurve extends Curve {
  @override
  double transformInternal(double t) {
    final d = t * math.sin(t * math.pi * 2);
    return d;
  }
}
