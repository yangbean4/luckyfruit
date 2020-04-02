import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/models/index.dart'
    show PersonalInfo, GlobalDividendTree;

class Dividend extends StatefulWidget {
  Dividend({Key key}) : super(key: key);

  @override
  _DividendState createState() => _DividendState();
}

class _DividendState extends State<Dividend> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.getPersonalInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: MyTheme.grayColor,
      body: Container(
        width: ScreenUtil().setWidth(1080),
        height: ScreenUtil().setHeight(2100),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setHeight(636),
              padding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(0),
                ScreenUtil().setHeight(60),
                ScreenUtil().setWidth(0),
                ScreenUtil().setHeight(220),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment(-1.0, 0.0),
                    end: Alignment(1.0, 0.0),
                    colors: [
                      Color.fromRGBO(255, 116, 94, 1),
                      Color.fromRGBO(255, 92, 65, 1),
                    ]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(1080),
                    height: ScreenUtil().setHeight(90),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            MyNavigator().navigatorPop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(30)),
                              width: ScreenUtil().setWidth(90),
                              height: ScreenUtil().setHeight(90),
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: ScreenUtil().setHeight(90),
                              )
                              //   child: Text('<',
                              //       textAlign: TextAlign.right,
                              //       style: TextStyle(
                              //           color: Colors.white,
                              //           fontSize: ScreenUtil().setSp(60),
                              //           height: 1)),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Text('Upgrade to level 38 get Bonus Tree',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(60),
                          height: 1)),
                  Container(
                    width: ScreenUtil().setWidth(760),
                    height: ScreenUtil().setHeight(120),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(30)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setHeight(60))),
                    ),
                    child: Center(
                      child: Text(
                          'Permanent receive 20% ads earnings from "Lucky Fruit”',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontFamily.semibold,
                              color: Color.fromRGBO(255, 76, 47, 1),
                              fontSize: ScreenUtil().setSp(40),
                              height: 1)),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                left: 0,
                top: ScreenUtil().setWidth(496),
                child: Container(
                  width: ScreenUtil().setWidth(1080),
                  height: ScreenUtil().setHeight(1484),
                  padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(60),
                    ScreenUtil().setWidth(46),
                    ScreenUtil().setWidth(60),
                    ScreenUtil().setWidth(0),
                  ),
                  decoration: BoxDecoration(
                      color: MyTheme.grayColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          ScreenUtil().setWidth(40),
                        ),
                        topRight: Radius.circular(
                          ScreenUtil().setWidth(40),
                        ),
                      )),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Selector<TreeGroup, GlobalDividendTree>(
                            builder:
                                (_, GlobalDividendTree globalDividendTree, __) {
                              return _Gbox(
                                height: 440,
                                child: Container(
                                  width: ScreenUtil().setWidth(960),
                                  height: ScreenUtil().setWidth(440),
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Container(
                                        width: ScreenUtil().setWidth(960),
                                        height: ScreenUtil().setWidth(440),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(700),
                                              height:
                                                  ScreenUtil().setWidth(150),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                      '\$${globalDividendTree.amount}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontFamily.bold,
                                                          color: Color.fromRGBO(
                                                              255, 76, 47, 1),
                                                          fontSize: ScreenUtil()
                                                              .setWidth(70),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 1.2)),
                                                  Text(
                                                      "Today's earnings (Per Bonus Tree)",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .regular,
                                                          color: Colors.black,
                                                          fontSize: ScreenUtil()
                                                              .setWidth(40),
                                                          height: 1.2)),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: ScreenUtil().setWidth(960),
                                              height:
                                                  ScreenUtil().setWidth(110),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  _BounsItem(
                                                      top: '0',
                                                      bottom: 'My Bonus Tree'),
                                                  _BounsItem(
                                                      top:
                                                          '\$${globalDividendTree.today}',
                                                      bottom: 'Today earning'),
                                                  _BounsItem(
                                                      top:
                                                          '\$${globalDividendTree.total}',
                                                      bottom: 'Total earning'),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        left: ScreenUtil().setWidth(0),
                                        top: ScreenUtil().setWidth(-20),
                                        child: Container(
                                          width: ScreenUtil().setWidth(200),
                                          height: ScreenUtil().setWidth(46),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(10))),
                                            gradient: LinearGradient(
                                                begin: Alignment(0.0, -1.0),
                                                end: Alignment(0.0, 1.0),
                                                colors: [
                                                  Color.fromRGBO(
                                                      255, 110, 86, 1),
                                                  Color.fromRGBO(
                                                      255, 76, 47, 1),
                                                ]),
                                          ),
                                          child: Center(
                                            child: Text('Bonus Tree',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.semibold,
                                                    color: Colors.white,
                                                    fontSize: ScreenUtil()
                                                        .setWidth(32),
                                                    height: 1)),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: ScreenUtil().setWidth(45),
                                        top: ScreenUtil().setWidth(58),
                                        child: Container(
                                            width: ScreenUtil().setWidth(110),
                                            height: ScreenUtil().setWidth(120),
                                            child: Image.asset(
                                              'assets/tree/bonus.png',
                                              width: ScreenUtil().setWidth(110),
                                              height:
                                                  ScreenUtil().setWidth(120),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                            selector: (context, provider) =>
                                provider.globalDividendTree),
                        Container(height: ScreenUtil().setWidth(30)),
                        _Gbox(
                          height: 338,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('What is Bonus Tree?',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: FontFamily.regular,
                                        color: MyTheme.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(50),
                                        height: 1)),
                                Container(height: ScreenUtil().setWidth(44)),
                                Text(
                                    'The Bonus Tree distribute 20% of the advertising revenue to users by 100K shares and up to 100 shares every day.',
                                    style: TextStyle(
                                        fontFamily: FontFamily.regular,
                                        color: MyTheme.tipsColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(40),
                                        height: 1.2)),
                              ]),
                        ),
                        Container(height: ScreenUtil().setWidth(30)),
                        _Gbox(
                          height: 324,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text('How to get Bonus Tree?',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontFamily: FontFamily.regular,
                                        color: MyTheme.blackColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(50),
                                        height: 1)),
                                Container(height: ScreenUtil().setWidth(44)),
                                Text(
                                    '1. Merge 5 continental trees,100%chance to get it. \n' +
                                        '2.Merge any 2 trees in Level 37 \n3.Stay active in the game,100%chance to get it',
                                    style: TextStyle(
                                        fontFamily: FontFamily.regular,
                                        color: MyTheme.tipsColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: ScreenUtil().setSp(36),
                                        height: 1.2)),
                              ]),
                        ),
                        Container(height: ScreenUtil().setWidth(30)),
                        Selector<UserModel, PersonalInfo>(
                            builder: (_, PersonalInfo personalInfo, __) {
                              return _Gbox(
                                height: 312,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: ScreenUtil().setWidth(108),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                                height:
                                                    ScreenUtil().setWidth(108),
                                                width:
                                                    ScreenUtil().setWidth(660),
                                                child: Text(
                                                    'How to stay active in game to get bonus Tree?',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        color:
                                                            MyTheme.blackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: ScreenUtil()
                                                            .setWidth(50),
                                                        height: 1))),
                                            GestureDetector(
                                                onTap: () => MyNavigator()
                                                    .pushNamed(context,
                                                        'bonusTreePage'),
                                                child: Container(
                                                    width: ScreenUtil()
                                                        .setWidth(170),
                                                    height: ScreenUtil()
                                                        .setWidth(108),
                                                    child: Container(
                                                      width: ScreenUtil()
                                                          .setWidth(170),
                                                      height: ScreenUtil()
                                                          .setWidth(46),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Image.asset(
                                                            'assets/image/recoket.png',
                                                            width: ScreenUtil()
                                                                .setWidth(46),
                                                            height: ScreenUtil()
                                                                .setWidth(46),
                                                          ),
                                                          Text('Booster',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .semibold,
                                                                  color: MyTheme
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setWidth(
                                                                              32),
                                                                  height: 1.6))
                                                        ],
                                                      ),
                                                    ))),
                                          ],
                                        ),
                                      ),
                                      // 进度条
                                      Container(
                                          width: ScreenUtil().setWidth(860),
                                          height: ScreenUtil().setWidth(26),
                                          margin: EdgeInsets.only(
                                            top: ScreenUtil().setWidth(19),
                                            bottom: ScreenUtil().setWidth(26),
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                222, 220, 216, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(13))),
                                          ),
                                          child: Stack(children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(410 *
                                                  ((personalInfo?.count_ratio ??
                                                          0) /
                                                      100)),
                                              height: ScreenUtil().setWidth(26),
                                              decoration: BoxDecoration(
                                                color: MyTheme.primaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setWidth(13))),
                                              ),
                                            ),
                                          ])),
                                      Text.rich(TextSpan(children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                '${(personalInfo?.count_ratio ?? 0)} %',
                                            style: TextStyle(
                                                color: MyTheme.primaryColor,
                                                fontFamily: FontFamily.regular,
                                                height: 1,
                                                fontSize:
                                                    ScreenUtil().setWidth(30))),
                                        TextSpan(
                                            text:
                                                "completed, it's based on yours and friends' activities.",
                                            style: TextStyle(
                                                color: MyTheme.tipsColor,
                                                fontFamily: FontFamily.regular,
                                                fontWeight: FontWeight.w400,
                                                height: 1,
                                                fontSize:
                                                    ScreenUtil().setWidth(30)))
                                      ]))
                                    ]),
                              );
                            },
                            selector: (context, provider) =>
                                provider.personalInfo),
                        Container(height: ScreenUtil().setWidth(210)),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class _Gbox extends StatelessWidget {
  final Widget child;
  final num width;
  final num height;
  const _Gbox({Key key, this.child, this.width = 960, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(width),
      height: ScreenUtil().setWidth(height),
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(50),
        ScreenUtil().setWidth(46),
        ScreenUtil().setWidth(50),
        ScreenUtil().setWidth(50),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(
            ScreenUtil().setWidth(40),
          ))),
      child: child,
    );
  }
}

class _BounsItem extends StatelessWidget {
  final String top;
  final String bottom;

  const _BounsItem({Key key, this.top, this.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(top,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: FontFamily.regular,
                color: MyTheme.blackColor,
                fontWeight: FontWeight.bold,
                fontSize: ScreenUtil().setSp(46),
                height: 1)),
        Text(bottom,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: FontFamily.regular,
                color: MyTheme.tipsColor,
                fontSize: ScreenUtil().setSp(40),
                height: 1)),
      ],
    );
  }
}
