import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initState');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}

class MapPrizeModal {
  show() {}
}

class _MapPrize extends StatefulWidget {
  _MapPrize({Key key}) : super(key: key);

  @override
  __MapPrizeState createState() => __MapPrizeState();
}

class __MapPrizeState extends State<_MapPrize> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
