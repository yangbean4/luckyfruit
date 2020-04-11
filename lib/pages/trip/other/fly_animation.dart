import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

typedef Widget _BuilderFun(BuildContext context,
    {Animation<double> top, Animation<double> size, Animation<double> axis});

class Position {
  double x;
  double y;
  Position({this.x, this.y});
}

enum PositionType { Type_Top, Type_Bottom }

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
  final PositionType type;

  FlyGroup(
      {Key key,
      this.endPos,
      this.startCenter,
      this.animateTime = const Duration(milliseconds: 600),
      this.radius,
      this.count = 10,
      this.child,
      this.type,
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

  Widget getPositionedWidgetWithType(
      double horizontal, double vertical, Widget child) {
    if (widget.type == PositionType.Type_Bottom) {
      return Positioned(right: horizontal, bottom: vertical, child: child);
    } else {
      return Positioned(left: horizontal, top: vertical, child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    double ex = widget.endPos.x;
    double ey = widget.endPos.y;
    return FlyAnimation(
        onFinish: widget.onFinish,
        animateTime: widget.animateTime,
        builder: (ctx,
            {Animation<double> top,
            Animation<double> size,
            Animation<double> axis}) {
          return Stack(
              children: starList.map((_Star star) {
            double sx = (star.position.x - widget.startCenter.x) * axis.value +
                widget.startCenter.x;
            double sy = (star.position.y - widget.startCenter.y) * axis.value +
                widget.startCenter.y;

            Widget child = Transform.scale(
                alignment: Alignment.center,
                scale: size.value,
                child: widget.child);

            double horizontal = sx + (ex - sx) * top.value;
            double vertical = sy + (ey - sy) * top.value;
            return getPositionedWidgetWithType(horizontal, vertical, child);
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
    double x = (1 - (Random().nextInt(200) / 100)) * radius + startCenter.x;
    double y = (1 - (Random().nextInt(200) / 100)) * radius + startCenter.y;
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
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onFinish();
        }
      });
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
            curve: Interval(0.2, 1.0, curve: Curves.easeInToLinear))),
        // 大小
        enlargeSize = Tween<double>(
          begin: 1.0,
          end: 0.4,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.6, 1.0, curve: Curves.bounceInOut))),
        positionAxis = Tween<double>(
          begin: 1.0,
          end: 1.8,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.2, curve: Curves.easeOutCirc))),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> enlargeSize;
  // 开始时的一个放大的效果
  final Animation<double> positionAxis;
  final Animation<double> positionTop;
  final _BuilderFun builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, Widget child) {
        return builder(context,
            top: positionTop, size: enlargeSize, axis: positionAxis);
      },
    );
  }
}
