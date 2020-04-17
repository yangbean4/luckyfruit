import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/models/index.dart' show Issued;
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/widgets/count_down.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:tuple/tuple.dart';
import 'package:luckyfruit/utils/mo_ad.dart';

class RightBtns extends StatefulWidget {
  RightBtns({Key key}) : super(key: key);

  @override
  _RightBtnsState createState() => _RightBtnsState();
}

class _RightBtnsState extends State<RightBtns>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isDouble = false;

  bool isAuto = false;
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
    bool active = true,
  }) {
    return Container(
      width: ScreenUtil().setWidth(313),
      height: ScreenUtil().setWidth(115),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: ScreenUtil().setWidth(2),
            child: Container(
              width: ScreenUtil().setWidth(271),
              height: ScreenUtil().setWidth(111),
              decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    image: AssetImage(active
                        ? 'assets/image/right_btn_active_bg.png'
                        : 'assets/image/right_btn_bg.png')),
              ),
            ),
          ),
          Positioned(
            left: ScreenUtil().setWidth(40),
            top: ScreenUtil().setWidth(20),
            child: Container(
              width: ScreenUtil().setWidth(160),
              height: ScreenUtil().setWidth(80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  top == null
                      ? (!active
                          ? Stack(children: <Widget>[
                              Text(
                                topString,
                                style: TextStyle(
                                    height: 1,
                                    foreground: new Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = ScreenUtil().setWidth(2)
                                      ..color = Colors.white,
                                    fontFamily: FontFamily.regular,
                                    fontSize: ScreenUtil().setSp(30),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                topString,
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 172, 30, 1),
                                    height: 1,
                                    fontFamily: FontFamily.regular,
                                    fontSize: ScreenUtil().setSp(30),
                                    fontWeight: FontWeight.bold),
                              )
                            ])
                          : Text(topString,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  color: MyTheme.redColor,
                                  height: 1,
                                  fontFamily: active
                                      ? FontFamily.black
                                      : FontFamily.regular,
                                  fontWeight: active
                                      ? FontWeight.w900
                                      : FontWeight.w500)))
                      : top,
                  bottom == null
                      ? runderBottomString(bottomString, active)
                      : bottom,
                ],
              ),
            ),
          ),
          Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: ScreenUtil().setWidth(113),
                height: ScreenUtil().setWidth(115),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      image: AssetImage(active
                          ? 'assets/image/right_icon_active_bg.png'
                          : 'assets/image/right_icon_bg.png')),
                ),
                child: icon,
              ))
        ],
      ),
    );
  }

  runderBottomString(String bottomString, bool active) {
    return Text(bottomString,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: ScreenUtil().setWidth(40),
            color: Colors.white,
            height: 1,
            fontFamily: active ? FontFamily.black : FontFamily.regular,
            fontWeight: active ? FontWeight.w900 : FontWeight.w500));
  }

  @override
  Widget build(BuildContext context) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);

    return Selector<LuckyGroup, Tuple3<Issued, bool, bool>>(
      selector: (context, luckyGroup) =>
          Tuple3(luckyGroup.issed, luckyGroup.showDouble, luckyGroup.showAuto),
      builder: (_, data, __) {
        Issued issed = data.item1;
        bool showDouble = data.item2;
        bool showAuto = data.item3;

        return Container(
            width: ScreenUtil().setWidth(313),
            height: ScreenUtil().setWidth(262),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                showDouble
                    ? _ShakeAnimation(
                        animateTime: Duration(
                            milliseconds:
                                (issed?.double_coin_remain_time ?? 10) * 1000),
                        child: GestureDetector(
                          onTap: () {
                            MoAd.viewAd(context).then((res) {
                              if (res) {
                                luckyGroup.doubleStart();
                                setState(() {
                                  isDouble = true;
                                  luckyGroup.setShowCoinRain = true;
                                });
                              } else {
                                //看广告失败,弹框提示
                                Layer.toastWarning(
                                    "Number of videos has used up");
                              }
                            });
                          },
                          child: renderItem(
                              Container(
                                width: ScreenUtil().setWidth(43),
                                height: ScreenUtil().setWidth(53),
                                alignment: Alignment(0.3, 0),
                                child: Image.asset(
                                  'assets/image/right_vadio.png',
                                  width: ScreenUtil().setWidth(43),
                                  height: ScreenUtil().setWidth(53),
                                ),
                              ),
                              active: false,
                              bottomString: 'in ${issed?.double_coin_time}s',
                              topString: 'Earningsx${issed?.reward_multiple}',
                              color: Color.fromRGBO(49, 200, 84, 1)),
                        ),
                      )
                    : Container(),
                isDouble
                    ? renderItem(
                        Container(
                          width: ScreenUtil().setWidth(56),
                          height: ScreenUtil().setWidth(54),
                          alignment: Alignment(0.1, 0),
                          child: Image.asset(
                            'assets/image/right_gold.png',
                            width: ScreenUtil().setWidth(56),
                            height: ScreenUtil().setWidth(54),
                          ),
                        ),
                        topString: 'EarningsX${issed?.reward_multiple}',
                        active: true,
                        bottom: CountdownFormatted(
                          duration: Duration(seconds: issed?.double_coin_time),
                          onFinish: () {
                            luckyGroup.doubleEnd();
                            setState(() {
                              isDouble = false;
                              luckyGroup.setShowCoinRain = false;
                            });
                          },
                          builder: (ctx, time) {
                            // issed?.double_coin_time = time?.inSeconds;
                            return runderBottomString(
                                Util.formatCountDownTimer(time), true);
                          },
                        ),
                      )
                    : Container(),
                showAuto
                    ? _ShakeAnimation(
                        animateTime: Duration(
                            milliseconds:
                                (issed?.automatic_remain_time ?? 10) * 1000),
                        child: GestureDetector(
                          onTap: () {
                            MoAd.viewAd(context).then((res) {
                              if (res) {
                                luckyGroup.autoStart();
                                setState(() {
                                  isAuto = true;
                                });
                              } else {
                                //看广告失败,弹框提示
                                Layer.toastWarning(
                                    "Number of videos has used up");
                              }
                            });
                          },
                          child: renderItem(
                              Container(
                                width: ScreenUtil().setWidth(43),
                                height: ScreenUtil().setWidth(53),
                                alignment: Alignment(0.3, 0),
                                child: Image.asset(
                                  'assets/image/right_vadio.png',
                                  width: ScreenUtil().setWidth(43),
                                  height: ScreenUtil().setWidth(53),
                                ),
                              ),
                              active: false,
                              bottomString: 'in ${issed?.automatic_time}s',
                              topString: 'Auto Merge',
                              color: Color.fromRGBO(49, 200, 84, 1)),
                        ))
                    : Container(),
                isAuto
                    ? renderItem(
                        Container(
                          width: ScreenUtil().setWidth(43),
                          height: ScreenUtil().setWidth(54),
                          alignment: Alignment(0, 0),
                          child: Image.asset(
                            'assets/image/right_loop.png',
                            width: ScreenUtil().setWidth(43),
                            height: ScreenUtil().setWidth(54),
                          ),
                        ),
                        topString: 'Auto Merge',
                        bottom: CountdownFormatted(
                          duration: Duration(seconds: issed?.automatic_time),
                          onFinish: () {
                            luckyGroup.autoEnd();
                            setState(() {
                              isAuto = false;
                            });
                          },
                          builder: (ctx, time) {
                            // issed?.automatic_game_timelen = time?.inSeconds;
                            return runderBottomString(
                                Util.formatCountDownTimer(time), true);
                          },
                        ),
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
