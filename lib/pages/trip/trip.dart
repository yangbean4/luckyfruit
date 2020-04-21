import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart' show UserInfo;
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/bgm.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/EarningWidget.dart';
import 'package:luckyfruit/widgets/breathe_text.dart';
import 'package:luckyfruit/widgets/coin_rain.dart';
import 'package:provider/provider.dart';

import './game/game.dart';
import './other/balloon.dart';
import './other/barrage.dart';
import './other/treasure.dart';
import './trip_btns/right_btns.dart';
import './trip_btns/trip_btns.dart';

class _SelectorUse {
  String city;
  double schedule;
  String level;

  _SelectorUse({this.level, this.city, this.schedule});
}

class Trip extends StatefulWidget {
  Trip({Key key}) : super(key: key);

  @override
  _TripState createState() => _TripState();
}

class _TripState extends State<Trip>
    with MyNavigator, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool isPlay = Bgm.isPlay;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isPlay = Bgm.isPlay;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(1080),
      height: ScreenUtil().setHeight(1920),
      child: Stack(children: <Widget>[
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
                  //城市图片
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
                  // 车辆图片
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
                  // 人物图片
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
                  Positioned(
                      right: 0,
                      top: ScreenUtil().setWidth(223),
                      child: RightBtns()),
                  Positioned(
                    bottom: ScreenUtil().setWidth(50),
                    right: 0,
                    child: GestureDetector(
                        onTap: () {
                          final _isplay = !isPlay;
                          setState(() {
                            isPlay = _isplay;
                          });
                          _isplay ? Bgm.play() : Bgm.stop();
                        },
                        child: Container(
                          width: ScreenUtil().setWidth(144),
                          height: ScreenUtil().setWidth(124),
                          child: Center(
                            child: Image.asset(
                              "assets/image/${isPlay ? 'isPlay' : 'isStop'}.png",
                              width: ScreenUtil().setWidth(60),
                              height: ScreenUtil().setWidth(50),
                            ),
                          ),
                        )),
                  ),
                  // 头部 多按钮等
                  Positioned(
                      top: ScreenUtil().setWidth(24),
                      right: 0,
                      child: // 右上角入口按钮
                          Container(
                        width: ScreenUtil().setWidth(740),
                        height: ScreenUtil().setWidth(140),
                        child: TripBtns(),
                      )),
                  Positioned(
                    top: ScreenUtil().setWidth(24),
                    child: Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: ScreenUtil().setWidth(60)),
//                        height: ScreenUtil().setWidth(280),
                        child: Selector<TourismMap, _SelectorUse>(
                            selector: (context, provider) => _SelectorUse(
                                city: provider.city,
                                schedule: provider.schedule,
                                level: provider.level),
                            builder:
                                (context, _SelectorUse _selectorUse, child) {
                              String cityName = _selectorUse.city.toUpperCase();
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width: ScreenUtil().setWidth(378),
//                                      height: ScreenUtil().setWidth(280),
                                      // 当前城市标识
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              // 切换到map的tab栏
                                              BottomNavigationBar
                                                  navigationBar = Consts
                                                      .globalKeyBottomBar
                                                      .currentWidget;
                                              navigationBar?.onTap(1);
                                            },
                                            // pushNamed(context, 'map'),
                                            child: Container(
                                              width: ScreenUtil().setWidth(378),
                                              height: ScreenUtil().setWidth(54),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    // width: ScreenUtil()
                                                    //     .setWidth(312),
                                                    margin: EdgeInsets.only(
                                                        top: ScreenUtil()
                                                            .setWidth(8)),
                                                    child: Text(
                                                      cityName,
                                                      // _selectorUse.city
                                                      //     .toUpperCase(),
                                                      overflow:
                                                          TextOverflow.visible,
                                                      style: TextStyle(
                                                          height: 1,
                                                          fontFamily:
                                                              FontFamily.black,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(
                                                                  cityName.length >=
                                                                          9
                                                                      ? 36
                                                                      : 56)),
                                                    ),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          top: ScreenUtil()
                                                              .setWidth(
                                                                  cityName.length >=
                                                                          9
                                                                      ? 0
                                                                      : 12),
                                                          left: ScreenUtil()
                                                              .setWidth(
                                                                  cityName.length >=
                                                                          9
                                                                      ? 5
                                                                      : 10)),
                                                      child: Image.asset(
                                                        'assets/image/cityarrow.png',
                                                        width: ScreenUtil()
                                                            .setWidth(21),
                                                        height: ScreenUtil()
                                                            .setWidth(
                                                                cityName.length >=
                                                                        9
                                                                    ? 20
                                                                    : 30),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // 城市下方等级
                                          Container(
                                            width: ScreenUtil().setWidth(248),
                                            margin: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(10),
                                            ),
                                            child: Selector<UserModel,
                                                    UserInfo>(
                                                builder:
                                                    (_, UserInfo user, __) {
                                                  return Text(
                                                    // 'LV.${_selectorUse.level}',
                                                    user?.nickname ?? "",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontFamily.bold,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            MyTheme.blackColor,
                                                        fontSize: ScreenUtil()
                                                            .setSp(24)),
                                                  );
                                                },
                                                selector: (context, provider) =>
                                                    provider.userInfo),
                                          ),
                                          // 等级进度条
                                          Container(
                                              width: ScreenUtil().setWidth(288),
                                              height: ScreenUtil().setWidth(36),
                                              margin: EdgeInsets.only(
                                                  bottom: ScreenUtil()
                                                      .setWidth(27)),
                                              child: Stack(
                                                children: <Widget>[
                                                  Container(
                                                    width: ScreenUtil()
                                                        .setWidth(240),
                                                    height: ScreenUtil()
                                                        .setWidth(16),
                                                    margin: EdgeInsets.only(
                                                        top: ScreenUtil()
                                                            .setWidth(10)),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          8))),
                                                    ),
                                                    child: Stack(
                                                        children: <Widget>[
                                                          Container(
                                                            width: ScreenUtil()
                                                                .setWidth(240 *
                                                                    4 *
                                                                    _selectorUse
                                                                        .schedule),
                                                            height: ScreenUtil()
                                                                .setWidth(12),
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: ScreenUtil()
                                                                  .setWidth(2),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: MyTheme
                                                                  .primaryColor,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      ScreenUtil()
                                                                          .setWidth(
                                                                              6))),
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                  Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Container(
                                                        width: ScreenUtil()
                                                            .setWidth(36),
                                                        height: ScreenUtil()
                                                            .setWidth(36),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          2),
                                                              style: BorderStyle
                                                                  .solid),
                                                          color: MyTheme
                                                              .primaryColor,
                                                          borderRadius: BorderRadius
                                                              .all(Radius.circular(
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          18))),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                              _selectorUse
                                                                  .level,
                                                              style: TextStyle(
                                                                  fontSize: ScreenUtil()
                                                                      .setWidth(
                                                                          20),
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ))
                                                ],
                                              )),
                                          // 今日分红树收益提示
                                          EarningWidget(
                                            EarningWidgetType
                                                .Earning_Type_Bonus,
                                          ),
                                          SizedBox(
                                            height: ScreenUtil().setWidth(10),
                                          ),
                                          EarningWidget(
                                            EarningWidgetType.Earning_Type_CASH,
                                          ),
                                        ],
                                      )),
                                ],
                              );
                            })),
                  ),
                ],
              ),
            ),
          ),
          // 主游戏网格视图
          Game(),
        ])),
        Positioned(
          bottom: ScreenUtil().setWidth(930),
          left: 0,
          child: Selector<MoneyGroup, double>(
            selector: (context, provider) => provider.gold,
            builder: (context, double gold, child) {
              // 金币产生速度视图
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
                    // 金币生成速度数字
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
                                      Util.formatNumber(gold),
                                      style: TextStyle(
                                          // The color must be set to white for this to work
                                          color: Colors.white,
                                          fontFamily: FontFamily.black,
                                          fontSize: ScreenUtil().setSp(68),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            ),
                            Selector<TreeGroup, double>(
                              selector: (context, povider) =>
                                  povider.makeGoldSped,
                              builder: (_, double makeGoldSped, __) {
                                return Text(
                                  '${Util.formatNumber(makeGoldSped)}/s',
                                  style: TextStyle(
                                      color: MyTheme.blackColor,
                                      fontFamily: FontFamily.bold,
                                      fontSize: ScreenUtil().setSp(46),
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    // 金币产生速度中的金币图标
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
        // 气球🎈
        Balloon(),
        // 宝箱 📦
        Treasure(),
        // 弹幕
        Barrage(),
        // 金币雨动效
        CoinRainWidget(),
      ]),
    );
  }
}
