import 'dart:ui';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/router.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/bgm.dart';
import 'package:luckyfruit/utils/daynamic_links.dart';
import 'package:luckyfruit/widgets/double_click_quit.dart';
import 'package:luckyfruit/widgets/gold_flying_animation.dart';
import 'package:luckyfruit/widgets/guidance_lucky_wheel.dart';
import 'package:luckyfruit/widgets/money_flying_animation.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'mould/tree.mould.dart';
import 'utils/firebase_msg.dart';
import 'utils/mo_ad.dart';

void main() {
  // debugProfileBuildsEnabled = true;
  // debugPrintRebuildDirtyWidgets = true;
  // debugProfilePaintsEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  DynamicLink.initDynamicLinks();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Sse.init();\

  // 初始化Adjust
  AdjustConfig config =
      new AdjustConfig('p3j6r5u7mvi8', AdjustEnvironment.production);
//  config.logLevel = AdjustLogLevel.verbose;
  Adjust.start(config);

  Initialize.initMain();

// 开启背景音乐
  Bgm.init();

  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TreeGroup>.value(
        value: Initialize.treeGroup,
      ),
      ChangeNotifierProvider<MoneyGroup>.value(
        value: Initialize.moneyGroup,
      ),
      ChangeNotifierProvider<TourismMap>.value(
        value: Initialize.tourismMap,
      ),
      ChangeNotifierProvider<LuckyGroup>.value(
        value: Initialize.luckyGroup,
      ),
      ChangeNotifierProvider<UserModel>.value(
        value: Initialize.userModel,
      ),
    ],
    child: MyApp(),
  ));
}

class Initialize {
  static UserModel userModel = UserModel();
  static TreeGroup treeGroup = TreeGroup();
  static MoneyGroup moneyGroup = MoneyGroup();
  static TourismMap tourismMap = TourismMap();
  static LuckyGroup luckyGroup = LuckyGroup();

  static Future initMain() async {
    print("initMain1");
    await userModel.initUser().then((e) {
      print("initMain2_${userModel.value.device_id}");
      Service().userModel = userModel;
      final String userId = userModel.value?.acct_id;
      // 初始化firebase_messaging
      FbMsg.init(userId);
      // 监听来源 :是否是DynamicLink
      DynamicLink.setUserId(userId);
      print("initMain3");
      luckyGroup
          .init(userModel.value.last_draw_time, userModel.value?.version,
              userModel.value.share_version, userId)
          .then((e) {
        Tree.init(luckyGroup.treeConfig);

        treeGroup.init(moneyGroup, luckyGroup, userModel);
        tourismMap.init(moneyGroup, luckyGroup, treeGroup, userModel);
        moneyGroup.init(
            treeGroup, userModel, luckyGroup.issed.first_reward_coin);
        print("initMain4");
      });
    });
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    MoAd.getInstance(context);
    var overlay = Overlay(initialEntries: [
      OverlayEntry(
        builder: (BuildContext context) {
          return Stack(
            children: <Widget>[
              DoubleQuit(
                child: OKToast(
                  child: MaterialApp(
                    title: 'Lucky Merge',
                    theme: ThemeData(
                        primarySwatch: Colors.blue,
                        textTheme:
                            TextTheme().apply(decoration: TextDecoration.none)),
                    initialRoute: 'loadingPage',
                    onGenerateRoute: onGenerateRoute,
                    // showPerformanceOverlay: true,
                  ),
                ),
              ),
              // 美元图标飞向右下角动效
              MoneyFlyingAnimation(),
              // 领取金币动画
              GoldFlyingAnimation(),
              // 新手引导-大转盘
              GuidanceLuckyWheelWidget(),
            ],
          );
        },
      )
    ]);

    return Directionality(
      child: overlay,
      textDirection: TextDirection.ltr,
    );
  }
}
