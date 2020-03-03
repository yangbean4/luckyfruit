import 'package:flutter/material.dart';

// 椭圆
class EllipticalWidget extends StatelessWidget {
  final num width;
  final num height;
  final Color color;
  final Widget child;
  EllipticalWidget({
    Key key,
    @required this.width,
    @required this.height,
    @required this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.elliptical(width / 2, height / 2),
          )),
      child: child,
    );
  }
}
