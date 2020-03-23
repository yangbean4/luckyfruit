import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:luckyfruit/config/app.dart';

class AlightingAnimation extends StatefulWidget {
  final Widget child;
  //
  final double begin;
  final double end;
  final Duration animateTime;
  final Widget Function(BuildContext context, Animation<double> remaining)
      builder;

  AlightingAnimation({
    Key key,
    this.child,
    this.begin = 0,
    this.end = 1,
    this.animateTime =
        const Duration(milliseconds: AnimationConfig.AlightingTime * 1000),
    this.builder,
  }) : super(key: key);

  @override
  _AlightingAnimationState createState() => _AlightingAnimationState();
}

class _AlightingAnimationState extends State<AlightingAnimation>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  Timer timer;
  bool isDispose;

  @override
  void initState() {
    super.initState();
    isDispose = false;
    controller = AnimationController(duration: widget.animateTime, vsync: this)
      ..value = 0.0;
    // ..fling(velocity: 0.1);
    final CurvedAnimation curve =
        new CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation = new Tween(begin: widget.begin, end: widget.end).animate(curve);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return GrowTransition(
    //     child: widget.child, animation: animation, left: widget.left);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, Widget child) {
        return widget.builder(context, animation);
      },
    );
  }
}

// class GrowTransition extends StatelessWidget {
//   GrowTransition({this.child, this.animation, this.left});

//   final Widget child;
//   final Animation<double> animation;
//   final num left;

//   Widget build(BuildContext context) {
//     return new Center(
//       child: new AnimatedBuilder(
//           animation: animation,
//           builder: (BuildContext context, Widget child) {
//             return new Transform.scale(
//                 alignment: Alignment.center,
//                 scale: animation.value,
//                 child: child);
//           },
//           child: child),
//     );
//   }
// }
