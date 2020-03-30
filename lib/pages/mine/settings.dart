import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/compatible_avatar_widget.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  final UserInfo userInfo;
  SettingsPage({Key key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          SizedBox(width:30, height: 20,)
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
                return Column(children: [
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
                  ItemWidget(
                    title: "Name",
                    trailingText: userInfo?.nickname,
                  ),
                  ItemWidget(
                    title: "Telephone",
                    // trailingText: "${userInfo?.phoneNum ?? ""}",
                    trailingText: "18899990000",
                  ),
                  ItemWidget(
                    title: "Privacy",
                    onTap: () {
                      MyNavigator().pushNamed(context, 'privacyPage');
                    },
                    trailingImg: Image.asset(
                      "assets/image/partner_right_arrow_icon.png",
                      width: ScreenUtil().setWidth(20),
                      height: ScreenUtil().setWidth(35),
                    ),
                  ),
                  ItemWidget(
                    title: "About Lucky Fruit",
                    trailingText: "v1.0.0",
                  ),
                ]);
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
