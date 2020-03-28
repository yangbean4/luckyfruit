import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

// 次要的 红色文字
class SecondaryText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontsize;
  final FontWeight fontWeight;
  final textAlign;
  final String fontFamily;
  const SecondaryText(this.text,
      {Key key,
      this.color = MyTheme.blackColor,
      this.fontsize = 50,
      this.textAlign = TextAlign.center,
      this.fontFamily = FontFamily.regular,
      this.fontWeight = FontWeight.w600})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontSize: ScreenUtil().setSp(fontsize),
          fontFamily: fontFamily,
          fontWeight: fontWeight),
    );
  }
}
