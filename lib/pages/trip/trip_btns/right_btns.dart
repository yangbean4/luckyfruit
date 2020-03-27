import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/widgets/count_down.dart';
import 'package:luckyfruit/widgets/shake_button.dart';
import 'package:luckyfruit/theme/index.dart';

class RightBtns extends StatefulWidget {
  RightBtns({Key key}) : super(key: key);

  @override
  _RightBtnsState createState() => _RightBtnsState();
}

class _RightBtnsState extends State<RightBtns>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 是否显示双倍的入口按钮
  bool showDouble = false;
  // 当前是双倍
  bool isDouble = false;

  bool showAuto = false;

  bool isAuto = false;
  LuckyGroup luckyGroup;
  // 下发的配置
  Issued issed;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LuckyGroup _luckyGroup = Provider.of<LuckyGroup>(context);

    if (_luckyGroup != null) {
      Issued _issed = _luckyGroup.issed;
      setState(() {
        luckyGroup = _luckyGroup;
        issed = _issed;
      });
      if (issed?.game_timeLen != null) {
        Future.delayed(Duration(seconds: issed?.game_timeLen)).then((e) {
          luckyGroup.adTimeCheck(Duration(seconds: _issed?.two_adSpace), () {
            if (mounted) {
              setState(() {
                showDouble = true;
              });
            }

            // 设置的时间后 隐藏
            Future.delayed(Duration(seconds: issed?.double_coin_remain_time))
                .then((e) {
              if (mounted) {
                setState(() {
                  showDouble = false;
                });
              }
            });
          });
        });
      }

      if (issed?.automatic_game_timelen != null) {
        Future.delayed(Duration(seconds: issed?.automatic_game_timelen))
            .then((e) {
          luckyGroup.adTimeCheck(
              Duration(seconds: _issed?.automatic_two_adSpace), () {
            if (mounted) {
              setState(() {
                showAuto = true;
              });
            }

            // 设置的时间后 隐藏
            Future.delayed(Duration(seconds: issed?.automatic_remain_time))
                .then((e) {
              if (mounted) {
                setState(() {
                  showAuto = false;
                });
              }
            });
          });
        });
      }
    }
  }

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
                    luckyGroup.doubleStart();
                    setState(() {
                      showDouble = false;
                      isDouble = true;
                    });
                  },
                  child: renderItem('assets/image/vadio.png',
                      bottomString: 'in ${issed?.limited_time} s',
                      top: GoldText('x${issed?.reward_multiple}',
                          iconSize: 36, textSize: 36, textColor: Colors.white),
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
                      showDouble = false;
                      isDouble = false;
                    });
                  },
                  builder: (ctx, time) {
                    return ThirdText(
                      time,
                      color: Colors.white,
                    );
                  },
                ),
              )
            : Container(),
        showAuto
            ? _ShakeAnimation(
                animateTime: Duration(
                    milliseconds: (issed?.automatic_remain_time ?? 10) * 1000),
                child: GestureDetector(
                  onTap: () {
                    luckyGroup.autoStart();
                    setState(() {
                      showAuto = false;
                      isAuto = true;
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
                  duration: Duration(seconds: issed?.automatic_game_timelen),
                  onFinish: () {
                    luckyGroup.autoEnd();
                    setState(() {
                      showAuto = false;
                      isAuto = false;
                    });
                  },
                  builder: (ctx, time) {
                    return ThirdText(
                      time,
                      color: Colors.white,
                    );
                  },
                ),
              )
            : Container(),
      ],
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
