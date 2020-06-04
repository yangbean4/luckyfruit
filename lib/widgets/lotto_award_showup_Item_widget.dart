import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/theme/public/gold_text.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class LottoAwardShowupItemWidget extends StatefulWidget {
  Function callback;
  int positonLeft;
  bool hidePlusIcon;
  int goldNumGrade;
  int goldNum;
  Duration animationTime;

  LottoAwardShowupItemWidget(
      {this.callback,
      this.positonLeft,
      this.goldNum,
      this.animationTime = const Duration(milliseconds: 1000),
      this.hidePlusIcon = false,
      this.goldNumGrade});

  @override
  _LottoAwardShowupItemWidgetState createState() =>
      _LottoAwardShowupItemWidgetState();
}

class _LottoAwardShowupItemWidgetState extends State<LottoAwardShowupItemWidget>
    with TickerProviderStateMixin {
  Animation<double> scaleImageAnimation;
  Animation<double> posImageAnimation;
  AnimationController controller;

  bool _visible = false;
  num goldNum;
  LuckyGroup luckyGroup;

  @override
  void initState() {
    super.initState();

    luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    goldNum = widget.goldNum ??
        luckyGroup.getCoinNumWithWinningGrade(widget.goldNumGrade);

    controller =
        new AnimationController(duration: widget.animationTime, vsync: this);

    posImageAnimation = Tween<double>(
      begin: ScreenUtil().setHeight(360),
      end: ScreenUtil().setHeight(1100),
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        )));

    scaleImageAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        )))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _visible = true;
            if (widget.callback != null) {
              widget.callback();
            }
          });
        }
      });

    controller.forward().orCancel;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        builder: (BuildContext context, Widget child) {
          return Positioned(
            bottom: posImageAnimation?.value ?? 0,
            left: ScreenUtil().setWidth(widget.positonLeft),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Transform.scale(
                      scale: scaleImageAnimation?.value ?? 0,
                      child: Image.asset(
                        "assets/image/lotto_coin_heap.png",
                        width: ScreenUtil().setWidth(290),
                        height: ScreenUtil().setWidth(290),
                      ),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(5),
                    ),
                    AnimatedOpacity(
                      opacity: (_visible && !widget.hidePlusIcon) ? 1.0 : 0.0,
//                            opacity: 1.0,
                      duration: Duration(milliseconds: 100),
                      child: Image.asset(
                        "assets/image/lotto_icon_plus.png",
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(60),
                      ),
                    )
                  ],
                ),
                AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 100),
                  child: GoldText(
                    Util.formatNumber(goldNum),
                    textSize: 60,
                    iconSize: 54,
                    textColor: Colors.white,
                  ),
                )
              ],
            ),
          );
        },
        animation: controller);
  }

  num getGoldNum(int grade) {}
}
