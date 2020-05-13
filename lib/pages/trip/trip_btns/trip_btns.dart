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

  Widget getItem(String imgSrc, label,
      {double labelWith,
      GlobalKey key,
      Function onTap,
      bool showMark = false,
      bool showLock = false,
      bool showFree = false}) {
    Widget item = Container(
      width: ScreenUtil().setWidth(142),
      // height: ScreenUtil().setWidth(130),
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
      key: key,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(142),
            height: ScreenUtil().setWidth(142),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   shape: BoxShape.circle,
            // ),
            child: Stack(alignment: AlignmentDirectional.center, children: [
              Selector<LuckyGroup, bool>(
                  selector: (context, provider) =>
                      provider.showLuckyWheelLockIcon,
                  builder: (_, bool show, __) {
                    return GestureDetector(
                      onTap: onTap,
                      child: showLock && !show
                          ? Stack(overflow: Overflow.visible, children: [
                              Positioned(
                                  left: ScreenUtil().setWidth(-78),
                                  top: ScreenUtil().setWidth(-78),
                                  // child: Center(
                                  child: Lottie.asset(
                                    'assets/lottiefiles/lucky_wheel/data.json',
                                    width: ScreenUtil().setWidth(300),
                                    height: ScreenUtil().setWidth(300),
                                  ))
                            ])
                          : Image.asset(
                              imgSrc,
                              width: ScreenUtil().setWidth(142),
                              height: ScreenUtil().setWidth(142),
                            ),
                    );
                  }),
              showMark
                  ? Positioned(
                      top: ScreenUtil().setWidth(10),
                      right: ScreenUtil().setWidth(10),
                      child: Container(
                        width: ScreenUtil().setWidth(35),
                        height: ScreenUtil().setWidth(35),
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: ScreenUtil().setWidth(2),
                              style: BorderStyle.solid,
                              color: Colors.white),
                          gradient: LinearGradient(
                              begin: Alignment(-1.0, 0.0),
                              end: Alignment(1.0, 0.0),
                              colors: <Color>[
                                Color.fromRGBO(238, 71, 31, 1),
                                Color.fromRGBO(201, 79, 81, 1)
                              ]),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
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
                                    width: ScreenUtil().setWidth(142),
                                    height: ScreenUtil().setWidth(142),
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
            top: ScreenUtil().setWidth(118),
            child: Center(
              child: Container(
                height: ScreenUtil().setWidth(32),
                width: ScreenUtil().setWidth(142),
                child: label is Widget
                    ? label
                    : Center(
                        child: Stack(children: <Widget>[
                        Text(
                          label,
                          style: TextStyle(
                              height: 1,
                              foreground: new Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = ScreenUtil().setWidth(8)
                                ..color = Color.fromRGBO(196, 61, 27, 1),
                              fontFamily: FontFamily.bold,
                              fontSize: ScreenUtil().setSp(30),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          label,
                          style: TextStyle(
                              color: Colors.white,
                              height: 1,
                              fontFamily: FontFamily.bold,
                              fontSize: ScreenUtil().setSp(30),
                              fontWeight: FontWeight.bold),
                        )
                      ])),
              ),
            ),
          ),
          showFree
              ? Positioned(
                  top: ScreenUtil().setWidth(-16),
                  left: ScreenUtil().setWidth(-40),
                  child: Image.asset(
                    'assets/image/top_btn_phone_free.png',
                    width: ScreenUtil().setWidth(85),
                    height: ScreenUtil().setWidth(73),
                  ))
              : Container()
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
    return Selector<UserModel, bool>(
      selector: (context, provider) => provider.value.is_m != 0,
      builder: (_, bool show, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Selector<LuckyGroup, LuckyGroup>(
              selector: (context, provider) => provider,
              builder: (_, LuckyGroup selectorUse, __) {
                return getItem(
                  'assets/image/top_btn_get.png',
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
                            String label = Util.formatCountDownTimer(duration);

                            return Center(
                                child: Stack(children: <Widget>[
                              Text(
                                label,
                                style: TextStyle(
                                    height: 1,
                                    foreground: new Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = ScreenUtil().setWidth(8)
                                      ..color = Color.fromRGBO(196, 61, 27, 1),
                                    fontFamily: FontFamily.bold,
                                    fontSize: ScreenUtil().setSp(30),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                label,
                                style: TextStyle(
                                    color: Colors.white,
                                    height: 1,
                                    fontFamily: FontFamily.bold,
                                    fontSize: ScreenUtil().setSp(30),
                                    fontWeight: FontWeight.bold),
                              )
                            ]));

                            // Center(
                            //   child: Text(
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //         color: Colors.white,
                            //         height: 1,
                            //         fontFamily: FontFamily.bold,
                            //         fontSize: ScreenUtil().setSp(20),
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // );
                          })
                      : 'Get',
                  onTap: () {
                    if (!isCountdown) {
                      double _getGoldCountdown =
                          Provider.of<TreeGroup>(context, listen: false)
                              .makeGoldSped;
                      num coin = selectorUse.receriveTime * _getGoldCountdown;
                      _showWindow(coin, () {
                        BurialReport.report('collect_coin', {
                          'type':
                              selectorUse.receriveTime ~/ 60 == 30 ? '1' : '2'
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
            show
                ? FreePhone(
                    child: Selector<UserModel, bool>(
                        selector: (context, provider) => provider.freePhoneMask,
                        builder: (_, bool show, __) {
                          return getItem(
                              'assets/image/top_btn_phone.png', 'Phone',
                              showMark: show, showFree: true);
                        }),
                  )
                : Container(),

            show
                ? Selector<LuckyGroup, bool>(
                    selector: (context, provider) => provider.showLuckyWheelDot,
                    builder: (_, bool show, __) {
                      return getItem(
                        'assets/image/top_btn_spin.png',
                        'Spin',
                        showMark: show,
                        showLock: true,
                        key: Consts.globalKeyWheel,
                        onTap: () {
                          BurialReport.report('c_wheel_entr', {});
                          BurialReport.report('page_imp', {'page_code': '007'});
                          Layer.showLuckyWheel(context);
                        },
                      );
                    })
                : Container(),

            show
                ? getItem(
                    'assets/image/top_btn_rank.png',
                    'Rank',
                    onTap: () {
                      print('rank');
                      MyNavigator().pushNamed(context, "RankPage");
                    },
                  )
                : Container(),
            // show
            //     ? getItem(
            //         'assets/image/top_btn_help.png',
            //         'HOW TO PLAY',
            //         onTap: () {
            //           BurialReport.report('page_imp', {'page_code': '010'});
            //           MyNavigator().pushNamed(context, "howToPlay");
            //         },
            //       )
            //     : Container(),
          ],
        );
      },
    );
  }
}
