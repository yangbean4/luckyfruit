import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/partnerWrap.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
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
        "fb_login_history_profit": 39,
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
      _partnerWrap = res;
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

  @override
  Widget build(BuildContext context) {
    var avatarWidget = ClipOval(
      child: Image.network(
        "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
        width: ScreenUtil().setWidth(100),
        height: ScreenUtil().setWidth(100),
        fit: BoxFit.cover,
      ),
    );

    return Scaffold(
        appBar: AppBar(
          //导航栏
          title: Text("Partners"),
          backgroundColor: MyTheme.primaryColor,
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(100),
                    horizontal: ScreenUtil().setWidth(60)),
                color: Color(0xFFEFEEF3),
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SecondaryText(
                                "Number of friends: ${_partnerWrap?.friends_total}"),
                            SizedBox(
                              width: ScreenUtil().setWidth(100),
                            ),
                            Container(
                                width: ScreenUtil().setWidth(220),
                                child: Stack(
                                  // fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      // width: ScreenUtil().setWidth(100),
                                      left: ScreenUtil().setWidth(120),
                                      child: avatarWidget,
                                    ),
                                    Positioned(
                                      left: ScreenUtil().setWidth(60),
                                      child: avatarWidget,
                                    ),
                                    Positioned(
                                      child: avatarWidget,
                                    ),
                                  ],
                                )),
                            GestureDetector(
                                onTap: () {
                                  MyNavigator().pushNamed(
                                      context, "InvitatioinPage",
                                      arguments: _partnerWrap?.friends);
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    padding: EdgeInsets.only(
                                        left: ScreenUtil().setWidth(45),
                                        top: ScreenUtil().setWidth(30),
                                        bottom: ScreenUtil().setWidth(30)),
                                    child: Image.asset(
                                      "assets/image/partner_right_arrow_icon.png",
                                      width: ScreenUtil().setWidth(20),
                                      height: ScreenUtil().setWidth(35),
                                      fit: BoxFit.cover,
                                    ))),
                          ]),
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
                              fontSize: ScreenUtil().setWidth(52),
                            ),
                          ))),
                      SizedBox(
                        height: ScreenUtil().setWidth(63),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(35),
                              horizontal: ScreenUtil().setWidth(50)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(40))),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text:
                                  "the number of friends who have not logged in facebook is ${_partnerWrap?.friends_total}, those people earned",
                              style: TextStyle(
                                  fontSize: ScreenUtil().setWidth(30),
                                  color: Color(0xFF7C7C7C),
                                  fontFamily: FontFamily.regular,
                                  fontWeight: FontWeight.w400),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        " \$${_partnerWrap?.fb_no_login_all_profit}",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(50),
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF4C2F))),
                                TextSpan(
                                    text:
                                        ' for you, inform them  logging in facebook to get those cash.',
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setWidth(30),
                                        color: Color(0xFF7C7C7C),
                                        fontFamily: FontFamily.regular,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          )),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SecondaryText("Earning from Partners"),
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: <Widget>[
                                    Text("Rules of play",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setWidth(36),
                                            fontFamily: FontFamily.regular,
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
                              ),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(45),
                          ),
                          // 第二行
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ModalTitle(
                                    "\$${_partnerWrap?.fb_login_history_profit}",
                                    color: Color(0xFFFF4C2F),
                                  ),
                                  Text(
                                    "current total earning",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0XFF7C7C7C),
                                      fontSize: ScreenUtil().setWidth(40),
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )),
                              Flexible(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ModalTitle(
                                    "\$50.00",
                                  ),
                                  Text(
                                    "accelerate magnification ratio in stage 2 is 1.1",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0XFF7C7C7C),
                                      fontSize: ScreenUtil().setWidth(40),
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )),
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(30),
                          ),
                          // 第三行,进度条
                          Container(
                              width: ScreenUtil().setWidth(860),
                              height: ScreenUtil().setWidth(26),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(239, 238, 243, 1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(13))),
                              ),
                              child: Stack(children: <Widget>[
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 4),
                                  width:
                                      ScreenUtil().setWidth(860 * (30 / 100)),
                                  height: ScreenUtil().setWidth(26),
                                  decoration: BoxDecoration(
                                    color: MyTheme.primaryColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(13))),
                                  ),
                                  child: Text(
                                    '30%',
                                    style: TextStyle(
                                        fontFamily: FontFamily.bold,
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(26),
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
                                  fontSize: ScreenUtil().setWidth(30),
                                  color: Color(0xFF7C7C7C),
                                  fontFamily: FontFamily.regular,
                                  fontWeight: FontWeight.w400)),
                        ]),
                      ),

                      SizedBox(
                        height: ScreenUtil().setWidth(30),
                      ),

                      // Partner Profit help me earnings部分
                      GestureDetector(
                          onTap: () {
                            MyNavigator().pushNamed(
                              context,
                              "PartnerProfit",
                            );
                          },
                          child: Container(
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
                                  // 第一行
                                  SecondaryText("Partner help me earnings"),
                                  SizedBox(
                                    height: ScreenUtil().setWidth(45),
                                  ),
                                  // 第二行
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ModalTitle(
                                            "\$${_partnerWrap?.direct_profit??0 + _partnerWrap?.indirect_profit??0}",
                                            color: Color(0xFFFF4C2F),
                                          ),
                                          Text(
                                            "Total earning",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0XFF7C7C7C),
                                              fontSize:
                                                  ScreenUtil().setWidth(40),
                                              fontFamily: FontFamily.bold,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      )),
                                      Flexible(
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
                                              fontFamily: FontFamily.bold,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      )),
                                      Flexible(
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
                                              fontFamily: FontFamily.bold,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      )),
                                    ],
                                  ),
                                ]),
                          )),
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
                                Radius.circular(ScreenUtil().setWidth(40))),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SecondaryText("My inviter"),
                                SizedBox(
                                  height: ScreenUtil().setWidth(45),
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      ClipOval(
                                        child: Image.network(
                                          // TODO 头像判空,增加默认头像
                                          _partnerWrap?.superior?.avatar,
                                          width: ScreenUtil().setWidth(180),
                                          height: ScreenUtil().setWidth(180),
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
                                                    fontFamily:
                                                        FontFamily.regular,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFF7C7C7C))),
                                            TextSpan(
                                                text:
                                                    '\$${_partnerWrap?.superior?.today_profit}',
                                                style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setWidth(50),
                                                    color: Color(0xFFFF4C2F),
                                                    fontFamily:
                                                        FontFamily.semibold,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ],
                                        ),
                                      ),
                                    ])
                              ])),
                    ]))));
  }
}
