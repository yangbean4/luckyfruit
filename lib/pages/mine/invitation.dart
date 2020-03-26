import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:luckyfruit/models/index.dart' show PersonalInfo, InviterData;
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:luckyfruit/theme/public/public.dart';

class InvitationCodePage extends StatefulWidget {
  InvitationCodePage({Key key}) : super(key: key);

  @override
  _InvitationCodePageState createState() => _InvitationCodePageState();
}

class _InvitationCodePageState extends State<InvitationCodePage> {
  InviterData inviterData;
  String userId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _init();
  }

  _init() async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.getPersonalInfo();
    userId = userModel.value.acct_id;

    Map<String, dynamic> ajax =
        await Service().getinviterData({'acct_id': userModel.value.acct_id});
    inviterData = ajax == null ? null : InviterData.fromJson(ajax);
  }

  _showModal(BuildContext context) {
    // Modal(
    //     onCancel: () {},
    //     context: context,
    //     childrenBuilder: (Modal modal) => <Widget>[
    //           _InputModel(
    //               userId: userId,
    //               onOk: () {
    //                 _init();
    //               }),
    //         ]).show();
    if (inviterData == null) {
      showDialog(
          context: context,
          builder: (_) => _InputModel(
              userId: userId,
              onOk: () {
                _init();
              }));
    } else {
      Modal(
          onCancel: () {},
          childrenBuilder: (Modal modal) => <Widget>[
                ModalTitle('My Inviter'),
                Container(
                  height: ScreenUtil().setWidth(42),
                ),
                Container(
                  width: ScreenUtil().setWidth(108),
                  height: ScreenUtil().setWidth(108),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(54)),
                    child: Image.network(inviterData.avatar),
                  ),
                ),
                Container(
                  height: ScreenUtil().setWidth(30),
                ),
                SecondaryText('Lv.${inviterData.level} ${inviterData.nickname}')
              ]).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: MyTheme.blackColor,
          ),
          backgroundColor: Colors.white,
          title: Text(
            'My Invitation Code',
            style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setWidth(70),
                fontFamily: FontFamily.bold,
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            GestureDetector(
                onTap: () {
                  _showModal(context);
                },
                child: Container(
                  width: ScreenUtil().setWidth(220),
                  child: Center(
                      child: Text(
                    'my inviter',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: MyTheme.tipsColor,
                        fontSize: ScreenUtil().setWidth(36),
                        fontFamily: FontFamily.semibold,
                        fontWeight: FontWeight.w500),
                  )),
                ))
          ]),
      body: Container(
        width: ScreenUtil().setWidth(1080),
        height: ScreenUtil().setWidth(1100),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Selector<UserModel, String>(
                selector: (context, provider) => provider.userInfo?.invite_code,
                builder: (_, String invite_code, __) {
                  return GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: invite_code))
                          .then((e) {
                        Layer.toastSuccess('copy Success');
                      });
                    },
                    child: Container(
                      height: ScreenUtil().setWidth(67),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(invite_code,
                              style: TextStyle(
                                  color: MyTheme.blackColor,
                                  fontSize: ScreenUtil().setWidth(90),
                                  height: 1,
                                  fontFamily: FontFamily.black,
                                  fontWeight: FontWeight.w900)),
                          Container(
                            width: ScreenUtil().setWidth(30),
                          ),
                          Container(
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
                                  fontSize: ScreenUtil().setWidth(36),
                                  height: 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            Selector<UserModel, PersonalInfo>(
                builder: (_, PersonalInfo personalInfo, __) {
                  return Container(
                    width: ScreenUtil().setWidth(960),
                    height: ScreenUtil().setWidth(204),
                    decoration: BoxDecoration(
                        color: MyTheme.grayColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(40)))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(479),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(personalInfo?.superior2 ?? '0',
                                  style: TextStyle(
                                      color: MyTheme.blackColor,
                                      fontSize: ScreenUtil().setWidth(70),
                                      height: 1,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.bold)),
                              Text('direct friends',
                                  style: TextStyle(
                                      color: MyTheme.tipsColor,
                                      fontSize: ScreenUtil().setWidth(40),
                                      height: 1,
                                      fontFamily: FontFamily.regular,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(2),
                          height: ScreenUtil().setWidth(90),
                          color: MyTheme.darkGrayColor,
                        ),
                        Container(
                          width: ScreenUtil().setWidth(479),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(personalInfo?.superior2 ?? '0',
                                  style: TextStyle(
                                      color: MyTheme.blackColor,
                                      fontSize: ScreenUtil().setWidth(70),
                                      height: 1,
                                      fontFamily: FontFamily.bold,
                                      fontWeight: FontWeight.bold)),
                              Text('indirect friends',
                                  style: TextStyle(
                                      color: MyTheme.tipsColor,
                                      fontSize: ScreenUtil().setWidth(40),
                                      height: 1,
                                      fontFamily: FontFamily.regular,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                selector: (context, provider) => provider.personalInfo),
            Container(
              width: ScreenUtil().setWidth(960),
              height: ScreenUtil().setWidth(600),
              child: RichText(
                text: TextSpan(
                    text: 'Invitation Award Rules\n',
                    style: TextStyle(
                        color: MyTheme.blackColor,
                        fontSize: ScreenUtil().setWidth(40),
                        fontFamily: FontFamily.semibold,
                        height: 1.5,
                        fontWeight: FontWeight.w500),
                    children: [
                      TextSpan(
                          text:
                              "1. Who are valid users? Direct-invited and indirect friends who login with their Facebook accounts and merge trees to level 5.\n 2. The active earning of friends is depend on the activity of direct friends and indrect friends, total watched videos, total invited friends and etc. More friends invited, more earnings will be granted everyday.",
                          style: TextStyle(
                              color: Color.fromRGBO(83, 83, 83, 1),
                              fontSize: ScreenUtil().setWidth(40),
                              height: 1.5,
                              fontFamily: FontFamily.regular,
                              fontWeight: FontWeight.w400))
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _InputModel extends StatefulWidget {
  final String userId;
  final Function onOk;
  _InputModel({Key key, this.userId, this.onOk}) : super(key: key);

  @override
  __InputModelState createState() => __InputModelState();
}

class __InputModelState extends State<_InputModel> {
  TextEditingController _controller = new TextEditingController();

  _onTap() async {
    try {
      await Service().inviteCode(
          {'acct_id': widget.userId, 'invite_code': _controller.text});
      Navigator.of(context).pop();
      widget.onOk();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        body: Container(
          width: ScreenUtil().setWidth(1080),
          height: ScreenUtil()
              .setWidth(1920 - MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(840),
                  height: ScreenUtil().setWidth(630),
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setWidth(90),
                    horizontal: ScreenUtil().setWidth(120),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(100)),
                    ),
                  ),
                  child: Container(
                    width: ScreenUtil().setWidth(600),
                    height: ScreenUtil().setWidth(452),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: ModalTitle('Enter Invitation Code',
                              textAlign: TextAlign.center),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(460),
                          height: ScreenUtil().setWidth(100),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              filled: true,
                              border: InputBorder.none,
                              fillColor: MyTheme.grayColor,
                            ),
                            style: TextStyle(
                                fontSize: ScreenUtil().setWidth(60),
                                height: 1.0,
                                color: Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _onTap();
                          },
                          child: PrimaryButton(
                              width: 600,
                              height: 124,
                              child: Center(
                                  child: Text(
                                'Claim',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setWidth(52),
                                ),
                              ))),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: ScreenUtil().setWidth(-20),
                  right: ScreenUtil().setWidth(-20),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setWidth(200),
                        // color: Colors.red,
                        child: Center(
                            child: Image.asset(
                          'assets/image/close.png',
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(40),
                        ))),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
