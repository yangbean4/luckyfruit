import 'package:flutter/material.dart';

import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'package:luckyfruit/widgets/double_click_quit.dart';
import 'package:luckyfruit/routes/router.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tourism_map.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  TreeGroup treeGroup = TreeGroup();
  MoneyGroup moneyGroup = MoneyGroup();
  TourismMap tourismMap = TourismMap();
  treeGroup.init(moneyGroup);
  moneyGroup.init(treeGroup);

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
