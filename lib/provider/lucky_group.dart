import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:luckyfruit/models/index.dart' show LevelRoule, Issued;
import './money_group.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/storage.dart';

class LuckyGroup with ChangeNotifier {
  // 检查广告间隔的时间间隔 单位:秒
  static const int CheckTimeInterval = 1;
  // 存储 等级数据 的key
  static const String CACHE_COIN_RULE = 'CACHE_COIN_RULE';
  // 存储 等级数据 version 的key
  static const String CACHE_COIN_RULE_VERSION = 'CACHE_COIN_RULE_VERSION';

  // 存储 Issued 的key
  static const String CACHE_DEPLY = 'CACHE_DEPLY';
  // 存储 Issued version 的key
  static const String CACHE_DEPLY_VERSION = 'CACHE_DEPLY_VERSION';
  // 全球分红树昨日分红
  double _dividend = 400;
  double get dividend => _dividend;

  // 检查广告间隔的_Check数组
  List<_Check> _checkList = [];

  // 等级数据
  List<LevelRoule> _levelRouleList;
  List<LevelRoule> get levelRouleList => _levelRouleList;

// 展示广告时间
  DateTime _showAdtime;
// // 是否显示双倍的入口按钮
//   bool _showDouble = false;
//   bool get showDouble => _showDouble;

// //  当前是双倍
//   bool _isDoublee = false;
//   bool get isDouble => _isDoublee;
//   // 是否显示双倍的入口按钮
//   bool _showAuto = false;
//   bool get showAuto => _showAuto;
//   // 是否显示双倍的入口按钮
//   bool _isAuto = false;
//   bool get isAuto => _isAuto;

  // 领奖倒计时
  Duration _getGoldCountdown = Duration(seconds: 1000);
  Duration get getGoldCountdown => _getGoldCountdown;

  // 从后端获取的配置Json
  Issued _issued;
  Issued get issed => _issued;

  void doubleStart() {
    EVENT_BUS.emit(MoneyGroup.SET_INCREASE, _issued.reward_multiple);
  }

  void doubleEnd() {
    EVENT_BUS.emit(MoneyGroup.SET_INCREASE, 1);
  }

  void autoStart() {
    EVENT_BUS.emit(MoneyGroup.SET_INCREASE, _issued.reward_multiple);
  }

  void autoEnd() {
    EVENT_BUS.emit(MoneyGroup.SET_INCREASE, 1);
  }

/**
 * last_draw_time : 上一次领取时间戳 用于 30/60分钟的领取
 * configVersion: 后端下发的配置版本号
 */
  init(String last_draw_time, String configVersion) async {
    // TODO:判断时间显示领取的倒计时
    // 利用Future.wait 的并发 同时处理
    await Future.wait([
      // Issued
      checkVersion(
              cacheKey: LuckyGroup.CACHE_DEPLY,
              cacheVersionKey: LuckyGroup.CACHE_DEPLY_VERSION,
              version: configVersion,
              ajax: Service().getDefaultDeploy)
          .then((issuedJson) {
        _issued = Issued.fromJson(issuedJson);
      }),
      // 等级数据 List<LevelRoule>
      checkVersion(
              cacheKey: LuckyGroup.CACHE_COIN_RULE,
              cacheVersionKey: LuckyGroup.CACHE_COIN_RULE_VERSION,
              version: configVersion,
              ajax: Service().getCoinRule)
          .then((issuedJson) {
        _levelRouleList =
            (issuedJson as List).map((e) => LevelRoule.fromJson(e)).toList();
      }),
    ]);
    // 等所有的请求结束,通知更新
    notifyListeners();
  }

/*
 * cacheKey 存储真实数据所用的 key
 * cacheVersionKey 存储版本号所用的 key
 * version 最新的版本号
 * ajax 获取数据所用的接口
 */
  Future<dynamic> checkVersion(
      {String cacheKey,
      String cacheVersionKey,
      String version,
      Future<dynamic> Function(Map<String, dynamic>) ajax}) async {
    String res = await Storage.getItem(cacheVersionKey);

    if (res == version) {
      String cache = await Storage.getItem(cacheKey);
      return json.decode(cache);
    } else {
      dynamic ajaxJson = await ajax({'version': version});
      Storage.setItem(cacheVersionKey, version);
      Storage.setItem(cacheKey, json.encode(ajaxJson));
      return ajaxJson;
    }
  }

  // 处理广告时长间隔
  adTimeCheck(Duration interval, Function callBack) {
    // 如果此时check数组为空则启动检查
    if (_checkList.length == 0) {
      goRunCheck();
    }
    _checkList.add(_Check(interval: interval, callBack: callBack));
  }

  // 展示广告
  showAd() {
    _showAdtime = DateTime.now();
  }

  goRunCheck() {
    const period = const Duration(seconds: LuckyGroup.CheckTimeInterval);

    Timer.periodic(period, (timer) {
      _Check _check;
      if (_showAdtime == null) {
        _check = _checkList[0];
      } else {
        Duration diff = DateTime.now().difference(_showAdtime);
        // 每隔一个时间间隔检查是否有符合条件的回调;
        _check = _checkList.firstWhere((check) => check.interval > diff,
            orElse: () => null);
      }

      if (_check != null) {
        // 如果有则执行;切移除这条回调
        _check.callBack();
        _checkList.remove(_check);
      }
      // 如果数组为空则清除 定时器
      if (_checkList.length == 0) {
        timer.cancel();
      }
    });

    // if (issed.game_timeLen != null) {
    //   Future.delayed(Duration(seconds: issed.game_timeLen)).then((e) {
    //     _showDouble = true;
    //     notifyListeners();
    //   });
    // }
  }
}

class _Check {
  Duration interval;
  void Function() callBack;
  _Check({this.callBack, this.interval});
}
