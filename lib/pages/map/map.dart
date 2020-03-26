import 'package:flutter/material.dart';
import 'package:luckyfruit/utils/index.dart';

import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:luckyfruit/models/index.dart' show CityInfo, DeblokCity;
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';

class _SelectorUse {
  List<CityInfo> cityInfoList;
  String cityId;
  List<DeblokCity> deblokCityList;
  TourismMap tourismMap;
  _SelectorUse({this.tourismMap})
      : cityInfoList = tourismMap.cityInfoList ?? [],
        cityId = tourismMap.cityId,
        deblokCityList = tourismMap.deblokCityList ?? [];
}

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.getPersonalInfo();
    TourismMap tourismMap = Provider.of<TourismMap>(context, listen: false);
    tourismMap.getDeblokCityList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setWidth(500),
              color: MyTheme.primaryColor,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // GestureDetector(
                    //   onTap: () => MyNavigator().navigatorPop(context),
                    //   child: Container(
                    //     width: ScreenUtil().setWidth(147),
                    //     height: ScreenUtil().setWidth(289),
                    //     child: Center(
                    //       child: Container(
                    //         width: ScreenUtil().setWidth(29),
                    //         height: ScreenUtil().setWidth(49),
                    //         child: Text('<',
                    //             style: TextStyle(
                    //                 fontFamily: FontFamily.bold,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.white,
                    //                 fontSize: ScreenUtil().setSp(60))),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                        child: Container(
                      height: ScreenUtil().setWidth(500),
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(120),
                          left: ScreenUtil().setWidth(120)),
                      child: Text(
                          'More trees your friends merge\nMore closer to the Bonus Tree!',
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(60))),
                    ))
                  ]),
            ),
            Container(
              height: ScreenUtil().setWidth(210),
            ),
            Expanded(
                child: Container(
              width: ScreenUtil().setWidth(1080),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(ScreenUtil().setWidth(40)),
                    topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                  )),
              child: Selector<TourismMap, _SelectorUse>(
                  builder: (_, _SelectorUse selectorUse, __) {
                    return ListView.builder(
                        itemCount: selectorUse.cityInfoList.length,
                        padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(146),
                            right: ScreenUtil().setWidth(87)),
                        reverse: true,
                        controller: ScrollController(
                            keepScrollOffset: true,
                            initialScrollOffset: ScreenUtil().setWidth(
                                351 * (int.parse(selectorUse.cityId) - 1))),
                        itemExtent: ScreenUtil().setWidth(351),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          CityInfo cityInfo = selectorUse.cityInfoList[index];
                          DeblokCity deblokCity = selectorUse.deblokCityList
                              .firstWhere((e) => e.city_id == cityInfo.id,
                                  orElse: () => null);
                          Color color = deblokCity == null
                              ? MyTheme.tipsColor
                              : Colors.white;
                          return Container(
                            width: ScreenUtil().setWidth(1080),
                            height: ScreenUtil().setWidth(351),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                deblokCity == null || cityInfo.bg_img == null
                                    ? Image.asset(
                                        'assets/image/deblokCity.png',
                                        width: ScreenUtil().setWidth(301),
                                        height: ScreenUtil().setWidth(220),
                                      )
                                    : Image.network(
                                        cityInfo.bg_img,
                                        width: ScreenUtil().setWidth(301),
                                        height: ScreenUtil().setWidth(220),
                                      ),
                                Container(
                                  width: ScreenUtil().setWidth(79),
                                  height: ScreenUtil().setWidth(351),
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(48),
                                    right: ScreenUtil().setWidth(26),
                                  ),
                                  child: Stack(children: <Widget>[
                                    Center(
                                        child: Container(
                                      width: ScreenUtil().setWidth(10),
                                      height: ScreenUtil().setWidth(351),
                                      color: MyTheme.darkGrayColor,
                                    )),
                                    Positioned(
                                      top: ScreenUtil().setWidth(136),
                                      left: 0,
                                      width: ScreenUtil().setWidth(79),
                                      height: ScreenUtil().setWidth(79),
                                      child: Image.asset(
                                        'assets/image/position_${deblokCity == null ? 'dis' : cityInfo.id == selectorUse.cityId ? 'now' : 'open'}.png',
                                        width: ScreenUtil().setWidth(79),
                                        height: ScreenUtil().setWidth(79),
                                      ),
                                    ),
                                    cityInfo.id == selectorUse.cityId
                                        ? Positioned(
                                            top: ScreenUtil().setWidth(86),
                                            left: ScreenUtil().setWidth(8),
                                            child: Image.asset(
                                              'assets/image/position_icon.png',
                                              width: ScreenUtil().setWidth(62),
                                              height: ScreenUtil().setWidth(91),
                                            ),
                                          )
                                        : Container(),
                                  ]),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      if (deblokCity?.is_open_box == '0') {
                                        MapPrizeModal().show(cityInfo);
                                      }
                                    },
                                    child: Image.asset(
                                      'assets/image/box_${deblokCity == null ? "disable" : deblokCity.is_open_box == '1' ? 'opend' : 'can'}.png',
                                      width: ScreenUtil().setWidth(103),
                                      height: ScreenUtil().setWidth(92),
                                    )),
                                GestureDetector(
                                    onTap: () {
                                      if (deblokCity?.is_open_box == '0') {
                                        MapPrizeModal().show(cityInfo);
                                      }
                                    },
                                    child: Container(
                                      width: ScreenUtil().setWidth(290),
                                      height: ScreenUtil().setWidth(130),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              alignment: Alignment.center,
                                              fit: BoxFit.contain,
                                              image: AssetImage(
                                                  'assets/image/city_${deblokCity == null ? 'dis' : 'open'}_bg.png'))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              deblokCity != null
                                                  ? cityInfo.continent
                                                  : cityInfo.code,
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(40),
                                                  fontFamily: FontFamily.bold,
                                                  fontWeight: FontWeight.bold,
                                                  color: color)),
                                          Text(
                                              deblokCity != null
                                                  ? cityInfo.code
                                                  : 'Lv.${int.parse(cityInfo.id) * TourismMap.LEVEL_SPLIT}',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(50),
                                                  fontFamily: FontFamily.bold,
                                                  fontWeight: FontWeight.bold,
                                                  color: color))
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          );
                        });
                  },
                  selector: (context, provider) =>
                      _SelectorUse(tourismMap: provider)),
            ))
          ],
        ),
        Positioned(
          top: ScreenUtil().setWidth(390),
          left: ScreenUtil().setWidth(60),
          child: GestureDetector(
            onTap: () => MyNavigator().pushNamed(context, 'bonusTreePage'),
            child: Container(
              width: ScreenUtil().setWidth(960),
              height: ScreenUtil().setWidth(254),
              padding: EdgeInsets.all(ScreenUtil().setWidth(45)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(40)))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(517),
                    height: ScreenUtil().setWidth(89),
                    child: Text('100% chance to get the Bonus Tree',
                        style: TextStyle(
                            fontFamily: FontFamily.semibold,
                            fontWeight: FontWeight.w500,
                            color: MyTheme.blackColor,
                            height: 1.0,
                            fontSize: ScreenUtil().setSp(46))),
                  ),
                  Container(
                      height: ScreenUtil().setWidth(46),
                      child: Selector<UserModel, num>(
                        selector: (context, provider) =>
                            provider.personalInfo?.count_ratio ?? 0,
                        builder: (_, num count_ratio, __) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(220),
                                height: ScreenUtil().setWidth(30),
                                child: Text('your progress',
                                    style: TextStyle(
                                        fontFamily: FontFamily.regular,
                                        color: MyTheme.blackColor,
                                        height: 1.0,
                                        fontSize: ScreenUtil().setSp(34))),
                              ),
                              Container(
                                  width: ScreenUtil().setWidth(500),
                                  height: ScreenUtil().setWidth(26),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(222, 220, 216, 1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(13))),
                                  ),
                                  child: Stack(children: <Widget>[
                                    Container(
                                      width: ScreenUtil().setWidth(
                                          410 * ((count_ratio ?? 0) / 100)),
                                      height: ScreenUtil().setWidth(26),
                                      decoration: BoxDecoration(
                                        color: MyTheme.primaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(13))),
                                      ),
                                    ),
                                  ])),
                              Container(
                                width: ScreenUtil().setWidth(120),
                                height: ScreenUtil().setWidth(34),
                                child: Text('$count_ratio%',
                                    style: TextStyle(
                                        fontFamily: FontFamily.regular,
                                        color: MyTheme.blackColor,
                                        height: 1.0,
                                        fontSize: ScreenUtil().setSp(34))),
                              ),
                            ],
                          );
                        },
                      ))
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: ScreenUtil().setWidth(252),
            right: ScreenUtil().setWidth(70),
            child: Container(
                width: ScreenUtil().setWidth(344),
                height: ScreenUtil().setWidth(370),
                child: Center(
                  child: Image.asset(
                    'assets/image/money_bag.png',
                    width: ScreenUtil().setWidth(344),
                    height: ScreenUtil().setWidth(279),
                  ),
                ))),
        // Map
        Positioned(
            top: ScreenUtil().setWidth(674),
            right: ScreenUtil().setWidth(357),
            child: Container(
                width: ScreenUtil().setWidth(367),
                height: ScreenUtil().setWidth(106),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      spreadRadius: 0.0,
                      blurRadius: ScreenUtil().setWidth(0),
                      offset: Offset(
                          ScreenUtil().setWidth(0), ScreenUtil().setWidth(7)),
                      color: Color.fromRGBO(235, 235, 235, 1),
                    )
                  ],
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(30))),
                ),
                child: Center(
                  child: Text('Map',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: FontFamily.bold,
                          fontWeight: FontWeight.bold,
                          color: MyTheme.blackColor,
                          height: 1.0,
                          fontSize: ScreenUtil().setSp(70))),
                )))
      ],
    );
  }
}

class MapPrizeModal {
  show(CityInfo cityInfo) {
    Modal(
        okText: 'Open',
        onCancel: () {},
        onOk: () => _nextModalShow(),
        children: <Widget>[
          Text('Welcome To \n ${cityInfo.code}',
              style: TextStyle(
                  fontFamily: FontFamily.bold,
                  color: MyTheme.blackColor,
                  height: 1.0,
                  fontSize: ScreenUtil().setSp(70))),
          Container(
            height: ScreenUtil().setWidth(45),
          ),
          Image.asset(
            'assets/image/box_can.png',
            width: ScreenUtil().setWidth(250),
            height: ScreenUtil().setWidth(188),
          ),
          Container(
            height: ScreenUtil().setWidth(45),
          ),
        ]).show();
  }

  _nextModalShow() {
    print('_nextModalShow');
    Modal(childrenBuilder: (Modal modal) => <Widget>[_MapPrize(modal: modal)])
        .show();
  }
}

class _MapPrize extends StatefulWidget {
  final Modal modal;
  _MapPrize({Key key, this.modal}) : super(key: key);

  @override
  __MapPrizeState createState() => __MapPrizeState();
}

class __MapPrizeState extends State<_MapPrize> {
  int index;
  int startInterval = 50;
  int endInterval = 400;
  int speed = 30;
  int server = 1;
  _goRun() async {
    TourismMap tourismMap = Provider.of<TourismMap>(context, listen: false);
// 有返回值 true 中分红树
    bool sign = await tourismMap.goDeblokCity();
    setState(() {
      index = 0;
      server = sign ? 1 : 0;
    });

    _runAnimation(startInterval);
  }

  _runAnimation(int interval) {
    Future.delayed(Duration(milliseconds: interval)).then((e) {
      if (interval >= endInterval && index == server) {
        _runEnd();
      } else {
        _runAnimation(interval > endInterval ? endInterval : interval + speed);
        setState(() {
          index = (index + 1) % 2;
        });
      }
    });
  }

  _runEnd() {
    // TourismMap tourismMap = Provider.of<TourismMap>(context, listen: false);
    // tourismMap.openCityBox(server);
    widget.modal.hide();
  }

  _itemRun(int _index, Widget child) {
    return Container(
      width: ScreenUtil().setWidth(260),
      height: ScreenUtil().setWidth(340),
      decoration: _index == index
          ? BoxDecoration(
              color: Color.fromRGBO(231, 230, 232, 1),
              border: Border.all(
                width: ScreenUtil().setWidth(6),
                style: BorderStyle.solid,
                color: Color.fromRGBO(41, 191, 76, 1),
              ),
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(26))))
          : BoxDecoration(),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Gift For Unlocking New City',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: FontFamily.bold,
                color: MyTheme.blackColor,
                height: 1.0,
                fontSize: ScreenUtil().setSp(70))),
        Container(
          width: ScreenUtil().setWidth(600),
          height: ScreenUtil().setWidth(340),
          margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(45)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _itemRun(
                  0,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TreeWidget(
                        imgSrc: 'assets/image/dividend_tree.png',
                        label: '38',
                        imgHeight: ScreenUtil().setWidth(199),
                        imgWidth: ScreenUtil().setWidth(182),
                        labelWidth: ScreenUtil().setWidth(72),
                      ),
                      Text('Limited Time Bonus Tree',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontFamily.regular,
                              color: MyTheme.blackColor,
                              height: 1.0,
                              fontSize: ScreenUtil().setSp(36)))
                    ],
                  )),
              _itemRun(
                  1,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Image.asset(
                        'assets/image/coin_full_bag.png',
                        width: ScreenUtil().setWidth(229),
                        height: ScreenUtil().setWidth(225),
                      ),
                      Selector<TourismMap, num>(
                          builder: (_, num boxMoney, __) {
                            return Text(Util.formatNumber(boxMoney),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: FontFamily.regular,
                                    color: MyTheme.blackColor,
                                    height: 1.0,
                                    fontSize: ScreenUtil().setSp(36)));
                          },
                          selector: (context, provider) => provider.boxMoney)
                    ],
                  )),
            ],
          ),
        ),
        AdButton(
          btnText: 'Get it',
          onCancel: () => widget.modal.hide(),
          onOk: _goRun,
        )
      ],
    );
  }
}
