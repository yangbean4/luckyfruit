import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/widgets/layer.dart';
import './money_group.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/index.dart';

class TreeGroup with ChangeNotifier {
  // MoneyGroup Provider引用
  MoneyGroup moneyGroup;
  TreeGroup();
  // 存储数据用句柄
  static const String CACHE_KEY = 'TreeGroup';
  static const int MAX_LEVEL = 38;
  // 当前最大等级和最小等级的差
  static const int DIFF_LEVEL = 5;

  static const String LOAD = 'LOAD';

  String acct_id;

  // 冷却时间
  int delayTime;
  // 最后种树时间
  DateTime makeTreeTime = DateTime.now();

  Map<String, int> treeGradeNumber = {};

  // 当前生产树的等级
  int _minLevel = 1;
  int get minLevel => _minLevel;

  Tree get minLevelTree =>
      new Tree(grade: minLevel, gradeNumber: treeGradeNumber['$minLevel'] ?? 1);

  // 当前树中的最大等级
  // int _maxLevel = 1;
  int get maxLevel => treeGradeNumber.keys.map((t) => int.parse(t)).reduce(max);

  Tree get maxLevelTree => new Tree(grade: maxLevel);

  // Tree列表
  List<Tree> _treeList = [];
  List<Tree> get treeList => _treeList;

  // 更新时间
  DateTime _upDateTime;
  DateTime get upDateTime => _upDateTime;

  // 单位时间产生金币数
  double get makeGoldSped {
    return treeList.map((sub) => sub.gold).toList().fold(0, (a, b) => a + b);
  }

  // 单位时间产生钱数
  double get makeMoneySped {
    return treeList.map((sub) => sub.money).toList().fold(0, (a, b) => a + b);
  }

  // 转成二维数组
  List<List<Tree>> get treeMatrix {
    List<List<Tree>> treeMatrix = List(GameConfig.Y_AMOUNT);
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      List<Tree> yMat = List(GameConfig.X_AMOUNT);
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        Tree tree = _treeList.firstWhere((t) => t.x == x && t.y == y,
            orElse: () => null);
        yMat[x] = tree;
      }
      treeMatrix[y] = yMat;
    }

    return treeMatrix;
  }

  // 将对象转为json
  Map<String, dynamic> toJson() => {
        'upDateTime': this._upDateTime.toString(),
        'treeList': this._treeList.map((map) => map.toJson()).toList(),
        'treeGradeNumber': jsonEncode(treeGradeNumber).toString()
      };

  // json 2 Obj
  // factory TreeGroup.formJson(Map<String, dynamic> group) => TreeGroup()
  //   .._upDateTime = group['upDateTime'] as double
  //   .._treeList = group['treeList'].map((map) => Tree.formJson(map)).toList();

  void setTreeGroup(Map<String, dynamic> group) {
    if (group != null && group.isNotEmpty) {
      _upDateTime = group['upDateTime'] != null
          ? DateTime.parse(group['upDateTime'])
          : null;
      _treeList = (group['treeList'] as List)
          ?.map((map) =>
              map == null ? null : Tree.formJson(map as Map<String, dynamic>))
          ?.toList();
      Map<String, dynamic> _treeGradeNumber =
          jsonDecode(group['treeGradeNumber']);
      treeGradeNumber =
          Map.castFrom<String, dynamic, String, int>(_treeGradeNumber);

      notifyListeners();
    }
  }

  bool isDirty(group) => group.isEmpty || group['upDateTime'] == null;

  Map<String, dynamic> getUseGroup(String str1, String str2) {
    Map<String, dynamic> group1 = Util.decodeStr(str1);
    Map<String, dynamic> group2 = Util.decodeStr(str2);
    Map<String, dynamic> group = {};
    if (isDirty(group1) || isDirty(group2)) {
      group = isDirty(group1) ? group2 : group1;
    } else {
      DateTime upDateTime1 = DateTime.tryParse(group1['upDateTime'] ?? '');
      DateTime upDateTime2 = DateTime.tryParse(group2['upDateTime'] ?? '');
      group = upDateTime1.isAfter(upDateTime2) ? group1 : group2;
    }
    return group;
  }

  //初始化 form请求&Storage
  Future<TreeGroup> init(MoneyGroup _moneyGroup, String accId) async {
    acct_id = accId;
    moneyGroup = _moneyGroup;

    String res = await Storage.getItem(TreeGroup.CACHE_KEY);

    Map<String, dynamic> ajaxData =
        await Service().getTreeInfo({'acct_id': accId, 'city': '123'});

    setTreeGroup(getUseGroup(res, ajaxData['code']));
    EVENT_BUS.emit(TreeGroup.LOAD);
    // 退出时保存数据
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      save();
    });
    return this;
  }

  // 保存
  Future<bool> save() async {
    _upDateTime = DateTime.now();
    String data = jsonEncode(this);
    bool saveSuccess = await Storage.setItem(TreeGroup.CACHE_KEY, data);

    await Service().saveTreeInfo({
      'acct_id': acct_id,
      'code': data,
      'city': '123',
      'last_time': 'last_time'
    });
    // 通知更新
    notifyListeners();
    return saveSuccess;
  }

  // 更新,
  // Future<bool> update({
  //   @required List<Tree> treeList,
  //   double upDateTime,
  // }) async {
  //   _upDateTime = _upDateTime ?? new DateTime.now().millisecondsSinceEpoch;
  //   if (_upDateTime > this._upDateTime) {
  //     bool saveSuccess = await this.save();
  //     if (saveSuccess) {
  //       this._upDateTime = upDateTime;
  //       this._treeList = treeList;
  //     }
  //     return saveSuccess;
  //   }
  // }

  // 找到空的位置
  TreePoint findFirstEmty() {
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        if (treeMatrix[y][x] == null) {
          return new TreePoint(x: x, y: y);
        }
      }
    }
  }

// 添加树
  Future<bool> addTree({Tree tree}) {
    TreePoint point = findFirstEmty();
    // 找空的位置 如果没有则无法添加 返回;
    // REVIEW: 如果是抽奖时是否放入仓库?
    if (point == null) {
      Layer.toastWarning('没有位置啦,试试把树拖到伐木场吧');
      return Future.value(false);
    }
    if (makeTreeTime
        .add(Duration(seconds: delayTime ?? 0))
        .isAfter(DateTime.now())) {
      Layer.toastWarning('冷却中....');
      return Future.value(false);
    }

    if (tree == null) {
      tree = new Tree(
          x: point.x,
          y: point.y,
          grade: minLevel,
          gradeNumber: treeGradeNumber['$minLevel'] ?? 0);
    }
    if (tree?.x == null || tree?.y == null) {
      tree?.x = point.x;
      tree?.y = point.y;
    }
    if (moneyGroup.gold < tree.consumeGold) {
      return Future.value(false);
    }

    EVENT_BUS.emit(MoneyGroup.ACC_GOLD, tree.consumeGold);
    treeGradeNumber['$minLevel'] = (treeGradeNumber['$minLevel'] ?? 0) + 1;

    delayTime = tree.delay;
    makeTreeTime = DateTime.now();
    // 添加并保存
    _treeList.add(tree);
    return save();
  }

// 拖拽移动时的处理
  trans(Tree source, Tree target, {TreePoint pos}) {
    if (source == target) {
      return;
    }
    if (target == null) {
      source.x = pos.x;
      source.y = pos.y;
    } else if (source.grade == target.grade) {
      if (++target.grade > maxLevel) {
        // _maxLevel = target.grade;
        // 最低级别的树更新
        if (maxLevel - _minLevel > TreeGroup.DIFF_LEVEL) {
          _minLevel = maxLevel - TreeGroup.DIFF_LEVEL;
        }
        Layer.newGrade(maxLevelTree);
      }
      _treeList.remove(source);
    } else {
      target.x = source.x;
      target.y = source.y;
      source.x = pos.x;
      source.y = pos.y;
    }
    save();
  }

  // 回收树木
  recycle(Tree tree) {
    if (_treeList.length == 1) {
      Layer.toastWarning('你就要没树啦....');
      return;
    }
    _treeList.remove(tree);
    // TODO:回收的时候加钱
    save();
  }
}
