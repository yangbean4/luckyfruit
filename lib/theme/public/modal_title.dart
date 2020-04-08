import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../index.dart';

class ModalTitle extends StatelessWidget {
  final String text;
  final Color color;
  final num fontsize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  const ModalTitle(
    this.text, {
    Key key,
    this.color = MyTheme.blackColor,
    this.fontsize = 70,
    this.fontWeight,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: textAlign,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(fontsize),
            color: color,
            height: 1,
            fontFamily: FontFamily.bold,
            fontWeight: FontWeight.bold));
  }
}
