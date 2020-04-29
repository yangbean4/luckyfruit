import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/pages/map/map.dart' show MapPage;
import 'package:luckyfruit/pages/mine/mine.dart' show MinePage;
import 'package:luckyfruit/pages/partner/partner.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/utils/method_channel.dart';
import 'package:luckyfruit/widgets/guidance_draw_circle.dart';
import 'package:luckyfruit/widgets/guidance_draw_recycle.dart';
import 'package:luckyfruit/widgets/guidance_draw_rrect.dart';
import 'package:luckyfruit/widgets/guidance_finger.dart';
import 'package:luckyfruit/widgets/guidance_first_get_money.dart';
import 'package:luckyfruit/widgets/guidance_map.dart';
import 'package:luckyfruit/widgets/guidance_welcome.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/widgets/lucky_wheel_unlock_animation.dart';
import 'package:provider/provider.dart';

import './trip/trip.dart';
import '../theme/index.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

Map<String, String> pageCodeTarget = {
  "trip": '001',
  "map": '014',
  "partner": '015',
  "mine": '034',
};

class _HomeState extends State<Home> with WidgetsBindingObserver {
  int tabIndex = 0;
  List<Widget> pageList = [Trip(), MapPage(), Partner(), MinePage()];

  final pageController = PageController();

  //监听
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      print('AppLifecycleState.paused');
      BurialReport.report('switchback', {'type': '2'});

      EVENT_BUS.emit(Event_Name.APP_PAUSED);
    }
    if (state == AppLifecycleState.resumed) {
      BurialReport.report('switchback', {'type': '1'});

      EVENT_BUS.emit(Event_Name.APP_RESUMED);
    }
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    WidgetsBinding.instance.addObserver(this); // 注册监听器
    BurialReport.report('page_imp', {'page_code': '001'});

    // 初始化完成后调用java代码上报安装列表
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    channelBus.callNativeMethod(Event_Name.start_report_app_list,
        arguments: <String, dynamic>{
          'acct_id': userModel.value?.acct_id,
        });
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    WidgetsBinding.instance.removeObserver(this); // 移除监听器
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    BurialReport.report('switchback', {'type': '2'});

    EVENT_BUS.emit(Event_Name.APP_PAUSED);
    return false;
  }

  void onPageChanged(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  BottomNavigationBarItem _createBarItem(
      {String iconUrl, String activeIconUrl, String name, bool remind = true}) {
    return BottomNavigationBarItem(
        icon: remind
            ? Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Image.asset(
                    iconUrl,
                    width: ScreenUtil().setWidth(56),
                  ),
                  Positioned(
                      right: ScreenUtil().setWidth(-20),
                      top: ScreenUtil().setWidth(-16),
                      child: Container(
                        width: ScreenUtil().setWidth(20),
                        height: ScreenUtil().setWidth(20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment(0.0, -1.0),
                                end: Alignment(0.0, 1.0),
                                colors: <Color>[
                                  Color(0xffFE6541),
                                  Color(0xffDC1B0C),
                                ]),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(10)))),
                        child: null,
                      ))
                ],
              )
            : Image.asset(
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

  Widget _createBottomBar(Map<String, bool> remind) {
    List<BottomNavigationBarItem> items = [
      _createBarItem(
          iconUrl: 'assets/image/trip.png',
          activeIconUrl: 'assets/image/trip_active.png',
          remind: remind['trip'] ?? false,
          name: 'TRIP'),
      _createBarItem(
          iconUrl: 'assets/image/map.png',
          remind: remind['map'] ?? false,
          activeIconUrl: 'assets/image/map_active.png',
          name: 'MAP'),
    ];
    if (remind['isM']) {
      items.add(_createBarItem(
          iconUrl: 'assets/image/partner.png',
          remind: remind['partner'] ?? false,
          activeIconUrl: 'assets/image/partner_active.png',
          name: 'PARTNER'));
    }
    if (remind['isM']) {
      items.add(_createBarItem(
          iconUrl: 'assets/image/mine.png',
          remind: remind['mine'] ?? false,
          activeIconUrl: 'assets/image/mine_active.png',
          name: 'MINE'));
    }
    return BottomNavigationBar(
      key: Consts.globalKeyBottomBar,
      iconSize: ScreenUtil().setWidth(56),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: ScreenUtil().setSp(34),
      unselectedFontSize: ScreenUtil().setSp(34),
      selectedItemColor: MyTheme.mainActiveColor,
      unselectedItemColor: MyTheme.mainItemColor,
      items: items,
      currentIndex: this.tabIndex,
      onTap: (int index) {
        List<String> pageName = ['trip', 'map', 'partner', 'mine'];
        pageController.jumpToPage(index);
        String goName = pageName[index];
        BurialReport.report('page_imp', {'page_code': pageCodeTarget[goName]});
        if (goName == 'map' && remind['map']) {
          TourismMap tourismMap =
              Provider.of<TourismMap>(context, listen: false);
          tourismMap.newCitydeblock = false;
        } else if (goName == 'partner' && remind['partner']) {
          Layer.partnerCash(context);
          TreeGroup tourismMap = Provider.of<TreeGroup>(context, listen: false);
          tourismMap.isFirstTimeimt = false;
        }
      },
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
          bottomNavigationBar:
              Selector3<TourismMap, TreeGroup, UserModel, Map<String, bool>>(
                  builder: (_, Map<String, bool> remind, __) {
                    return _createBottomBar(remind);
                  },
                  selector: (context, TourismMap pTourismMap,
                          TreeGroup pTreeGroup, UserModel userModel) =>
                      {
                        'map': pTourismMap.newCitydeblock,
                        'partner': pTreeGroup.isFirstTimeimt,
                        'isM': userModel.value.is_m != 0
                      }),
        ),
        // 新手引导-welcome
        GuidanceWelcomeWidget(),
        // 新手引导-添加树
        GuidanceDrawCircleWidget(),
        // 新手引导-合成树
        GuidanceDrawRRectWidget(),
        // 新手引导-map
        GuidanceMapWidget(),
        // 新手引导-firstGetMoney
        GuidanceFirstGetMoneyWidget(),
        // 大转盘解锁
        WheelUnlockWidget(),
        // 手指引导
        GuidanceFingerWidget(),
        // 新手引导-回收树木
        GuidanceDrawRecycleWidget(),
      ],
    );
  }
}
