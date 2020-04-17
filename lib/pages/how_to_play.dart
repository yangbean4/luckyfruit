import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

class HowToPlay extends StatefulWidget {
  HowToPlay({Key key}) : super(key: key);

  @override
  _HowToPlayState createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        iconTheme: IconThemeData(
          color: MyTheme.blackColor,
        ),
        backgroundColor: MyTheme.grayColor,
        title: Align(
          alignment: Alignment(-0.3, 0),
          child: Text(
            'How to play',
            style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setSp(70),
                fontFamily: FontFamily.bold,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: ScreenUtil().setWidth(1080),
          height: ScreenUtil().setWidth(6707),
          child: Image.asset(
            'assets/image/how_to_play.png',
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(6707),
          ),
        ),
      ),
    );
  }
}
