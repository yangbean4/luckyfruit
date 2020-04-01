import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as JSON;

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/models/index.dart' show UserInfo, PersonalInfo;
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/theme/public/compatible_avatar_widget.dart';
import 'package:luckyfruit/service/index.dart';

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  _loginWithFB() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        UserModel user = Provider.of<UserModel>(context, listen: false);
        await Service().relaRelated({
          'acct_id': user.value.acct_id,
          'rela_type': 1,
          'avatar': profile['picture']['data']['url'],
          'name': profile['name'],
          'rela_account': profile['email']
        });
        user.getUserInfo();
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    UserModel user = Provider.of<UserModel>(context, listen: false);
    // 每次切换到mine tab时请求一下该接口,防止长时间为更新接口导致本地记录的余额等数据没有更新
    user.getPersonalInfo(forceFetch: true);
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
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(60),
                    ScreenUtil().setWidth(90),
                    ScreenUtil().setWidth(60),
                    ScreenUtil().setWidth(70)),
                child: Selector<UserModel, _SelectorUse>(
                    builder: (_, _SelectorUse _selectorUse, __) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(400),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_selectorUse.userInfo.nickname,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        height: 1,
                                        fontSize: ScreenUtil().setSp(90))),
                                SizedBox(height: ScreenUtil().setWidth(40)),
                                Text('ID: ${_selectorUse.userId}',
                                    style: TextStyle(
                                        fontFamily: FontFamily.semibold,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        height: 1,
                                        fontSize: ScreenUtil().setSp(50))),
                              ],
                            ),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(180),
                            height: ScreenUtil().setWidth(180),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(90)),
                              child: CompatibleNetworkAvatarWidget(
                                _selectorUse?.userInfo?.avatar,
                                defaultImageUrl:
                                    "assets/image/rank_page_portrait_default.png",
                                width: ScreenUtil().setWidth(180),
                                height: ScreenUtil().setWidth(180),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    selector: (context, provider) =>
                        _SelectorUse(userModel: provider))),
            Expanded(
              child: Container(
                width: ScreenUtil().setWidth(1080),
                color: MyTheme.grayColor,
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(160),
                    left: ScreenUtil().setWidth(60),
                    right: ScreenUtil().setWidth(60)),
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    _Card(
                      child: _CardItem(
                          iconName: 'msg',
                          title: 'Message',
                          hasArrow: true,
                          onTap: () =>
                              MyNavigator().pushNamed(context, 'message')),
                    ),
                    _Card(
                      child: Column(children: <Widget>[
                        Selector<UserModel, String>(
                            selector: (context, provider) =>
                                provider.personalInfo?.amount,
                            builder: (_, String amount, __) {
                              return _CardItem(
                                iconName: 'wallet',
                                title: 'My wallet',
                                hasArrow: true,
                                border: true,
                                onTap: () {
                                  MyNavigator().pushNamed(
                                      context, "WithDrawPage",
                                      arguments: amount);
                                },
                                rightText: '\$${amount}',
                                // onTap: () =>
                                //     MyNavigator().pushNamed(context, 'records'),
                              );
                            }),
                        Selector<UserModel, String>(
                            selector: (context, provider) =>
                                provider.userInfo?.invite_code,
                            builder: (_, String invite_code, __) {
                              return _CardItem(
                                iconName: 'code',
                                title: 'My invitation code',
                                hasArrow: true,
                                border: true,
                                rightText: '${invite_code}',
                                onTap: () => MyNavigator()
                                    .pushNamed(context, 'invitationCodePage'),
                              );
                            }),
                        Selector<UserModel, String>(
                            selector: (context, provider) =>
                                provider.shareLink ??
                                'https://lanhuapp.com/url/eWZiw-Ck31c',
                            builder: (_, String shareLink, __) {
                              return _CardItem(
                                  iconName: 'link',
                                  title: 'My share link',
                                  tips: shareLink,
                                  border: true,
                                  right: Container(
                                    width: ScreenUtil().setWidth(120),
                                    height: ScreenUtil().setWidth(56),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(28)),
                                      gradient: LinearGradient(
                                          begin: Alignment(-1.0, 0.0),
                                          end: Alignment(1.0, 0.0),
                                          colors: [
                                            Color.fromRGBO(36, 185, 71, 1),
                                            Color.fromRGBO(49, 200, 84, 1),
                                          ]),
                                    ),
                                    child: Text(
                                      'copy',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: FontFamily.semibold,
                                          fontSize: ScreenUtil().setSp(36),
                                          height: 1.2,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  onTap: () {
                                    Clipboard.setData(
                                            ClipboardData(text: shareLink))
                                        .then((e) {
                                      Layer.toastSuccess('copy Success');
                                    });
                                  });
                            }),
                        _CardItem(
                            iconName: 'fb',
                            title: 'Facebook login',
                            onTap: () {
                              _loginWithFB();
                            }),
                      ]),
                    ),
                    _Card(
                        child: Column(children: <Widget>[
                      _CardItem(
                        iconName: 'mine_faq_icon',
                        title: 'Help center',
                        hasArrow: true,
                        border: true,
                      ),
                      _CardItem(
                        iconName: 'setting',
                        title: 'Setting',
                        hasArrow: true,
                        onTap: () {
                          MyNavigator().pushNamed(context, 'settings');
                        },
                      )
                    ]))
                  ],
                )),
              ),
            )
          ],
        ),
        Positioned(
          top: ScreenUtil().setWidth(360),
          left: ScreenUtil().setWidth(60),
          child: GestureDetector(
            onTap: () => MyNavigator().pushNamed(context, 'bonusTreePage'),
            child: Container(
              width: ScreenUtil().setWidth(960),
              height: ScreenUtil().setWidth(260),
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(23),
                  vertical: ScreenUtil().setWidth(49)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(40)))),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/image/dividend_tree.png',
                      width: ScreenUtil().setWidth(147),
                      height: ScreenUtil().setWidth(160),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(685),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: ScreenUtil().setWidth(99),
                            child: Text(
                                '100% chance to the bonus tree by staying active in the game',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: ScreenUtil().setWidth(262),
                                        height: ScreenUtil().setWidth(30),
                                        child: RichText(
                                          text: TextSpan(
                                              text: 'completed ',
                                              style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.regular,
                                                  color: MyTheme.blackColor,
                                                  height: 1.0,
                                                  fontSize:
                                                      ScreenUtil().setSp(32)),
                                              children: [
                                                TextSpan(
                                                  text: '$count_ratio% ',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.semibold,
                                                      color: MyTheme.blackColor,
                                                      height: 1.0,
                                                      fontSize: ScreenUtil()
                                                          .setSp(32)),
                                                ),
                                              ]),
                                        ),
                                      ),
                                      // Text('completed ',

                                      Container(
                                          width: ScreenUtil().setWidth(400),
                                          height: ScreenUtil().setWidth(26),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                222, 220, 216, 1),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(13))),
                                          ),
                                          child: Stack(children: <Widget>[
                                            Container(
                                              width: ScreenUtil().setWidth(400 *
                                                  ((count_ratio ?? 0) / 100)),
                                              height: ScreenUtil().setWidth(26),
                                              decoration: BoxDecoration(
                                                color: MyTheme.primaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setWidth(13))),
                                              ),
                                            ),
                                          ])),
                                    ],
                                  );
                                },
                              ))
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/image/partner_right_arrow_icon.png',
                      width: ScreenUtil().setWidth(19),
                      height: ScreenUtil().setWidth(34),
                    )
                  ]),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectorUse {
  UserInfo userInfo;
  String userId;
  UserModel userModel;
  _SelectorUse({this.userModel})
      : userInfo = userModel.userInfo,
        userId = userModel.value.acct_id;
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(960),
        // padding: EdgeInsets.symmetric(
        //     horizontal: ScreenUtil().setWidth(23),
        //     vertical: ScreenUtil().setWidth(49)),
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(40)))),
        child: child);
  }
}

class _CardItem extends StatelessWidget {
  final String iconName;
  final String title;
  final String tips;
  final bool hasArrow;
  final String rightText;
  final Widget right;
  final Function onTap;
  final bool border;
  const _CardItem(
      {Key key,
      @required this.iconName,
      @required this.title,
      this.tips,
      this.hasArrow = false,
      this.rightText,
      this.right,
      this.onTap,
      this.border = false})
      : assert(!(rightText != null && right != null)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (onTap != null) onTap();
        },
        child: Container(
          width: ScreenUtil().setWidth(960),
          height: ScreenUtil().setWidth(180),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(34)),
          decoration: this.border
              ? BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          style: BorderStyle.solid,
                          width: 1,
                          color: MyTheme.lightGrayColor)))
              : BoxDecoration(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(64),
                height: ScreenUtil().setWidth(64),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/image/${iconName}.png'),
                        alignment: Alignment.center,
                        fit: BoxFit.contain)),
              ),
              Container(
                width: ScreenUtil().setWidth(30),
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
                  tips == null
                      ? Container()
                      : Text(tips,
                          style: TextStyle(
                              fontFamily: FontFamily.regular,
                              color: MyTheme.blackColor,
                              height: 1.0,
                              fontSize: ScreenUtil().setSp(32))),
                ],
              )),
              right == null ? Container() : right,
              rightText == null
                  ? Container()
                  : Container(
                      width: ScreenUtil().setWidth(200),
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(36)),
                      child: Text(rightText,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontFamily: FontFamily.regular,
                              color: MyTheme.tipsColor,
                              height: 1.0,
                              fontSize: ScreenUtil().setSp(50))),
                    ),
              hasArrow
                  ? Image.asset(
                      'assets/image/partner_right_arrow_icon.png',
                      width: ScreenUtil().setWidth(19),
                      height: ScreenUtil().setWidth(34),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
