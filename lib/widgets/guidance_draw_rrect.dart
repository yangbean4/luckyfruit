import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:provider/provider.dart';

class _InvertedCRRectClipper extends CustomClipper<Path> {
  double radius;
  _InvertedCRRectClipper(this.radius);

  @override
  Path getClip(Size size) {
    return new Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0.0, ScreenUtil().setWidth(300), radius * 2, radius),
          Radius.circular(70)))
      ..addRect(Rect.fromLTWH(
          0.0, 0.0, ScreenUtil().setWidth(1080), ScreenUtil().setWidth(2500)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class GuidanceDrawRRectWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceDrawCircleState();
}

class _GuidanceDrawCircleState extends State<GuidanceDrawRRectWidget>
    with TickerProviderStateMixin {
  CurvedAnimation curveEaseIn;
  AnimationController controller;
  Animation<double> scaleAnimation;
  Tween<double> scaleTween;
  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    curveEaseIn =
        new CurvedAnimation(parent: controller, curve: Curves.easeOutBack);

    scaleTween = Tween<double>(
      begin: ScreenUtil().setWidth(2000),
      end: ScreenUtil().setWidth(200),
    );

    scaleAnimation = scaleTween.animate(curveEaseIn)
      ..addListener(() {
        print("draw_circle addListener");
        setState(() {});
      });
  }

  _playAnimation() async {
    try {
      print("Draw Circle _playAnimation");

      // controller.value = 0;
      // controller.reset();
      //先正向执行动画
      await controller.forward();
      //再反向执行动画
      // await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LuckyGroup, bool>(
        selector: (context, provider) => provider.showCircleGuidance,
        builder: (_, bool showCircleGuidance, __) {
          if (showCircleGuidance) {
            _playAnimation();
          }
          return ClipPath(
            clipper: _InvertedCRRectClipper(scaleAnimation.value),
            child: Container(
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setWidth(2500),
              color: Color.fromRGBO(0, 0, 0, 0.5),
            ),
          );
        });
  }
}
