import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/mould/tree.mould.dart';

class ShakeButton extends StatefulWidget {
  final Tree minLevelTree;
  ShakeButton({Key key, this.minLevelTree}) : super(key: key);

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
        controller.value = 0.0;
        // controller?.forward();
        runAnimation();
      } else {
        timer?.cancel();
      }
    });
    controller?.forward();
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
    return GrowTransition(
        child: TheButton(
          minLevelTree: widget.minLevelTree,
        ),
        animation: animation);
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
                angle: math.pi / 30 * (animation.value),
                child: child);
          },
          child: child),
    );
  }
}

class TheButton extends StatelessWidget {
  const TheButton({Key key, this.minLevelTree}) : super(key: key);
  final Tree minLevelTree;
  @override
  Widget build(BuildContext context) {
    return Container(
      // minWidth: ScreenUtil().setWidth(560),
      width: ScreenUtil().setWidth(500),
      height: ScreenUtil().setWidth(128),
      decoration: BoxDecoration(
        color: MyTheme.primaryColor,
        borderRadius: BorderRadius.all(
          Radius.elliptical(
            ScreenUtil().setWidth(64),
            ScreenUtil().setWidth(64),
          ),
        ),
      ),
      child: Stack(overflow: Overflow.visible, children: <Widget>[
        Container(
          height: ScreenUtil().setWidth(55),
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(55),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/image/gold.png',
                width: ScreenUtil().setWidth(55),
                height: ScreenUtil().setWidth(55),
              ),
              Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(14),
                  ),
                  child: Text(
                    Util.formatNumber(minLevelTree?.consumeGold ?? 0),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setWidth(34),
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          ),
        ),
        Positioned(
          bottom: ScreenUtil().setWidth(80),
          left: ScreenUtil().setWidth(220),
          child: TreeWidget(
            tree: minLevelTree,
            imgHeight: ScreenUtil().setWidth(84),
            imgWidth: ScreenUtil().setWidth(77),
            labelWidth: ScreenUtil().setWidth(40),
            primary: false,
          ),
        )
      ]),
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
