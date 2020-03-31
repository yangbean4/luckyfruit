import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:provider/provider.dart';

class ContinentsMergeWidget extends StatelessWidget {
  static double itemSize = ScreenUtil().setWidth(200);
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
        child: Selector<TreeGroup, TreeGroup>(
            selector: (_, provider) => provider,
            builder: (_, TreeGroup treeGroup, __) {
              return Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  bigCircle,
                  Positioned(
                    child: new CircleButton(
                      onTap: () => print("Cool"),
                      iconData: Stack(
                        children: checkWhetherTreeTypeExits(
                                treeGroup, TreeType.Type_Continents_African)
                            ? getTreeLayoutWidget(
                                TreeType.Type_Continents_African,
                                "continents_name_bg_african")
                            : [Container()],
                      ),
                    ),
                    left: list[0].x,
                    top: list[0].y,
                  ),
                  Positioned(
                    child: new CircleButton(
                      onTap: () => print("Cool"),
                      iconData: Stack(
                        children: checkWhetherTreeTypeExits(
                                treeGroup, TreeType.Type_Continents_Asian)
                            ? getTreeLayoutWidget(
                                TreeType.Type_Continents_Asian,
                                "continents_name_bg_asian")
                            : [Container()],
                      ),
                    ),
                    left: list[1].x,
                    top: list[1].y,
                  ),
                  Positioned(
                    child: new CircleButton(
                      onTap: () => print("Cool"),
                      iconData: Stack(
                        children: checkWhetherTreeTypeExits(
                                treeGroup, TreeType.Type_Continents_Oceania)
                            ? getTreeLayoutWidget(
                                TreeType.Type_Continents_Oceania,
                                "continents_name_bg_oceania")
                            : [Container()],
                      ),
                    ),
                    left: list[2].x,
                    top: list[2].y,
                  ),
                  Positioned(
                    child: new CircleButton(
                      onTap: () => print("Cool"),
                      iconData: Stack(
                        children: checkWhetherTreeTypeExits(
                                treeGroup, TreeType.Type_Continents_American)
                            ? getTreeLayoutWidget(
                                TreeType.Type_Continents_American,
                                "continents_name_bg_american")
                            : [Container()],
                      ),
                    ),
                    left: list[3].x,
                    top: list[3].y,
                  ),
                  Positioned(
                    child: new CircleButton(
                      onTap: () => print("Cool"),
                      iconData: Stack(
                        children: checkWhetherTreeTypeExits(
                                treeGroup, TreeType.Type_Continents_European)
                            ? getTreeLayoutWidget(
                                TreeType.Type_Continents_European,
                                "continents_name_bg_european")
                            : [Container()],
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
                        Image.asset(
                            "assets/image/continents_btn_trigger_merge.png"),
                        Align(
                            alignment: Alignment(0, 0),
                            child: Text(
                              "Merge",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: FontFamily.bold,
                                fontSize: ScreenUtil().setSp(52),
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
              );
            }),
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

  ///检查当前树类型是否本地存在
  bool checkWhetherTreeTypeExits(TreeGroup treeGroup, String treeType) {
    List list = treeGroup.allTreeList
        .where((tree) => tree?.type?.compareTo(treeType) == 0)
        .toList();
    return list != null && list.length > 0;
  }

  List<Widget> getTreeLayoutWidget(String treeType, String labelBgName) {
    return [
      Container(
          padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(10)),
          child: Image.asset("assets/tree/$treeType.png")),
      Align(
        child: Image.asset("assets/image/$labelBgName.png"),
        alignment: Alignment.centerRight,
      )
    ];
  }
}

class CircleButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final Widget iconData;

  const CircleButton({Key key, this.onTap, this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = ScreenUtil().setWidth(200);
    return new Container(
      width: size,
      height: size,
      alignment: Alignment.topCenter,
      decoration: new BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/continents_item_bg.png"),
            fit: BoxFit.fill,
          ),
          shape: BoxShape.circle),
      child: iconData,
    );
  }
}
