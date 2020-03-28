import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/partnerSubordinateList.dart';
import 'package:luckyfruit/models/partnerWrap.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/compatible_avatar_widget.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:provider/provider.dart';

class Partner extends StatefulWidget {
  Partner({Key key}) : super(key: key);

  @override
  PartnerState createState() => PartnerState();
}

class PartnerState extends State<Partner> {
  String testJson = """
  {
        "friends": {
            "lower1": [
                {
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 1,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 1,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                }
            ],
            "lower2": [{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                }],
            "pending": [
                {
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                },{
                    "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
                    "name": "nickname",
                    "fb_login": 0,
                    "date": "03-05",
                    "level": 21
                }
            ]
        },
        "fb_no_login": 15,
        "direct_profit": 10,
        "indirect_profit": 20,
        "total_profit": 30,
        "friends_total": 25,
        "fb_no_login_all_profit": 199,
        "fb_login_today_profit": 299,
        "fb_login_history_profit": 119,
        "superior": {
            "avatar": "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
            "name": "superior name",
            "fb_login": 1,
            "date": "03-05",
            "level": 34,
            "today_profit": "100.00"
        }
    }
  """;
  PartnerWrap _partnerWrap;
  @override
  void initState() {
    super.initState();

    getInvitationListInfoData().then((res) {
      setState(() {
        _partnerWrap = res;
      });
    });
  }

  Future<PartnerWrap> getInvitationListInfoData() async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    // dynamic partnerMap =
    //     await Service().getPartnerListInfo({'acct_id': treeGroup.acct_id});
    // PartnerWrap partnerWrap = PartnerWrap.fromJson(partnerMap);
    PartnerWrap partnerWrap = PartnerWrap.fromJson(json.decode(testJson));
    // 测试空白页面使用
    // await Future.delayed(Duration(seconds: 3));
    return partnerWrap;
  }

  List<num> getStateInfoOfPartnerEarning(num historyProfit) {
    if (historyProfit == null) {
      return [0, 0, 0, 0];
    }
    int flag = 0;

    for (var i = 0; i < Consts.StageInfoListOfPartner.length; i++) {
      if (historyProfit - Consts.StageInfoListOfPartner[i][2] <= 0) {
        break;
      }
      flag++;
    }
    return [
      Consts.StageInfoListOfPartner[flag][0],
      Consts.StageInfoListOfPartner[flag][1],
      Consts.StageInfoListOfPartner[flag][2],
      historyProfit / Consts.StageInfoListOfPartner[flag][2] * 100.0
    ];
  }

  Widget getAvatarWidgetListOfFriends(int index) {
    String imageUrl = "";

    if (_partnerWrap?.friends != null &&
        index < getAvatarListOfFriends(_partnerWrap.friends).length) {
      imageUrl = getAvatarListOfFriends(_partnerWrap.friends)[index];
    }

    return ClipOval(
      child: CompatibleNetworkAvatarWidget(
        imageUrl,
        defaultImageUrl: "assets/image/rank_page_portrait_default.png",
        width: ScreenUtil().setWidth(100),
        height: ScreenUtil().setWidth(100),
        fit: BoxFit.cover,
      ),
    );
  }

  List<String> getAvatarListOfFriends(PartnerSubordinateList friends) {
    List<String> resultList = [];
    for (var i = 0; friends.lower1 != null && i < friends.lower1.length; i++) {
      resultList.add(friends.lower1[i]?.avatar ?? "");
    }
    for (var i = 0; friends.lower2 != null && i < friends.lower2.length; i++) {
      resultList.add(friends.lower2[i]?.avatar ?? "");
    }
    for (var i = 0;
        friends.pending != null && i < friends.pending.length;
        i++) {
      resultList.add(friends.pending[i]?.avatar ?? "");
    }

    return resultList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            color: Color(0xFFEFEEF3),
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(2300),
            child: Stack(
              children: [
                Container(
                  width: ScreenUtil().setWidth(1080),
                  height: ScreenUtil().setWidth(480),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(-1.0, 0.0),
                        end: Alignment(1.0, 0.0),
                        colors: [
                          Color.fromRGBO(103, 228, 127, 1),
                          Color.fromRGBO(59, 206, 100, 1),
                        ]),
                  ),
                  child: Stack(children: [
                    Positioned(
                      bottom: ScreenUtil().setWidth(50),
                      right: ScreenUtil().setWidth(60),
                      child: Image.asset(
                        'assets/image/money_bag.png',
                        width: ScreenUtil().setWidth(280),
                        height: ScreenUtil().setWidth(226),
                      ),
                    ),
                    Positioned(
                      bottom: ScreenUtil().setWidth(40),
                      left: ScreenUtil().setWidth(90),
                      child: Image.asset(
                        'assets/image/partner_gold_icon.png',
                        width: ScreenUtil().setWidth(140),
                        height: ScreenUtil().setWidth(112),
                      ),
                    ),
                    Align(
                      alignment: Alignment(-0.6, 0),
                      child: RichText(
                        text: TextSpan(
                          text: "More trees your friends merge,",
                          style: TextStyle(
                              fontFamily: FontFamily.semibold,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(46)),
                          children: <TextSpan>[
                            TextSpan(
                              text: '\nHigher earnings you will have',
                              style: TextStyle(
                                  fontFamily: FontFamily.semibold,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setWidth(50)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
                Positioned(
                  top: ScreenUtil().setWidth(390),
                  child: Container(
                      width: ScreenUtil().setWidth(1080),
                      // height: ScreenUtil().setWidth(1920),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          // color: Color(0xFFEFEEF3),
                          // color: Colors.red,
                          borderRadius: BorderRadius.only(
                              topLeft:
                                  Radius.circular(ScreenUtil().setWidth(40)),
                              topRight:
                                  Radius.circular(ScreenUtil().setWidth(40)))),
                      padding: EdgeInsets.symmetric(
                        // vertical: ScreenUtil().setWidth(70),
                        horizontal: ScreenUtil().setWidth(60),
                      ),
                      alignment: Alignment.center,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(37),
                                    horizontal: ScreenUtil().setWidth(47)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(40))),
                                ),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          MyNavigator().pushNamed(
                                              context, "InvitatioinPage",
                                              arguments: _partnerWrap?.friends);
                                        },
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: SecondaryText(
                                                  "Number of friends: ${_partnerWrap?.friends_total}",
                                                  textAlign: TextAlign.left,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(50),
                                              ),
                                              Container(
                                                  width: ScreenUtil()
                                                      .setWidth(220),
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        left: ScreenUtil()
                                                            .setWidth(120),
                                                        child:
                                                            getAvatarWidgetListOfFriends(
                                                                0),
                                                      ),
                                                      Positioned(
                                                        left: ScreenUtil()
                                                            .setWidth(60),
                                                        child:
                                                            getAvatarWidgetListOfFriends(
                                                                1),
                                                      ),
                                                      Positioned(
                                                        child:
                                                            getAvatarWidgetListOfFriends(
                                                                2),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                  width: ScreenUtil()
                                                      .setWidth(45)),
                                              Image.asset(
                                                "assets/image/partner_right_arrow_icon.png",
                                                width:
                                                    ScreenUtil().setWidth(20),
                                                height:
                                                    ScreenUtil().setWidth(35),
                                                fit: BoxFit.cover,
                                              )
                                            ]),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //TODO 调起FB分享
                                        },
                                        child: Column(children: [
                                          SizedBox(
                                            height: ScreenUtil().setWidth(36),
                                          ),
                                          PrimaryButton(
                                              width: 600,
                                              height: 124,
                                              child: Center(
                                                  child: Text(
                                                "Invite Friends",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      ScreenUtil().setWidth(52),
                                                ),
                                              ))),
                                          SizedBox(
                                            height: ScreenUtil().setWidth(44),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  "the number of friends who have not logged in facebook is ${_partnerWrap?.friends_total}, those people earned",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setWidth(30),
                                                  color: Color(0xFF7C7C7C),
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  fontWeight: FontWeight.w400),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        " \$${_partnerWrap?.fb_no_login_all_profit}",
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setWidth(50),
                                                        fontFamily:
                                                            FontFamily.bold,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFFF4C2F))),
                                                TextSpan(
                                                    text:
                                                        ' for you, inform them  logging in facebook to get those cash.',
                                                    style: TextStyle(
                                                        fontSize: ScreenUtil()
                                                            .setWidth(30),
                                                        color:
                                                            Color(0xFF7C7C7C),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ],
                                            ),
                                          )
                                        ]),
                                      ),
                                    ])),
                            SizedBox(
                              height: ScreenUtil().setWidth(30),
                            ),

                            // Earning from Partners部分
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(54),
                                  horizontal: ScreenUtil().setWidth(47)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(40))),
                              ),
                              child: Column(children: [
                                // 第一行
                                GestureDetector(
                                  onTap: () {
                                    // TODO 跳转到玩法介绍界面
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Earning from Partners",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setWidth(50),
                                          fontFamily: FontFamily.bold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text("Rules of play",
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setWidth(36),
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xFF7C7C7C))),
                                          SizedBox(
                                            width: ScreenUtil().setWidth(17),
                                          ),
                                          Image.asset(
                                            "assets/image/partner_right_arrow_icon.png",
                                            width: ScreenUtil().setWidth(20),
                                            height: ScreenUtil().setWidth(35),
                                            fit: BoxFit.cover,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(45),
                                ),
                                // 第二行
                                GestureDetector(
                                  onTap: () {
                                    MyNavigator().pushNamed(
                                      context,
                                      "PartnerProfit",
                                    );
                                  },
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Expanded(
                                            child: Container(
                                          // color: Colors.red[300],
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              ModalTitle(
                                                "\$${_partnerWrap?.fb_login_history_profit}",
                                                color: Color(0xFFFF4C2F),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  // color: Colors.yellow,
                                                  child: Center(
                                                    child: Text(
                                                      "current total earning",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        // backgroundColor: Colors.green,
                                                        color:
                                                            Color(0XFF7C7C7C),
                                                        fontSize: ScreenUtil()
                                                            .setWidth(40),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                        Expanded(
                                            child: Container(
                                          // color: Colors.green[300],
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ModalTitle(
                                                "\$${getStateInfoOfPartnerEarning(_partnerWrap?.fb_login_history_profit)[2]}",
                                              ),
                                              Text(
                                                "accelerate magnification ratio in stage ${getStateInfoOfPartnerEarning(_partnerWrap?.fb_login_history_profit)[0]}" +
                                                    " is ${getStateInfoOfPartnerEarning(_partnerWrap?.fb_login_history_profit)[1]}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  // backgroundColor: Colors.red,
                                                  color: Color(0XFF7C7C7C),
                                                  fontSize:
                                                      ScreenUtil().setWidth(40),
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(38),
                                ),
                                // 第三行,进度条
                                Container(
                                    width: ScreenUtil().setWidth(860),
                                    height: ScreenUtil().setWidth(26),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(239, 238, 243, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(13))),
                                    ),
                                    child: Stack(children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 4),
                                        width: ScreenUtil().setWidth(860 *
                                            (getStateInfoOfPartnerEarning(
                                                    _partnerWrap
                                                        ?.fb_login_history_profit)[3] /
                                                100)),
                                        height: ScreenUtil().setWidth(26),
                                        decoration: BoxDecoration(
                                          color: MyTheme.primaryColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(13))),
                                        ),
                                        child: Text(
                                          '${getStateInfoOfPartnerEarning(_partnerWrap?.fb_login_history_profit)[3]}%',
                                          style: TextStyle(
                                              fontFamily: FontFamily.bold,
                                              color: Colors.white,
                                              fontSize:
                                                  ScreenUtil().setWidth(26),
                                              height: 1,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ])),
                                SizedBox(
                                  height: ScreenUtil().setWidth(20),
                                ),
                                Text(
                                    "20% unlocked. Earnings over \$50 will be applied to your account automatically and enter to the next level.",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(30),
                                        color: Color(0xFF7C7C7C),
                                        fontFamily: FontFamily.regular,
                                        fontWeight: FontWeight.w400)),
                              ]),
                            ),

                            SizedBox(
                              height: ScreenUtil().setWidth(30),
                            ),

                            // Partner Profit help me earnings部分
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(54),
                                  horizontal: ScreenUtil().setWidth(47)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(40))),
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Partner help me earnings",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(50),
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // 加速倍率图标
                                    Align(
                                        alignment: Alignment(-0.6, 0),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(30)),
                                          padding: EdgeInsets.only(
                                              left: ScreenUtil().setWidth(40),
                                              right: ScreenUtil().setWidth(10)),
                                          width: ScreenUtil().setWidth(140),
                                          height: ScreenUtil().setWidth(40),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment: Alignment.center,
                                              image: AssetImage(
                                                  "assets/image/partner_profit_from_friends_rate_bg.png"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          child: Text(
                                            "${getStateInfoOfPartnerEarning(_partnerWrap?.fb_login_history_profit)[1]} rate",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setWidth(24),
                                                fontFamily: FontFamily.semibold,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white),
                                          ),
                                        )),
                                    // 第二行
                                    IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                              child: Container(
                                            // color: Colors.red[300],
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ModalTitle(
                                                  "\$${_partnerWrap?.direct_profit == null ? 0 : _partnerWrap.direct_profit + _partnerWrap.indirect_profit}",
                                                  color: Color(0xFFFF4C2F),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    // color: Colors.yellow[300],
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Total earning",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        // backgroundColor: Colors.green,
                                                        color:
                                                            Color(0XFF7C7C7C),
                                                        fontSize: ScreenUtil()
                                                            .setWidth(40),
                                                        fontFamily:
                                                            FontFamily.regular,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ModalTitle(
                                                "\$${_partnerWrap?.direct_profit}",
                                              ),
                                              Text(
                                                "Direct friend contribution",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0XFF7C7C7C),
                                                  fontSize:
                                                      ScreenUtil().setWidth(40),
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            ],
                                          )),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ModalTitle(
                                                "\$${_partnerWrap?.indirect_profit}",
                                              ),
                                              Text(
                                                "Indirect friend contributions",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0XFF7C7C7C),
                                                  fontSize:
                                                      ScreenUtil().setWidth(40),
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(30),
                            ),

                            // My inviter部分
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(54),
                                    horizontal: ScreenUtil().setWidth(47)),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(40))),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "My inviter",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setWidth(50),
                                          fontFamily: FontFamily.bold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenUtil().setWidth(36),
                                      ),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            ClipOval(
                                              child:
                                                  CompatibleNetworkAvatarWidget(
                                                _partnerWrap?.superior?.avatar,
                                                defaultImageUrl:
                                                    "assets/image/rank_page_portrait_default.png",
                                                width:
                                                    ScreenUtil().setWidth(180),
                                                height:
                                                    ScreenUtil().setWidth(180),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              width: ScreenUtil().setWidth(63),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                      text: "today earns",
                                                      style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setWidth(50),
                                                          fontFamily: FontFamily
                                                              .regular,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Color(
                                                              0xFF7C7C7C))),
                                                  TextSpan(
                                                      text:
                                                          '\$${_partnerWrap?.superior?.today_profit}',
                                                      style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setWidth(50),
                                                          color:
                                                              Color(0xFFFF4C2F),
                                                          fontFamily: FontFamily
                                                              .semibold,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                ],
                                              ),
                                            ),
                                          ])
                                    ])),
                          ])),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
