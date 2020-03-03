import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

class GoldText extends StatelessWidget {
  final String text;
  const GoldText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/image/gold.png',
          width: ScreenUtil().setWidth(64),
          height: ScreenUtil().setWidth(64),
        ),
        Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(25),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setWidth(43),
                fontWeight: FontWeight.w600,
              ),
            )),
      ],
    );
  }
}
