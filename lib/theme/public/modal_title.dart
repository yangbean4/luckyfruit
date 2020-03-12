import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../index.dart';

class ModalTitle extends StatelessWidget {
  final String text;
  const ModalTitle(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: ScreenUtil().setWidth(70),
            color: MyTheme.blackColor,
            fontFamily: FontFamily.bold,
            fontWeight: FontWeight.bold));
  }
}
