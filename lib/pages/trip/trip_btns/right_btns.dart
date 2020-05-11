import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart' show Issued;
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class RightBtns extends StatefulWidget {
  RightBtns({Key key}) : super(key: key);

  @override
  _RightBtnsState createState() => _RightBtnsState();
}

class _RightBtnsState extends State<RightBtns>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // bool isDouble = false;

  // bool isAuto = false;
  // LuckyGroup luckyGroup;
  // 下发的配置
  // Issued issed;

  renderItem(
    Widget icon, {
    Widget top,
    Widget bottom,
    String topString,
    String bottomString,
    Color color,
    bool active,
  }) {
    return Container(
      width: ScreenUtil().setWidth(288),
      height: ScreenUtil().setWidth(112),
      decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.6),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(ScreenUtil().setWidth(56)),
              topLeft: Radius.circular(ScreenUtil().setWidth(56)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(100),
            height: ScreenUtil().setWidth(100),
            child: icon,
          ),
          Container(
            width: ScreenUtil().setWidth(166),
            height: ScreenUtil().setWidth(90),
            decoration: BoxDecoration(
              color: color,
              borderRadius: color != null
                  ? BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                top == null
                    ? Text(
                        topString,
                        style: TextStyle(
                            color: MyTheme.redColor,
                            fontFamily: FontFamily.bold,
                            fontSize: ScreenUtil().setWidth(32),
                            fontWeight: FontWeight.bold),
                      )
                    : top,
                bottom == null
                    ? Text(
                        bottomString,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontFamily.semibold,
                            fontSize: ScreenUtil().setWidth(30),
                            fontWeight: FontWeight.w500),
                      )
                    : bottom,
              ],
            ),
          )
        ],
      ),
    );
  }

  runderBottomString(String bottomString, bool active) {
    return Text(
      bottomString,
      style: TextStyle(
          color: Colors.white,
          fontFamily: FontFamily.semibold,
          fontSize: ScreenUtil().setWidth(30),
          fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    return Selector<LuckyGroup,
        Tuple7<Issued, bool, bool, bool, bool, int, int>>(
      selector: (context, luckyGroup) => Tuple7(
        luckyGroup.issed,
        luckyGroup.showDouble,
        luckyGroup.showAuto,
        luckyGroup.isDouble,
        luckyGroup.isAuto,
        luckyGroup.double_coin_time,
        luckyGroup.automatic_time,
      ),
      builder: (_, data, __) {
        Issued issed = data.item1;
        bool showDouble = data.item2;
        bool showAuto = data.item3;
        bool isDouble = data.item4;
        bool isAuto = data.item5;
        int doubleTime = data.item6;
        int autoTime = data.item7;

        return Container(
            width: ScreenUtil().setWidth(313),
            height: ScreenUtil().setWidth(262),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                showDouble
                    ? _ShakeAnimation(
                        animateTime: Duration(
                            milliseconds:
                                (issed?.double_coin_remain_time ?? 10) * 1000),
                        child: AdButton(
                          ad_code: '201',
                          adUnitIdFlag: 1,
                          onOk: () {
                            //success
                            luckyGroup.doubleStart();
                          },
                          child: renderItem(
                              Container(
                                width: ScreenUtil().setWidth(73),
                                height: ScreenUtil().setWidth(74),
                                alignment: Alignment(0.3, 0),
                                child: Image.asset(
                                  'assets/image/right_gold.png',
                                  width: ScreenUtil().setWidth(73),
                                  height: ScreenUtil().setWidth(74),
                                ),
                              ),
                              active: false,
                              bottomString: 'in ${issed?.double_coin_time}s',
                              topString: 'Earn X${issed?.reward_multiple}',
                              color: Color.fromRGBO(49, 200, 84, 1)),
                        ),
                      )
                    : Container(),
                isDouble
                    ? renderItem(
                        Container(
                          width: ScreenUtil().setWidth(73),
                          height: ScreenUtil().setWidth(74),
                          alignment: Alignment(0.3, 0),
                          child: Image.asset(
                            'assets/image/right_gold.png',
                            width: ScreenUtil().setWidth(73),
                            height: ScreenUtil().setWidth(74),
                          ),
                        ),
                        topString: 'Earn X${issed?.reward_multiple}',
                        bottom: runderBottomString(
                            Util.formatCountDownTimer(
                                Duration(seconds: doubleTime)),
                            true)
                        // bottom: CountdownFormatted(
                        //   duration: Duration(seconds: issed?.double_coin_time),
                        //   onFinish: () {
                        //     luckyGroup.doubleEnd();
                        //     setState(() {
                        //       isDouble = false;
                        //     });
                        //   },
                        //   builder: (ctx, time) {
                        //     // issed?.double_coin_time = time?.inSeconds;
                        //     return runderBottomString(
                        //         Util.formatCountDownTimer(time), true);
                        //   },
                        // ),
                        )
                    : Container(),
                showAuto
                    ? _ShakeAnimation(
                        animateTime: Duration(
                            milliseconds:
                                (issed?.automatic_remain_time ?? 10) * 1000),
                        child: AdButton(
                          ad_code: '202',
                          adUnitIdFlag: 2,
                          onOk: () {
                            //success
                            luckyGroup.autoStart();
                            setState(() {
                              isAuto = true;
                            });
                          },
                          child: renderItem(
                              Container(
                                width: ScreenUtil().setWidth(89),
                                height: ScreenUtil().setWidth(89),
                                alignment: Alignment(0.3, 0),
                                child: Image.asset(
                                  'assets/image/right_loop.png',
                                  width: ScreenUtil().setWidth(89),
                                  height: ScreenUtil().setWidth(89),
                                ),
                              ),
                              active: false,
                              bottomString: 'in ${issed?.automatic_time}s',
                              topString: 'Auto',
                              color: Color.fromRGBO(49, 200, 84, 1)),
                        ))
                    : Container(),
                isAuto
                    ? renderItem(
                        Container(
                          width: ScreenUtil().setWidth(89),
                          height: ScreenUtil().setWidth(89),
                          alignment: Alignment(0.3, 0),
                          child: Image.asset(
                            'assets/image/right_loop.png',
                            width: ScreenUtil().setWidth(89),
                            height: ScreenUtil().setWidth(89),
                          ),
                        ),
                        topString: 'Auto Merge',
                        bottom: runderBottomString(
                            Util.formatCountDownTimer(
                                Duration(seconds: autoTime)),
                            true)
                        // bottom: CountdownFormatted(
                        //   duration: Duration(seconds: issed?.automatic_time),
                        //   onFinish: () {
                        //     luckyGroup.autoEnd();
                        //     setState(() {
                        //       isAuto = false;
                        //     });
                        //   },
                        //   builder: (ctx, time) {
                        //     // issed?.automatic_game_timelen = time?.inSeconds;
                        //     return runderBottomString(
                        //         Util.formatCountDownTimer(time), true);
                        //   },
                        // ),
                        )
                    : Container(),
              ],
            ));
      },
    );
  }
}

class _ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration animateTime;
  _ShakeAnimation({
    Key key,
    this.child,
    this.animateTime = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  __ShakeAnimationState createState() => __ShakeAnimationState();
}

class __ShakeAnimationState extends State<_ShakeAnimation>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: widget.animateTime, vsync: this)
      ..value = 0.0;
    // ..fling(velocity: 0.1);
    final CurvedAnimation curve = new CurvedAnimation(
        parent: controller,
        curve: _ShakeCurve(longTime: widget.animateTime.inMilliseconds));
    animation = new Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
    controller?.forward();
    runAnimation();
  }

  Future<void> runAnimation() async {
    await controller?.forward();
    // await controller.reverse();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GrowTransition(child: widget.child, animation: animation);
  }
}

class _GrowTransition extends StatelessWidget {
  _GrowTransition({this.child, this.animation});

  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return new Center(
      child: new AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return new Transform.rotate(
                alignment: Alignment.center,
                angle: math.pi / 40 * (animation.value),
                child: child);
          },
          child: child),
    );
  }
}

class _ShakeCurve extends Curve {
  final int longTime;
  _ShakeCurve({this.longTime});

  @override
  double transformInternal(double t) {
    final d = math.sin(math.sqrt(t * longTime) * math.pi);
    return d;
  }
}
