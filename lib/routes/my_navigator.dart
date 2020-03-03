import 'package:flutter/material.dart';

import 'package:luckyfruit/utils/event_bus.dart';

class MyNavigator {
  pushNamed(BuildContext context, String path, arg) {
    _routerChange();
    Navigator.pushNamed(context, path, arguments: arg);
  }

  navigatorPop(BuildContext context) {
    _routerChange();
    Navigator.pop(context, true);
  }

  _routerChange() {
    // 路由跳转,视屏停止
    EVENT_BUS.emit('routerChange');
  }
}
