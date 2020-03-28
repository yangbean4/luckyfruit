import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

class GoldText extends StatelessWidget {
  final String text;
  final double iconSize;
  final double textSize;
  final Color textColor;
  final String imgUrl;
  final String fontFamily;
  final FontWeight fontWeight;
  const GoldText(this.text,
      {Key key,
      this.imgUrl = "assets/image/gold.png",
      this.iconSize = 64,
      this.textSize = 43,
      this.fontFamily = FontFamily.semibold,
      this.fontWeight = FontWeight.w600,
      this.textColor = MyTheme.blackColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          imgUrl,
          width: ScreenUtil().setWidth(iconSize),
          height: ScreenUtil().setWidth(iconSize),
        ),
        Container(
            margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: ScreenUtil().setSp(textSize),
                fontFamily: fontFamily,
                fontWeight: fontWeight,
              ),
            )),
      ],
    );
  }
}
