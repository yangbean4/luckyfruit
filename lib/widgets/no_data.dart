import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/index.dart';

class NoData extends StatelessWidget {
  final String msg;
  const NoData({Key key, this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/image/no_data.png',
          width: ScreenUtil().setWidth(466),
          height: ScreenUtil().setWidth(527),
        ),
        Container(
          height: ScreenUtil().setWidth(90),
          child: null,
        ),
        Text(
          msg,
          style: TextStyle(
              color: MyTheme.tipsColor,
              fontFamily: FontFamily.semibold,
              fontSize: ScreenUtil().setWidth(46)),
        )
      ],
    ));
  }
}
