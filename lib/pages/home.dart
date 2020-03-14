import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import './trip/trip.dart';
import '../theme/index.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/config/app.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  BottomNavigationBar bottomBar;
  int tabIndex = 0;
  List<Widget> pageList = [Trip(), Text('MAP')];

  //监听
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      EVENT_BUS.emit(Event_Name.APP_PAUSED);
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
              fontSize: ScreenUtil().setWidth(34)),
        ));
  }

  Widget _createBottomBar() {
    return BottomNavigationBar(
      iconSize: ScreenUtil().setWidth(56),
      showUnselectedLabels: true,
      selectedFontSize: ScreenUtil().setWidth(34),
      unselectedFontSize: ScreenUtil().setWidth(34),
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
      onTap: (int index) {
        setState(() {
          this.tabIndex = index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyBuider = tabIndex == 0 ? Trip() : Text('MAP');
    // 设置屏幕适配插件
    ScreenUtil.init(context, width: 1080, height: 1920);

    return Scaffold(
      // 通过IndexedStack 保持页面状态
      body: IndexedStack(
        children: pageList,
        index: tabIndex,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _createBottomBar(),
    );
  }
}
