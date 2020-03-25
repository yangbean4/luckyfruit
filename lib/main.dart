import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'package:luckyfruit/widgets/double_click_quit.dart';
import 'package:luckyfruit/routes/router.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/utils/bgm.dart';

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
    luckyGroup.init(userModel.value.last_draw_time, userModel.value?.version,
        userModel.value?.acct_id);
    treeGroup.init(moneyGroup, luckyGroup, userModel.value?.acct_id);
    moneyGroup.init(treeGroup, userModel.value?.acct_id);
    tourismMap.init(moneyGroup, luckyGroup, treeGroup,
        userModel.value?.level ?? '1', userModel.value?.acct_id);
  });

// 开启背景音乐
  // Bgm.init();

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
