import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import './game/game.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/widgets/breathe_text.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import './trip_btns/trip_btns.dart';
import 'package:luckyfruit/widgets/gradient_text.dart';

class _SelectorUse {
  String city;
  double schedule;
  int level;
  _SelectorUse({this.level, this.city, this.schedule});
}

class Trip extends StatefulWidget {
  Trip({Key key}) : super(key: key);

  @override
  _TripState createState() => _TripState();
}

class _TripState extends State<Trip> with MyNavigator {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
          Expanded(
            child: Container(
              width: ScreenUtil().setWidth(1080),
              // height: ,
              child: Stack(
                children: <Widget>[
                  Selector<TourismMap, String>(
                    selector: (context, provider) => provider.cityImgSrc,
                    builder: (context, String cityImgSrc, child) {
                      return Container(
                        width: ScreenUtil().setWidth(1080),
                        // height: ScreenUtil().setWidth(812),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          alignment: Alignment.center,
                          image: AssetImage(cityImgSrc),
                          fit: BoxFit.cover,
                        )),
                      );
                    },
                  ),
                  Selector<TourismMap, String>(
                    selector: (context, provider) => provider.carImgSrc,
                    builder: (context, String carImgSrc, child) {
                      return Positioned(
                        bottom: ScreenUtil().setWidth(46),
                        left: ScreenUtil().setWidth(256),
                        child: Image.asset(
                          carImgSrc,
                          width: ScreenUtil().setWidth(687),
                          height: ScreenUtil().setWidth(511),
                        ),
                      );
                    },
                  ),
                  Selector<TourismMap, String>(
                    selector: (context, provider) => provider.manImgSrc,
                    builder: (context, String manImgSrc, child) {
                      return Positioned(
                        bottom: ScreenUtil().setWidth(88),
                        left: ScreenUtil().setWidth(88),
                        child: Image.asset(
                          manImgSrc,
                          width: ScreenUtil().setWidth(172),
                          height: ScreenUtil().setWidth(352),
                        ),
                      );
                    },
                  ),

                  // 头部 多按钮等
                  Positioned(
                    top: ScreenUtil().setWidth(92),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(60)),
                        height: ScreenUtil().setWidth(250),
                        child: Selector<TourismMap, _SelectorUse>(
                            selector: (context, provider) => _SelectorUse(
                                city: provider.city,
                                schedule: provider.schedule,
                                level: provider.level),
                            builder:
                                (context, _SelectorUse _selectorUse, child) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width: ScreenUtil().setWidth(378),
                                      height: ScreenUtil().setWidth(250),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () =>
                                                pushNamed(context, 'map'),
                                            child: Container(
                                              width: ScreenUtil().setWidth(378),
                                              height: ScreenUtil().setWidth(54),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    _selectorUse.city
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        height: 1,
                                                        fontFamily:
                                                            FontFamily.black,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil()
                                                            .setSp(74)),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: ScreenUtil()
                                                              .setWidth(9),
                                                          left: ScreenUtil()
                                                              .setWidth(12)),
                                                      child: Image.asset(
                                                        'assets/image/cityarrow.png',
                                                        width: ScreenUtil()
                                                            .setWidth(21),
                                                        height: ScreenUtil()
                                                            .setWidth(35),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: ScreenUtil().setWidth(248),
                                            margin: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(10),
                                            ),
                                            child: Text(
                                              'LV.${_selectorUse.level}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: FontFamily.bold,
                                                  fontWeight: FontWeight.bold,
                                                  color: MyTheme.blackColor,
                                                  fontSize:
                                                      ScreenUtil().setSp(24)),
                                            ),
                                          ),
                                          Container(
                                            width: ScreenUtil().setWidth(248),
                                            height: ScreenUtil().setWidth(20),
                                            margin: EdgeInsets.only(
                                                bottom:
                                                    ScreenUtil().setWidth(36)),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setWidth(10))),
                                            ),
                                            child: Container(
                                                width: ScreenUtil().setWidth(
                                                    248 /
                                                        100 *
                                                        _selectorUse.schedule),
                                                height:
                                                    ScreenUtil().setWidth(20),
                                                decoration: BoxDecoration(
                                                  color: MyTheme.yellowColor,
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          ScreenUtil()
                                                              .setWidth(10))),
                                                )),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                pushNamed(context, 'dividend'),
                                            child: Container(
                                              width: ScreenUtil().setWidth(378),
                                              height: ScreenUtil().setWidth(96),
                                              padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setWidth(24),
                                              ),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                alignment: Alignment.center,
                                                image: AssetImage(
                                                    'assets/image/dividend.png'),
                                                fit: BoxFit.cover,
                                              )),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/dividend_tree.png',
                                                    width: ScreenUtil()
                                                        .setWidth(44),
                                                    height: ScreenUtil()
                                                        .setWidth(48),
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text('TODAY',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          24),
                                                              fontFamily:
                                                                  FontFamily
                                                                      .bold,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: MyTheme
                                                                  .redColor)),
                                                      Selector<LuckyGroup,
                                                              double>(
                                                          selector: (context,
                                                                  provider) =>
                                                              provider.dividend,
                                                          builder: (context,
                                                              double dividend,
                                                              child) {
                                                            return Text(
                                                                '\$${Util.formatNumber(dividend)}',
                                                                style: TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            32),
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .bold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: MyTheme
                                                                        .redColor));
                                                          })
                                                    ],
                                                  )),
                                                  Image.asset(
                                                    'assets/image/dividend_btn.png',
                                                    width: ScreenUtil()
                                                        .setWidth(123),
                                                    height: ScreenUtil()
                                                        .setWidth(64),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: ScreenUtil().setWidth(960 - 378),
                                    height: ScreenUtil().setWidth(106),
                                    child: TripBtns(),
                                  )
                                ],
                              );
                            })),
                  ),
                ],
              ),
            ),
          ),
          Game(),
        ])),
        Positioned(
          bottom: ScreenUtil().setWidth(930),
          left: 0,
          child: Selector<MoneyGroup, Map<String, double>>(
            selector: (context, provider) => ({
              'makeGoldSped': provider.makeGoldSped,
              'gold': provider.gold,
            }),
            builder: (context, Map<String, double> map, child) {
              return Container(
                width: ScreenUtil().setWidth(600),
                height: ScreenUtil().setWidth(150),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(ScreenUtil().setWidth(75)))),
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: 0,
                      child: Container(
                        width: ScreenUtil().setWidth(400),
                        height: ScreenUtil().setWidth(150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BreatheAnimation(
                              child: Container(
                                  width: ScreenUtil().setWidth(400),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) =>
                                        LinearGradient(colors: [
                                      Color.fromRGBO(255, 172, 30, 1),
                                      Color.fromRGBO(255, 131, 30, 1),
                                    ]).createShader(Rect.fromLTWH(
                                            0, 0, bounds.width, bounds.height)),
                                    child: Text(
                                      Util.formatNumber(map['gold']),
                                      style: TextStyle(
                                          // The color must be set to white for this to work
                                          color: Colors.white,
                                          fontFamily: FontFamily.black,
                                          fontSize: ScreenUtil().setSp(68),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                            Text(
                              '${Util.formatNumber(map['makeGoldSped'])}/s',
                              style: TextStyle(
                                  color: MyTheme.blackColor,
                                  fontFamily: FontFamily.bold,
                                  fontSize: ScreenUtil().setSp(46),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: ScreenUtil().setWidth(-20),
                      left: ScreenUtil().setWidth(60),
                      child: Image.asset(
                        'assets/image/gold.png',
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setWidth(120),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
