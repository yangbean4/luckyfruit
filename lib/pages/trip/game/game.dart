import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import './grid_item.dart';
import 'package:luckyfruit/widgets/shake_button.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/utils/index.dart';
// import 'package:luckyfruit/widgets/layer.dart';

num gridWidth = 200;
num gridHeight = 210;
num xSpace = (960 - gridWidth * GameConfig.X_AMOUNT) ~/ 3;

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
                  return true;
                },
              );
            }));
        // print(treeGroup.treeMatrix);
        // grids.add(Text('$x-$y'));
      }
    }
    return grids;
  }

  List<Widget> renderGridforPos(BuildContext context) {
    List<Widget> grids = [];
    TreeGroup treeGroup = Provider.of<TreeGroup>(context);

    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        // Selector<A, S> A 是我们从顶层获取的 Provider 的类型 S为获取到的类型
        grids.add(Selector<TreeGroup, Tree>(
            selector: (context, provider) => provider.treeMatrix[y][x],
            builder: (context, Tree data, child) {
              return Positioned(
                  top: ScreenUtil().setWidth(y * gridHeight),
                  left: ScreenUtil().setWidth(x * (gridWidth + xSpace)),
                  child: DragTarget(
                    builder: (context, candidateData, rejectedData) {
                      return GridItem(tree: data);
                    },
                    onWillAccept: (Tree source) {
                      return true;
                    },
                    onAccept: (Tree source) {
                      treeGroup.trans(source, data,
                          pos: new TreePoint(x: x, y: y));
                      return true;
                    },
                  ));
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
      height: ScreenUtil().setWidth(980),
      color: Color.fromRGBO(255, 255, 255, 1),
      padding: EdgeInsets.only(
        left: ScreenUtil().setWidth(60),
        right: ScreenUtil().setWidth(60),
        top: ScreenUtil().setWidth(90),
        bottom: ScreenUtil().setWidth(46),
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
                  Container(
                    width: ScreenUtil().setWidth(1080 - 120),
                    height: ScreenUtil().setWidth(gridHeight * 3),
                    child: Stack(
                      overflow: Overflow.visible,
                      children: renderGridforPos(context),
                    ),
                  ),
                  // Expanded(
                  //   child: GridView.count(
                  //       childAspectRatio: 200 / 210,
                  //       physics: new NeverScrollableScrollPhysics(),
                  //       primary: false,
                  //       // itemCount: X_AMOUNT * Y_AMOUNT,
                  //       // mainAxisSpacing: ScreenUtil().setHeight(30),
                  //       crossAxisCount: 4,
                  //       crossAxisSpacing: ScreenUtil().setWidth(54),
                  //       children: renderGrid(context)),
                  // ),
                  Container(
                      margin: EdgeInsets.only(
                        top: ScreenUtil().setWidth(85),
                        // bottom: ScreenUtil().setWidth(54),
                      ),
                      child: GestureDetector(
                        onTap: addTree,
                        child: Center(
                            child: ShakeButton(
                          child: Container(
                            // minWidth: ScreenUtil().setWidth(560),
                            width: ScreenUtil().setWidth(400),
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
                                height: ScreenUtil().setWidth(50),
                                margin: EdgeInsets.only(
                                  top: ScreenUtil().setWidth(59),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/image/gold.png',
                                      width: ScreenUtil().setWidth(50),
                                      height: ScreenUtil().setWidth(50),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(14),
                                        ),
                                        child: Text(
                                          Util.formatNumber(
                                              minLevelTree?.consumeGold ?? 0),
                                          style: TextStyle(
                                            fontFamily: FontFamily.bold,
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setWidth(44),
                                            height: 1,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: ScreenUtil().setWidth(80),
                                left: ScreenUtil().setWidth(156),
                                child: TreeWidget(
                                  tree: minLevelTree,
                                  imgHeight: ScreenUtil().setWidth(96),
                                  imgWidth: ScreenUtil().setWidth(88),
                                  labelWidth: ScreenUtil().setWidth(72),
                                  primary: false,
                                ),
                              )
                            ]),
                          ),
                        )),
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
