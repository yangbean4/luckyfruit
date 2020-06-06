import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:luckyfruit/utils/position.dart';

typedef Widget _BuilderFun(BuildContext context,
    {Animation<double> top, Animation<double> size});

class FlyGroup extends StatefulWidget {
  final Widget child;
  // 终点位置
  final Position endPos;
  // 开始的中心点位置
  final Position startCenter;
  // 散落的半径
  final double radius;
  // start的个数
  final int count;
  final Function onFinish;
  final Duration animateTime;

  FlyGroup(
      {Key key,
      this.endPos,
      this.startCenter,
      this.animateTime = const Duration(milliseconds: 600),
      this.radius,
      this.count = 10,
      this.child,
      this.onFinish})
      : super(key: key);

  @override
  _FlyGroupState createState() => _FlyGroupState();
}

class _FlyGroupState extends State<FlyGroup> {
  List<_Star> starList;
  @override
  void initState() {
    super.initState();
    starList = List.generate(
        widget.count, (e) => _Star(widget.startCenter, widget.radius));
  }

  @override
  Widget build(BuildContext context) {
    double ex = widget.endPos.x;
    double ey = widget.endPos.y;
    return FlyAnimation(
        onFinish: widget.onFinish,
        animateTime: widget.animateTime,
        builder: (ctx, {Animation<double> top, Animation<double> size}) {
          return Stack(
              children: starList.map((_Star star) {
            double sx = star.position.x;
            double sy = star.position.y;

            return Positioned(
                left: sx + (ex - sx) * top.value,
                top: sy + (ey - sy) * top.value,
                child: Transform.scale(
                    alignment: Alignment.center,
                    scale: size.value,
                    child: widget.child));
          }).toList());
        });
  }
}

class _Star {
  // 开始的中心点位置
  final Position startCenter;
  // 散落的半径
  final double radius;

  Position position;
  _Star(this.startCenter, this.radius) {
    double x = 1 - (Random().nextInt(200) / 100) * radius + startCenter.x;
    double y = 1 - (Random().nextInt(200) / 100) * radius + startCenter.y;
    position = Position(x: x, y: y);
  }
}

class FlyAnimation extends StatefulWidget {
  final Duration animateTime;
  final _BuilderFun builder;
  final Function onFinish;

  FlyAnimation({
    Key key,
    this.animateTime = const Duration(milliseconds: 600),
    this.builder,
    this.onFinish,
  }) : super(key: key);

  @override
  _FlyAnimationState createState() => _FlyAnimationState();
}

class _FlyAnimationState extends State<FlyAnimation>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.animateTime,
      vsync: this,
    )
      ..value = 0.0
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onFinish();
        }
      });
    Future.delayed(Duration(milliseconds: 200))
        .then((value) => controller.forward());
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return _GrowTransition(controller: controller, builder: widget.builder);
  }
}

class _GrowTransition extends StatelessWidget {
  _GrowTransition({Key key, this.controller, this.builder})
      :
        // 位置
        positionTop = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 1.0, curve: Curves.easeInToLinear))),
        // 大小
        enlargeSize = Tween<double>(
          begin: 1.0,
          end: 0.5,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.8, 1.0, curve: Curves.bounceInOut))),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> enlargeSize;
  final Animation<double> positionTop;
  final _BuilderFun builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, Widget child) {
        return builder(context, top: positionTop, size: enlargeSize);
      },
    );
  }
}
