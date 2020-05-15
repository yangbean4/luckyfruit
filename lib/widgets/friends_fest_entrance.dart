import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:provider/provider.dart';

class FriendsFestEntranceWidget extends StatefulWidget {
  @override
  _FriendsFestEntranceWidgetState createState() =>
      _FriendsFestEntranceWidgetState();
}

class _FriendsFestEntranceWidgetState extends State<FriendsFestEntranceWidget> {
  int inviteFriendsNum = 0;
  bool timeReached = false;

  @override
  void initState() {
    super.initState();

    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    List<dynamic> friends = userModel.value.invite_friend ?? [];
    if (friends != null && friends.length > 0) {
      inviteFriendsNum = friends[0] ?? 0;
    }

    List<dynamic> timerList = userModel.value.residue_7days_time;
    timeReached = timerList != null && timerList.isNotEmpty ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!timeReached) {
          Layer.showSevenDaysInviteEventWindow(context);
        } else {
          Layer.partnerCash(context);
        }
      },
      child: Container(
        width: ScreenUtil().setWidth(210),
        height: ScreenUtil().setWidth(150),
        color: Colors.transparent,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              bottom: ScreenUtil().setWidth(0),
              left: ScreenUtil().setWidth(10),
              child: Container(
                width: ScreenUtil().setWidth(190),
                height: ScreenUtil().setWidth(60),
                decoration: BoxDecoration(
                    gradient: timeReached
                        ? null
                        : LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0),
                            colors: <Color>[
                                Color(0xffFF90FE),
                                Color(0xff8840FF),
                              ]),
                    borderRadius: timeReached
                        ? null
                        : BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(100)),
                          ),
                    image: timeReached
                        ? DecorationImage(
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            image: AssetImage(
                                'assets/image/friends_fest_bg_disable.png'))
                        : null),
              ),
            ),
            timeReached
                ? Container()
                : Positioned(
                    bottom: ScreenUtil().setWidth(5),
                    left: ScreenUtil().setWidth(45),
                    child: Container(
                      width: ScreenUtil().setWidth(120),
                      height: ScreenUtil().setWidth(23),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/image/friends_fest_progress_bg.png'),
                              alignment: Alignment.bottomCenter,
                              fit: BoxFit.fill)),
                    ),
                  ),
            timeReached
                ? Container()
                : Positioned(
                    bottom: ScreenUtil().setWidth(5),
                    left: ScreenUtil().setWidth(38),
                    child: Container(
//                      color: Colors.red,
                      width: ScreenUtil().setWidth(138),
                      height: ScreenUtil().setWidth(24),
                      child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: getProgressWidgetList(),
                            ),
                            Text(
                              "$inviteFriendsNum/5",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(28),
                                  height: 1,
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    )),
            Container(
              child: Transform.scale(
                scale: 1.0,
                child: Image.asset(
                  'assets/image/friends_fest_icon_gif.gif',
                  width: ScreenUtil().setWidth(210),
                  height: ScreenUtil().setWidth(115),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getProgressWidgetList() {
    List<Widget> list = [];

    Widget item1 = Image.asset(
      'assets/image/friends_fest_progress_1.png',
      width: ScreenUtil().setWidth(26),
      height: ScreenUtil().setWidth(30),
    );

    Widget item2 = Image.asset(
      'assets/image/friends_fest_progress_m.png',
      width: ScreenUtil().setWidth(26),
      height: ScreenUtil().setWidth(30),
    );

    Widget item3 = Image.asset(
      'assets/image/friends_fest_progress_5.png',
      width: ScreenUtil().setWidth(26),
      height: ScreenUtil().setWidth(30),
    );

    Widget space = SizedBox(
      width: ScreenUtil().setWidth(2),
    );

    for (int i = 0; i < inviteFriendsNum; i++) {
      if (i == 0) {
        list.add(item1);
        list.add(space);
      }

      if (i > 0 && i < 4) {
        list.add(item2);
        list.add(space);
      }

      if (i == 4) {
        list.add(item3);
      }
    }

    return list;
  }
}
