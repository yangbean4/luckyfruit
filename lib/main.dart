import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:luckyfruit/utils/bgm.dart';
import 'package:luckyfruit/utils/daynamic_links.dart';
import 'package:luckyfruit/utils/firebase_msg.dart';

import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'package:luckyfruit/widgets/double_click_quit.dart';
import 'package:luckyfruit/routes/router.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'mould/tree.mould.dart';
import 'utils/mo_ad.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // Sse.init();\
  UserModel userModel = UserModel();
  TreeGroup treeGroup = TreeGroup();
  MoneyGroup moneyGroup = MoneyGroup();
  TourismMap tourismMap = TourismMap();
  LuckyGroup luckyGroup = LuckyGroup();
  userModel.initUser().then((e) {
    final String userId = userModel.value?.acct_id;
    // 初始化firebase_messaging
    FbMsg.init(userId);
    // 监听来源 :是否是DynamicLink
    DynamicLink.initDynamicLinks(userId);
    MoAd.USER_ID = userId;
    luckyGroup
        .init(userModel.value.last_draw_time, userModel.value?.version, userId)
        .then((e) {
      Tree.init(luckyGroup.treeConfig);

      treeGroup.init(moneyGroup, luckyGroup, userModel);
      tourismMap.init(moneyGroup, luckyGroup, treeGroup, userModel);
      moneyGroup.init(treeGroup, userModel);
    });
  });

// 开启背景音乐
  Bgm.init();

  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TreeGroup>.value(
        value: treeGroup,
      ),
      ChangeNotifierProvider<MoneyGroup>.value(
        value: moneyGroup,
      ),
      ChangeNotifierProvider<TourismMap>.value(
        value: tourismMap,
      ),
      ChangeNotifierProvider<LuckyGroup>.value(
        value: luckyGroup,
      ),
      ChangeNotifierProvider<UserModel>.value(
        value: userModel,
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return DoubleQuit(
        child: OKToast(
            child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme().apply(decoration: TextDecoration.none)),
      initialRoute: 'Home',
      onGenerateRoute: onGenerateRoute,
    )));
  }
}
