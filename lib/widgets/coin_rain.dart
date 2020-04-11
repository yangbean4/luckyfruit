import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoinRainWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CoinRainState();
}

class CoinRainState extends State with TickerProviderStateMixin {
  CurvedAnimation curveEaseIn;
  AnimationController controller;
  Animation<double> posAnimation;

  List leftList = [];
  List topList = [];
  static const int count = 30;
  static const int goldImgSize = 80;
  static double screenHeight = ScreenUtil().setWidth(2500);

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
    curveEaseIn = new CurvedAnimation(parent: controller, curve: Curves.linear);

    posAnimation = Tween<double>(
      begin: .0,
      end: 1.0,
    ).animate(curveEaseIn);

    _playAnimation();

    for (int i = 0; i < count; i++) {
      double leftRandom =
          Random().nextInt(ScreenUtil().setWidth(1080).round()).toDouble() -
              ScreenUtil().setWidth(goldImgSize);
      leftList.add(leftRandom <= 0 ? 0.0 : leftRandom);
      topList.add(Random().nextDouble() * screenHeight);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> coinList = [];

  _playAnimation() {
    try {
      controller.repeat().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  getCoinList(num value) {
    coinList.clear();
    for (int i = 0; i < count; i++) {
      double topV = value * screenHeight + topList[i];

      if (topV > screenHeight) {
        topV = topV % screenHeight;
      }

      coinList.add(Positioned(
        left: leftList[i],
        top: topV,
        child: Container(
          child: Image.asset(
            'assets/image/gold_400.png',
            width: ScreenUtil().setWidth(goldImgSize),
            height: ScreenUtil().setWidth(goldImgSize),
          ),
        ),
      ));
    }

    return coinList;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        builder: (BuildContext context, Widget child) {
          return Stack(children: getCoinList(posAnimation.value));
        },
        animation: controller);
  }
}
