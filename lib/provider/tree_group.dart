import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/widgets/layer.dart';
import './money_group.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/index.dart';
import './lucky_group.dart';
import 'package:luckyfruit/models/index.dart'
    show GlobalDividendTree, UnlockNewTreeLevel;
import 'package:luckyfruit/utils/bgm.dart';
import './user_model.dart';

class TreeGroup with ChangeNotifier {
  // MoneyGroup Provider引用
  MoneyGroup _moneyGroup;
  LuckyGroup _luckyGroup;
  TreeGroup();
  // 存储数据用句柄
  static const String CACHE_KEY = 'TreeGroup';

  static const String AUTO_MERGE_START = 'AUTO_MERGE_START';

  static const String AUTO_MERGE_END = 'AUTO_MERGE_END';

  // 当前最大等级和最小等级的差
  static const int DIFF_LEVEL = 5;

  static const int WAREHOUSE_MAX_LENGTH = 15;

  static const String LOAD = 'LOAD';

  String acct_id;

  // 合成的总次数
  int totalMergeCount = 1;

  bool _isLoad = false;
  bool get isLoad => _isLoad;

  // 全球分红树 数据
  GlobalDividendTree _globalDividendTree;
  GlobalDividendTree get globalDividendTree => _globalDividendTree;

  //宝箱的树
  Tree treasureTree;
  Timer _boxTimer;
  // 设置的宝箱出现的时间间隔 单位 s
  num get _treasureInterval => _luckyGroup.issed?.random_space_time;
  // 宝箱停留时长;超出后隐藏
  num get _treasuReremain => _luckyGroup.issed?.box_remain_time;
  // 随机的等级
  num get _treasugrade => _luckyGroup.issed?.random_m_level;

  // 冷却时间
  int delayTime;
  // 最后种树时间
  DateTime makeTreeTime = DateTime.now();

  // 是否在自动合成
  bool _isAuto = false;
  // 自动合成是否暂停 有弹窗时暂停 路由跳转时暂停
  bool _autoTimeOut = false;
  // 保存 自动合成检查的定时器
  Timer timer;
  // 正在执行合成动画的树
  Tree autoSourceTree;
  // 正在执行合成动画的树 的合成目标
  Tree autoTargetTree;

  //🚩 在执行合成动画时先设置这两个的值
  // 这两个有值会使得对应的位置显示为动画合成
  // 合成结束后 显示出合成出的树
  // 在执行合成动画的两哥树
  Tree animateSourceTree;
  // 正在执行合成动画的树 的合成目标
  Tree animateTargetTree;

  // 记录每个等级种树的次数
  Map<String, int> treeGradeNumber = {};

  // 当前生产树的等级
  int get minLevel {
    int usLv = maxLevel - TreeGroup.DIFF_LEVEL;
    return usLv > 1 ? usLv : 1;
  }

  Tree get minLevelTree =>
      new Tree(grade: minLevel, gradeNumber: treeGradeNumber['$minLevel'] ?? 0);

  // 显示 添加/回收 树
  Tree _isrecycle;
  Tree get isrecycle => _isrecycle;

  // 当前树中的最大等级
  int get maxLevel {
    final gjb = allTreeList
        .where((tree) => tree.grade != Tree.MAX_LEVEL)
        .map((t) => t.grade);
    return gjb.isEmpty ? 1 : gjb.reduce(max);
  }

  Tree get maxLevelTree => new Tree(grade: maxLevel);

  /**
   * 返回最大级别（38级）的树
   */
  Tree get topLevelTree => new Tree(grade: Tree.MAX_LEVEL);

  // Tree列表
  List<Tree> _treeList = [];
  List<Tree> get treeList => _treeList;
// 是否是满的
  bool get isFull => _findFirstEmty() == null;
  // treeList.length == GameConfig.Y_AMOUNT * GameConfig.X_AMOUNT;

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
  // double get makeMoneySped {
  //   return treeList.map((sub) => sub.money).toList().fold(0, (a, b) => a + b);
  // }

  // 转成二维数组
  List<List<Tree>> get treeMatrix {
    List<List<Tree>> treeMatrix = List(GameConfig.Y_AMOUNT);
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      List<Tree> yMat = List(GameConfig.X_AMOUNT);
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        Tree tree = _treeList.firstWhere((t) => t.x == x && t.y == y,
            orElse: () => null);
        // 如果出现限时分红树的showCountDown为false的情况
        // (测试时有出现过,但还不清楚什么原因导致的), 删除这棵树
        if (tree?.type == TreeType.Type_BONUS && !tree.showCountDown) {
          _treeList.remove(tree);
          continue;
        }
        yMat[x] = tree;
      }
      treeMatrix[y] = yMat;
    }

    return treeMatrix;
  }

  // 将对象转为json
  Map<String, dynamic> toJson() => {
        'upDateTime': this._upDateTime.millisecondsSinceEpoch.toString(),
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
          ? DateTime.fromMicrosecondsSinceEpoch(
              int.parse(group['upDateTime']) * 1000)
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

  bool isDirty(group) =>
      group.isEmpty || group['upDateTime'] == null || group['upDateTime'] == '';

  Map<String, dynamic> getUseGroup(String str1, String str2) {
    Map<String, dynamic> group1 = Util.decodeStr(str1);
    Map<String, dynamic> group2 = Util.decodeStr(str2);
    Map<String, dynamic> group = {};
    if (isDirty(group1) || isDirty(group2)) {
      group = isDirty(group1) ? group2 : group1;
    } else {
      DateTime upDateTime1 = DateTime.fromMicrosecondsSinceEpoch(
          int.tryParse(group1['upDateTime']) * 1000);
      DateTime upDateTime2 = DateTime.fromMicrosecondsSinceEpoch(
          int.tryParse(group2['upDateTime']) * 1000);
      group = upDateTime1.isAfter(upDateTime2) ? group1 : group2;
    }
    return group;
  }

  //初始化 form请求&Storage
  Future<TreeGroup> init(
      MoneyGroup moneyGroup, LuckyGroup luckyGroup, UserModel userModel) async {
    String accId = userModel.value?.acct_id;
    acct_id = accId;
    _moneyGroup = moneyGroup;
    _luckyGroup = luckyGroup;
    _getGlobalDividendTree();
    String res = await Storage.getItem(TreeGroup.CACHE_KEY);

    Map<String, dynamic> ajaxData =
        await Service().getTreeInfo({'acct_id': accId});

    setTreeGroup(getUseGroup(res, ajaxData['code']));
    EVENT_BUS.emit(TreeGroup.LOAD);
    // 退出时保存数据
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      _boxTimer?.cancel();
      save();
    });
    // 自动合成  开始/结束
    EVENT_BUS.on(TreeGroup.AUTO_MERGE_START, (_) {
      _isAuto = true;
      _autoMerge();
    });
    EVENT_BUS.on(TreeGroup.AUTO_MERGE_END, (_) {
      _autoMergeTimeout();
    });
    // 弹窗显示时�������动合��暂停
    EVENT_BUS.on(Event_Name.MODAL_SHOW, (_) {
      // _autoTimeOut = true;
    });
    EVENT_BUS.on(Event_Name.MODAL_HIDE, (_) {
      if (_autoTimeOut) {
        _autoTimeOut = false;
        // 如果仅仅是暂停但是 自动合成还未结束(_isAuto) 在暂停结束时重新开始
        if (_isAuto) _autoMerge();
      }
    });
    EVENT_BUS.on(Event_Name.Router_Change, (_) {
      _autoMergeTimeout();
    });
    Timer.periodic(Duration(seconds: _treasureInterval), (timer) {
      // 检查出现宝箱
      _boxTimer = timer;
      checkTreasure();
    });

    _isLoad = true;
    notifyListeners();
    return this;
  }

  Future<GlobalDividendTree> _getGlobalDividendTree() async {
    dynamic userMap =
        await Service().getGlobalDividendTree({"acct_id": acct_id});
    GlobalDividendTree globalDividendTree =
        GlobalDividendTree.fromJson(userMap);
    _globalDividendTree = globalDividendTree;
    notifyListeners();
    return globalDividendTree;
  }

  // 保存
  Future<bool> save() async {
    notifyListeners();

    // 如果实在自动合成 则返回 避免频繁触发
    if (_isAuto) return false;
    _upDateTime = DateTime.now();
    String data = jsonEncode(this);
    bool saveSuccess = await Storage.setItem(TreeGroup.CACHE_KEY, data);

    await Service().saveTreeInfo({
      'acct_id': acct_id,
      'code': data,
      'last_time': _upDateTime.millisecondsSinceEpoch.toString()
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
            (x != treasureTree?.x || y != treasureTree?.y)) {
          return new TreePoint(x: x, y: y);
        }
      }
    }
  }

// 添加树
  bool addTree({Tree tree, bool saveData = true}) {
    TreePoint point = _findFirstEmty();
    // 找空的位置 如果没有则无法添加 返回;
    // 找不到空位置 且传过来的树没有坐标; 有可能树是treasureTree 礼物盒子中的树占用
    if (point == null && tree?.x == null) {
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
        int coin_award = _luckyGroup.issed.coin_award ?? 10;
        num coin = coin_award * makeGoldSped;
        Layer.showCoinInsufficientWindow(coin_award / 60, coin, () {
          EVENT_BUS.emit(MoneyGroup.ADD_GOLD, coin);
        });
        return false;
      }

      EVENT_BUS.emit(MoneyGroup.ACC_GOLD, tree.consumeGold);
      treeGradeNumber['$minLevel'] = (treeGradeNumber['$minLevel'] ?? 0) + 1;

      Bgm.puchaseTree();
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

  // 自动合成开启
  _autoMerge() {
    // 动画时间的1.2倍时间检查一次
    final ti = (AnimationConfig.AutoMergeTime * 1.5).toInt();
    final period = Duration(milliseconds: ti);
    Timer.periodic(period, (_tim) {
      timer = _tim;
      if (_isAuto) {
        if (!_autoTimeOut) {
          //自动合成状态且不是暂停状态
          _checkMerge();
        }
      } else {
        _tim.cancel();
      }
    });
  }

// 自动合成结束
  _autoMergeTimeout() {
    _isAuto = false;
    timer?.cancel();
    save();
  }

// 检查是否有自可以自动合成的🌲 如果有执行自动合成动画
  _checkMerge() {
    for (int index = 0; index < _treeList.length; index++) {
      Tree target = _treeList[index];
      Tree source = _treeList.firstWhere(
          (t) =>
              t != target &&
              t.grade == target.grade &&
              t.grade != Tree.MAX_LEVEL,
          orElse: () => null);
      if (source != null) {
        autoSourceTree = source;
        autoTargetTree = target;

        // 从列表中删除 开始自动合成动画
        _treeList.remove(source);
        notifyListeners();
        break;
      }
    }
  }

  // 一组自动合成动画结束
  autoMergeEnd(Tree source, Tree target) {
    autoSourceTree = null;
    autoTargetTree = null;
    mergeTree(source, target);
    notifyListeners();
  }

// 合并树
  mergeTree(Tree source, Tree target) {
    // 每合成一次统计一下
    totalMergeCount++;
    if (target.grade == Tree.MAX_LEVEL) {
      // 判断是什么类型
      if (target.type.contains("continents") &&
          source.type.contains("continents")) {
        // 五大洲树弹窗
        Layer.showContinentsMergeWindow();
      } else if (target.type.contains("hops") && source.type.contains("hops")) {
        // 啤酒花树
        Layer.showHopsMergeWindow(
            _luckyGroup?.issed?.hops_reward?.toString() ?? "--");
      }
    } else if (target.grade == Tree.MAX_LEVEL - 1) {
      // 37级树合成的时候弹出选择合成哪种38级树的弹窗（五大洲树或者啤酒花树）
      Layer.showTopLevelMergeWindow(this, source, target);
    } else {
      // 结束前一个合成队列的动画, 避免前一个后一个合成动作重叠
      treeMergeAnimateEnd(animateTargetTree);
      removeAnimateTargetTree(animateSourceTree);

      // 解锁新等级
      if (target.grade + 1 > maxLevel) {
        Layer.newGrade(
          new Tree(grade: maxLevel + 1),
          amount: globalDividendTree?.amount,
        );
        // 检测是否出现(1. 限时分红树 2. 全球分红树 3. 啤酒花雌花 4. 啤酒花雄花 5. 许愿树)
        // （只在升级到最新等级时触发）
        checkBonusTree();
      }

      // 设置animateTree 开始执行动画
      animateSourceTree = source;
      animateTargetTree = target;
      notifyListeners();
      // 设置animateTree的两个树 使得动画开始执行
      _treeList.remove(source);
    }
  }

  // 合成动画结束
  treeMergeAnimateEnd(Tree tree) {
    if (animateTargetTree != null && animateSourceTree != null) {
      Bgm.mergeTree();

      // 设置等级+1
      animateTargetTree.grade++;
      // 移除动画用到的树
    }
    animateSourceTree = null;

    notifyListeners();
  }

  removeAnimateTargetTree(Tree tree) {
    animateTargetTree = null;
    notifyListeners();
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
      // 同等级 合并
      mergeTree(source, target);
    } else {
      target.x = source.x;
      target.y = source.y;
      source.x = pos.x;
      source.y = pos.y;
    }
    notifyListeners();
    save();
  }

  /// 通过接口检查是否获取奖励(1. 限时分红树 2. 全�����分红树 3. 啤酒花雌花 4. 啤酒花雄花 5. 许愿树)
  checkBonusTree() async {
    checkBonusTreeWhenUnlockingNewLevel(acct_id, maxLevel + 1).then((value) {
      if (value?.tree_type == 1) {
        // 如果是限时分红树
        Layer.showLimitedTimeBonusTree(this, value);
      }
    });
  }

  /// 通过接口��查是否获取奖励(1. 限时分红树 2. 全球分红树 3. 啤酒花雌花 4. 啤酒花雄花 5. 许���树)
  Future<UnlockNewTreeLevel> checkBonusTreeWhenUnlockingNewLevel(
      String acctId, int level) async {
    dynamic stateMap =
        await Service().unlockNewLevel({'acct_id': acctId, "level": level});

    // String test = """{"tree_type": 1,"tree_id": 21,"amount": 11.0,"duration": 300}""";
    // stateMap = json.decode(test);

    if (stateMap == null) {
      return null;
    }
    UnlockNewTreeLevel newLevel = UnlockNewTreeLevel.fromJson(stateMap);
    //TODO 测试代码
    // newLevel.duration = 3000;
    return newLevel;
  }

  // 检查是否生成宝箱
  checkTreasure() {
    TreePoint point = _findFirstEmty();
    // 时间间隔 不存在宝箱 存在空的位置
    if (treasureTree == null && point != null) {
      makeTreasure(point);
    }
  }

  // 生成��箱
  makeTreasure(TreePoint point) {
    treasureTree = Tree(
        x: point.x,
        y: point.y,
        // type: TreeType.Type_Mango,
        // 等级为 最小等级+���机的_treasugrade等级 与最大等级减1 的最小值
        grade: min(maxLevel - 1, minLevel + Random().nextInt(_treasugrade)));
    notifyListeners();
    // 设置时长结束后隐藏
    Duration duration = Duration(seconds: _treasuReremain);
    Tree _tree = treasureTree;
    Future.delayed(duration).then((e) {
      if (treasureTree == _tree) treasureTree = null;
      notifyListeners();
    });
  }

  // 领取宝箱
  pickTreasure(bool pick) {
    // 是否��取树
    if (pick) addTree(tree: treasureTree);
    treasureTree = null;
    notifyListeners();
  }

  // 回收树木
  recycle(Tree tree) {
    if (_treeList.length == 1) {
      Layer.toastWarning('Keep at least one tree');
      return;
    }
    if (tree.grade == maxLevel) {
      return Layer.toastWarning('Maximal tree cannot recycle');
    }
    _treeList.remove(tree);

    if (tree.type == TreeType.Type_Wishing) {
      // 许愿树回收金钱
      Service().wishTreeRecycle(
          {'acct_id': acct_id, 'tree_id': tree.treeId}).then((ajax) {
        if (ajax != null && ajax['code'] == 0) {
          EVENT_BUS.emit(MoneyGroup.ADD_MONEY, tree.recycleMoney);
        }
      });
    } else {
      //回收金币
      EVENT_BUS.emit(MoneyGroup.ADD_GOLD, tree.recycleGold);
    }

    notifyListeners();
  }

  ///删除指定的树木
  deleteSpecificTree(Tree tree) {
    _treeList.remove(tree);
    save();
  }

  /// 五洲树合成全球分红树后,删除五洲树
  deleteContinentsTrees() {
    TreeType.Continents_Trees_List.forEach((item) {
      Tree tree = _treeList.firstWhere((treeItem) {
        return treeItem?.type?.compareTo(item) == 0;
      }, orElse: () => null);

      print("deleteContinentsTrees item=${tree?.type}");
      // 找到tree,删除
      if (tree != null) {
        _treeList.remove(tree);
      }
    });

    save();
  }

  /// 雌雄花树合成后删除
  deleteHopsTrees() {
    TreeType.Hops_Trees_List.forEach((item) {
      Tree tree = _treeList.firstWhere((treeItem) {
        return treeItem.type.compareTo(item) == 0;
      }, orElse: () => null);

      print("deleteHopsTrees item=${tree.type}");
      // 找到tree,删除
      if (tree != null) {
        _treeList.remove(tree);
      }
    });

    save();
  }

  // 切换添加/回收树按钮 树是否在拖拽.
  void transRecycle(Tree tree) {
    _isrecycle = tree;
    notifyListeners();
  }

  // 存入仓库
  void inWarehouse(Tree tree) {
    if (_warehouseTreeList.length == TreeGroup.WAREHOUSE_MAX_LENGTH) {
      Layer.toastWarning('Warehouse is full.');
    } else {
      _treeList.remove(tree);
      _warehouseTreeList.add(tree);
      // 去除位置信息
      tree.x = null;
      tree.y = null;
      save();
    }
  }

  // 从���库取出
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

  void addWishTree() async {
    TreePoint point = _findFirstEmty();
    // 找空的位置 如果没有则无法添加 返回;
    if (point == null) {
      Layer.locationFull();
      return;
    } else {
      Map<String, dynamic> ajax = await Service().wishTreeDraw({
        'acct_id': acct_id,
      });
      Tree tree = Tree(
          grade: Tree.MAX_LEVEL,
          type: TreeType.Type_Wishing,
          treeId: ajax['tree_id'],
          recycleMoney: double.parse(ajax['amount'].toString()));
      Layer.getWishing(() {
        addTree(tree: tree);
      }, tree);
    }
  }
}
