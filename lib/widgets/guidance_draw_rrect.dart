import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:provider/provider.dart';

class _InvertedCRRectClipper extends CustomClipper<Path> {
  double radius;
  double leftPos;
  double topPos;
  _InvertedCRRectClipper(this.radius, this.leftPos, this.topPos);

  @override
  Path getClip(Size size) {
    return new Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(
              leftPos, topPos, radius * 2.1, ScreenUtil().setWidth(300)),
          Radius.circular(70)))
      ..addRect(Rect.fromLTWH(
          0.0, 0.0, ScreenUtil().setWidth(1080), ScreenUtil().setWidth(2500)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class GuidanceFingerInRRectWidget extends StatelessWidget {
  final double left;
  GuidanceFingerInRRectWidget(this.left);
  @override
  Widget build(BuildContext context) {
    return Positioned(
        // 屏幕高-金币速度视图bottom值 +statusBarHeight+手指height
        top: ScreenUtil().setWidth(1920 - 930 + 86 + 130),
        left: left,
        child: Container(
            child: Image.asset(
          "assets/image/guidance_finger.png",
          width: ScreenUtil().setWidth(120),
          height: ScreenUtil().setWidth(130),
        )));
  }
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
  Animation<double> leftPosAnimation;
  Animation<double> topPosAnimation;
  Animation<double> fingerLeftPosAnimation;
  Tween<double> scaleTween;
  bool enableFingerAnimatino = false;
  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    curveEaseIn =
        new CurvedAnimation(parent: controller, curve: Curves.easeOutBack);

    scaleAnimation = Tween<double>(
      begin: ScreenUtil().setWidth(540),
      end: ScreenUtil().setWidth(300),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.easeOutCubic,
      ),
    ));

    leftPosAnimation = Tween<double>(
      begin: -ScreenUtil().setWidth(50),
      end: ScreenUtil().setWidth(0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
    topPosAnimation = Tween<double>(
      // begin: -ScreenUtil().setWidth(1920 ),
      // end: ScreenUtil().setWidth(1920),
      begin: -ScreenUtil().setWidth(1920 - 930 - 10 + 86),
      end: ScreenUtil().setWidth(1920 - 930 - 10 + 86),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.duration = Duration(milliseconds: 2000);
          scaleAnimation = null;
          leftPosAnimation = null;
          topPosAnimation = null;
          enableFingerAnimatino = true;
          controller.repeat().orCancel;
        }
      });

    fingerLeftPosAnimation = Tween<double>(
      begin: ScreenUtil().setWidth(120),
      end: ScreenUtil().setWidth(400),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ),
    );
  }

  _playAnimation() async {
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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        builder: (BuildContext context, Widget child) {
          return Selector<LuckyGroup, bool>(
              selector: (context, provider) => provider.showRRectGuidance,
              builder: (_, bool show, __) {
                if (show) {
                  _playAnimation();
                }
                return show
                    ? Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: _InvertedCRRectClipper(
                              scaleAnimation?.value ??
                                  ScreenUtil().setWidth(300),
                              leftPosAnimation?.value ?? 0,
                              topPosAnimation?.value ??
                                  ScreenUtil().setWidth(1920 - 930 - 10 + 86),
                            ),
                            child: Container(
                              width: ScreenUtil().setWidth(1080),
                              height: ScreenUtil().setWidth(2500),
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                            ),
                          ),
                          enableFingerAnimatino
                              ? GuidanceFingerInRRectWidget(
                                  fingerLeftPosAnimation.value)
                              : Container(),
                        ],
                      )
                    : Container();
              });
        },
        animation: controller);
  }
}
