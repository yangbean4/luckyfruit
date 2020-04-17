import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart' show App, Consts, TreeType;
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/utils/index.dart';
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
  }) {
    Widget item = Container(
      width: ScreenUtil().setWidth(96),
      height: ScreenUtil().setWidth(96),
      key: key,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(96),
            height: ScreenUtil().setWidth(96),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Stack(alignment: AlignmentDirectional.center, children: [
              Image.asset(
                imgSrc,
                width: ScreenUtil().setWidth(66),
                height: ScreenUtil().setWidth(66),
              ),
              showMark
                  ? Positioned(
                      top: ScreenUtil().setWidth(0),
                      right: ScreenUtil().setWidth(0),
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
                  : Container()
            ]),
          ),
          Positioned(
            top: ScreenUtil().setWidth(86),
            left:
                ScreenUtil().setWidth(96 - (labelColor == null ? 146 : 80)) / 2,
            child: Center(
              child: Container(
                height: ScreenUtil().setWidth(20),
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
                                  fontSize: ScreenUtil().setSp(20),
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
                                  fontSize: ScreenUtil().setSp(20),
                                  fontWeight: FontWeight.bold),
                            )
                          ]))
                        : Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: labelColor == null
                                    ? MyTheme.blackColor
                                    : Colors.white,
                                height: 1,
                                fontFamily: FontFamily.bold,
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.bold),
                          ),
              ),
            ),
          )
        ],
      ),
    );
    return onTap == null
        ? item
        : GestureDetector(
            onTap: onTap,
            child: item,
          );
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Selector<LuckyGroup, LuckyGroup>(
          selector: (context, provider) => provider,
          builder: (_, LuckyGroup selectorUse, __) {
            return getItem(
              'assets/image/gold.png',
              isCountdown && selectorUse.getGoldCountdown != null
                  ? CountdownFormatted(
                      duration: selectorUse.getGoldCountdown,
                      onFinish: () {
                        setState(() {
                          isCountdown = false;
                        });
                      },
                      builder: (context, Duration duration) {
                        selectorUse.setGoldContDownDuration(duration);
                        return Text(
                          Util.formatCountDownTimer(duration),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              height: 1,
                              fontFamily: FontFamily.bold,
                              fontSize: ScreenUtil().setSp(20),
                              fontWeight: FontWeight.bold),
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
        FreePhone(
          child: getItem('assets/image/phone.png', 'FREE',
              labelColor: Color(0xFFF87A46)),
        ),
        getItem(
          'assets/image/spin.png',
          'SPIN',
          showMark: true,
          key: Consts.globalKeyWheel,
          onTap: () {
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
            MyNavigator().pushNamed(context, "howToPlay");
          },
        ),
      ],
    );
  }
}
