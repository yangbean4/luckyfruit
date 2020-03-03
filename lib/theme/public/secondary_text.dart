import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

// 次要的 红色文字
class SecondaryText extends StatelessWidget {
  final String text;
  const SecondaryText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: MyTheme.secondaryColor,
          fontSize: ScreenUtil().setWidth(46),
          fontWeight: FontWeight.w600),
    );
  }
}
