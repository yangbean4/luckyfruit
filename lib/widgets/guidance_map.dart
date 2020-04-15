import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:provider/provider.dart';

class GuidanceMapWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceMapState();
}

class _GuidanceMapState extends State with TickerProviderStateMixin {
  AnimationController controller;

  Animation<double> scaleTextAnimation;
  Animation<double> transPeopleAnimation;

  Tween<double> transPeopleTween;
  Tween<double> scaleTextTween;

  Color bgColor = Color.fromRGBO(0, 0, 0, 0.5);
  Interval scaleTextInterval;
  Interval transPeopleInterval;

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);

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
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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

    Storage.setItem(Consts.SP_KEY_GUIDANCE_MAP, "1");
  }

  @override
  Widget build(BuildContext context) {
    print(
        "build::: trans: ${transPeopleAnimation?.value}, scale: ${scaleTextAnimation?.value}");
    return Selector<TourismMap, bool>(
        builder: (_, show, __) {
          if (show) {
            controller.forward().orCancel;
          }
          return show
              ? AnimatedBuilder(
                  builder: (BuildContext context, Widget child) {
                    return Positioned(
                      left: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          transToHideGuidance();
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
                                      "assets/image/guidance_message_map.png",
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
        },
        selector: (context, provider) => provider.showMapGuidance);
  }
}
