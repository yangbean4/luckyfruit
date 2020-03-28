import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/widgets/layer.dart';

class ContinentsMergeWidget extends StatelessWidget {
  static double itemSize = ScreenUtil().setWidth(180);
  final Function onStartMergeFun;
  ContinentsMergeWidget({Key key, this.onStartMergeFun}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Point> list = convertToPoints(
        Point(ScreenUtil().setWidth(425), ScreenUtil().setWidth(425)),
        ScreenUtil().setWidth(425),
        5);

    list.forEach((f) {
      print("x=${f.x}, y=${f.y}");
    });
    Widget bigCircle = new Container(
      width: ScreenUtil().setWidth(850),
      height: ScreenUtil().setWidth(850),
      decoration: new BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.center,
          image: AssetImage("assets/image/continents_bg.png"),
          fit: BoxFit.fill,
        ),
        // color: Colors.orange,
        shape: BoxShape.circle,
      ),
    );

    return new Material(
      color: Colors.transparent,
      child: new Container(
        // color: Colors.red,
        alignment: Alignment.center,
        height: ScreenUtil().setWidth(1100),
        child: new Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            bigCircle,
            Positioned(
              child: new CircleButton(
                onTap: () => print("Cool"),
                iconData: Stack(
                  children: [
                    // Image.asset("assets/image/dividend_tree.png"),
                    // Align(
                    //   child: Image.asset(
                    //       "assets/image/continents_name_bg_african.png"),
                    //   alignment: Alignment.centerRight,
                    // )
                  ],
                ),
              ),
              left: list[0].x,
              top: list[0].y,
            ),
            Positioned(
              child: new CircleButton(
                onTap: () => print("Cool"),
                iconData: Stack(
                  children: [
                    Image.asset("assets/image/dividend_tree.png"),
                    Align(
                      child: Image.asset(
                          "assets/image/continents_name_bg_asian.png"),
                      alignment: Alignment.centerRight,
                    )
                  ],
                ),
              ),
              left: list[1].x,
              top: list[1].y,
            ),
            Positioned(
              child: new CircleButton(
                onTap: () => print("Cool"),
                iconData: Stack(
                  children: [
                    Image.asset("assets/image/dividend_tree.png"),
                    Align(
                      child: Image.asset(
                          "assets/image/continents_name_bg_oceania.png"),
                      alignment: Alignment.centerRight,
                    )
                  ],
                ),
              ),
              left: list[2].x,
              top: list[2].y,
            ),
            Positioned(
              child: new CircleButton(
                onTap: () => print("Cool"),
                iconData: Stack(
                  children: [
                    Image.asset("assets/image/dividend_tree.png"),
                    Align(
                      child: Image.asset(
                          "assets/image/continents_name_bg_american.png"),
                      alignment: Alignment.centerRight,
                    )
                  ],
                ),
              ),
              left: list[3].x,
              top: list[3].y,
            ),
            Positioned(
              child: new CircleButton(
                onTap: () => print("Cool"),
                iconData: Stack(
                  children: [
                    Image.asset("assets/image/dividend_tree.png"),
                    Align(
                      child: Image.asset(
                          "assets/image/continents_name_bg_european.png"),
                      alignment: Alignment.centerRight,
                    )
                  ],
                ),
              ),
              left: list[4].x,
              top: list[4].y,
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  print("开始合成五洲树");
                  onStartMergeFun();
                },
                child: Stack(children: [
                  Image.asset("assets/image/continents_btn_trigger_merge.png"),
                  Align(
                      alignment: Alignment(0, 0),
                      child: Text(
                        "Start",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(50),
                        ),
                      )),
                ]),
              ),
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setWidth(200),
              left: ScreenUtil().setWidth(325),
              top: ScreenUtil().setWidth(325),
            ),
          ],
        ),
      ),
    );
  }

  static List<Point> convertToPoints(Point center, double r, int num,
      {double startRadian = 0.0}) {
    var list = List<Point>();
    double perRadian = 2.0 * pi / num;
    for (int i = 0; i < num; i++) {
      double radian = i * perRadian + startRadian;
      if (radian > 2 * pi) {
        radian -= 2 * pi;
      }
      var p = radianPoint(center, r, radian);
      list.add(p);
    }
    return list;
  }

  static Point radianPoint(Point center, double r, double radian) {
    radian -= pi / 10;
    print("旋转角度：$radian");
    return Point(center.x + r * cos(radian) - itemSize / 2,
        center.y + r * sin(radian) - itemSize / 2);
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget iconData;

  const CircleButton({Key key, this.onTap, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = ScreenUtil().setWidth(180);
    return new Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/continents_item_bg.png"),
          fit: BoxFit.fill,
        ),
        shape: BoxShape.circle,
      ),
      child: iconData,
    );
  }
}
