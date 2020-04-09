import 'package:flutter/material.dart';

import 'package:luckyfruit/models/user.dart';
import 'package:provider/provider.dart';

import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart' show Consts;

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    // 设置屏幕适配插件
    ScreenUtil.init(context, width: 1080, height: 1920);
    return Container(
      width: ScreenUtil().setWidth(1080),
      height: ScreenUtil().setWidth(1920),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/image/screen.png'),
              alignment: Alignment.center,
              fit: BoxFit.fill)),
      child: Selector5<UserModel, TourismMap, LuckyGroup, TreeGroup, MoneyGroup,
              List<bool>>(
          builder: (_, List<bool> loadArr, __) {
            List<bool> trueArr = loadArr.where((i) => i).toList();
            if (trueArr.length == loadArr.length) {
              Future.delayed(Duration(microseconds: 100)).then((e) {
                // 切换到map的tab栏
                BottomNavigationBar navigationBar =
                    Consts.globalKey.currentWidget;
                if (navigationBar != null) {
                  navigationBar?.onTap(0);
                } else {
                  MyNavigator().pushReplacementNamed(context, 'Home');
                }
              });
            }
            return Container(
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setWidth(1920),
              child: Stack(children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(1080),
                  height: ScreenUtil().setWidth(1920),
                  child: Selector<UserModel, User>(
                    selector: (context, provider) => provider.value,
                    builder: (context, user, __) {
                      return user != null && user.rela_account == ''
                          ? Center(
                              child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                    child: Image.asset(
                                      'assets/image/fb_play.png',
                                      width: ScreenUtil().setWidth(541),
                                      height: ScreenUtil().setWidth(147),
                                    ),
                                    onTap: () {
                                      UserModel userModel =
                                          Provider.of<UserModel>(context,
                                              listen: false);
                                      userModel.loginWithFB();
                                    }),
                                Container(
                                  height: ScreenUtil().setWidth(78),
                                ),
                                GestureDetector(
                                    child: Image.asset(
                                      'assets/image/guest_play.png',
                                      width: ScreenUtil().setWidth(541),
                                      height: ScreenUtil().setWidth(147),
                                    ),
                                    onTap: () {
                                      // UserModel userModel =
                                      //     Provider.of<UserModel>(context,
                                      //         listen: false);
                                      // userModel.loginWithFB();
                                    }),
                              ],
                            ))
                          : Container();
                    },
                  ),
                ),
                Positioned(
                    left: ScreenUtil().setWidth(143),
                    bottom: ScreenUtil().setWidth(38),
                    child: Container(
                      width: ScreenUtil().setWidth(794),
                      height: ScreenUtil().setWidth(80),
                      child: Stack(children: <Widget>[
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
                            width: ScreenUtil().setWidth(
                                761 * trueArr.length / loadArr.length),
                            height: ScreenUtil().setWidth(44),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/image/loading_bar_small.png'),
                                    alignment: Alignment.center,
                                    fit: BoxFit.fitHeight)),
                          ),
                        )
                      ]),
                    ))
              ]),
            );
          },
          selector: (context, pUserModel, pTourismMap, pLuckyGroup, pTreeGroup,
                  pMoneyGroup) =>
              [
                pUserModel.dataLoad,
                pTourismMap.dataLoad,
                pLuckyGroup.dataLoad,
                pTreeGroup.dataLoad,
                pMoneyGroup.dataLoad,
              ]),
    );
  }
}
