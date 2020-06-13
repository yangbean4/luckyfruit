import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/main.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
    return Selector<LuckyGroup, Tuple2<bool, GlobalKey>>(
        selector: (context, provider) =>
            Tuple2(provider.showRevengeShovel, provider.revengeShovelKey),
        builder: (_, tuple2, __) {
          if (tuple2.item1) {
            offsetStartPoint = Util.getOffset(tuple2.item2);
            posLeft = offsetStartPoint.dx;
            posTop = offsetStartPoint.dy;
          }
          return tuple2.item1
              ? _ShovelAnimation(
                  animateTime: Duration(milliseconds: 400),
                  onFinish: () {
                    Initialize.luckyGroup.showRevengeShovel = false;
                    Initialize.luckyGroup.showRevengeGoldFlowing = true;
                  },
                  builder: (ctx,
                      {Animation<double> top, Animation<double> size}) {
                    return Positioned(
                        left: posLeft + ScreenUtil().setWidth(50),
                        top: posTop +
                            ScreenUtil().setWidth(120) * (top.value - 1),
                        child: Image.asset(
                          "assets/image/revenge_shovel.png",
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setWidth(200),
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
  final Function onFinish;

  _ShovelAnimation(
      {Key key,
      @required this.builder,
      this.onFinish,
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
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.onFinish != null) {
            widget.onFinish();
          }
        }
      })
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
            curve: Interval(0.2, 0.6, curve: _ShakeCurve(longTime: 1)))),
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
