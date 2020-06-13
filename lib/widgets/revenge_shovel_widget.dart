import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

typedef Widget _BuilderFun(BuildContext context,
    {Animation<double> top, Animation<double> size});

class RevengeShovelWidget extends StatefulWidget {
  @override
  _RevengeShovelWidgetState createState() => _RevengeShovelWidgetState();
}

class _RevengeShovelWidgetState extends State<RevengeShovelWidget> {
  Offset offsetStartPoint;
  double posLeft;
  double posTop;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LuckyGroup, bool>(
        selector: (context, provider) => provider.showRevengeShovel,
        builder: (_, bool show, __) {
          if (show) {
            offsetStartPoint = Util.getOffset(Consts.treeGroupGlobalKey[0][1]);
            posLeft = offsetStartPoint.dx;
            posTop = offsetStartPoint.dy;
          }
          return show
              ? _ShovelAnimation(
                  animateTime: Duration(milliseconds: 400),
                  builder: (ctx,
                      {Animation<double> top, Animation<double> size}) {
                    return Positioned(
                        left: posLeft,
                        top: posTop + ScreenUtil().setWidth(100) * top.value,
                        child: Image.asset(
                          "assets/image/position_icon.png",
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setWidth(120),
                        ));
                  },
                )
              : Container();
        });
  }
}

class _ShovelAnimation extends StatefulWidget {
  final _BuilderFun builder;
  final Duration animateTime;

  _ShovelAnimation(
      {Key key,
      @required this.builder,
      this.animateTime = const Duration(milliseconds: 600)})
      : super(key: key);

  @override
  _ShovelAnimationState createState() => _ShovelAnimationState();
}

class _ShovelAnimationState extends State<_ShovelAnimation>
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
      ..forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            curve: Interval(0.0, 1.0, curve: _ShakeCurve(longTime: 1)))),
        // 大小
        enlargeSize = Tween<double>(
          begin: -1.0,
          end: 0.0,
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

class _ShakeCurve extends Curve {
  final int longTime;

  _ShakeCurve({this.longTime});

  @override
  double transformInternal(double t) {
    //https://youtu.be/qnnlGcZ8vaQ
    final d = sin(t * 2 * longTime * pi) * 0.5 + 0.5;
    return d;
  }
}
