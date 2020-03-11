import 'package:flutter/material.dart';

import 'package:luckyfruit/pages/illustration/illustration.dart';
import '../pages/Home.dart';

final routes = {
  'Home': (context) => Home(),
  'Illustration': (context) => Illustration(),
  // 'app.content': (content, {arguments}) => AppPage(arguments: arguments),
  '404': (context) => Text("404"),
};

var onGenerateRoute = (RouteSettings routeSettings) {
  final String name = routeSettings.name;

  final Function pageBuilder = routes[name];
  if (pageBuilder != null) {
    Route route;
    if (routeSettings.arguments != null) {
      route = MaterialPageRoute(
          builder: (context) =>
              pageBuilder(context, arguments: routeSettings.arguments));
    } else {
      route = MaterialPageRoute(builder: (context) => pageBuilder(context));
    }
    return route;
  } else {
    // miss match
    final Function notFoundPageBuilder = routes['404'];
    final Route route =
        MaterialPageRoute(builder: (context) => notFoundPageBuilder(context));
    return route;
  }
};
