import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/models/index.dart' show PersonalInfo;
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:provider/provider.dart';

class BonusTree extends StatefulWidget {
  BonusTree({Key key}) : super(key: key);

  @override
  _BonusTreeState createState() => _BonusTreeState();
}

class _BonusTreeState extends State<BonusTree> {
  _showModal() {
    Modal(okText: 'Ok', horizontalPadding: 90, children: [
      Text('My Bonus Tree',
          style: TextStyle(
              fontFamily: FontFamily.bold,
              fontWeight: FontWeight.bold,
              color: MyTheme.blackColor,
              fontSize: ScreenUtil().setSp(70))),
      RichText(
        text: TextSpan(
            text: 'I. How to Get Bonus Tree\n',
            style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setSp(40),
                fontFamily: FontFamily.semibold,
                height: 2.5,
                fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                  text:
                      '1,Merge any 2 trees in Level 37\n2,Merge continental trees from Asia, Africa, Europe, America and Oceania;100% chance to get \n3,Stay active in the game,100%chance to get',
                  style: TextStyle(
                      color: Color.fromRGBO(83, 83, 83, 1),
                      fontSize: ScreenUtil().setSp(40),
                      height: 1.5,
                      fontFamily: FontFamily.regular,
                      fontWeight: FontWeight.w400))
            ]),
      ),
      RichText(
        text: TextSpan(
            text: 'II.100% chance to get the Bonus Tree\n',
            style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setSp(40),
                fontFamily: FontFamily.semibold,
                height: 2.5,
                fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                  text:
                      "【100% chance to get the Bonus Tree】\nbelongs to the thrid way,the progress will calculate by your personal behavior and your partner bahavior.Among them ,personal behavior including but not limited to:the trees merge times,watch video times,unlocking the city progress,the number of friends,friend's earnings.",
                  style: TextStyle(
                      color: Color.fromRGBO(83, 83, 83, 1),
                      fontSize: ScreenUtil().setSp(40),
                      height: 1.5,
                      fontFamily: FontFamily.regular,
                      fontWeight: FontWeight.w400))
            ]),
      ),
      Container(
        height: ScreenUtil().setWidth(46),
      ),
    ]).show();
  }

  @override
  Widget build(BuildContext context) {
    final double statusbarHeight =
        MediaQuery.of(context).padding.top + ScreenUtil().setWidth(20);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(200) + statusbarHeight,
            padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(60),
                statusbarHeight + ScreenUtil().setWidth(80),
                ScreenUtil().setWidth(60),
                0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => MyNavigator().navigatorPop(context),
                    child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setWidth(50),
                      child: Container(
                        width: ScreenUtil().setWidth(29),
                        height: ScreenUtil().setWidth(49),
                        child: Icon(
                          Icons.chevron_left,
                          color: MyTheme.blackColor,
                          size: ScreenUtil().setHeight(70),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(646),
                    height: ScreenUtil().setWidth(500),
                    child: Text('100% Chance To Get \nThe Bonus Tree',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontFamily.bold,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.blackColor,
                            height: 1,
                            fontSize: ScreenUtil().setSp(60))),
                  )
                ]),
          ),
          Container(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(636),
            child: Stack(overflow: Overflow.clip, children: <Widget>[
              _PosLabel(
                left: 428,
                top: 46,
                width: 226,
                height: 71,
                label: 'Total watched\nvideos',
              ),
              _PosLabel(
                left: 120,
                top: 249,
                width: 212,
                label: 'Total merged\ntrees',
              ),
              _PosLabel(
                left: 759,
                top: 249,
                width: 146,
                label: 'Unlocked\ncities',
              ),
              _PosLabel(
                left: 199,
                top: 498,
                width: 169,
                label: 'Number of\nfriends',
              ),
              _PosLabel(
                left: 707,
                top: 498,
                width: 226,
                label: 'Partners\nearning',
              ),
              Positioned(
                top: ScreenUtil().setWidth(100),
                left: ScreenUtil().setWidth(273),
                child: Image.asset(
                  'assets/image/star5.png',
                  width: ScreenUtil().setWidth(535.3),
                  height: ScreenUtil().setWidth(505.2),
                ),
              ),
              Positioned(
                  top: ScreenUtil().setWidth(212),
                  left: ScreenUtil().setWidth(399),
                  height: ScreenUtil().setWidth(259),
                  width: ScreenUtil().setWidth(282),
                  child: Selector<UserModel, PersonalInfo>(
                    selector: (context, provider) => provider.personalInfo,
                    builder: (_, PersonalInfo info, __) {
                      return CustomPaint(
                        isComplex: true,
                        willChange: false,
                        painter: _MyPainter(
                          [
                            info.videoTimesDayRatio,
                            info.deblockCityDayRatio,
                            info.profitDayRatio,
                            info.friendsNumberDayRatio,
                            info.treeComposerDayRatio
                          ],
                          strokeColor: Color.fromRGBO(89, 187, 111, 1),
                          fillColor: Color.fromRGBO(159, 230, 175, 1),
                        ),
                        size: Size(
                          ScreenUtil().setWidth(282),
                          ScreenUtil().setWidth(259),
                        ),
                      );
                    },
                  )),
            ]),
          ),
          Expanded(
              child: Container(
            width: ScreenUtil().setWidth(1080),
            padding: EdgeInsets.only(
              top: ScreenUtil().setWidth(46),
              left: ScreenUtil().setWidth(60),
              right: ScreenUtil().setWidth(60),
            ),
            decoration: BoxDecoration(
                color: MyTheme.grayColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(ScreenUtil().setWidth(40)),
                  topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                )),
            child: Column(children: [
              GestureDetector(
                onTap: () => _showModal(),
                child: Container(
                  width: ScreenUtil().setWidth(960),
                  height: ScreenUtil().setWidth(160),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/image/dividend_tree.png',
                          width: ScreenUtil().setWidth(147),
                          height: ScreenUtil().setWidth(160),
                        ),
                        Selector<UserModel, num>(
                          selector: (context, provider) =>
                              provider.personalInfo?.count_ratio ?? 0,
                          builder: (_, num count_ratio, __) {
                            return Container(
                              width: ScreenUtil().setWidth(774),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      height: ScreenUtil().setWidth(50),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('My Bonus Tree',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.semibold,
                                                    fontWeight: FontWeight.w500,
                                                    color: MyTheme.blackColor,
                                                    height: 1.0,
                                                    fontSize: ScreenUtil()
                                                        .setSp(46))),
                                            Text('${count_ratio} %',
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.semibold,
                                                    fontWeight: FontWeight.w500,
                                                    color: MyTheme.blackColor,
                                                    height: 1.0,
                                                    fontSize: ScreenUtil()
                                                        .setSp(46))),
                                          ])),
                                  Container(height: ScreenUtil().setWidth(22)),
                                  Container(
                                      height: ScreenUtil().setWidth(46),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              width: ScreenUtil().setWidth(774),
                                              height: ScreenUtil().setWidth(26),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setWidth(13))),
                                              ),
                                              child: Stack(children: <Widget>[
                                                Container(
                                                  width: ScreenUtil().setWidth(
                                                      774 *
                                                          ((count_ratio ?? 0) /
                                                              100)),
                                                  height:
                                                      ScreenUtil().setWidth(26),
                                                  decoration: BoxDecoration(
                                                    color: MyTheme.primaryColor,
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            ScreenUtil()
                                                                .setWidth(13))),
                                                  ),
                                                ),
                                              ])),
                                        ],
                                      ))
                                ],
                              ),
                            );
                          },
                        ),
                      ]),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(960),
                height: ScreenUtil().setWidth(66),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          width: ScreenUtil().setWidth(240),
                          height: ScreenUtil().setWidth(66),
                          decoration: BoxDecoration(
                              color: MyTheme.darkGrayColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(33)))),
                          child: Center(
                            child: Text('Redeem',
                                style: TextStyle(
                                    fontFamily: FontFamily.bold,
                                    fontWeight: FontWeight.bold,
                                    color: MyTheme.tipsColor,
                                    height: 1.0,
                                    fontSize: ScreenUtil().setSp(36))),
                          ))
                    ]),
              ),
              Container(
                width: ScreenUtil().setWidth(960),
                height: ScreenUtil().setWidth(70),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(560),
                        height: ScreenUtil().setWidth(50),
                        child: Text('Early bonus',
                            style: TextStyle(
                                fontFamily: FontFamily.bold,
                                fontWeight: FontWeight.bold,
                                color: MyTheme.blackColor,
                                height: 1.0,
                                fontSize: ScreenUtil().setSp(50))),
                      )
                    ]),
              ),
              _Card(
                iconName: 'Invite_friends',
                title: 'Invite friends',
                tips: 'more active partners, faster the progress',
              ),
              _Card(
                iconName: 'Improve_activity',
                title: 'Improve activity',
                tips:
                    'watch more videos and merge more trees to faster the progress.',
              ),
              _Card(
                iconName: 'Unlocked_cities',
                title: 'Unlocked cities',
                tips:
                    'more earned coins, more unlocked cities and faster the progress.',
              ),
            ]),
          ))
        ]),
      ),
      // ),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(240),
      //   child: AppBar(
      //       elevation: 0,
      //       iconTheme: IconThemeData(
      //         color: MyTheme.blackColor,
      //       ),
      //       backgroundColor: Colors.white,
      //       title: Center(
      //           child: Container(
      //         color: Colors.red,
      //         width: ScreenUtil().setWidth(746),
      //         height: ScreenUtil().setWidth(150),
      //         child: Text(
      //           '100% Chance To Get The Bonus Tree',
      //           style: TextStyle(
      //               color: MyTheme.blackColor,
      //               fontSize: ScreenUtil().setSp(70),
      //               fontFamily: FontFamily.bold,

      //               height: 1,
      //               fontWeight: FontWeight.bold),
      //         ),
      //       ))),
      // ),
    );
  }
}

class _Card extends StatelessWidget {
  final String iconName;
  final String title;
  final String tips;
  final Function onTap;

  const _Card(
      {Key key,
      @required this.iconName,
      @required this.title,
      @required this.tips,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(960),
        height: ScreenUtil().setWidth(220),
        margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(40)))),
        child: GestureDetector(
            onTap: () {
              if (onTap != null) onTap();
            },
            child: Container(
              width: ScreenUtil().setWidth(960),
              height: ScreenUtil().setWidth(220),
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(56)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(147),
                    height: ScreenUtil().setWidth(147),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/image/${iconName}.png'),
                            alignment: Alignment.center,
                            fit: BoxFit.contain)),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(46),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(title,
                          style: TextStyle(
                              fontFamily: FontFamily.semibold,
                              color: MyTheme.blackColor,
                              height: 1.0,
                              fontSize: ScreenUtil().setSp(50))),
                      Text(tips,
                          style: TextStyle(
                              fontFamily: FontFamily.regular,
                              color: MyTheme.tipsColor,
                              height: 1.0,
                              fontSize: ScreenUtil().setSp(32))),
                    ],
                  )),
                  Image.asset(
                    'assets/image/partner_right_arrow_icon.png',
                    width: ScreenUtil().setWidth(19),
                    height: ScreenUtil().setWidth(34),
                  )
                ],
              ),
            )));
  }
}

class _PosLabel extends StatelessWidget {
  final num left;
  final num top;
  final num width;
  final num height;
  final String label;
  const _PosLabel(
      {Key key,
      @required this.left,
      @required this.top,
      @required this.label,
      this.width,
      this.height = 71})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: ScreenUtil().setWidth(left),
      top: ScreenUtil().setWidth(top),
      child: Container(
        width: ScreenUtil().setWidth(width),
        height: ScreenUtil().setWidth(height),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: FontFamily.regular,
                fontWeight: FontWeight.w400,
                color: MyTheme.tipsColor,
                height: 1,
                fontSize: ScreenUtil().setSp(34))),
      ),
    );
  }
}

class _Point {
  // 水平位置
  double x;
  // 垂直位置
  double y;

  _Point({
    this.x,
    this.y,
  });
}

class _MyPainter extends CustomPainter {
  final Color strokeColor;
  final Color fillColor;
  // 顶部开始顺时针 小数
  final List<num> stageArr;
  const _MyPainter(this.stageArr, {this.strokeColor, this.fillColor})
      : assert(stageArr.length == 5);
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
  @override
  void paint(Canvas canvas, Size size) {
    print(size);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = strokeColor;

    Path path = Path();

    List<_Point> pathPoint = _getPoint(size);
    path.moveTo(pathPoint[0].x, pathPoint[0].y);
    for (var i = 0; i < pathPoint.length; i++) {
      path.lineTo(pathPoint[i].x, pathPoint[i].y);
    }
    path.close();
    canvas.drawPath(path, paint);

    paint
      ..style = PaintingStyle.fill
      ..color = fillColor;
    canvas.drawPath(path, paint);
  }

  List<_Point> _getPoint(Size size) {
    _Pentagon _pentagon = _Pentagon(heigit: size.height, width: size.width);
    List<_Point> pointArr = [
      _pentagon.point1,
      _pentagon.point2,
      _pentagon.point3,
      _pentagon.point4,
      _pentagon.point5
    ];
    List<_Point> res = [];
    _Point center = _pentagon.center;
    for (var i = 0; i < pointArr.length; i++) {
      _Point _point = pointArr[i];
      num stage = stageArr[i] / 100;
      double x = center.x + (_point.x - center.x) * stage;
      double y = center.y + (_point.y - center.y) * stage;

      res.add(_Point(x: x, y: y));
    }

    return res;
  }
}

class _Pentagon {
  // 铺满height 且中心点位于width的���点
  final double width;
  final double heigit;

  double radians;
  double long;
  // 顶部
  _Point point1;
  // 右上
  _Point point2;
  // 右下
  _Point point3;
  // 左下
  _Point point4;
  // 左上
  _Point point5;
  // 中心
  _Point center;

  _Pentagon({this.heigit, this.width}) {
    radians = heigit / (1 + cos(2 * pi / 10));
    long = 2 * radians * sin(2 * pi / 10);
    // cos 54
    double longcos54 = long * cos(2 * pi * (36) / 360);
    double longsin54 = long * sin(2 * pi * (36) / 360);

    double radianscos54 = long * cos(2 * pi * (54) / 360);
    point1 = _Point(x: width * 0.5, y: 0);
    point2 = _Point(x: width * 0.5 + longcos54, y: longsin54);
    point3 = _Point(x: width * 0.5 + radianscos54, y: heigit);
    point4 = _Point(x: width * 0.5 - radianscos54, y: heigit);
    point5 = _Point(x: width * 0.5 - longcos54, y: longsin54);
    center = _Point(x: width * 0.5, y: heigit * 0.5);
  }
}
