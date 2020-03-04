import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/theme/index.dart';
import './grid_item.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/utils/index.dart';

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> renderGrid(BuildContext context) {
    List<Widget> grids = [];
    TreeGroup treeGroup = Provider.of<TreeGroup>(context);

    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        // Selector<A, S> A 是我们从顶层获取的 Provider 的类型 S为获取到的类型
        grids.add(Selector<TreeGroup, Tree>(
            selector: (context, provider) => provider.treeMatrix[y][x],
            builder: (context, Tree data, child) {
              return DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return GridItem(tree: data);
                },
                onWillAccept: (Tree source) {
                  return true;
                },
                onAccept: (Tree source) {
                  treeGroup.trans(source, data, pos: new TreePoint(x: x, y: y));
                },
              );
            }));
        // print(treeGroup.treeMatrix);
        // grids.add(Text('$x-$y'));
      }
    }
    return grids;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(1080),
      height: ScreenUtil().setWidth(1200),
      color: Color.fromRGBO(255, 255, 255, 1),
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setWidth(46),
        horizontal: ScreenUtil().setWidth(60),
      ),
      child: Selector<TreeGroup, Tree>(
        selector: (context, provider) => provider.minLevelTree,
        builder: (context, Tree minLevelTree, child) {
          return Selector<TreeGroup, Function>(
            selector: (context, provider) => provider.addTree,
            builder: (context, Function addTree, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GridView.count(
                        childAspectRatio: 0.83,
                        physics: new NeverScrollableScrollPhysics(),
                        primary: false,
                        // itemCount: X_AMOUNT * Y_AMOUNT,
                        // mainAxisSpacing: ScreenUtil().setHeight(30),
                        crossAxisCount: 4,
                        crossAxisSpacing: ScreenUtil().setWidth(54),
                        children: renderGrid(context)),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(86),
                        // bottom: ScreenUtil().setWidth(54),
                      ),
                      child: GestureDetector(
                        onTap: addTree,
                        child: Center(
                          child: Container(
                            // minWidth: ScreenUtil().setWidth(560),
                            width: ScreenUtil().setWidth(500),
                            height: ScreenUtil().setWidth(128),
                            decoration: BoxDecoration(
                              color: MyTheme.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.elliptical(
                                  ScreenUtil().setWidth(64),
                                  ScreenUtil().setWidth(64),
                                ),
                              ),
                            ),
                            child: Stack(overflow: Overflow.visible, children: <
                                Widget>[
                              Container(
                                height: ScreenUtil().setWidth(55),
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(55),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/image/gold.png',
                                      width: ScreenUtil().setWidth(55),
                                      height: ScreenUtil().setWidth(55),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(14),
                                        ),
                                        child: Text(
                                          Util.formatNumber(
                                              minLevelTree?.consumeGold ?? 0),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setWidth(34),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: ScreenUtil().setWidth(80),
                                left: ScreenUtil().setWidth(220),
                                child: TreeWidget(
                                  tree: minLevelTree,
                                  imgHeight: ScreenUtil().setWidth(84),
                                  imgWidth: ScreenUtil().setWidth(77),
                                  labelWidth: ScreenUtil().setWidth(40),
                                  primary: false,
                                ),
                              )
                            ]),
                          ),
                        ),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
