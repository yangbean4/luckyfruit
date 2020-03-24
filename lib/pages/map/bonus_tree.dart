import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/models/index.dart' show PersonalInfo;
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';

class BonusTree extends StatefulWidget {
  BonusTree({Key key}) : super(key: key);

  @override
  _BonusTreeState createState() => _BonusTreeState();
}

class _BonusTreeState extends State<BonusTree> {
  @override
  Widget build(BuildContext context) {
    final double statusbarHeight =
        MediaQuery.of(context).padding.top + ScreenUtil().setWidth(20);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(124) + statusbarHeight,
            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(60),
                statusbarHeight, ScreenUtil().setWidth(60), 0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => MyNavigator().navigatorPop(context),
                    child: Container(
                      width: ScreenUtil().setWidth(150),
                      height: ScreenUtil().setWidth(124),
                      child: Container(
                        width: ScreenUtil().setWidth(29),
                        height: ScreenUtil().setWidth(49),
                        child: Text('<',
                            style: TextStyle(
                                fontFamily: FontFamily.bold,
                                fontWeight: FontWeight.bold,
                                color: MyTheme.blackColor,
                                fontSize: ScreenUtil().setSp(60))),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(646),
                    height: ScreenUtil().setWidth(500),
                    child: Text('100% Chance To Get \nThe Bonus Tree',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontFamily.bold,
                            fontWeight: FontWeight.bold,
                            color: MyTheme.blackColor,
                            height: 1,
                            fontSize: ScreenUtil().setSp(60))),
                  )
                ]),
          ),
          Container(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(636),
            child: Stack(children: <Widget>[
              _PosLabel(
                left: 428,
                top: 46,
                width: 226,
                height: 71,
                label: 'Total watched\nvideos',
              ),
              _PosLabel(
                left: 120,
                top: 249,
                width: 212,
                label: 'Total merged\ntrees',
              ),
              _PosLabel(
                left: 759,
                top: 249,
                width: 146,
                label: 'Unlocked\ncities',
              ),
              _PosLabel(
                left: 199,
                top: 498,
                width: 169,
                label: 'Number of\nfriends',
              ),
              _PosLabel(
                left: 707,
                top: 498,
                width: 226,
                label: 'Partners\nearning',
              ),
              Positioned(
                top: ScreenUtil().setWidth(100),
                left: ScreenUtil().setWidth(273),
                child: Image.asset(
                  'assets/image/star5.png',
                  width: ScreenUtil().setWidth(535.3),
                  height: ScreenUtil().setWidth(505.2),
                ),
              ),
              Positioned(
                  top: ScreenUtil().setWidth(212),
                  left: ScreenUtil().setWidth(399),
                  height: ScreenUtil().setWidth(259),
                  width: ScreenUtil().setWidth(282),
                  child: CustomPaint(
                    isComplex: true,
                    willChange: false,
                    painter: _MyPainter(),
                    size: Size(
                      ScreenUtil().setWidth(282),
                      ScreenUtil().setWidth(259),
                    ),
                  )),
            ]),
          )
        ]),
      ),
      // ),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(240),
      //   child: AppBar(
      //       elevation: 0,
      //       iconTheme: IconThemeData(
      //         color: MyTheme.blackColor,
      //       ),
      //       backgroundColor: Colors.white,
      //       title: Center(
      //           child: Container(
      //         color: Colors.red,
      //         width: ScreenUtil().setWidth(746),
      //         height: ScreenUtil().setWidth(150),
      //         child: Text(
      //           '100% Chance To Get The Bonus Tree',
      //           style: TextStyle(
      //               color: MyTheme.blackColor,
      //               fontSize: ScreenUtil().setWidth(70),
      //               fontFamily: FontFamily.bold,

      //               height: 1,
      //               fontWeight: FontWeight.bold),
      //         ),
      //       ))),
      // ),
    );
  }
}

class _PosLabel extends StatelessWidget {
  final num left;
  final num top;
  final num width;
  final num height;
  final String label;
  const _PosLabel(
      {Key key,
      @required this.left,
      @required this.top,
      @required this.label,
      this.width,
      this.height = 71})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: ScreenUtil().setWidth(left),
      top: ScreenUtil().setWidth(top),
      child: Container(
        width: ScreenUtil().setWidth(width),
        height: ScreenUtil().setWidth(height),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: FontFamily.regular,
                fontWeight: FontWeight.w400,
                color: MyTheme.tipsColor,
                height: 1,
                fontSize: ScreenUtil().setSp(34))),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  final Color strokeColor;
  final Color fillColor;
  const _MyPainter({this.strokeColor, this.fillColor});
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
  @override
  void paint(Canvas canvas, Size size) {
    print(size);
    Paint paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = strokeColor;
  }
}
