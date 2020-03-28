import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/image/dividend_tree.png',
      width: ScreenUtil().setWidth(1080),
    );
  }
}
