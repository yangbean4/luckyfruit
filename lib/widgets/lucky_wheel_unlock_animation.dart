import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:provider/provider.dart';

class WheelUnlockWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WheelUnlockState();
}

class _WheelUnlockState extends State with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleImageAnimation;
  Animation<double> scaleTextAnimation;
  Animation<double> posImageAnimation;
  Animation<double> scaleSunShineAnimation;
  bool endOfAnimation = false;

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    scaleSunShineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          0.8,
          curve: Curves.ease,
        )));

    posImageAnimation = Tween<double>(
      begin: ScreenUtil().setWidth(850),
      end: ScreenUtil().setWidth(1250),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.ease,
        )));

    scaleImageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.1,
          0.8,
          curve: Curves.ease,
        )));

    scaleTextAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.8,
          1.0,
          curve: Curves.ease,
        )))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print("Lucky Wheel AnimationStatus.completed");
          endOfAnimation = true;
          Storage.setItem(Consts.SP_KEY_UNLOCK_WHEEL, "1");
        }
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
//      await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LuckyGroup, bool>(
        selector: (context, provider) => provider.showLuckyWheelUnlock,
        builder: (_, bool show, __) {
          if (show) {
            _playAnimation();
          }
          return show
              ? AnimatedBuilder(
                  builder: (BuildContext context, Widget child) {
                    print(
                        "posImageAnimation.value= ${posImageAnimation.value}");
                    return Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: ScreenUtil().setWidth(1080),
                        height: ScreenUtil().setWidth(2500),
                        color: Color.fromRGBO(0, 0, 0, 0.5),
//                          alignment: Alignment(0, 0.3),
                        child: Container(
//                          color: Colors.red,
//                            alignment: Alignment(.0, 0.3),
                            child: !endOfAnimation
                                ? Stack(
                                    overflow: Overflow.visible,
                                    alignment: AlignmentDirectional(0, 0),
                                    children: <Widget>[
                                      Visibility(
//                                        opacity: endOfAnimation ? 0 : 1,
//                                        opacity: 0,
                                        visible: endOfAnimation ? false : true,
                                        child: Container(
                                          color: Colors.cyanAccent,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                width:
                                                    ScreenUtil().setWidth(1080),
                                                height:
                                                    ScreenUtil().setWidth(40),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment(-1.0, 0.0),
                                                      end: Alignment(1.0, 0.0),
                                                      colors: <Color>[
                                                        Color(0xFFFFF2B1),
                                                        Colors.white,
                                                        Color(0xFFFFF2B1),
                                                      ],
                                                      stops: [
                                                        0.2,
                                                        0.5,
                                                        0.8
                                                      ]),
                                                ),
                                              ),
                                              Container(
                                                width:
                                                    ScreenUtil().setWidth(1080),
                                                height:
                                                    ScreenUtil().setWidth(440),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment(0.0, -1.0),
                                                      end: Alignment(0.0, 1.0),
                                                      colors: <Color>[
                                                        Color(0xFFFBA22A),
                                                        Color(0xFFF94856),
                                                      ]),
                                                ),
                                              ),
                                              Container(
                                                width:
                                                    ScreenUtil().setWidth(1080),
                                                height:
                                                    ScreenUtil().setWidth(40),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      begin:
                                                          Alignment(-1.0, 0.0),
                                                      end: Alignment(1.0, 0.0),
                                                      colors: <Color>[
                                                        Color(0xFFFFF2B1),
                                                        Colors.white,
                                                        Color(0xFFFFF2B1),
                                                      ],
                                                      stops: [
                                                        0.2,
                                                        0.5,
                                                        0.8
                                                      ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !endOfAnimation,
//                                        visible: false,
                                        child: Positioned(
                                          bottom: posImageAnimation.value -
                                              ScreenUtil().setWidth(50),
                                          child: Container(
//                              color: Colors.blue,
                                            width: ScreenUtil().setWidth(640),
                                            height: ScreenUtil().setWidth(640),
                                            child: Transform.scale(
                                              scale: scaleSunShineAnimation
                                                      ?.value ??
                                                  0,
                                              child: Image.asset(
                                                'assets/image/wheel_unlock_bg.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: posImageAnimation.value,
                                        child: Transform.scale(
                                          scale: 1.0,
                                          child: Container(
//                                            color: Colors.green,
                                            width: ScreenUtil().setWidth(540),
                                            height: ScreenUtil().setWidth(540),
                                            child: Transform.scale(
//                                    scale: 0.1,
                                              scale:
                                                  scaleImageAnimation?.value ??
                                                      0,
                                              child: Image.asset(
                                                'assets/image/wheel_unlock_animation.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
//                                      Container(
//                                        color: Colors.amber,
//                                        height: ScreenUtil().setWidth(40),
//                                      ),
                                      Visibility(
                                        visible: !endOfAnimation,
//                                        visible: false,
                                        child: Positioned(
                                          bottom: posImageAnimation.value -
                                              ScreenUtil().setWidth(150),
                                          child: Container(
//                                    color: Colors.cyanAccent,
                                            child: Transform.scale(
                                                scale:
                                                    scaleTextAnimation?.value ??
                                                        0,
                                                child: Text(
                                                  "Spin Unlocked!",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.bold,
                                                      fontSize: ScreenUtil()
                                                          .setSp(100),
                                                      color:
                                                          Colors.amberAccent),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : WheelScaleAinmationWidget()),
                      ),
                    );
                  },
                  animation: controller)
              : Container();
        });
  }
}

class WheelScaleAinmationWidget extends StatefulWidget {
  @override
  _WheelScaleAinmationWidgetState createState() =>
      _WheelScaleAinmationWidgetState();
}

class _WheelScaleAinmationWidgetState extends State<WheelScaleAinmationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> posBottomAnimation;
  Animation<double> posRightAnimation;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();

    posBottomAnimation = Tween<double>(
      begin: ScreenUtil().setWidth(1250),
//      end: ScreenUtil().setHeight(1920-410),
      end: ScreenUtil().setWidth(1920 + 155 + 86 - 410),
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        )));
    posRightAnimation = Tween<double>(
      begin: ScreenUtil().setWidth(270),
      end: ScreenUtil().setWidth(60 + (960 - 378) / 2 - 270),
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        )));
    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        )))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          LuckyGroup luckyGroup =
              Provider.of<LuckyGroup>(context, listen: false);
          luckyGroup.setShowLuckyWheelUnlock = false;
        }
      });

    _playAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      //先正向执行动画
      await _controller.forward().orCancel;
      //再反向执行动画
//      await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (BuildContext context, Widget child) {
        return Stack(
          overflow: Overflow.visible,
          alignment: AlignmentDirectional(0, 0),
          children: <Widget>[
            Positioned(
              bottom: posBottomAnimation.value,
//              bottom: ScreenUtil().setWidth(1920 + 155 + 86 - 410),
//          bottom: ScreenUtil().setWidth(),
              right: posRightAnimation.value,
//              right: ScreenUtil().setWidth(60 + (960 - 378) / 2 - 270),
//          right: ScreenUtil().setWidth(80),
              child: Transform.scale(
//                scale: 0.1,
                scale: scaleAnimation.value,
                child: Container(
//                  color: Colors.cyanAccent,
                  width: ScreenUtil().setWidth(540),
                  height: ScreenUtil().setWidth(540),
                  child: Image.asset(
                    'assets/image/wheel_unlock_animation.png',
                  ),
                ),
              ),
            ),
//            Positioned(
//              bottom: 0,
//              child: Container(
//                color: Colors.amber,
//                height: ScreenUtil().setWidth(40),
//              ),
//            ),
          ],
        );
      },
      animation: _controller,
    );
  }
}
