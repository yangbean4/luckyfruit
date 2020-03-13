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
        Color.fromRGBO(51, 199, 86, 1),
        Color.fromRGBO(36, 182, 69, 1)
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
      ),
      child: child ??
          Center(
              child: ModalTitle(
            text,
            color: Colors.white,
          )),
    );
  }
}