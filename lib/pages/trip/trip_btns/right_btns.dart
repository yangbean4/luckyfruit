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
    String imgSrc, {
    Widget top,
    Widget bottom,
    String topString,
    String bottomString,
    Color color,
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imgSrc,
            width: ScreenUtil().setWidth(72),
            height: ScreenUtil().setWidth(72),
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
                    ? ThirdText(
                        topString,
                        color: MyTheme.redColor,
                      )
                    : top,
                bottom == null
                    ? ThirdText(
                        bottomString,
                        color: Colors.white,
                      )
                    : bottom,
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    return Selector<LuckyGroup, Tuple3<Issued, bool, bool>>(
      selector: (context, luckyGroup) =>
          Tuple3(luckyGroup.issed, true, true),
      builder: (_, data, __) {
        Issued issed = data.item1;
        bool showDouble = data.item2;
        bool showAuto = data.item3;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            });
                          } else {
                            //看广告失败,弹框提示
                            Layer.toastWarning("Number of videos has used up");
                          }
                        });
                      },
                      child: renderItem('assets/image/vadio.png',
                          bottomString: 'in ${issed?.limited_time} s',
                          top: GoldText('x${issed?.reward_multiple}',
                              iconSize: 36,
                              textSize: 36,
                              textColor: Colors.white),
                          color: Color.fromRGBO(49, 200, 84, 1)),
                    ),
                  )
                : Container(),
            isDouble
                ? renderItem(
                    'assets/image/double_glod.png',
                    topString: 'EarningsX${issed?.reward_multiple}',
                    bottom: CountdownFormatted(
                      duration: Duration(seconds: issed?.double_coin_time),
                      onFinish: () {
                        luckyGroup.doubleEnd();
                        setState(() {
                          isDouble = false;
                        });
                      },
                      builder: (ctx, time) {
                        // issed?.double_coin_time = time?.inSeconds;
                        return ThirdText(
                          Util.formatCountDownTimer(time),
                          color: Colors.white,
                        );
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
                            Layer.toastWarning("Number of videos has used up");
                          }
                        });
                      },
                      child: renderItem('assets/image/vadio.png',
                          bottomString: 'in ${issed?.automatic_game_timelen} s',
                          topString: 'Auto Merge',
                          color: Color.fromRGBO(49, 200, 84, 1)),
                    ))
                : Container(),
            isAuto
                ? renderItem(
                    'assets/image/auto.png',
                    topString: 'Auto Merge',
                    bottom: CountdownFormatted(
                      duration:
                          Duration(seconds: issed?.automatic_game_timelen),
                      onFinish: () {
                        luckyGroup.autoEnd();
                        setState(() {
                          isAuto = false;
                        });
                      },
                      builder: (ctx, time) {
                        // issed?.automatic_game_timelen = time?.inSeconds;
                        return ThirdText(
                          Util.formatCountDownTimer(time),
                          color: Colors.white,
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        );
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
