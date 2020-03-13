import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

class GoldText extends StatelessWidget {
  final String text;
  final double iconSize;
  final double textSize;
  const GoldText(this.text, {Key key, this.iconSize = 64, this.textSize = 43})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/image/gold.png',
          width: ScreenUtil().setWidth(iconSize),
          height: ScreenUtil().setWidth(iconSize),
        ),
        Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(25),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setWidth(textSize),
                fontWeight: FontWeight.w600,
              ),
            )),
      ],
    );
  }
}
