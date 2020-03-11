import 'package:flutter/material.dart';

import 'package:luckyfruit/utils/event_bus.dart';

class MyNavigator {
  static const String Router_Change = 'Router_Change';
  void pushNamed(BuildContext context, String path, {arguments}) {
    _routerChange();
    Navigator.pushNamed(context, path, arguments: arguments);
  }

  void navigatorPop(BuildContext context) {
    _routerChange();
    Navigator.pop(context, true);
  }

  _routerChange() {
    // 路由跳转, 全局通知
    EVENT_BUS.emit(MyNavigator.Router_Change);
  }
}
