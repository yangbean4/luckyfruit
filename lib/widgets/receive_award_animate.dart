import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/gold_text.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class DwardType {
  static const gold = 'gold';
  static const tree = 'tree';
  static const lotto = 'lotto';
  static const attack = 'attack';
}

class ReceiveAwardAnimate {
  static show(
    context, {
    Function callback,
    int awardAcount,
    String awardType,
    Duration animationTime,
  }) {
    showDialog(
        context: context,
        builder: (_) => _ReceiveAwardAnimate(
              callback: callback,
              awardAcount: awardAcount,
              awardType: awardType,
              animationTime: animationTime,
            ));
  }
}

class _ReceiveAwardAnimate extends StatefulWidget {
  Function callback;
  int awardAcount;
  String awardType;
  Duration animationTime;

  _ReceiveAwardAnimate(
      {this.callback,
      this.awardType,
      this.animationTime = const Duration(milliseconds: 1000),
      this.awardAcount});

  @override
  __ReceiveAwardAnimateState createState() => __ReceiveAwardAnimateState();
}

class __ReceiveAwardAnimateState extends State<_ReceiveAwardAnimate>
    with TickerProviderStateMixin {
  Animation<double> scaleImageAnimation;
  Animation<double> posImageAnimation;
  Animation<double> opaImageAnimation;

  AnimationController controller;

  Map<String, Widget> imageSource = {
    DwardType.gold: Image.asset(
      "assets/image/lotto_coin_heap.png",
      width: ScreenUtil().setWidth(290),
      height: ScreenUtil().setWidth(290),
    ),
    DwardType.tree: Image.asset(
      'assets/tree/bonus.png',
      key: Consts.globalKeyFlowerSpinBouns,
      width: ScreenUtil().setWidth(290),
      height: ScreenUtil().setWidth(290),
    ),
    DwardType.lotto: Image.asset(
      'assets/image/lotto_tickets_icon.png',
      key: Consts.globalKeyFlowerSpinLotto,
      width: ScreenUtil().setWidth(290),
      height: ScreenUtil().setWidth(290),
    ),
    DwardType.attack: Image.asset(
      'assets/image/attack.png',
      width: ScreenUtil().setWidth(209),
      height: ScreenUtil().setWidth(232),
    )
  };
  Map<String, Widget> labelSource = {};

  Map<String, num> positonLeft = {
    DwardType.gold: 246,
    DwardType.tree: 246,
    DwardType.lotto: 395,
    DwardType.attack: 260
  };

  bool _visible = false;
  num awardAcount;
  LuckyGroup luckyGroup;

  @override
  void initState() {
    super.initState();

    luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    awardAcount = widget.awardAcount;

    controller =
        new AnimationController(duration: widget.animationTime, vsync: this);

    posImageAnimation = Tween<double>(
      begin: ScreenUtil().setHeight(360),
      end: ScreenUtil().setHeight(1100),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.ease,
        )));

    opaImageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.6,
          0.7,
          curve: Curves.ease,
        )));

    scaleImageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.ease,
        )))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.callback != null) {
            widget.callback();
          }
          Navigator.pop(context);
        }
      });

    labelSource = {
      DwardType.gold: Container(
          width: ScreenUtil().setWidth(600),
          height: ScreenUtil().setWidth(120),
          // alignment: Alignment(1, 0),
          child: GoldText(
            Util.formatNumber(awardAcount),
            textSize: 60,
            iconSize: 54,
            textColor: Colors.white,
          )),
      DwardType.tree: Container(
        width: ScreenUtil().setWidth(600),
        height: ScreenUtil().setWidth(120),
        // alignment: Alignment(-0.5, 0),
        child: Text(
          'The Limited Time \nBonus Tree x $awardAcount',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            fontSize: ScreenUtil().setSp(48),
            fontFamily: FontFamily.semibold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      DwardType.lotto: GoldText(
        awardAcount.toString(),
        textSize: 60,
        iconSize: 54,
        imgUrl: "assets/image/lotto_tickets_icon.png",
        textColor: Colors.white,
      ),
      DwardType.attack: Container(
        width: ScreenUtil().setWidth(600),
        height: ScreenUtil().setWidth(120),
        // alignment: Alignment(1, 0),
        child: GoldText(
          awardAcount.toString(),
          textSize: 60,
          iconSize: 54,
          imgUrl: "assets/image/attack.png",
          textColor: Colors.white,
        ),
      ),
    };

    controller.forward().orCancel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
      body: Stack(children: [
        AnimatedBuilder(
            builder: (BuildContext context, Widget child) {
              return Positioned(
                bottom: posImageAnimation?.value ?? 0,
                left: ScreenUtil().setWidth(positonLeft[widget.awardType]),
                // left: ScreenUtil().setWidth(widget.positonLeft),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                      scale: scaleImageAnimation?.value ?? 0,
                      alignment: Alignment.center,
                      child: imageSource[widget.awardType],
                    ),
                    Opacity(
                      opacity: opaImageAnimation.value,
                      child: labelSource[widget.awardType],
                    )
                    // AnimatedOpacity(
                    //   opacity: _visible ? 1.0 : 0.0,
                    //   duration: Duration(milliseconds: 100),

                    // )
                  ],
                ),
              );
            },
            animation: controller)
      ]),
    );
  }
}
