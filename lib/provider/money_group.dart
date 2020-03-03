import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import './tree_group.dart';
import 'package:luckyfruit/config/app.dart';

class MoneyGroup with ChangeNotifier {
  // 对TreeGroup Provider引用
  TreeGroup treeGroup;
  MoneyGroup();
  // 存储数据用句柄
  static const String CACHE_KEY = 'MoneyGroup';

// 用于增加/减少 金币金钱的事件句柄
  static const String ADD_GOLD = 'ADD_GOLD';
  static const String ACC_GOLD = 'ACC_GOLD';
  static const String ADD_MONEY = 'ADD_MONEY';
  static const String ACC_MONEY = 'ACC_MONEY';

// 金币
  double _gold = 400;
  double get gold => _gold;

// 金钱
  double _money = 0;
  double get money => _money;

  // 更新时间
  DateTime _upDateTime;
  DateTime get upDateTime => _upDateTime;

  // double _makeGoldSped;

  double get makeGoldSped => treeGroup?.makeGoldSped;

  //初始化 form请求&Storage
  Future<MoneyGroup> init(TreeGroup _treeGroup) async {
    treeGroup = _treeGroup;
    String res = await Storage.getItem(MoneyGroup.CACHE_KEY);

    if (res != null) {
      Map<String, dynamic> group = json.decode(res);
      String t = group['_upDateTime'];
      _gold = double.parse(group['_gold'].toString());
      _money = double.parse(group['_money'].toString());
      _upDateTime = t == null ? null : DateTime.parse(t);
    }

    EVENT_BUS.on(MoneyGroup.ADD_GOLD, (gold) => addGold(gold));
    EVENT_BUS.on(MoneyGroup.ACC_GOLD, (gold) => accGold(gold));
    EVENT_BUS.on(MoneyGroup.ADD_MONEY, (gold) => addMoney(gold));
    EVENT_BUS.on(MoneyGroup.ACC_MONEY, (gold) => accMoney(gold));
    // 退出时保存数据
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      save();
    });
    const period = const Duration(seconds: 1);
    Timer.periodic(period, (timer) {
      addGold(treeGroup.makeGoldSped);
      addMoney(treeGroup.makeMoneySped);
    });
    notifyListeners();

    return this;
  }

  // 将对象转为json
  Map<String, dynamic> toJson() => {
        'upDateTime': this._upDateTime.toString(),
        '_gold': this._gold,
        '_money': _money
      };

  Future<bool> save() async {
    bool saveSuccess =
        await Storage.setItem(MoneyGroup.CACHE_KEY, jsonEncode(this));
    // 通知更新
    notifyListeners();
    return saveSuccess;
  }

  addGold(double gold) {
    _gold += gold;
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
