import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

class FourthText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontsize;
  final FontWeight fontWeight;
  final String fontFamily;

  const FourthText(this.text,
      {Key key,
      this.color = MyTheme.lightGrayColor,
      this.fontsize = 40,
      this.fontWeight = FontWeight.w500,
      this.fontFamily = FontFamily.semibold})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: fontFamily,
          color: color,
          fontSize: ScreenUtil().setWidth(fontsize),
          fontWeight: fontWeight),
    );
  }
}
