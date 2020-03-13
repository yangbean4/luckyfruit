import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/widgets/count_down.dart';
import 'package:luckyfruit/widgets/layer.dart';

// 右上角的一些入口玩法

class TripBtns extends StatefulWidget {
  TripBtns({Key key}) : super(key: key);

  @override
  _TripBtnsState createState() => _TripBtnsState();
}

class _TripBtnsState extends State<TripBtns> {
  String goldLabel = '';
  Duration getGoldCountdown;
  bool isCountdown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((c) {
      Duration _getGoldCountdown =
          Provider.of<LuckyGroup>(context, listen: false).getGoldCountdown;
      if (_getGoldCountdown != null) {
        setState(() {
          getGoldCountdown = _getGoldCountdown;
          isCountdown = true;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget getItem(String imgSrc, Function onTap, label,
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
                  child: label is Widget
                      ? label
                      : labelColor == null
                          ? Center(
                              child: Stack(children: <Widget>[
                              Text(
                                label,
                                style: TextStyle(
                                    height: 1,
                                    foreground: new Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = ScreenUtil().setWidth(3)
                                      ..color = Colors.white,
                                    fontFamily: FontFamily.bold,
                                    fontSize: ScreenUtil().setWidth(20),
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
                                    fontSize: ScreenUtil().setWidth(20),
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
                                  fontSize: ScreenUtil().setWidth(20),
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
      children: [
        getItem('assets/image/gold.png', () {
          print('gold');
        },
            isCountdown
                ? CountdownFormatted(
                    duration: getGoldCountdown,
                    builder: (context, String str) {
                      return Text(
                        str,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            height: 1,
                            fontFamily: FontFamily.bold,
                            fontSize: ScreenUtil().setWidth(20),
                            fontWeight: FontWeight.bold),
                      );
                    })
                : 'GET',
            labelColor: MyTheme.yellowColor),
        getItem('assets/image/phone.png', () {
          print('phone');
        }, 'FREE', labelColor: MyTheme.redColor),
        getItem('assets/image/spin.png', () {
          Layer.showLuckyWheel();
        }, 'SPIN'),
        getItem('assets/image/rank.png', () {
          print('rank');
        }, 'RANK'),
        getItem('assets/image/help.png', () {
          print('help');
        }, 'HOW TO PLAY'),
      ],
    );
  }
}
