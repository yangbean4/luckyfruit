import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:luckyfruit/config/app.dart';
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
  double itemWidth = 40;
  double spaceWidth = 1;

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
        Layer.showSevenDaysInviteEventWindow(context);
      },
      child: Container(
        width: ScreenUtil().setWidth(270),
        height: ScreenUtil().setWidth(230),
        color: Colors.transparent,
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              bottom: ScreenUtil().setWidth(20),
              left: ScreenUtil().setWidth(10),
              child: Container(
                width: ScreenUtil().setWidth(250),
                height: ScreenUtil().setWidth(80),
                decoration: BoxDecoration(
                    gradient: timeReached
                        ? null
                        : LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, 1.0),
                            colors: <Color>[
                                Color(0xffFFF1C6),
                                Color(0xffFFC200),
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
                    bottom: ScreenUtil().setWidth(30),
                    left: ScreenUtil().setWidth(35),
                    child: Container(
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setWidth(30),
                      decoration: BoxDecoration(
                        color: Color(0xff604E42),
                        borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(20)),
                        ),
                      ),
                    ),
                  ),
            timeReached
                ? Container()
                : Positioned(
                    bottom: ScreenUtil().setWidth(30),
                    left: ScreenUtil().setWidth(30),
                    child: Container(
                      width: ScreenUtil().setWidth(210),
                      height: ScreenUtil().setWidth(30),
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
                                  fontSize: ScreenUtil().setSp(40),
                                  height: 1,
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    )),
            Container(
              child: Transform.scale(
                scale: 1.3,
                child: Lottie.asset(
                  'assets/lottiefiles/img_sweep_share.json',
                  width: ScreenUtil().setWidth(270),
                  height: ScreenUtil().setWidth(170),
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
      width: ScreenUtil().setWidth(itemWidth),
      height: ScreenUtil().setWidth(31),
    );

    Widget item2 = Image.asset(
      'assets/image/friends_fest_progress_m.png',
      width: ScreenUtil().setWidth(itemWidth),
      height: ScreenUtil().setWidth(30),
    );

    Widget item3 = Image.asset(
      'assets/image/friends_fest_progress_5.png',
      width: ScreenUtil().setWidth(itemWidth),
      height: ScreenUtil().setWidth(30),
    );

    Widget space = SizedBox(
      width: ScreenUtil().setWidth(spaceWidth),
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
