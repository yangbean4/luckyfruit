import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luckyfruit/models/index.dart';

import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import './tree_group.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/index.dart';

class MoneyGroup with ChangeNotifier {
  // 对TreeGroup Provider引用
  TreeGroup treeGroup;
  MoneyGroup();
  // 存储数据用句柄
  static const String CACHE_KEY = 'MoneyGroup';
  // 设置金币倍数
  static const String SET_INCREASE = 'SET_INCREASE';
// 用于增加/减少 金币金钱的事件句柄
  static const String ADD_GOLD = 'ADD_GOLD';
  static const String ACC_GOLD = 'ACC_GOLD';
  static const String ADD_MONEY = 'ADD_MONEY';
  static const String ACC_MONEY = 'ACC_MONEY';
  // 升级时减少总金币
  static const String ACC_ALL_GOLD = 'ACC_ALL_GOLD';
  // 触发等级检查
  static const String ADD_ALL_GOLD = 'ADD_ALL_GOLD';
// 保存 接口获取的用户信息
  UserInfo userInfo;

  String acct_id;

// 定时器引用
  Timer _timer;

// 金币
  double _gold = 400;
  double get gold => _gold;

  // 总金币;用于升级使用
  double _allgold = 0;
  double get allgold => _gold;

// 金钱
  double _money = 0;
  double get money => _money;

  // 更新时间
  DateTime _upDateTime;
  DateTime get upDateTime => _upDateTime;

  // double _makeGoldSped;

  // 多倍金币时的产生金币的 倍数
  int _makeGoldIncrease = 1;
  int get makeGoldIncrease => _makeGoldIncrease;

  double get makeGoldSped => treeGroup?.makeGoldSped;

  // 离线收益计算
  addUnLineGet(DateTime upDateTime, num sped) {
    if (upDateTime != null && sped != null) {
      num diffTime = DateTime.now().difference(upDateTime).inSeconds;
      diffTime = diffTime > App.UN_LINE_TIME ? App.UN_LINE_TIME : diffTime;
      // TODO:离线后重新登录时的离线奖励弹窗
      addGold(sped * diffTime);
      // 加过就卸载避免多次添加
      EVENT_BUS.off(TreeGroup.LOAD);
    }
  }

  bool isDirty(group) => group.isEmpty || group['upDateTime'] == null;

  Map<String, dynamic> getUseGroup(String str1, Map<String, dynamic> group2) {
    Map<String, dynamic> group1 = Util.decodeStr(str1);
    Map<String, dynamic> group = {};
    if (isDirty(group1) || isDirty(group2)) {
      group = isDirty(group1) ? group2 : group1;
    } else {
      DateTime upDateTime1 = DateTime.fromMicrosecondsSinceEpoch(
          int.tryParse(group1['upDateTime'] ?? ''));
      DateTime upDateTime2 = DateTime.fromMicrosecondsSinceEpoch(
          int.tryParse(group2['upDateTime'] ?? ''));
      group = upDateTime1.isAfter(upDateTime2) ? group1 : group2;
    }
    return group;
  }

  void setTreeGroup(Map<String, dynamic> group) {
    if (group != null && group.isNotEmpty) {
      String t = group['_upDateTime'];
      _gold = group['_gold'] != null
          ? double.parse(group['_gold'].toString())
          : 400.0;
      _allgold = group['_allgold'] != null
          ? double.parse(group['_allgold'].toString())
          : 0.0;
      _money = group['_money'] != null
          ? double.parse((group['_money']).toString())
          : 0.0;
      DateTime upDateTime =
          t == null ? null : DateTime.fromMicrosecondsSinceEpoch(int.parse(t));

      if (upDateTime != null) {
        // 如果此时没有makeGoldSped的值的话就等通知
        addUnLineGet(upDateTime, treeGroup.makeGoldSped);
        EVENT_BUS.on(TreeGroup.LOAD,
            (_) => addUnLineGet(upDateTime, treeGroup.makeGoldSped));
      }
      notifyListeners();
    }
  }

  //初始化 form请求&Storage
  Future<MoneyGroup> init(TreeGroup _treeGroup, String accId) async {
    acct_id = accId;
    treeGroup = _treeGroup;

    String res = await Storage.getItem(MoneyGroup.CACHE_KEY);
    Map<String, dynamic> ajaxData =
        await Service().getMoneyInfo({'acct_id': accId, 'city': '123'});
    // 保存数据
    userInfo = UserInfo.fromJson(ajaxData);

    setTreeGroup(getUseGroup(res, {
      'upDateTime': ajaxData['last_leave_time'],
      '_gold': ajaxData['coin'],
      '_allgold': ajaxData['_allgold']
    }));

    EVENT_BUS.on(MoneyGroup.ADD_GOLD, (gold) => addGold(gold));
    EVENT_BUS.on(MoneyGroup.ACC_GOLD, (gold) => accGold(gold));
    EVENT_BUS.on(MoneyGroup.ADD_MONEY, (gold) => addMoney(gold));
    EVENT_BUS.on(MoneyGroup.ACC_MONEY, (gold) => accMoney(gold));
    EVENT_BUS.on(MoneyGroup.ACC_MONEY, (gold) => accMoney(gold));
    // 升级时使用
    EVENT_BUS.on(MoneyGroup.ACC_ALL_GOLD, (gold) => accAllGold(gold));

    // 设置金币产生倍数
    EVENT_BUS.on(MoneyGroup.SET_INCREASE, (increase) {
      _makeGoldIncrease = increase;
    });
    // 退出时保存数据 并取消记时器
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      save();
      _timer.cancel();
    });
    const period = const Duration(seconds: App.SAVE_INTERVAL);
    Timer.periodic(period, (timer) {
      _timer = _timer;
      addGold(treeGroup.makeGoldSped * makeGoldIncrease * App.SAVE_INTERVAL);
      // addMoney 暂时不是定时➕的 是在限时分红树时间结束是时加的
      // addMoney(treeGroup.makeMoneySped * AnimationConfig.TreeAnimationTime);
    });
    save();

    return this;
  }

  // 用户签到
  beginSign(String reward_id, String number) async {
    await Service().beginSign(
        {'acct_id': acct_id, "reward_id": reward_id, "count": number});
    await updateUserInfo();
  }

// 更新userInfo
  updateUserInfo() async {
    Map<String, dynamic> ajaxData =
        await Service().getMoneyInfo({'acct_id': acct_id, 'city': '123'});
    // 保存数据
    userInfo = UserInfo.fromJson(ajaxData);
  }

  // 将对象转为json
  Map<String, dynamic> toJson() => {
        'upDateTime': _upDateTime.millisecondsSinceEpoch.toString(),
        '_gold': _gold,
        '_money': _money,
        '_allgold': _allgold
      };

  Future<bool> save() async {
    _upDateTime = DateTime.now();
    String data = jsonEncode(this);
    bool saveSuccess = await Storage.setItem(MoneyGroup.CACHE_KEY, data);

    await Service().saveMoneyInfo({
      'acct_id': acct_id,
      'coin': _gold,
      'last_leave_time': _upDateTime.millisecondsSinceEpoch.toString(),
      '_allgold': _allgold
    });

    // 通知等级检查
    EVENT_BUS.emit(MoneyGroup.ADD_ALL_GOLD, _allgold);

    // 通知更新
    notifyListeners();
    return saveSuccess;
  }

  addTimeMakeGlod(inSeconds) {
    addGold(inSeconds * treeGroup.makeGoldSped);
  }

// 升级是清除金币
  accAllGold(g) {
    _allgold = 0;
    save();
  }

  addGold(double gold) {
    _gold = double.parse((_gold + gold).toStringAsFixed(2));
    _allgold = double.parse((_allgold + gold).toStringAsFixed(2));
    save();
  }

  accGold(double gold) {
    _gold -= gold;
    save();
  }

  accMoney(double money) {
    _money -= money;
    save();
  }

  addMoney(double money) {
    _money += money;
    save();
  }
}
