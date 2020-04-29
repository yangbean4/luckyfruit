import 'package:flutter/material.dart';
import 'package:luckyfruit/config/app.dart' show Event_Name;
import 'package:luckyfruit/utils/event_bus.dart';

class MyNavigator {
  void pushNamed(BuildContext context, String path, {arguments}) {
    if (context == null) {
      return;
    }
    _routerChange();
    Navigator.pushNamed(context, path, arguments: arguments);
  }

  void pushReplacementNamed(BuildContext context, String path, {arguments}) {
    if (context == null) {
      return;
    }
    _routerChange();
    Navigator.pushReplacementNamed(context, path, arguments: arguments);
  }

  void navigatorPop(BuildContext context) {
    _routerChange();
    Navigator.pop(context, true);
  }

  _routerChange() {
    // 路由跳转, 全局通知
    EVENT_BUS.emit(Event_Name.Router_Change);
  }
}
