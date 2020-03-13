import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../index.dart';

class ModalTitle extends StatelessWidget {
  final String text;
  final Color color;
  final double fontsize;
  final FontWeight fontWeight;
  const ModalTitle(this.text,
      {Key key,
      this.color = MyTheme.blackColor,
      this.fontsize = 70,
      this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: ScreenUtil().setWidth(fontsize),
            color: color,
            fontFamily: FontFamily.bold,
            fontWeight: FontWeight.bold));
  }
}
