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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  UserModel userModel = UserModel();
  TreeGroup treeGroup = TreeGroup();
  MoneyGroup moneyGroup = MoneyGroup();
  TourismMap tourismMap = TourismMap();
  userModel.initUser().then((e) {
    treeGroup.init(moneyGroup, userModel.value?.acct_id);
    moneyGroup.init(treeGroup, userModel.value?.acct_id);
  });

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
      ),
      initialRoute: 'Home',
      onGenerateRoute: onGenerateRoute,
    )));
  }
}
