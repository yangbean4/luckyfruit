import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:provider/provider.dart';

class InvertedCircleClipper extends CustomClipper<Path> {
  double radius;
  InvertedCircleClipper(this.radius);

  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(new Rect.fromCircle(
          center: Offset(
              ScreenUtil().setWidth(1080 / 2), ScreenUtil().setWidth(1920)),
          radius: radius))
      ..addRect(new Rect.fromLTWH(
          0.0, 0.0, ScreenUtil().setWidth(1080), ScreenUtil().setWidth(2500)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class GuidanceDrawCircleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceDrawCircleState();
}

class _GuidanceDrawCircleState extends State<GuidanceDrawCircleWidget>
    with TickerProviderStateMixin {
  CurvedAnimation curveEaseIn;
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    curveEaseIn =
        new CurvedAnimation(parent: controller, curve: Curves.easeOutBack);

    scaleAnimation = Tween<double>(
      begin: ScreenUtil().setWidth(2000),
      end: ScreenUtil().setWidth(200),
    ).animate(curveEaseIn);
  }

  Future<Null> _playAnimation() async {
    try {
      //先正向执行动画
      await controller.forward().orCancel;
      //再反向执行动画
      // await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (BuildContext context, Widget child) {
        return Selector<LuckyGroup, bool>(
            selector: (context, provider) => provider.showCircleGuidance,
            builder: (_, bool showCircleGuidance, __) {
              if (showCircleGuidance) {
                // Future.delayed(Duration(seconds: 0), () {
                  _playAnimation();
                // });
              }
              return ClipPath(
                clipper: InvertedCircleClipper(scaleAnimation.value),
                child: Container(
                  width: ScreenUtil().setWidth(1080),
                  height: ScreenUtil().setWidth(2500),
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                ),
              );
            });
      },
      animation: controller,
    );
  }
}
