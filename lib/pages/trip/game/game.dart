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
import 'package:luckyfruit/widgets/layer.dart';
// import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/public/public.dart';
import './warehouse.dart';
import './auto_merge.dart';
import './tree_no_animation.dart';

// 由位置 x , y 转为 left top
class PositionLT {
  int x;
  int y;
  num _gridWidth = 200;
  num gridHeight = 210;
  num get xSpace => (960 - _gridWidth * GameConfig.X_AMOUNT) ~/ 3;

  num get left => x * (_gridWidth + xSpace);
  num get top => y * gridHeight;
  PositionLT({this.x, this.y});
}

class _SelectorUse {
  Tree minLevelTree;
  Function addTree;
  Tree isrecycle;
  Function recycle;
  _SelectorUse({this.minLevelTree, this.addTree, this.isrecycle, this.recycle});
}

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with MyNavigator {
  @override
  void initState() {
    super.initState();
  }

  // List<Widget> renderGrid(BuildContext context) {
  //   List<Widget> grids = [];
  //   TreeGroup treeGroup = Provider.of<TreeGroup>(context);
  //   for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
  //     for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
  //       // Selector<A, S> A 是我们从顶层获取的 Provider 的类型 S为获取到的类型
  //       grids.add(Selector<TreeGroup, Tree>(
  //           selector: (context, provider) => provider.treeMatrix[y][x],
  //           builder: (context, Tree data, child) {
  //             return DragTarget(
  //               builder: (context, candidateData, rejectedData) {
  //                 return GridItem(tree: data);
  //               },
  //               onWillAccept: (Tree source) {
  //                 return true;
  //               },
  //               onAccept: (Tree source) {
  //                 treeGroup.trans(source, data, pos: new TreePoint(x: x, y: y));
  //                 return true;
  //               },
  //             );
  //           }));
  //       // print(treeGroup.treeMatrix);
  //       // grids.add(Text('$x-$y'));
  //     }
  //   }
  //   return grids;
  // }

  List<Widget> renderGridforPos(BuildContext context) {
    List<Widget> grids = [];
    TreeGroup treeGroup = Provider.of<TreeGroup>(context);
    Tree animateTargetTree = treeGroup.animateTargetTree;
    Tree animateSourceTree = treeGroup.animateSourceTree;
    // REVIEW:还是否需要使用Selector
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        // Selector<A, S> A 是我们从顶层获取的 Provider 的类型 S为获取到的类型
        grids.add(Selector<TreeGroup, Tree>(
            selector: (context, provider) => provider.treeMatrix[y][x],
            builder: (context, Tree data, child) {
              PositionLT positionLT = PositionLT(x: x, y: y);
              return Positioned(
                  top: ScreenUtil().setWidth(positionLT.top),
                  left: ScreenUtil().setWidth(positionLT.left),
                  child: DragTarget(
                    builder: (context, candidateData, rejectedData) {
                      return GridItem(
                        tree: data,
                        animateTargetTree: animateTargetTree == data
                            ? animateTargetTree
                            : null,
                        animateSourceTree: animateTargetTree == data
                            ? animateSourceTree
                            : null,
                      );
                    },
                    onWillAccept: (Tree source) {
                      return true;
                    },
                    onAccept: (Tree source) {
                      // 是否要弹出越级升级界面
                      Layer.showBypassLevelUp(context, () {
                        // 进行越级升级
                        source.grade += 1;
                        data.grade += 1;
                        treeGroup.trans(source, data,
                            pos: new TreePoint(x: x, y: y));
                      }, () {
                        // 取消越级升级或者不满足弹出条件，走正常升级流程
                        treeGroup.trans(source, data,
                            pos: new TreePoint(x: x, y: y));
                      }, source, data);
                      return true;
                    },
                  ));
            }));
        // print(treeGroup.treeMatrix);
        // grids.add(Text('$x-$y'));
      }
    }
    if (treeGroup.autoSourceTree != null) {
      grids.add(
        AutoMerge(
            startPosition: PositionLT(
                x: treeGroup.autoSourceTree.x, y: treeGroup.autoSourceTree.y),
            endPosition: PositionLT(
                x: treeGroup.autoTargetTree.x, y: treeGroup.autoTargetTree.y),
            child: TreeNoAnimation(treeGroup.autoSourceTree),
            onFinish: () {
              treeGroup.autoMergeEnd(
                treeGroup.autoSourceTree,
                treeGroup.autoTargetTree,
              );
            }),
      );
    }
    return grids;
  }

  Widget getBtn(String imgSrc, String name) => Container(
        width: ScreenUtil().setWidth(262),
        height: ScreenUtil().setWidth(128),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imgSrc,
              width: ScreenUtil().setWidth(48),
              height: ScreenUtil().setWidth(54),
            ),
            Text(
              name,
              style: TextStyle(
                  fontFamily: FontFamily.bold,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setWidth(34),
                  color: MyTheme.blackColor),
            )
          ],
        ),
      );

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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          // 树木所在的网格
          Container(
            width: ScreenUtil().setWidth(1080 - 120),
            height: ScreenUtil().setWidth(PositionLT().gridHeight * 3),
            child: Stack(
              overflow: Overflow.visible,
              children: renderGridforPos(context),
            ),
          ),
          // 网格下方的添加树的按钮布局
          Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setWidth(85),
                // bottom: ScreenUtil().setWidth(54),
              ),
              child: Container(
                width: ScreenUtil().setWidth(960),
                height: ScreenUtil().setWidth(128),
                // 外层的圆角
                decoration: BoxDecoration(
                    color: MyTheme.grayColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(64)))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // ��边的图鉴按钮
                    GestureDetector(
                      child: getBtn(
                          'assets/image/Illustration.png', 'Illustration'),
                      onTap: () {
                        pushNamed(context, 'Illustration');
                      },
                    ),
                    // 中间的添加树组合图
                    Selector<TreeGroup, _SelectorUse>(
                        selector: (context, provider) => _SelectorUse(
                            minLevelTree: provider.minLevelTree,
                            addTree: provider.addTree,
                            recycle: provider.recycle,
                            isrecycle: provider.isrecycle),
                        builder: (context, _SelectorUse selectorUse, child) {
                          Widget center = selectorUse.isrecycle == null
                              ? GestureDetector(
                                  onTap: selectorUse.addTree,
                                  child: ShakeAnimation(
                                    child: PrimaryButton(
                                      // minWidth: ScreenUtil().setWidth(560),
                                      width: 400,
                                      height: 128,
                                      colors: <Color>[
                                        Color.fromRGBO(51, 199, 86, 1),
                                        Color.fromRGBO(36, 182, 69, 1)
                                      ],
                                      child: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            // 底层的金币数行
                                            Container(
                                              height: ScreenUtil().setWidth(50),
                                              margin: EdgeInsets.only(
                                                top: ScreenUtil().setWidth(59),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Image.asset(
                                                    'assets/image/gold.png',
                                                    width: ScreenUtil()
                                                        .setWidth(50),
                                                    height: ScreenUtil()
                                                        .setWidth(50),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                        left: ScreenUtil()
                                                            .setWidth(14),
                                                      ),
                                                      child: Text(
                                                        Util.formatNumber(selectorUse
                                                                .minLevelTree
                                                                ?.consumeGold ??
                                                            0),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              FontFamily.bold,
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setWidth(44),
                                                          height: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            // 添加树的树
                                            Positioned(
                                              bottom: ScreenUtil().setWidth(80),
                                              left: ScreenUtil().setWidth(156),
                                              child: TreeWidget(
                                                tree: selectorUse.minLevelTree,
                                                imgHeight:
                                                    ScreenUtil().setWidth(96),
                                                imgWidth:
                                                    ScreenUtil().setWidth(88),
                                                labelWidth:
                                                    ScreenUtil().setWidth(72),
                                                primary: false,
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                )
                              : DragTarget(builder:
                                  (context, candidateData, rejectedData) {
                                  return Container(
                                    // minWidth: ScreenUtil().setWidth(560),
                                    width: ScreenUtil().setWidth(400),
                                    height: ScreenUtil().setWidth(128),
                                    decoration: BoxDecoration(
                                      // color: MyTheme.primaryColor,
                                      gradient: LinearGradient(
                                          begin: Alignment(0.0, -1.0),
                                          end: Alignment(0.0, 1.0),
                                          colors: <Color>[
                                            Color.fromRGBO(18, 140, 140, 1),
                                            Color.fromRGBO(11, 121, 214, 1)
                                          ]),
                                      borderRadius: BorderRadius.all(
                                        Radius.elliptical(
                                          ScreenUtil().setWidth(64),
                                          ScreenUtil().setWidth(64),
                                        ),
                                      ),
                                    ),
                                    child: Stack(
                                        overflow: Overflow.visible,
                                        children: <Widget>[
                                          Container(
                                            height: ScreenUtil().setWidth(50),
                                            margin: EdgeInsets.only(
                                              top: ScreenUtil().setWidth(59),
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: ScreenUtil()
                                                          .setWidth(10)),
                                                  child: Text(
                                                    'Recycle',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            FontFamily.bold,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        height: 1.0,
                                                        fontSize: ScreenUtil()
                                                            .setWidth(30)),
                                                  ),
                                                ),
                                                Image.asset(
                                                  'assets/image/gold.png',
                                                  width:
                                                      ScreenUtil().setWidth(50),
                                                  height:
                                                      ScreenUtil().setWidth(50),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.only(
                                                      left: ScreenUtil()
                                                          .setWidth(14),
                                                    ),
                                                    child: Text(
                                                      Util.formatNumber(
                                                          selectorUse.isrecycle
                                                                  ?.recycleGold ??
                                                              0),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            FontFamily.bold,
                                                        color: Colors.white,
                                                        fontSize: ScreenUtil()
                                                            .setWidth(44),
                                                        height: 1,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                              bottom: ScreenUtil().setWidth(83),
                                              left: ScreenUtil().setWidth(167),
                                              child: Image.asset(
                                                'assets/image/isrecycle.png',
                                                width:
                                                    ScreenUtil().setWidth(67),
                                                height:
                                                    ScreenUtil().setWidth(82),
                                              ))
                                        ]),
                                  );
                                }, onWillAccept: (Tree source) {
                                  Layer.recycleLayer(
                                      () => selectorUse.recycle(source),
                                      source.treeImgSrc,
                                      source.recycleMoney,
                                      source.recycleGold);
                                  return true;
                                }, onAccept: (Tree source) {
                                  return true;
                                });

                          return center;
                        }),
                    Warehouse(
                        child:
                            getBtn('assets/image/Warehouse.png', 'Warehouse'))
                  ],
                ),
              ))
        ]));
  }
}
