import 'dart:math';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart' show App, Consts, Event_Name;
import 'package:luckyfruit/main.dart';
import 'package:luckyfruit/models/user.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  bool canJump = false;
  bool hasPaused = false;
  bool timeReached = !App.ReleaseOrDebug;
  bool clickFlag = false;
  bool jumpToHomeFlag = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      hasPaused = true;
      EVENT_BUS.emit(Event_Name.APP_PAUSED);
    }
    if (state == AppLifecycleState.resumed) {
      if (hasPaused) {
        EVENT_BUS.emit(Event_Name.APP_RESUMED);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    WidgetsBinding.instance.addObserver(this); // 注册监听器
    print("loading_start");

    Storage.getItem(UserModel.is_new_user).then((value) {
      if (value == null) {
        timeReached = true;
        return;
      }
      Future.delayed(Duration(seconds: 10), () {
        print("loading_end");
        if (mounted)
          setState(() {
            timeReached = true;
          });
      });
    });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    WidgetsBinding.instance.removeObserver(this); // 移除监听器
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    EVENT_BUS.emit(Event_Name.APP_PAUSED);
    return false;
  }

  useJump() {
    setState(() {
      canJump = true;
    });
  }

  go(String login_type) {
    if (jumpToHomeFlag) {
      // 防止多次跳转
      return;
    }
    jumpToHomeFlag = true;
    BottomNavigationBar navigationBar = Consts.globalKeyBottomBar.currentWidget;
    if (navigationBar != null) {
      navigationBar?.onTap(0);
    } else {
      MyNavigator().pushReplacementNamed(context, 'Home');
    }
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.reportLogin(login_type);
    EVENT_BUS.emit(Event_Name.JUMP_TO_HOME);
  }

  @override
  Widget build(BuildContext context) {
    // 设置屏幕适配插件
    ScreenUtil.init(context, width: 1080, height: 1920);
    return Selector<UserModel, User>(
      selector: (context, provider) => provider.value,
      builder: (context, user, __) {
        return Container(
          width: ScreenUtil().setWidth(1080),
          height: ScreenUtil().setWidth(1920),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/image/screen.png'),
                  alignment: Alignment.center,
                  fit: BoxFit.fill)),
          child: Selector5<UserModel, TourismMap, LuckyGroup, TreeGroup,
                  MoneyGroup, List<bool>>(
              builder: (_, List<bool> loadArr, __) {
                List<bool> trueArr = loadArr.where((i) => i).toList();
                if (timeReached &&
                    trueArr.length == loadArr.length &&
                    user != null) {
                  Future.delayed(Duration(microseconds: 100)).then((e) {
                    if (user?.rela_account == '' ||
                        user?.access_token == '' ||
                        user?.access_token == null) {
                      // 出现登录按钮
                      useJump();
                    } else {
                      // 跳转到首页
                      go('1');
                    }
                  });
                }

                num progress = (min(
                    trueArr.length / loadArr.length, timeReached ? 1.0 : .9));

//                print(
//                    "loading_${progress}_${trueArr.length / loadArr.length}_$timeReached");

                return Container(
                  width: ScreenUtil().setWidth(1080),
                  height: ScreenUtil().setWidth(1920),
                  child: Stack(children: <Widget>[
                    Container(
                        width: ScreenUtil().setWidth(1080),
                        height: ScreenUtil().setWidth(1920),
                        child: Center(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ((user != null && user?.rela_account == '') ||
                                    (user != null && user?.access_token == ''))
                                ? GestureDetector(
                                    child: Image.asset(
                                      'assets/image/fb_play.png',
                                      width: ScreenUtil().setWidth(541),
                                      height: ScreenUtil().setWidth(147),
                                    ),
                                    onTap: () async {
                                      if (clickFlag) {
                                        return;
                                      }
                                      clickFlag = true;
                                      UserModel userModel =
                                          Provider.of<UserModel>(context,
                                              listen: false);
                                      bool loginSuccess =
                                          await userModel.loginWithFB();
                                      print(
                                          "loginWithFB_loginSuccess: $loginSuccess");
                                      if (loginSuccess) {
                                        Storage.clearAllCache();
                                        print("initMain_start");
                                        Initialize.initMain().then((_) {
                                          print("initMain_end");
                                          go('1');
                                        });
                                      } else {
                                        clickFlag = false;
                                        Layer.toastWarning(
                                            "Login Failed, Try Again Later");
                                      }
                                    })
                                : Container(),
                            Container(
                              height: ScreenUtil().setWidth(78),
                            ),
                            canJump &&
                                    (user != null && user?.access_token != '')
                                ? GestureDetector(
                                    child: Image.asset(
                                      'assets/image/guest_play.png',
                                      width: ScreenUtil().setWidth(541),
                                      height: ScreenUtil().setWidth(147),
                                    ),
                                    onTap: () {
                                      go('0');
                                    })
                                : Container()
                          ],
                        ))),
                    (user != null && user?.access_token != '')
                        ? Positioned(
                            left: ScreenUtil().setWidth(143),
                            bottom: ScreenUtil().setWidth(38),
                            child: Container(
                              width: ScreenUtil().setWidth(794),
                              height: ScreenUtil().setWidth(80),
                              child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: <Widget>[
                                    Container(
                                      width: ScreenUtil().setWidth(794),
                                      height: ScreenUtil().setWidth(80),
                                      child: Image.asset(
                                        'assets/image/loading_page_bar.png',
                                        width: ScreenUtil().setWidth(794),
                                        height: ScreenUtil().setWidth(80),
                                      ),
                                    ),
                                    Positioned(
                                      top: ScreenUtil().setWidth(10),
                                      left: ScreenUtil().setWidth(17),
                                      child: Container(
                                        width: ScreenUtil()
                                            .setWidth(761 * progress),
                                        height: ScreenUtil().setWidth(44),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/image/loading_bar_small.png'),
                                                alignment: Alignment.center,
                                                fit: BoxFit.fitHeight)),
                                      ),
                                    ),
                                    Text(
                                      "Loading Resource...",
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(35),
                                          height: 1,
                                          fontFamily: FontFamily.bold,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                            ))
                        : Container(),
                    Positioned(
                      top: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "UserID:${user?.acct_id ?? ""}",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(35),
                              height: 1,
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ]),
                );
              },
              selector: (context, pUserModel, pTourismMap, pLuckyGroup,
                      pTreeGroup, pMoneyGroup) =>
                  [
                    pUserModel.dataLoad,
                    pTourismMap.dataLoad,
                    pLuckyGroup.dataLoad,
                    pTreeGroup.dataLoad,
                    pMoneyGroup.dataLoad,
                  ]),
        );
      },
    );
  }
}
