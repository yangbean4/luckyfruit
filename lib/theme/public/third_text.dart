import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

class ThirdText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontsize;
  final FontWeight fontWeight;
  final String fontFamily;
  const ThirdText(this.text,
      {Key key,
      this.color = MyTheme.tipsColor,
      this.fontsize = 30,
      this.fontWeight = FontWeight.normal,
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
