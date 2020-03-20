import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/public.dart';

class Partner extends StatefulWidget {
  Partner({Key key}) : super(key: key);

  @override
  PartnerState createState() => PartnerState();
}

class PartnerState extends State<Partner> {
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

    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setWidth(100),
                horizontal: ScreenUtil().setWidth(60)),
            color: Color(0xFFEFEEF3),
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SecondaryText("Number of friends: 200"),
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
                SizedBox(
                  width: ScreenUtil().setWidth(45),
                ),
                Image.asset(
                  "assets/image/partner_right_arrow_icon.png",
                  width: ScreenUtil().setWidth(20),
                  height: ScreenUtil().setWidth(35),
                  fit: BoxFit.cover,
                ),
              ]),
              SizedBox(
                height: ScreenUtil().setWidth(36),
              ),
              GestureDetector(
                  onTap: () {},
                  child: PrimaryButton(
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
                      )))),
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
                          "the number of friends who have logged in facebook is 10 people, those people earned ",
                      style: TextStyle(
                          fontSize: ScreenUtil().setWidth(30),
                          color: Color(0xFF7C7C7C),
                          fontFamily: FontFamily.regular,
                          fontWeight: FontWeight.w400),
                      children: <TextSpan>[
                        TextSpan(
                            text: " \$30 ",
                            style: TextStyle(
                                fontSize: ScreenUtil().setWidth(50),
                                fontFamily: FontFamily.bold,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF4C2F))),
                        TextSpan(
                            text:
                                'for you, inform them  logging in facebook to get those cash.',
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
                      Row(
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
                      )
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
                            "\$10.00",
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
                          width: ScreenUtil().setWidth(860 * (30 / 100)),
                          height: ScreenUtil().setWidth(26),
                          decoration: BoxDecoration(
                            color: MyTheme.primaryColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(13))),
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
                      "the number of friends who have logged in facebook is 10 people, those people earned ",
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

              // Partner help me earnings部分
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
                      // 第一行
                      SecondaryText("Partner help me earnings"),
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
                                "\$15.13",
                                color: Color(0xFFFF4C2F),
                              ),
                              Text(
                                "Total earning",
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
                                "\$8.13",
                              ),
                              Text(
                                "Direct friend contribution",
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
                                "\$7.00",
                              ),
                              Text(
                                "Indirect friend contributions",
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              ClipOval(
                                child: Image.network(
                                  "http://hbimg.huabanimg.com/1a8606097dc7697aa4061ad48353f2800c20820877cbc-czt9tg_fw236",
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
                                            fontSize: ScreenUtil().setWidth(50),
                                            fontFamily: FontFamily.regular,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFF7C7C7C))),
                                    TextSpan(
                                        text: '\$15.0',
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setWidth(50),
                                            color: Color(0xFFFF4C2F),
                                            fontFamily: FontFamily.semibold,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ),
                            ])
                      ])),
            ])));
  }
}
