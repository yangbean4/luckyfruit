import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HopsMergeWidget extends StatelessWidget {
  final Function onStartMergeFun;
  HopsMergeWidget({Key key, this.onStartMergeFun}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget bigCircle = new Container(
      width: ScreenUtil().setWidth(850),
      height: ScreenUtil().setWidth(750),
      decoration: new BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.center,
          image: AssetImage("assets/image/hops_merge_bg.png"),
          fit: BoxFit.fill,
        ),
        // color: Colors.orange,
        shape: BoxShape.rectangle,
      ),
    );

    return new Material(
        color: Colors.transparent,
        child: new Center(
            child: new Stack(overflow: Overflow.visible, children: <Widget>[
          bigCircle,
          Positioned(
            child: new CircleButton(
              onTap: () => print("Cool"),
              iconData: Stack(
                children: [
                  Image.asset("assets/image/dividend_tree.png"),
                  Align(
                    child: Image.asset("assets/image/hops_name_bg_hops.png"),
                    alignment: Alignment.centerRight,
                  )
                ],
              ),
            ),
            left: 0,
            top: 0,
          ),
          Positioned(
            child: new CircleButton(
              onTap: () => print("Cool"),
              iconData: Stack(
                children: [
                  Image.asset("assets/image/dividend_tree.png"),
                  Align(
                    child: Image.asset(
                        "assets/image/hops_name_bg_female_hops.png"),
                    alignment: Alignment.centerRight,
                  )
                ],
              ),
            ),
            left: ScreenUtil().setWidth(670),
            top: ScreenUtil().setWidth(0),
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                print("开始合成啤酒花树");
                onStartMergeFun();
              },
              child: Stack(children: [
                Image.asset("assets/image/hops_merge_trigger_btn.png"),
                Align(
                    alignment: Alignment(0, -0.3),
                    child: Text(
                      "Merge",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(50),
                      ),
                    )),
              ]),
            ),
            width: ScreenUtil().setWidth(250),
            height: ScreenUtil().setWidth(230),
            left: ScreenUtil().setWidth(300),
            top: ScreenUtil().setWidth(260),
          ),
        ])));
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
