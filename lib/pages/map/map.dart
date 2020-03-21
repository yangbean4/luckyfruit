import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel.getPersonalInfo();
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
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => MyNavigator().navigatorPop(context),
                      child: Container(
                        width: ScreenUtil().setWidth(147),
                        height: ScreenUtil().setWidth(289),
                        child: Center(
                          child: Container(
                            width: ScreenUtil().setWidth(29),
                            height: ScreenUtil().setWidth(49),
                            child: Text('<',
                                style: TextStyle(
                                    fontFamily: FontFamily.bold,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(60))),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      height: ScreenUtil().setWidth(500),
                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(120)),
                      child: Text(
                          'More trees your friends merge\nMore closer to the Bouns Tree!',
                          style: TextStyle(
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(60))),
                    ))
                  ]),
            ),
            Container(
              height: ScreenUtil().setWidth(210),
            ),
            Expanded(
                child: Container(
              width: ScreenUtil().setWidth(1080),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(ScreenUtil().setWidth(40)),
                    topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                  )),
            ))
          ],
        ),
        Positioned(
          top: ScreenUtil().setWidth(390),
          left: ScreenUtil().setWidth(60),
          child: Container(
            width: ScreenUtil().setWidth(960),
            height: ScreenUtil().setWidth(254),
            padding: EdgeInsets.all(ScreenUtil().setWidth(45)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(40)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(517),
                  height: ScreenUtil().setWidth(89),
                  child: Text('100% chance to get the Bouns Tree',
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
                          provider.personalInfo?.count_ratio,
                      builder: (_, num count_ratio, __) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(220),
                              height: ScreenUtil().setWidth(30),
                              child: Text('your progress',
                                  style: TextStyle(
                                      fontFamily: FontFamily.regular,
                                      color: MyTheme.blackColor,
                                      height: 1.0,
                                      fontSize: ScreenUtil().setSp(34))),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(220),
                              height: ScreenUtil().setWidth(34),
                              child: Text('$count_ratio%',
                                  style: TextStyle(
                                      fontFamily: FontFamily.regular,
                                      color: MyTheme.blackColor,
                                      height: 1.0,
                                      fontSize: ScreenUtil().setSp(34))),
                            ),
                          ],
                        );
                      },
                    ))
              ],
            ),
          ),
        ),
        Positioned(
            top: ScreenUtil().setWidth(252),
            right: ScreenUtil().setWidth(70),
            child: Container(
              width: ScreenUtil().setWidth(344),
              height: ScreenUtil().setWidth(279),
              child: Image.asset(
                'assets/image/money_bag.png',
                width: ScreenUtil().setWidth(344),
                height: ScreenUtil().setWidth(279),
              ),
            ))
      ],
    );
  }
}

class MapPrizeModal {
  show() {}
}

class _MapPrize extends StatefulWidget {
  _MapPrize({Key key}) : super(key: key);

  @override
  __MapPrizeState createState() => __MapPrizeState();
}

class __MapPrizeState extends State<_MapPrize> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
