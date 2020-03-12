import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';

// 右上角的一些入口玩法

class TripBtns extends StatefulWidget {
  TripBtns({Key key}) : super(key: key);

  @override
  _TripBtnsState createState() => _TripBtnsState();
}

class _TripBtnsState extends State<TripBtns> {
  List<Widget> btnList;
  @override
  void initState() {
    super.initState();
    btnList = [
      getItem('assets/image/phone.png', () {
        print('phone');
      }, 'FREE', labelColor: MyTheme.redColor),
      getItem('assets/image/spin.png', () {
        print('spin');
      }, 'SPIN'),
      getItem('assets/image/rank.png', () {
        print('rank');
      }, 'RANK'),
      getItem('assets/image/help.png', () {
        print('help');
      }, 'HOW TO PLAY'),
    ];
  }

  Widget getItem(String imgSrc, Function onTap, String label,
      {Color labelColor, double labelWith}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ScreenUtil().setWidth(96),
        height: ScreenUtil().setWidth(96),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(96),
              height: ScreenUtil().setWidth(96),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                // image: DecorationImage(
                //   image: AssetImage(
                //     'assets/image/imgSrc.png',
                //   ),
                //   alignment: Alignment.center,
                //   fit: BoxFit.cover,
                // )
              ),
              child: Center(
                  child: Image.asset(
                imgSrc,
                width: ScreenUtil().setWidth(56),
                height: ScreenUtil().setWidth(56),
              )),
            ),
            Positioned(
              top: ScreenUtil().setWidth(86),
              left:
                  ScreenUtil().setWidth(96 - (labelColor == null ? 146 : 80)) /
                      2,
              child: Center(
                child: Container(
                  height: ScreenUtil().setWidth(20),
                  width: ScreenUtil().setWidth(labelColor == null ? 146 : 80),
                  decoration: BoxDecoration(
                      color: labelColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(10)))),
                  child: labelColor == null
                      ? Center(
                          child: Stack(children: <Widget>[
                          Text(
                            label,
                            style: TextStyle(
                                height: 1,
                                foreground: new Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = ScreenUtil().setSp(3)
                                  ..color = Colors.white,
                                fontFamily: FontFamily.bold,
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            label,
                            style: TextStyle(
                                color: labelColor == null
                                    ? MyTheme.blackColor
                                    : Colors.white,
                                height: 1,
                                fontFamily: FontFamily.bold,
                                fontSize: ScreenUtil().setSp(20),
                                fontWeight: FontWeight.bold),
                          )
                        ]))
                      : Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: labelColor == null
                                  ? MyTheme.blackColor
                                  : Colors.white,
                              height: 1,
                              fontFamily: FontFamily.bold,
                              fontSize: ScreenUtil().setSp(20),
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: btnList,
    );
  }
}
