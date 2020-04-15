import 'package:flutter/material.dart';

// 椭圆
class EllipticalWidget extends StatelessWidget {
  final num width;
  final num height;
  final Widget child;
  final List<Color> colors;

  EllipticalWidget({
    Key key,
    @required this.width,
    @required this.height,
    @required this.colors,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: colors),
          borderRadius: BorderRadius.all(
            Radius.circular(width / 2),
          )),
      child: child,
    );
  }
}
