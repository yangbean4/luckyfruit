import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/compatible_avatar_widget.dart';
import 'package:luckyfruit/theme/public/primary_btn.dart';
import 'package:luckyfruit/utils/device_info.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  final UserInfo userInfo;
  SettingsPage({Key key, this.userInfo}) : super(key: key);
  final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.addListener(() {
      print("listener: ${_controller.text}");
      Storage.setItem("proxy_ip", _controller.text);
    });

    Storage.getItem("proxy_ip").then((value) {
      _controller.text = value;
    });
    return Scaffold(
      backgroundColor: Color(0xffEFEEF3),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: MyTheme.blackColor,
        ),
        leading: IconButton(
            iconSize: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color(0xffEFEEF3),
        actions: <Widget>[
          SizedBox(
            width: 30,
            height: 20,
          )
        ],
        title: Align(
          child: Text(
            'Settings',
            style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setSp(70),
                fontFamily: FontFamily.bold,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                  topRight: Radius.circular(ScreenUtil().setWidth(40)))),
          child: Selector<UserModel, UserInfo>(
              selector: (_, provider) => provider.userInfo,
              builder: (_, UserInfo userInfo, __) {
                return Stack(
                  children: <Widget>[
                    Column(children: [
                      ItemWidget(
                        title: "Photo",
                        trailingImg: ClipOval(
                            child: CompatibleNetworkAvatarWidget(
                          userInfo?.avatar,
                          defaultImageUrl:
                              "assets/image/rank_page_portrait_default.png",
                          width: ScreenUtil().setWidth(120),
                          height: ScreenUtil().setWidth(120),
                          fit: BoxFit.cover,
                        )),
                      ),
                      Divider(
                        height: ScreenUtil().setWidth(2),
                      ),
                      ItemWidget(
                        title: "Name",
                        trailingText: userInfo?.nickname,
                      ),
                      Divider(
                        height: ScreenUtil().setWidth(2),
                      ),
                      ItemWidget(
                        title: "Telephone",
                        trailingText: "${userInfo?.phoneNum ?? ""}",
                        // trailingText: "18899990000",
                      ),
                      Divider(
                        height: ScreenUtil().setWidth(2),
                      ),
                      ItemWidget(
                        title: "Authority",
                        onTap: () {
                          MyNavigator().pushNamed(context, 'privacyPage');
                        },
                        trailingImg: Image.asset(
                          "assets/image/partner_right_arrow_icon.png",
                          width: ScreenUtil().setWidth(20),
                          height: ScreenUtil().setWidth(35),
                        ),
                      ),
                      Divider(
                        height: ScreenUtil().setWidth(2),
                      ),
                      ItemWidget(
                          title: "About Lucky Fruit",
                          trailingText: App.appVersion),
                      Divider(
                        height: ScreenUtil().setWidth(2),
                      ),
                      ItemWidget(
                        title: "Privacy",
                        onTap: () {
                          launch(App.SETTING_PRIVACY_URL);
                        },
                        trailingImg: Image.asset(
                          "assets/image/partner_right_arrow_icon.png",
                          width: ScreenUtil().setWidth(20),
                          height: ScreenUtil().setWidth(35),
                        ),
                      ),
                      Divider(
                        height: ScreenUtil().setWidth(2),
                      ),
                      ItemWidget(
                        title: "Terms of Service",
                        onTap: () {
                          launch(App.SETTING_TERMS_URL);
                        },
                        trailingImg: Image.asset(
                          "assets/image/partner_right_arrow_icon.png",
                          width: ScreenUtil().setWidth(20),
                          height: ScreenUtil().setWidth(35),
                        ),
                      ),
                      App.IS_IN_RELEASE
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(100)),
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  hintText: _controller.text.isEmpty
                                      ? "10.200.15.61:8888"
                                      : null,
                                  hintStyle: TextStyle(color: Colors.red[100]),
                                  filled: true,
                                  border: InputBorder.none,
                                  fillColor: MyTheme.grayColor,
                                ),
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(60),
                                    color: Colors.black),
                              ),
                            ),
                    ]),
                    Positioned(
                      bottom: ScreenUtil().setWidth(108),
                      child: Container(
                        width: ScreenUtil().setWidth(1080),
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                            onTap: () {},
                            child: PrimaryButton(
                                text: "Sign Out", width: 600, height: 124)),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final Widget trailingImg;
  final String trailingText;
  final String title;
  final Function onTap;

  ItemWidget(
      {Key key, this.title, this.trailingImg, this.trailingText, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget trailing;

    if (trailingText != null) {
      trailing = Text(trailingText,
          style: TextStyle(
              color: Color(0xFF7C7C7C),
              fontSize: ScreenUtil().setSp(50),
              fontFamily: FontFamily.regular,
              fontWeight: FontWeight.w400));
    }

    if (trailingImg != null) {
      trailing = trailingImg;
    }

    return ListTile(
      trailing: trailing,
      onTap: onTap,
      title: Text(title,
          style: TextStyle(
              color: MyTheme.blackColor,
              fontSize: ScreenUtil().setSp(50),
              fontFamily: FontFamily.semibold,
              fontWeight: FontWeight.w500)),
    );
  }
}
