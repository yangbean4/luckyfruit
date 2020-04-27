import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:luckyfruit/config/app.dart'
    show App, Consts, Event_Name, TreeType;
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/utils/method_channel.dart';
import 'package:luckyfruit/widgets/count_down.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:provider/provider.dart';

import './free_phone.dart';
// 右上角的一些入口玩法

class _SelectorUse {
  Duration getGoldCountdown;
  Function receiveCoin;
  int receriveTime;

  _SelectorUse({this.getGoldCountdown, this.receiveCoin, this.receriveTime});
}

class TripBtns extends StatefulWidget {
  TripBtns({Key key}) : super(key: key);

  @override
  _TripBtnsState createState() => _TripBtnsState();
}

class _TripBtnsState extends State<TripBtns> {
  String goldLabel = '';
  bool isCountdown = true;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((c) {
    //   Duration _getGoldCountdown =
    //       Provider.of<LuckyGroup>(context, listen: false).getGoldCountdown;
    //   if (_getGoldCountdown != null) {
    //     setState(() {
    //       getGoldCountdown = _getGoldCountdown;
    //       isCountdown = true;
    //     });
    //   }
    // });
  }

  Widget getItem(
    String imgSrc,
    label, {
    Color labelColor,
    double labelWith,
    GlobalKey key,
    Function onTap,
    bool showMark = false,
    bool showLock = false,
  }) {
    Widget item = Container(
      width: ScreenUtil().setWidth(130),
      // height: ScreenUtil().setWidth(130),
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
      key: key,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(130),
            height: ScreenUtil().setWidth(130),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Stack(alignment: AlignmentDirectional.center, children: [
              Selector<LuckyGroup, bool>(
                  selector: (context, provider) =>
                      provider.showLuckyWheelLockIcon,
                  builder: (_, bool show, __) {
                    return GestureDetector(
                      onTap: onTap,
                      child: showLock && !show
                          ? Lottie.asset(
                              'assets/lottiefiles/lucky_wheel.json',
                              width: ScreenUtil().setWidth(90),
                              height: ScreenUtil().setWidth(90),
                            )
                          : Image.asset(
                              imgSrc,
                              width: ScreenUtil().setWidth(90),
                              height: ScreenUtil().setWidth(90),
                            ),
                    );
                  }),
              showMark
                  ? Selector<LuckyGroup, bool>(
                      selector: (context, provider) =>
                          provider.showLuckyWheelDot,
                      builder: (_, bool show, __) {
                        return show
                            ? Positioned(
                                top: ScreenUtil().setWidth(10),
                                right: ScreenUtil().setWidth(10),
                                child: Container(
                                  width: ScreenUtil().setWidth(24),
                                  height: ScreenUtil().setWidth(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment(-1.0, 0.0),
                                        end: Alignment(1.0, 0.0),
                                        colors: <Color>[
                                          Color.fromRGBO(253, 217, 76, 1),
                                          Color.fromRGBO(249, 93, 76, 1),
                                        ]),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : Container();
                      })
                  : Container(),
              showLock
                  ? Selector<LuckyGroup, bool>(
                      selector: (context, provider) =>
                          provider.showLuckyWheelLockIcon,
                      builder: (_, bool show, __) {
                        return show
                            ? Stack(
                                alignment: AlignmentDirectional.center,
                                children: <Widget>[
                                  Container(
                                    width: ScreenUtil().setWidth(130),
                                    height: ScreenUtil().setWidth(130),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/image/lucky_wheel_lock.png",
                                    width: ScreenUtil().setWidth(32),
                                    height: ScreenUtil().setWidth(40),
                                  )
                                ],
                              )
                            : Container();
                      })
                  : Container(),
            ]),
          ),
          Positioned(
            top: ScreenUtil().setWidth(110),
            left: ScreenUtil().setWidth(130 - (labelColor == null ? 146 : 80)) /
                2,
            child: Center(
              child: Container(
                height: ScreenUtil().setWidth(32),
                width: ScreenUtil().setWidth(labelColor == null ? 146 : 80),
                decoration: BoxDecoration(
                    color: labelColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(10)))),
                child: label is Widget
                    ? label
                    : labelColor == null
                        ? Center(
                            child: Stack(children: <Widget>[
                            Text(
                              label,
                              style: TextStyle(
                                  height: 1,
                                  foreground: new Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = ScreenUtil().setWidth(3)
                                    ..color = Colors.white,
                                  fontFamily: FontFamily.bold,
                                  fontSize: ScreenUtil().setSp(24),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              label,
                              style: TextStyle(
                                  color: labelColor == null
                                      ? MyTheme.blackColor
                                      : Colors.white,
                                  height: 1,
                                  fontFamily: FontFamily.bold,
                                  fontSize: ScreenUtil().setSp(24),
                                  fontWeight: FontWeight.bold),
                            )
                          ]))
                        : Center(
                            child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: labelColor == null
                                    ? MyTheme.blackColor
                                    : Colors.white,
                                height: 1,
                                fontFamily: FontFamily.bold,
                                fontSize: ScreenUtil().setSp(24),
                                fontWeight: FontWeight.bold),
                          )),
              ),
            ),
          )
        ],
      ),
    );
    return item;
  }

  _showWindow(num glod, Function onOk) {
    Modal(
        okText: 'Claim',
        onOk: onOk,
        dismissDurationInMilliseconds: Modal.DismissDuration,
        childrenBuilder: (modal) => <Widget>[
              Container(
                height: ScreenUtil().setWidth(70),
                child: Text(
                  "Awesome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.blackColor,
                      height: 1,
                      fontFamily: FontFamily.bold,
                      fontSize: ScreenUtil().setSp(70),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(height: ScreenUtil().setWidth(20)),
              Image.asset(
                'assets/image/coin_full_bag.png',
                width: ScreenUtil().setWidth(229),
                height: ScreenUtil().setWidth(225),
              ),
              // SecondaryText(
              //   "You‘ve got",
              //   color: MyTheme.blackColor,
              // ),
              Container(height: ScreenUtil().setWidth(14)),

              Text(
                "You‘ve got",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: MyTheme.blackColor,
                    height: 1,
                    fontFamily: FontFamily.regular,
                    fontSize: ScreenUtil().setSp(50),
                    fontWeight: FontWeight.w400),
              ),
              Container(height: ScreenUtil().setWidth(45)),
              GoldText(Util.formatNumber(glod), textSize: 66),
              Container(height: ScreenUtil().setWidth(45)),
            ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Selector<LuckyGroup, LuckyGroup>(
          selector: (context, provider) => provider,
          builder: (_, LuckyGroup selectorUse, __) {
            return getItem(
              'assets/image/gold_right_btn.png',
              isCountdown && selectorUse.getGoldCountdown != null
                  ? CountdownFormatted(
                      duration: selectorUse.getGoldCountdown,
                      onFinish: () {
                        setState(() {
                          BurialReport.report('coin_ready', {});
                          isCountdown = false;
                        });
                      },
                      builder: (context, Duration duration) {
                        selectorUse.setGoldContDownDuration(duration);
                        return Center(
                          child: Text(
                            Util.formatCountDownTimer(duration),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                height: 1,
                                fontFamily: FontFamily.bold,
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      })
                  : 'GET',
              labelColor: Color(0xFFFF8109),
              onTap: () {
                if (!isCountdown) {
                  double _getGoldCountdown =
                      Provider.of<TreeGroup>(context, listen: false)
                          .makeGoldSped;
                  num coin = selectorUse.receriveTime * _getGoldCountdown;
                  _showWindow(coin, () {
                    BurialReport.report('collect_coin', {
                      'type': selectorUse.receriveTime ~/ 60 == 30 ? '1' : '2'
                    });

                    selectorUse.receiveCoin(coin);
                    setState(() {
                      isCountdown = true;
                    });
                  });
                }
              },
            );
          },
        ),
        Selector<UserModel, bool>(
          selector: (context, provider) => provider.value.is_m != 0,
          builder: (_, bool show, __) {
            return show
                ? FreePhone(
                    child: getItem('assets/image/phone.png', 'FREE',
                        labelColor: Color(0xFFF87A46)),
                  )
                : Container();
          },
        ),
        getItem(
          'assets/image/spin.png',
          'SPIN',
          showMark: true,
          showLock: true,
          key: Consts.globalKeyWheel,
          onTap: () {
            BurialReport.report('c_wheel_entr', {});
            BurialReport.report('page_imp', {'page_code': '007'});
            Layer.showLuckyWheel(context);
          },
        ),
        getItem(
          'assets/image/rank.png',
          'RANK',
          onTap: () {
            print('rank');
            MyNavigator().pushNamed(context, "RankPage");
          },
        ),
        getItem(
          'assets/image/help.png',
          'HOW TO PLAY',
          onTap: () {
            BurialReport.report('page_imp', {'page_code': '010'});
            MyNavigator().pushNamed(context, "howToPlay");
          },
        ),
      ],
    );
  }
}
