import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:provider/provider.dart';

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
            child: Selector<TreeGroup, TreeGroup>(
                selector: (_, provider) => provider,
                builder: (_, TreeGroup treeGroup, __) {
                  return Stack(overflow: Overflow.visible, children: <Widget>[
                    bigCircle,
                    Positioned(
                      child: new CircleButton(
                        onTap: () => print("Cool"),
                        iconData: Stack(
                          children: checkWhetherTreeTypeExits(
                                  treeGroup, TreeType.Type_Hops_Male)
                              ? getTreeLayoutWidget(
                                  TreeType.Type_Hops_Male, "hops_name_bg_hops")
                              : [Container()],
                        ),
                      ),
                      left: 0,
                      top: 0,
                    ),
                    Positioned(
                      child: new CircleButton(
                        onTap: () => print("Cool"),
                        iconData: Stack(
                          children: checkWhetherTreeTypeExits(
                                  treeGroup, TreeType.Type_Hops_Female)
                              ? getTreeLayoutWidget(TreeType.Type_Hops_Female,
                                  "hops_name_bg_female_hops")
                              : [Container()],
                        ),
                      ),
                      left: ScreenUtil().setWidth(670),
                      top: ScreenUtil().setWidth(0),
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          print("开始合成啤酒花树");
                          // 删除雌雄花树
                          treeGroup.deleteHopsTrees();
                          onStartMergeFun();
                        },
                        child: Stack(children: [
                          Image.asset(
                              "assets/image/hops_merge_trigger_btn.png"),
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
                  ]);
                })));
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
