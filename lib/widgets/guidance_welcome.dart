import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/storage.dart';
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
  Interval scaleTextInterval;
  Interval transPeopleInterval;
  bool show = false;
  bool clickFlag = false;

  @override
  void initState() {
    super.initState();

    textTips = "assets/image/guidance_message_welcome.png";
    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

    Future.delayed(Duration(seconds: 2), () {
      print("Future.delayed");
      controller.forward().orCancel;
    });
    //文字框的缩放动画
    scaleTextTween = Tween<double>(
      begin: 0.0,
      end: 1.0,
    );

    scaleTextInterval = Interval(
      0.6,
      1.0,
      curve: Curves.ease,
    );
    scaleTextAnimation = scaleTextTween.animate(
      CurvedAnimation(parent: controller, curve: scaleTextInterval),
    );

    // 人物的平移动画
    transPeopleTween = Tween<double>(
      begin: -ScreenUtil().setWidth(1080),
      end: 0.0,
    );
    transPeopleInterval = Interval(
      0.0,
      0.6,
      curve: Curves.easeOutBack,
    );
    transPeopleAnimation = transPeopleTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: transPeopleInterval,
      ),
    );

    getShowOrNot();
  }

  getShowOrNot() async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    String cachedFlag = await Storage.getItem(Consts.SP_KEY_GUIDANCE_WELCOME);
    setState(() {
      show = (treeGroup?.treeList?.length == 0 && cachedFlag == null);
      print("gui_wel: $show");
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  showExplanationTips() async {
    BurialReport.report('page_imp', {'page_code': '028'});

    flag = true;
    controller.duration = Duration(milliseconds: 500);
    scaleTextInterval = Interval(
      0.0,
      1.0,
      curve: Curves.ease,
    );

    scaleTextAnimation = scaleTextTween.animate(
      CurvedAnimation(parent: controller, curve: scaleTextInterval),
    );

    // 隐藏welcome
    transPeopleTween.begin = 0;
    scaleTextTween.begin = 1.0;
    scaleTextTween.end = 0.1;
    controller.value = 0;
    try {
      await controller.forward().orCancel;
    } on TickerCanceled {}

    textTips = "assets/image/guidance_message_explanation.png";
    BurialReport.report('page_imp', {'page_code': '029'});

    // 显示explanation
    scaleTextTween.begin = 0.1;
    scaleTextTween.end = 1.0;
    controller.value = 0;
    await controller.forward().orCancel;
  }

  transToHideGuidance() async {
    if (clickFlag) {
      return;
    }
    clickFlag = true;
    transPeopleTween.begin = 0;
    transPeopleTween.end = -ScreenUtil().setWidth(1080);
    scaleTextTween.begin = 1.0;
    scaleTextTween.end = 1.0;
    controller.value = 0;
    try {
      await controller.forward().orCancel;
    } on TickerCanceled {}
    bgColor = null;

    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    // 显示添加树circle指引
    luckyGroup.setShowCircleGuidance = true;
    // 显示合成树rrect指引
    // luckyGroup.setShowRRectGuidance = true;

    Storage.setItem(Consts.SP_KEY_GUIDANCE_WELCOME, "1");
  }

  @override
  Widget build(BuildContext context) {
    print(
        "build::: trans: show=$show, ${transPeopleAnimation?.value}, scale: ${scaleTextAnimation?.value}");
    return show
        ? AnimatedBuilder(
            builder: (BuildContext context, Widget child) {
              return Positioned(
                left: 0,
                bottom: 0,
                child: GestureDetector(
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
                    padding: EdgeInsets.only(
                      bottom: ScreenUtil().setWidth(60),
                    ),
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
                ),
              );
            },
            animation: controller,
          )
        : Container();
  }
}
