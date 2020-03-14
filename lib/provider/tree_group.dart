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
import './lucky_group.dart';

class TreeGroup with ChangeNotifier {
  // MoneyGroup Provider引用
  MoneyGroup _moneyGroup;
  LuckyGroup _luckyGroup;
  TreeGroup();
  // 存储数据用句柄
  static const String CACHE_KEY = 'TreeGroup';
  static const int MAX_LEVEL = 38;
  // 当前最大等级和最小等级的差
  static const int DIFF_LEVEL = 5;

  static const String LOAD = 'LOAD';

  String acct_id;

  //记录宝箱占用的位置
  TreePoint treasurePosition;
  // 记录宝箱领取的时间
  DateTime treasureTime = DateTime.now();
  // 设置的宝箱出现的时间间隔 单位 s
  num get _treasureInterval => _luckyGroup.issed?.random_space_time;
  // 宝箱停留时长;超出后隐藏
  num get _treasuReremain => _luckyGroup.issed?.box_remain_time;

  // 冷却时间
  int delayTime;
  // 最后种树时间
  DateTime makeTreeTime = DateTime.now();

  // 记录每个等级种树的次数
  Map<String, int> treeGradeNumber = {};

  // 当前生产树的等级
  int get minLevel {
    int usLv = maxLevel - TreeGroup.DIFF_LEVEL;
    return usLv > 1 ? usLv : 1;
  }

  Tree get minLevelTree =>
      new Tree(grade: minLevel, gradeNumber: treeGradeNumber['$minLevel'] ?? 1);

  // 显示 添加/回收 树
  Tree _isrecycle;
  Tree get isrecycle => _isrecycle;

  // 当前树中的最大等级
  int get maxLevel {
    final gjb = allTreeList.map((t) => t.grade);
    return gjb.isEmpty ? 1 : gjb.reduce(max);
  }

  Tree get maxLevelTree => new Tree(grade: maxLevel);

  /**
   * 返回最大级别（38级）的树
   */
  Tree get topLevelTree => new Tree(grade: MAX_LEVEL);

  // Tree列表
  List<Tree> _treeList = [];
  List<Tree> get treeList => _treeList;

  // 仓库中的树
  List<Tree> _warehouseTreeList = [];
  List<Tree> get warehouseTreeList => _warehouseTreeList;

  List<Tree> get allTreeList => _treeList + _warehouseTreeList;
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
        'treeGradeNumber': jsonEncode(treeGradeNumber).toString(),
        'warehouseTreeList':
            this._warehouseTreeList.map((map) => map.toJson()).toList()
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
      _warehouseTreeList = group['warehouseTreeList'] == null
          ? []
          : (group['warehouseTreeList'] as List)
              ?.map((map) => map == null
                  ? null
                  : Tree.formJson(map as Map<String, dynamic>))
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
  Future<TreeGroup> init(
      MoneyGroup moneyGroup, LuckyGroup luckyGroup, String accId) async {
    acct_id = accId;
    _moneyGroup = moneyGroup;
    _luckyGroup = luckyGroup;

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
  TreePoint _findFirstEmty() {
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        if (treeMatrix[y][x] == null &&
            treasurePosition != null &&
            x != treasurePosition.x &&
            y != treasurePosition.y) {
          return new TreePoint(x: x, y: y);
        }
      }
    }
  }

// 添加树
  bool addTree({Tree tree, bool saveData = true}) {
    TreePoint point = _findFirstEmty();
    // 找空的位置 如果没有则无法添加 返回;
    // REVIEW: 如果是抽奖时是否放入仓库?
    if (point == null) {
      Layer.toastWarning('The location is full!');
      return false;
    }

    if (tree == null) {
      tree = new Tree(
          x: point.x,
          y: point.y,
          grade: minLevel,
          gradeNumber: treeGradeNumber['$minLevel'] ?? 0);

      if (_moneyGroup.gold < tree.consumeGold) {
        Layer.toastWarning('金币不够哟...');
        return false;
      }

      EVENT_BUS.emit(MoneyGroup.ACC_GOLD, tree.consumeGold);
      treeGradeNumber['$minLevel'] = (treeGradeNumber['$minLevel'] ?? 0) + 1;
    }

    if (tree?.x == null || tree?.y == null) {
      tree?.x = point.x;
      tree?.y = point.y;
    }

    // 添加并保存
    _treeList.add(tree);
    if (saveData) {
      save();
    }
    return true;
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
      int _maxLevel = maxLevel;
      if (++target.grade > _maxLevel) {
        // _maxLevel = target.grade;
        Layer.newGrade(maxLevelTree);
      } else {
        checkTreasure();
      }
      _treeList.remove(source);
    } else {
      target.x = source.x;
      target.y = source.y;
      source.x = pos.x;
      source.y = pos.y;
    }
    notifyListeners();
    save();
  }

  // 检查是否生成宝箱
  checkTreasure() {
    Duration diff = DateTime.now().difference(treasureTime);
    TreePoint point = _findFirstEmty();
    // 时间间隔 不存在宝箱 存在空的位置
    if (diff > Duration(seconds: _treasureInterval) &&
        treasurePosition == null &&
        point != null) {
      makeTreasure(point);
    }
  }

  // 生成宝箱
  makeTreasure(TreePoint point) {
    treasurePosition = point;
    notifyListeners();
    // 设置时长结束后隐藏
    Duration duration = Duration(seconds: _treasuReremain);
    Future.delayed(duration).then((e) {
      treasurePosition = null;
      notifyListeners();
    });
  }

  // 回收树木
  recycle(Tree tree) {
    if (_treeList.length == 1) {
      Layer.toastWarning('你就要没��啦....');
      return;
    }
    if (tree.grade == maxLevel) {
      return Layer.toastWarning('最大��级的🌲不能回收');
    }
    _treeList.remove(tree);
    EVENT_BUS.emit(MoneyGroup.ACC_GOLD, tree.recycleGold);
    save();
  }

  // 切换添加/回收树按钮 树是否在拖拽.
  void transRecycle(Tree tree) {
    _isrecycle = tree;
    notifyListeners();
  }

  // 存入仓库
  void inWarehouse(Tree tree) {
    _treeList.remove(tree);
    _warehouseTreeList.add(tree);
    // 去除位置信息
    tree.x = null;
    tree.y = null;
    save();
  }

  // 从仓库取出
  void outWarehouse(List<Tree> outTreeList) {
    for (var tree in outTreeList) {
      if (addTree(tree: tree, saveData: false)) {
        _warehouseTreeList.remove(tree);
      } else {
        break;
      }
    }
    save();
  }
}
