import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

// 次要的 红色文字
class SecondaryText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontsize;
  const SecondaryText(this.text, {Key key, this.color, this.fontsize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: color ?? MyTheme.blackColor,
          fontSize: ScreenUtil().setWidth(fontsize ?? 50),
          fontWeight: FontWeight.w600),
    );
  }
}
