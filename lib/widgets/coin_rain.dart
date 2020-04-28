import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:provider/provider.dart';

class CoinRainWidget extends StatelessWidget {
  const CoinRainWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<LuckyGroup, bool>(
        builder: (_, show, __) {
          return show ? _CoinRain() : Container();
        },
        selector: (context, provider) => provider.isDouble);
  }
}

class _CoinRain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CoinRainState();
}

class _CoinRainState extends State with TickerProviderStateMixin {
  CurvedAnimation curveEaseIn;
  AnimationController controller;
  Animation<double> posAnimation;

  static const int screen = 4;
  static const int count = 20 * screen;
  static const int goldImgSize = 80;
  static double screenHeight = ScreenUtil().setWidth(1920);
  List<Widget> children = [];

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 1500 * screen), vsync: this);
    curveEaseIn = new CurvedAnimation(
        parent: controller,
        curve:
//    _ShakeCurve(longTime: 3000 * screen)
            Curves.linear);

    posAnimation = Tween<double>(
      begin: -screen.toDouble(),
      end: 0.0,
    ).animate(curveEaseIn);

    // controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    //     luckyGroup.isDouble = false;
    //   }
    // });

    for (int i = 0; i < count; i++) {
      Widget child = getIconWidget();
      double leftRandom =
          Random().nextInt(ScreenUtil().setWidth(1080).round()).toDouble() -
              ScreenUtil().setWidth(goldImgSize);
      double left = leftRandom <= 0 ? 0.0 : leftRandom;
      double screenNum = Random().nextDouble() * (screen - 1);
      children.add(Positioned(
        left: left,
        top: screenNum * screenHeight,
        child: child,
      ));

      // 如果是第一屏的 则平移到最后一屏
      if (screenNum < 1) {
        children.add(Positioned(
          left: left,
          top: (screenNum + (screen - 1)) * screenHeight,
          child: child,
        ));
      }
    }

    controller
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller
            ..value = 1 / screen
            ..forward();
        }
      });
  }

  getIconWidget() {
    return Container(
      child: Image.asset(
        'assets/image/coin_rain_icon${Random().nextInt(5) + 1}.png',
        width: ScreenUtil().setWidth(goldImgSize),
        height: ScreenUtil().setWidth(goldImgSize),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> coinList = [];

  // _playAnimation() {
  //   try {
  //     controller.repeat().orCancel;
  //   } on TickerCanceled {
  //     // the animation got canceled, probably because we were disposed
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
          child: Container(
            width: ScreenUtil().setWidth(1080),
            height: screen * screenHeight + ScreenUtil().setWidth(goldImgSize),
            child: Stack(
              children: children,
            ),
          ),
          builder: (BuildContext context, Widget child) {
            double top = posAnimation.value * screenHeight;
            return Stack(overflow: Overflow.visible, children: [
              Positioned(
                child: child,
                top: top,
              )
            ]);
          },
          animation: posAnimation),
    );
  }
}
