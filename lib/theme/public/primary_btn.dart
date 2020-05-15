import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import './modal_title.dart';

class PrimaryButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final List<Color> colors;
  final String text;

  const PrimaryButton(
      {Key key,
      this.child,
      this.width,
      this.height,
      this.colors = const <Color>[
        Color.fromRGBO(49, 200, 84, 1),
        Color.fromRGBO(36, 185, 71, 1)
      ],
      this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // minWidth: ScreenUtil().setWidth(560),
      width: ScreenUtil().setWidth(width),
      height: ScreenUtil().setWidth(height),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: colors),
          borderRadius: BorderRadius.all(
            Radius.elliptical(
              ScreenUtil().setWidth(height / 2),
              ScreenUtil().setWidth(height / 2),
            ),
          ),
          boxShadow: [
            //阴影
            BoxShadow(
                color: Colors.black26,
                offset: Offset(2.0, 2.0),
                blurRadius: 2.0),
          ]),
      child: child ??
          Center(
              child: ModalTitle(
            text,
            color: Colors.white,
          )),
    );
  }
}
