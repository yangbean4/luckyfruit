import 'package:flutter/material.dart';

class DoubleQuit extends StatefulWidget {
  final Widget child;

  DoubleQuit({Key key, this.child}) : super(key: key);

  @override
  _DoubleQuitState createState() => _DoubleQuitState();
}

class _DoubleQuitState extends State<DoubleQuit> {
  DateTime lastPopTime;

  Future<bool> _onWillPop() async {
    final bool cake = lastPopTime != null &&
        DateTime.now().difference(lastPopTime) > Duration(seconds: 2);
    if (lastPopTime == null || cake) {
      lastPopTime = DateTime.now();
      return false;
    } else {
      lastPopTime = DateTime.now();
      // 退出app
      return true;
      // return await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: widget.child, onWillPop: _onWillPop);
  }
}
