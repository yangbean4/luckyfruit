import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/pages/trip/game/grid_item.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class TreeGridOfRevengeWidget extends StatefulWidget {
  final String acctId;
  final int type;

  TreeGridOfRevengeWidget(this.acctId, this.type);

  @override
  _TreeGridOfRevengeWidgetState createState() =>
      _TreeGridOfRevengeWidgetState();
}

class _TreeGridOfRevengeWidgetState extends State<TreeGridOfRevengeWidget> {
  String testJson =
      "{\"upDateTime\":\"1591962398930\",\"treeList\":[{\"x\":1,\"y\":1,\"type\":null,\"grade\":17,\"gradeNumber\":1,\"recycleMoney\":null,\"treeId\":null,\"duration\":200,\"amount\":null,\"limitedBonusedAmount\":0.0,\"showCountDown\":false,\"originalDuration\":200,\"timePlantedLimitedBonusTree\":null},{\"x\":1,\"y\":0,\"type\":null,\"grade\":17,\"gradeNumber\":29,\"recycleMoney\":null,\"treeId\":null,\"duration\":200,\"amount\":null,\"limitedBonusedAmount\":0.0,\"showCountDown\":false,\"originalDuration\":200,\"timePlantedLimitedBonusTree\":null},{\"x\":2,\"y\":1,\"type\":null,\"grade\":17,\"gradeNumber\":27,\"recycleMoney\":null,\"treeId\":null,\"duration\":200,\"amount\":null,\"limitedBonusedAmount\":0.0,\"showCountDown\":false,\"originalDuration\":200,\"timePlantedLimitedBonusTree\":null}],\"treeGradeNumber\":\"{\\\"1\\\":3,\\\"6\\\":37,\\\"3\\\":30,\\\"4\\\":30,\\\"5\\\":33,\\\"7\\\":40,\\\"8\\\":30,\\\"9\\\":33,\\\"10\\\":29,\\\"11\\\":33}\",\"hasMaxLevel\":\"17\",\"warehouseTreeList\":[{\"x\":null,\"y\":null,\"type\":null,\"grade\":1,\"gradeNumber\":2,\"recycleMoney\":null,\"treeId\":null,\"duration\":200,\"amount\":null,\"limitedBonusedAmount\":0.0,\"showCountDown\":false,\"originalDuration\":200,\"timePlantedLimitedBonusTree\":null}]}";

  List<Tree> _treeList = [];

  @override
  void initState() {
    super.initState();
    if (widget?.type == 1 && widget.acctId != null) {
      fetchOpponentTreeInfoWithAcctId();
    } else {
      // 虚拟用户，随机生成用户数据
      fetchOpponentTreeInfoRandomly();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(1080),
        height: ScreenUtil().setHeight(1280),
        color: Color.fromRGBO(255, 255, 255, 1),
        padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(60),
          right: ScreenUtil().setWidth(60),
          top: ScreenUtil().setWidth(70),
          bottom: ScreenUtil().setWidth(46),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: ScreenUtil().setWidth(50),
              ),
              // 树木所在的网格
              Container(
                width: ScreenUtil().setWidth(1080 - 120),
                height: ScreenUtil().setWidth(PositionLT().gridHeight * 3),
                child: Stack(
                  overflow: Overflow.visible,
                  children: renderGridforPos(context),
                ),
              ),
            ]));
  }

  List<Widget> renderGridforPos(BuildContext context) {
    List<Widget> grids = [];
    List<List<Tree>> treeMatrix = getTreeMatrix();
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        PositionLT positionLT = PositionLT(x: x, y: y);
        Tree data = treeMatrix[y][x];
        grids.add(Positioned(
            top: ScreenUtil().setWidth(positionLT.top),
            left: ScreenUtil().setWidth(positionLT.left),
            child: GridItem(
              key: Consts.revengeTreeGroupGlobalKey[y][x],
              enableDrag: false,
              tree: data,
              onTap: (key) {
                // 点击选择偷哪一棵树
                LuckyGroup luckyGroup =
                    Provider.of<LuckyGroup>(context, listen: false);
                luckyGroup.revengeShovelKey = key;
                luckyGroup.showRevengeShovel = true;
              },
            )));
      }
    }
    return grids;
  }

  // 转成二维数组
  List<List<Tree>> getTreeMatrix() {
    List<List<Tree>> treeMatrix = List(GameConfig.Y_AMOUNT);
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      List<Tree> yMat = List(GameConfig.X_AMOUNT);
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        Tree tree = _treeList.firstWhere((t) => t.x == x && t.y == y,
            orElse: () => null);
        // 会出现gradle==0的情况
        if (tree == null || (tree?.grade == 0)) {
          _treeList.remove(tree);
          continue;
        }
        yMat[x] = tree;
      }
      treeMatrix[y] = yMat;
    }

    return treeMatrix;
  }

  // 获取对手的树木、城市的信息
  fetchOpponentTreeInfoWithAcctId() {
    Service().getTreeInfo(
        {'acct_id': widget.acctId, 'disable_base_params': true}).then((value) {
      if (value == null) {
        return;
      }
      Map<String, dynamic> treeInfoMap = Util.decodeStr(value['code']);
//    treeInfoMap = Util.decodeStr(testJson);
      _treeList = (treeInfoMap['treeList'] as List)
          ?.map((e) =>
              e == null ? null : Tree.formJson(e as Map<String, dynamic>))
          .toList();
      setState(() {});
    });
  }

  /// 虚拟用户，随机生成用户数据
  void fetchOpponentTreeInfoRandomly() {
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        _treeList.add(generateRandomTreeInfo(x, y));
      }
    }
  }

  /// 根据用户可购买等级的树木(可购买等级树木向下3级，向上8级)，随机进行界面渲染
  Tree generateRandomTreeInfo(int x, int y) {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
    // 生成区间（n-3,n+8）之间的数值
    int treeGrade =
        Random().nextInt(11) + (treeGroup.minLevel - 3);
    return Tree(grade: treeGrade, x: x, y: y);
  }
}

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
