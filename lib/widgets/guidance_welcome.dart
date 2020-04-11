import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:provider/provider.dart';

class GuidanceWelcomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceWelcomeState();
}

class _GuidanceWelcomeState extends State with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curveEaseIn;
  Animation<double> positonBottom;

  Animation<double> scaleTextAnimation;
  Animation<double> transPeopleAnimation;

  Tween<double> transPeopleTween;
  Tween<double> scaleTextTween;

  String textTips;
  bool flag = false;
  Color bgColor = Color.fromRGBO(0, 0, 0, 0.2);

  @override
  void initState() {
    super.initState();

    textTips = "assets/image/guidance_message_welcome.png";
    controller = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    Future.delayed(Duration(seconds: 3), () {
      print("Future.delayed");
      controller.forward().orCancel;
    });

    //文字框的缩放动画
    scaleTextTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );
    scaleTextAnimation = scaleTextTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.6,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );

    // 人物的平移动画
    transPeopleTween = Tween<double>(
      begin: -ScreenUtil().setWidth(1080),
      end: 0.0,
    );
    transPeopleAnimation = transPeopleTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.easeOutBack,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  showExplanationTips() async {
    flag = true;
    // 隐藏welcome
    transPeopleTween.begin = 0;
    scaleTextTween.begin = 1.0;
    scaleTextTween.end = 0.0;
    controller.value = 0;
    try {
      await controller.forward().orCancel;
    } on TickerCanceled {}

    textTips = "assets/image/guidance_message_explanation.png";

    // 显示explanation
    scaleTextTween.begin = 0.0;
    scaleTextTween.end = 1.0;
    controller.value = 0;
    await controller.forward().orCancel;
  }

  transToHideGuidance() async {
    transPeopleTween.begin = 0;
    transPeopleTween.end = -ScreenUtil().setWidth(1080);
    scaleTextTween.begin = 1.0;
    scaleTextTween.end = 1.0;
    controller.value = 0;
    try {
      await controller.forward().orCancel;
    } on TickerCanceled {}
    bgColor = null;

    // LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    // luckyGroup.setShowCircleGuidance = true;
  }

  @override
  Widget build(BuildContext context) {
    print(
        "build::: trans: ${transPeopleAnimation?.value}, scale: ${scaleTextAnimation?.value}");
    return AnimatedBuilder(
      builder: (BuildContext context, Widget child) {
        return GestureDetector(
          onTap: () {
            if (!flag) {
              showExplanationTips();
            } else {
              transToHideGuidance();
            }
          },
          child: Container(
            color: bgColor,
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(2500),
            child: Transform.translate(
              offset: Offset(transPeopleAnimation?.value ?? 0, 0),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: ScreenUtil().setWidth(150),
                    bottom: ScreenUtil().setWidth(700),
                    child: Transform.scale(
                      scale: scaleTextAnimation?.value ?? 0,
                      child: Image.asset(
                        textTips,
                        width: ScreenUtil().setWidth(788),
                        height: ScreenUtil().setWidth(336),
                      ),
                    ),
                  ),
                  Positioned(
                    left: ScreenUtil().setWidth(0),
                    bottom: ScreenUtil().setWidth(0),
                    child: Image.asset(
                      'assets/image/guidance_people.png',
                      width: ScreenUtil().setWidth(370),
                      height: ScreenUtil().setWidth(750),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      animation: controller,
    );
  }
}
