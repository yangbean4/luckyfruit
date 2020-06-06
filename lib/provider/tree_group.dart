import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart'
    show GlobalDividendTree, UnlockNewTreeLevel;
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/pages/trip/trip_btns/free_phone.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/bgm.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/utils/method_channel.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/widgets/layer.dart';

import './lucky_group.dart';
import './money_group.dart';
import './user_model.dart';

class TreeGroup with ChangeNotifier {
  // MoneyGroup Provider引用
  MoneyGroup _moneyGroup;
  LuckyGroup _luckyGroup;
  UserModel _userModel;

  TreeGroup();

  // 存储数据用句柄
  static const String CACHE_KEY = 'TreeGroup';

  static const String CACHE_IS_FIRST_TIMELIMT_END =
      'CACHE_IS_FIRST_TIMELIMT_END';

  static const String CACHE_IS_FIRST_TIMELIMT_START =
      'CACHE_IS_FIRST_TIMELIMT_START';

  static const String CACHE_IS_FIRST_CLICK_PHONE = 'CACHE_IS_FIRST_CLICK_PHONE';

  static const String AUTO_MERGE_START = 'AUTO_MERGE_START';

  static const String AUTO_MERGE_END = 'AUTO_MERGE_END';

  // 当前最大等级和最小等级的差
  static const int DIFF_LEVEL = 5;

  static const int WAREHOUSE_MAX_LENGTH = 15;

  static const String LOAD = 'LOAD';

  String acct_id;

  // 该模块下的初始化数据加载完成
  bool _dataLoad = false;

  bool get dataLoad => _dataLoad;

  // 合成的总次数
  int totalMergeCount = 1;

  bool _isLoad = false;

  bool get isLoad => _isLoad;

  // 当前活跃的限时分红树
  Tree _currentLimitedBonusTree;

  Tree get currentLimitedBonusTree => _currentLimitedBonusTree;

  set setCurrentLimitedBonusTree(Tree tree) {
    _currentLimitedBonusTree = tree;
  }

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

  MoneyGroup get moneyGroup => _moneyGroup;

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

  // 当前gradle下能够生产的树的最大等级
  int get minLevel {
//    int usLv = maxLevel - TreeGroup.DIFF_LEVEL;
//    return usLv > 1 ? usLv : 1;

//    return Tree(grade: maxLevel(includeMaxLevel: true)).highLevelCanPurchese;

    // int level1 = maxLevel(includeMaxLevel: true);
//    int level2 = 0;
//    if (treeGradeNumber.keys?.length > 0) {
//      level2 = treeGradeNumber.keys.map((t) {
//        print("tree_minlevel: t=$t, int=${int.tryParse(t)}");
//        return int.tryParse(t);
//      }).reduce(max);
//    }
//    return max(Tree(grade: hasMaxLevel).highLevelCanPurchese, level2);
    return Tree(grade: hasMaxLevel).highLevelCanPurchese;
  }

  Tree get minLevelTree => new Tree(
      grade: minLevel,
      gradeNumber:
          treeGradeNumber == null ? 0 : (treeGradeNumber['$minLevel'] ?? 0));

// 第一次领取限时分红树的partner处红点提示
  bool _isFirstTimeimt = false;

// 曾经拥有过的最大等级的树
  int hasMaxLevel = 1;

  bool get isFirstTimeimt => _isFirstTimeimt;

  set isFirstTimeimt(bool type) {
    _isFirstTimeimt = type;
    notifyListeners();
  }

  // 显示 添加/回收 树
  Tree _isrecycle;

  Tree get isrecycle => _isrecycle;

  // 当前树中的最大等级
  int maxLevel({bool includeMaxLevel = false}) {
//     final gjb = allTreeList.where((tree) {
//       bool result = (includeMaxLevel &&
//               // 排除许愿树和限时分红树
//               tree.type != TreeType.Type_TimeLimited_Bonus &&
//               tree.type != TreeType.Type_Wishing) ||
//           (!includeMaxLevel && tree.grade != Tree.MAX_LEVEL);
// //      print("maxLevel:tree:${tree.toJson()}, $result, $includeMaxLevel");
//       return result;
//     }).map((t) => t.grade);
//     return gjb.isEmpty ? 1 : gjb.reduce(max);
    return hasMaxLevel;
  }

  Tree get maxLevelTree => new Tree(grade: hasMaxLevel);

  /**
   * 返回最大级别（38级）的树,作为限时分红树
   */
  Tree get topLevelTree =>
      new Tree(grade: Tree.MAX_LEVEL, type: TreeType.Type_TimeLimited_Bonus);

  // Tree列表
  List<Tree> _treeList = [];

  List<Tree> get treeList => _treeList;

// 是否是满的
  bool get isFull => findFirstEmty() == null;

  // treeList.length == GameConfig.Y_AMOUNT * GameConfig.X_AMOUNT;

  // 仓库中的树
  List<Tree> _warehouseTreeList = [];

  List<Tree> get warehouseTreeList => _warehouseTreeList;

  List<Tree> get allTreeList => _treeList + _warehouseTreeList;

  bool isFirstFreePhone = true;

  bool _canShowTreasure = false;

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
        // 对存在的限时分红树特殊处理
        handleLimitedBonusTree(tree);
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

  /**
   * 对存在的限时分红树特殊处理
   */
  void handleLimitedBonusTree(Tree tree) {
    if (tree?.type != TreeType.Type_TimeLimited_Bonus) {
      return;
    }

    // 如果出现限时分红树的showCountDown为false的情况
    tree?.showCountDown = true;

    // 如果限时分红树已经走完，但是没有消失，就删除掉
    if (tree.duration <= 0) {
      _treeList.remove(tree);
    }

    if (tree.timePlantedLimitedBonusTree != null && tree.initFlag == null) {
      tree.initFlag = "init";
      DateTime plantedTime =
          DateTime.fromMillisecondsSinceEpoch(tree.timePlantedLimitedBonusTree);
      // 已经走过的时间
      Duration difference = DateTime.now().difference(plantedTime);

      print(
          "handleLimitedBonusTree: ${difference.inSeconds}, ${tree.originalDuration}, ${tree.treeId}");

      int remainTime = tree.originalDuration - difference.inSeconds;

      if (remainTime <= 0) {
        // 如果从种下到现在的时间已经超过了分红树的总时长，则表明倒计时已经完成
        tree.duration = 0;
        setCurrentLimitedBonusTree = tree;
      } else {
        // 倒计时还没有走完，继续走
        tree.duration = remainTime;
      }

      /*每次重新打开App时，需要更新限时分红树产生的收益到余额中*/
      // 每秒产生的金额
      double speedPerSecond = tree?.amount / tree?.originalDuration?.toDouble();
      // 到目前为止，分红树总共产生的金额
      double earning =
          speedPerSecond * min(difference.inSeconds, tree.originalDuration);
      // 总共产生的金额-已经领取过的金额=还应该再给余额上加上的数额
      double left = earning - tree.limitedBonusedAmount;
      _moneyGroup.timeLimitedTreeAddMoney(left,
          isLastLTTreeMoney: remainTime <= 0);
    }
  }

  // 将对象转为json
  Map<String, dynamic> toJson() => {
        'upDateTime': this._upDateTime.millisecondsSinceEpoch.toString(),
        'treeList': this._treeList.map((map) => map.toJson()).toList(),
        // 种树计算放到后端下发; 这个字段不需要存储了
        'treeGradeNumber': jsonEncode(treeGradeNumber).toString(),
        "hasMaxLevel": hasMaxLevel.toString(),
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
      Map<String, dynamic> _treeGradeNumber = group['treeGradeNumber'] != null
          ? jsonDecode(group['treeGradeNumber'])
          : {};
      treeGradeNumber =
          Map.castFrom<String, dynamic, String, int>(_treeGradeNumber) ?? {};
      bool invalid =
          group['hasMaxLevel'] == null || group['hasMaxLevel'] == "null";
      print("group['hasMaxLevel']= ${group['hasMaxLevel']}");

      if (group['hasMaxLevel'] is String) {
        hasMaxLevel = int.parse(invalid ? '0' : group['hasMaxLevel']);
      } else if (group['hasMaxLevel'] is int) {
        hasMaxLevel = group['hasMaxLevel'];
      }
      if (hasMaxLevel <= 0) {
        //默认值为1
        hasMaxLevel = 1;
      }
      print("hasMaxLevel_init: $hasMaxLevel");
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
      if (upDateTime1.isAtSameMomentAs(upDateTime2)) {
        // 如果更新时间一样，使用本地的
        group = group1;
      }
    }
    return group;
  }

  //初始化 form请求&Storage
  Future<TreeGroup> init(
      MoneyGroup moneyGroup, LuckyGroup luckyGroup, UserModel userModel) async {
    String accId = userModel.value?.acct_id;
    _userModel = userModel;
    acct_id = accId;
    _moneyGroup = moneyGroup;
    _luckyGroup = luckyGroup;
    hasFlowerCount = userModel.value?.flower_nums ?? 0;
    _getGlobalDividendTree();

    _getFlower();
    String res = await Storage.getItem(TreeGroup.CACHE_KEY);

    Map<String, dynamic> ajaxData =
        await Service().getTreeInfo({'acct_id': accId});

    setTreeGroup(getUseGroup(res, ajaxData['code']));
    EVENT_BUS.emit(TreeGroup.LOAD);
    // 退出时保存数据
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      _boxTimer?.cancel();
      saveComposeTimes();
      save(skipIsAuto: true);
      _boxTimer = null;
    });

    _boxTimerRun();
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      _boxTimerRun();
    });
    // 自动合成  开始/结束
    EVENT_BUS.on(TreeGroup.AUTO_MERGE_START, (_) {
      _isAuto = true;
      _autoMerge();
    });
    EVENT_BUS.on(TreeGroup.AUTO_MERGE_END, (_) {
      _autoMergeTimeout();
      // saveComposeTimes();
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

    _isLoad = true;
    _dataLoad = true;
    notifyListeners();

    if (hasMaxLevel >= 6) {
      // 刚进来时判断最大等级树木已经超过6级，则不再显示大转盘解锁动画和大转盘锁icon
      Storage.setItem(Consts.SP_KEY_UNLOCK_WHEEL, "1");
      _luckyGroup.setShowLuckyWheelLockIcon(false, notify: false);

      if (userModel?.value?.ticket > 0 || userModel?.value?.ticket_time > 0) {
        _luckyGroup.setShowLuckyWheelDot(true, notify: false);
      }
    }
    return this;
  }

  _boxTimerRun() {
    if (_boxTimer == null) {
      Future.delayed(Duration(seconds: _luckyGroup.issed?.randon_remain_time))
          .then((e) {
        Timer.periodic(
            Duration(
                seconds: _treasureInterval ??
                    _luckyGroup.issed?.randon_remain_time), (timer) {
          // Timer.periodic(Duration(seconds: 30), (timer) {
          // 检查出现宝箱
          _boxTimer = timer;
          _canShowTreasure = true;
          checkTreasure();
        });
      });
    }
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
  Future<bool> save({bool skipIsAuto = false}) async {
    notifyListeners();

    // 如果实在自动合成 则返回 避免频繁触发
    if (_isAuto && !skipIsAuto) return false;
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
  TreePoint findFirstEmty() {
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        if (treeMatrix[y][x] == null &&
            (x != treasureTree?.x || y != treasureTree?.y)) {
          return new TreePoint(x: x, y: y);
        }
      }
    }
  }

  /// 是否显示回收指引
  Tree _showRecycleRectGuidance;

  Tree get showRecycleRectGuidance => _showRecycleRectGuidance;

  set showRecycleRectGuidance(Tree show) {
    _showRecycleRectGuidance = show;
    _isrecycle = show;

    notifyListeners();
  }

// 判断是否显示提示回收的引导
  checkRecycleRectGuidance() async {
    String res = await Storage.getItem('checkRecycleRectGuidance');
    int _minLevel = _treeList.map((tree) => tree.grade).reduce(min);
    res = null;
    if (res == null && _minLevel < minLevel) {
      Tree tree = _treeList.firstWhere((tree) => tree.grade == _minLevel);
      showRecycleRectGuidance = tree;

      Storage.setItem('checkRecycleRectGuidance', '_no_');
    }
  }

// 添加树
  bool addTree({Tree tree, bool saveData = true}) {
    // checkRecycleRectGuidance();
    // checkMag();

// 已经存在的限时分红树不能重复种
    if (tree?.type == TreeType.Type_TimeLimited_Bonus &&
        allTreeList.firstWhere((element) => tree.treeId == element.treeId,
                orElse: () => null) !=
            null) {
      return false;
    }

    TreePoint point = findFirstEmty();
    // 找空的位置 如果没有则无法添加 返回;
    // 找不到空位置 且传过来的树没有坐标; 有可能树是treasureTree 礼物盒子中的树占用
    if (point == null && tree?.x == null) {
      Layer.toastWarning('Location is Full');
      return false;
    }

    if (tree == null) {
//      print(
//          "addTree_number=${treeGradeNumber.length}, ${treeGradeNumber['$minLevel']}, minlevel=$minLevel");
      tree = new Tree(
          x: point.x,
          y: point.y,
          grade: minLevel,
          gradeNumber: treeGradeNumber['$minLevel'] ?? 0);

      bool canGo = _moneyGroup.checkAddTree(tree.consumeGold);
      if (canGo) {
        // EVENT_BUS.emit(MoneyGroup.ACC_GOLD, tree.consumeGold);
        treeGradeNumber['$minLevel'] = (treeGradeNumber['$minLevel'] ?? 0) + 1;
        Bgm.puchaseTree();
      } else {
        int coin_award = _luckyGroup.issed.coin_award ?? 10;
        num coin = coin_award * makeGoldSped;
        Layer.showCoinInsufficientWindow(coin_award / 60, coin, () {
          EVENT_BUS.emit(MoneyGroup.ADD_GOLD, coin);
        });
        return false;
      }
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

    if (_treeList.length == 2 && _luckyGroup.showCircleGuidance == true) {
      // 隐藏添加树引导,显示合成树引导
      _luckyGroup.setShowCircleGuidance = false;
      _luckyGroup.setShowRRectGuidance = true;
    }

    if (tree.type == TreeType.Type_TimeLimited_Bonus) {
      // 如果添加了限时分红树，
      _moneyGroup.LBTreeActive = 1;
    }
    return true;
  }

  // 自动合成开启
  _autoMerge() {
    // 动画时间的1.2倍时间检查一次
    // final ti = (AnimationConfig.AutoMergeTime * 1.5).toInt();
    // final period = Duration(milliseconds: ti);

    final period = Duration(milliseconds: 1100);
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
              t.grade < Tree.MAX_LEVEL - 1,
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

  saveComposeTimes() async {
    num _totalMergeCount = totalMergeCount;
    totalMergeCount = 0;

    await Service()
        .composeTimes({'acct_id': acct_id, 'times': _totalMergeCount});
  }

// 合并树
  mergeTree(Tree source, Tree target) {
    // 每合成一次统计一下
    totalMergeCount++;
    if (_userModel.value.is_m == 1 &&
        totalMergeCount == _luckyGroup?.issed?.merge_number &&
        _userModel.freePhoneMask &&
        isFirstFreePhone &&
        hasMaxLevel > 8) {
      isFirstFreePhone = false;
      FreePhone().showModal();
    }

    if (target.grade + 1 > hasMaxLevel) {
      BurialReport.report('merge_level',
          {'tree_level': (target.grade + 1).toString(), "type": "0"});
    } else {
      BurialReport.report('merge_level',
          {'tree_level': (target.grade + 1).toString(), "type": "1"});
    }

    if (target.grade == Tree.MAX_LEVEL) {
      //合成38
      // 判断是什么类型
      if (target.type.contains("continents") &&
          source.type.contains("continents")) {
        // 五大洲树弹窗
        Layer.showContinentsMergeWindow();
        BurialReport.report('page_imp', {'page_code': '004'});
      } else if (target.type.contains("hops") && source.type.contains("hops")) {
        // 啤酒花树
        Layer.showHopsMergeWindow(
            _luckyGroup?.issed?.hops_reward, source, target);
        BurialReport.report('page_imp', {'page_code': '003'});

        BurialReport.report('currency_incr', {
          'type': '6',
          'currency': _luckyGroup?.issed?.hops_reward.toString(),
        });
      }
    } else if (target.grade == Tree.MAX_LEVEL - 1) {
      //合成37
      BurialReport.report('page_imp', {'page_code': '002'});

      // 37级树合成的时候弹出选择合成哪种38级树的弹窗（五大洲树或者啤酒花树）
      Layer.showTopLevelMergeWindow(this, source, target);
    } else {
      // 其他的合成

      // 结束前一个合成队列的动画, 避免前一个后一个合成动作重叠
      treeMergeAnimateEnd(animateTargetTree);
      removeAnimateTargetTree(animateSourceTree);

      // 解锁新等级
      if (target.grade + 1 > hasMaxLevel) {
        hasMaxLevel = target.grade + 1;
        Bgm.treenewlevelup();

        if (hasMaxLevel == 3) {
          BurialReport.reportAdjust(
              BurialReport.Adjust_Event_Token_Completed_Tutorial);
        }

        if (hasMaxLevel == 6) {
          BurialReport.reportAdjust(
              BurialReport.Adjust_Event_Token_Achieved_Level_6);
        }

        Layer.newGrade(new Tree(grade: hasMaxLevel),
            amount: globalDividendTree?.amount, onOk: () {
          // 到达6级的时候，解锁大转盘
          if (hasMaxLevel < 6) {
            return;
          }

          if (hasMaxLevel == 8) {
            Storage.getItem(
              TreeGroup.CACHE_IS_FIRST_CLICK_PHONE,
            ).then((value) {
              if (value == null && _userModel.value.is_m == 1) {
                FreePhone().showModal();
              }
            });
          }
          // checkRecycleRectGuidance();

          Storage.getItem(Consts.SP_KEY_UNLOCK_WHEEL).then((value) {
            if (value == null && _userModel.value.is_m == 1) {
              _luckyGroup.setShowLuckyWheelUnlock = true;
            }
          });
        }, showBottom: _userModel.value.is_m != 0);
        // 检测是否出现(1. 限时分红树 2. 全球分红树 3. 啤酒花雌花 4. 啤酒花雄花 5. 许愿树)
        // （只在升级到最新等级时触发）
        checkBonusTree();
      }

      // 设置animateTree 开始执行动画
      animateSourceTree = source;
      animateTargetTree = target;

      _checkFlower(target.x, target.y);

      notifyListeners();
      // 设置animateTree的两个树 使得动画开始执行
      _treeList.remove(source);

      if (_luckyGroup.showRRectGuidance == true) {
        _luckyGroup.setShowRRectGuidance = false;
      }
    }
  }

  // 合成动画结束
  treeMergeAnimateEnd(Tree tree) {
    if (animateTargetTree != null && animateSourceTree != null) {
      Bgm.mergeTree();
      animateTargetTree.grade++;

      // 设置等级+1
      // 移除动画用到的树
    }
    animateSourceTree = null;
    checkTreasure();

    notifyListeners();
  }

  removeAnimateTargetTree(Tree tree) {
    checkTreasure();

    animateTargetTree = null;
    notifyListeners();
  }

// 拖拽移动时的处理
  trans(Tree source, Tree target, {TreePoint pos}) {
    if (source == target ||
        ((pos.x == treasureTree?.x && pos.y == treasureTree?.y))) {
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
    checkBonusTreeWhenUnlockingNewLevel(acct_id, hasMaxLevel)
        .then((value) async {
      if (value?.tree_type == 1) {
        // 如果是限时分红树
        Layer.showLimitedTimeBonusTree(this, value);

        BurialReport.report('currency_incr', {
          'type': '1',
          'currency': value?.amount.toString(),
          'tree_grade': hasMaxLevel.toString()
        });

        if (hasMaxLevel == 3) {
          BurialReport.report('currency_incr', {
            'type': '9',
            'currency': value?.amount.toString(),
            'tree_grade': hasMaxLevel.toString()
          });
        }

        String res = await Storage.getItem(CACHE_IS_FIRST_TIMELIMT_START);
        if (res == null) {
          // 如果是 显示弹窗; 则存储key 保证下次判断
          isFirstTimeimt = true;
          Storage.setItem(CACHE_IS_FIRST_TIMELIMT_START, '_no_');
        }

        // 检查是否弹出打开通知消息的弹创
        if (value.is_push_on == 1) {
          checkMag();
        }
      }
    });
  }

  void checkShowFirstGetMoney() async {
    String res = await Storage.getItem(CACHE_IS_FIRST_TIMELIMT_END);
    if (res == null) {
      // 如果是 显示弹窗; 则存储key 保证下次判断
      _luckyGroup.setShowFirstGetMoney = true;
      // isFirstTimeimt = true;
      Storage.setItem(CACHE_IS_FIRST_TIMELIMT_END, '_no_');
    }
  }

  // 检查是否开启了通知; 提示打开消息通知
  checkMag() async {
    bool result =
        await channelBus.callNativeMethod(Event_Name.message_notification);
    if (!result) {
      Layer.messageNotification(() {
        channelBus.callNativeMethod(Event_Name.set_message_notification);
      });
    }
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
    return newLevel;
  }

  // 检查是否生成宝箱
  checkTreasure() {
    TreePoint point = findFirstEmty();
    // 时间间隔 不存在宝箱 存在空的位置
    if (hasMaxLevel >= 3 &&
        _canShowTreasure &&
        treasureTree == null &&
        point != null) {
      makeTreasure(point);
      _canShowTreasure = false;
    }
  }

  // 生成��箱
  makeTreasure(TreePoint point) {
    // 等级为 最小等级+���机的_treasugrade等级 与最大等级减1 的最小值
    // _grade不能小于1
    int _grade =
        min(hasMaxLevel - 1, minLevel + Random().nextInt(_treasugrade));
    treasureTree = Tree(
        x: point.x,
        y: point.y,
        // type: TreeType.Type_Mango,
        grade: max(_grade, 1));
    notifyListeners();
    // 设置时长结束后隐藏
    Duration duration = Duration(seconds: _treasuReremain);
    // Tree _tree = treasureTree;
    Future.delayed(duration).then((e) {
      //  if (treasureTree == _tree)
      treasureTree = null;
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
    checkTreasure();

    if (_treeList.length == 1) {
      Layer.toastWarning('Keep at least one tree');
      return;
    }
    if (tree.grade == hasMaxLevel) {
      return Layer.toastWarning('Maximal tree cannot recycle');
    }

    if (tree.type == TreeType.Type_Wishing) {
      // 许愿树回收金钱
      Service().wishTreeRecycle(
          {'acct_id': acct_id, 'tree_id': tree.treeId}).then((ajax) {
        if (ajax != null && ajax['code'] == 0) {
          _treeList.remove(tree);
          EVENT_BUS.emit(MoneyGroup.ADD_MONEY, tree.recycleMoney);
          notifyListeners();
        } else {
          Layer.toastWarning("Failed to Recycle, ${ajax['msg']}");
        }
      });
    } else {
      _treeList.remove(tree);
      //回收金币
      EVENT_BUS.emit(MoneyGroup.ADD_GOLD, tree.recycleGold);
      notifyListeners();
    }
  }

  ///删除指定的树木
  deleteSpecificTree(Tree tree) {
    if (tree == null) {
      return;
    }

    if (tree.type == TreeType.Type_TimeLimited_Bonus) {
      // 如果限时分红树结束
      _moneyGroup.LBTreeActive = 0;
    }
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
    BurialReport.report('currency_incr', {
      'type': '7',
      // 'currency': newLevel?.amount.toString(),
    });

    save();
  }

  /// 雌雄花树合成后删除
  deleteHopsTrees() {
    TreeType.Hops_Trees_List.forEach((item) {
      Tree tree = _treeList.firstWhere((treeItem) {
        return treeItem?.type != null && treeItem?.type?.compareTo(item) == 0;
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
    // 隐藏回收引导
    showRecycleRectGuidance = null;
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
    TreePoint point = findFirstEmty();
    // 找空的位置 如果没有则无法添加 返回;
    if (point == null) {
      Layer.locationFull();
      return;
    } else {
      Map<String, dynamic> ajax = await Service().wishTreeDraw({
        'acct_id': acct_id,
      });
      if (ajax == null) {
        print("领取许愿树失败");
        return;
      }
      Tree tree = Tree(
          grade: Tree.MAX_LEVEL,
          type: TreeType.Type_Wishing,
          treeId: ajax['tree_id'],
          recycleMoney: double.parse(ajax['amount'].toString()));
      Layer.getWishing(() {
        addTree(tree: tree);
      }, tree);

      BurialReport.report('currency_incr', {
        'type': '5',
        // 'currency': newLevel?.amount.toString(),
      });
    }
  }

// ------------------🌹------🌹🌹🌹🌹🌹🌹------

  static int FLOWER_LUCKY_NUMBER = 150;
  static int CAN_GET_FLOWER_LEVEL = 8;

// 获得🌹队列
  List<int> _flowerList = [];

  // 当前拥有🌹的个数
  int _hasFlowerCount = 0;

  int get hasFlowerCount => _hasFlowerCount;

  set hasFlowerCount(int count) {
    _hasFlowerCount = count;
    if (_hasFlowerCount >= TreeGroup.FLOWER_LUCKY_NUMBER) {
      BurialReport.report('event_entr_click', {'entr_code': '17'});
    }
    _submitFlower();
    notifyListeners();
  }

  _submitFlower() {
    _userModel.upDate({'flower_nums': min(hasFlowerCount, 150)});
  }

  // 进行动画用的🌹个数
  int _animationUseflower = 0;

  int get animationUseflower => _animationUseflower;

  set animationUseflower(int count) {
    _animationUseflower = count;
    notifyListeners();
  }

  Tree _flowerMakeTree;

  Tree get flowerMakeTree => _flowerMakeTree;

  set flowerMakeTree(Tree count) {
    _flowerMakeTree = count;
    if (count != null && count is Tree) {
      TreePoint treePoint = findFirstEmty();
      _flowerMakeTree.x = treePoint?.x;
      _flowerMakeTree.y = treePoint?.y;
    }
    notifyListeners();
  }

  // 进行动画用的🌹个数
  int _gridAnimationUseflower = 0;

  int get gridAnimationUseflower => _gridAnimationUseflower;

  set gridAnimationUseflower(int count) {
    _gridAnimationUseflower = count;
    notifyListeners();
  }

  // 进行动画用的🌹个数
  int _gridReverseAnimationUseflower = 0;

  int get gridReverseAnimationUseflower => _gridReverseAnimationUseflower;

  set gridReverseAnimationUseflower(int count) {
    _gridReverseAnimationUseflower = count;
    notifyListeners();
  }

  int _flyAnimationUseflower = 0;

  int get flyAnimationUseflower => _flyAnimationUseflower;

  set flyAnimationUseflower(int count) {
    _flyAnimationUseflower = count;
    notifyListeners();
  }

  TreePoint _gridFlowerPoint;

  TreePoint get gridFlowerPoint => _gridFlowerPoint;

  set gridFlowerPoint(TreePoint count) {
    _gridFlowerPoint = count;
    notifyListeners();
  }

  TreePoint _gridReverseFlowerPoint;

  TreePoint get gridReverseFlowerPoint => _gridReverseFlowerPoint;

  set gridReverseFlowerPoint(TreePoint count) {
    _gridReverseFlowerPoint = count;
    notifyListeners();
  }

  TreePoint _flowerPoint;

  TreePoint get flowerPoint => _flowerPoint;

  set flowerPoint(TreePoint count) {
    _flowerPoint = count;
    notifyListeners();
  }

  TreePoint _flowerFlyPoint;

  TreePoint get flowerFlyPoint => _flowerFlyPoint;

  set flowerFlyPoint(TreePoint count) {
    _flowerFlyPoint = count;
    notifyListeners();
  }

  // 获取花朵数据
  _getFlower() async {
    List<int> list = await Service().getFlower({'acct_id': acct_id});
    _flowerList.addAll(list);
  }

  _checkFlower(int x, int y) {
    // if (hasMaxLevel < TreeGroup.CAN_GET_FLOWER_LEVEL) {
    //   return;
    // }
    if (_flowerList.length != 0
        //  &&
        //     ((animationUseflower == 0 && animationUseflower == 0) ||
        //         _flowerList[0] == 0
        //         )
        ) {
      gridFlowerPoint = TreePoint(x: x, y: y);
      gridAnimationUseflower = _flowerList[0];
      // gridAnimationUseflower = 150;
      _flowerList.removeAt(0);
    }
    if (_flowerList.length < 10) {
      _getFlower();
    }
  }

  int _lottoAnimationNumber = 0;

  int get lottoAnimationNumber => _lottoAnimationNumber;

  set lottoAnimationNumber(int count) {
    _lottoAnimationNumber = count;
    _luckyGroup.lottoTicketNumTotal += count;
    notifyListeners();
  }
}
