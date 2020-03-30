import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/userInfo.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:provider/provider.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffEFEEF3),
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: MyTheme.blackColor,
          ),
          backgroundColor: Color(0xffEFEEF3),
          title: Text(
            'Privacy',
            style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setSp(70),
                fontFamily: FontFamily.bold,
                fontWeight: FontWeight.bold),
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
                      type: 1,
                      switchSelected: userInfo?.worker_visible == 1,
                      title: "Visibel to my Master",
                      subTitle:
                          "Your social inforamtion will be visible to your Master when it turned on.",
                    ),
                    ItemWidget(
                      type: 2,
                      switchSelected: userInfo?.direct_friend_visible == 1,
                      title: "Visible to my direct/indirect friends",
                      subTitle:
                          "Your social inforamtion will be visible to your direct/indirect friends when it turned on.",
                    ),
                  ]);
                })));
  }
}

class ItemWidget extends StatefulWidget {
  bool switchSelected;
  final String title;
  final String subTitle;
  final int type;

  ItemWidget(
      {Key key, this.type, this.title, this.subTitle, this.switchSelected});

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Selector<UserModel, _SelectorUse>(
        selector: (_, provider) => _SelectorUse(userModel: provider),
        builder: (_, _SelectorUse select, __) {
          return ListTile(
            trailing: Switch(
              value: widget.switchSelected, //当前状态
              activeColor: Color(0xFF24B947),
              onChanged: (value) {
                Map<String, String> paraMap = {"acct_id": select?.userId};
                int result = value ? 1 : 0;
                if (widget.type == 1) {
                  paraMap.addAll({'worker_visible': "$result"});
                } else if (widget.type == 2) {
                  paraMap.addAll({'direct_friend_visible': "$result"});
                }
                Service().updateUserInfo(paraMap).then((e) {
                  print(e);
                  if (e != null && e["code"] == 0) {
                    if (widget.type == 1) {
                      select.userInfo.worker_visible = result;
                    } else if (widget.type == 2) {
                      select.userInfo.direct_friend_visible = result;
                    }
                  }
                });
                //重新构建页面
                setState(() {
                  widget.switchSelected = value;
                });
              },
            ),
            subtitle: Text(widget.subTitle,
                style: TextStyle(
                    color: Color(0xFF7C7C7C),
                    fontSize: ScreenUtil().setSp(34),
                    fontFamily: FontFamily.regular,
                    fontWeight: FontWeight.w400)),
            title: Text(widget.title,
                style: TextStyle(
                    color: MyTheme.blackColor,
                    fontSize: ScreenUtil().setSp(46),
                    fontFamily: FontFamily.semibold,
                    fontWeight: FontWeight.w500)),
          );
        });
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
