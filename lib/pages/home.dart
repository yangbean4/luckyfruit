import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/pages/map/map.dart' show MapPage;
import 'package:luckyfruit/pages/mine/mine.dart' show MinePage;
import 'package:luckyfruit/pages/partner/partner.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/widgets/coin_rain.dart';
import 'package:luckyfruit/widgets/guidance_draw_circle.dart';
import 'package:luckyfruit/widgets/guidance_draw_rrect.dart';
import 'package:luckyfruit/widgets/guidance_map.dart';
import 'package:luckyfruit/widgets/guidance_welcome.dart';
import 'package:luckyfruit/widgets/lucky_wheel_unlock_animation.dart';

import './trip/trip.dart';
import '../theme/index.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  int tabIndex = 0;
  List<Widget> pageList = [Trip(), MapPage(), Partner(), MinePage()];

  final pageController = PageController();

  //监听
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      print('12313${AppLifecycleState.paused}');
      EVENT_BUS.emit(Event_Name.APP_PAUSED);
    }
    if (state == AppLifecycleState.resumed) {
      EVENT_BUS.emit(Event_Name.APP_RESUMED);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this); // 注册监听器
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 移除监听器
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  BottomNavigationBarItem _createBarItem(
      {String iconUrl, String activeIconUrl, String name}) {
    return BottomNavigationBarItem(
        icon: Image.asset(
          iconUrl,
          width: ScreenUtil().setWidth(56),
        ),
        activeIcon: Image.asset(
          activeIconUrl,
          width: ScreenUtil().setWidth(56),
        ),
        title: Text(
          name,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontFamily: 'semibold',
              height: 1.2,
              fontSize: ScreenUtil().setSp(34)),
        ));
  }

  Widget _createBottomBar() {
    return BottomNavigationBar(
      key: Consts.globalKey,
      iconSize: ScreenUtil().setWidth(56),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: ScreenUtil().setSp(34),
      unselectedFontSize: ScreenUtil().setSp(34),
      selectedItemColor: MyTheme.mainActiveColor,
      unselectedItemColor: MyTheme.mainItemColor,
      items: [
        _createBarItem(
            iconUrl: 'assets/image/trip.png',
            activeIconUrl: 'assets/image/trip_active.png',
            name: 'TRIP'),
        _createBarItem(
            iconUrl: 'assets/image/map.png',
            activeIconUrl: 'assets/image/map_active.png',
            name: 'MAP'),
        _createBarItem(
            iconUrl: 'assets/image/partner.png',
            activeIconUrl: 'assets/image/partner_active.png',
            name: 'PARTNER'),
        _createBarItem(
            iconUrl: 'assets/image/mine.png',
            activeIconUrl: 'assets/image/mine_active.png',
            name: 'MINE'),
      ],
      currentIndex: this.tabIndex,
      onTap: (int index) => pageController.jumpToPage(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 设置屏幕适配插件
    // ScreenUtil.init(context, width: 1080, height: 1920);
    return Stack(
      children: <Widget>[
        Scaffold(
          // 通过IndexedStack 保持页面状态 但是会所有页面都初始化 so: pass
          // body: IndexedStack(
          //   children: pageList,
          //   index: tabIndex,
          // ),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: onPageChanged,
            children: pageList,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _createBottomBar(),
        ),
        // 金币雨动效
        CoinRainWidget(),
        // 新手引导-welcome
        GuidanceWelcomeWidget(),
        // 新手引导-添加树
        GuidanceDrawCircleWidget(),
        // 新手引导-合成树
        GuidanceDrawRRectWidget(),
        // 新手引导-map
        GuidanceMapWidget(),
        //大转盘解锁
        WheelUnlockWidget(),
      ],
    );
  }
}
