import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuidanceFingerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceFingerState();
}

class _GuidanceFingerState extends State with TickerProviderStateMixin {
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
      begin: 1.0,
      end: 0.6,
    ).animate(curveEaseIn);

    scaleAnimation.addListener(() {
      // print("positonBottom.addListener");
      // setState(() {});
    });

    scaleAnimation.addStatusListener((e) {
      // print("addStatusListener: $e");
      if (e == AnimationStatus.dismissed) {
        _playAnimation();
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      _playAnimation();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      //先正向执行动画
      await controller.forward().orCancel;
      //再反向执行动画
      await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            scale: scaleAnimation?.value ?? 0,
            child: Container(
              // color: Colors.red[100],
              child: Image.asset(
                'assets/image/guidance_finger.png',
                width: ScreenUtil().setWidth(86),
                height: ScreenUtil().setWidth(94),
              ),
            ),
          );
        },
        animation: controller);
  }
}
