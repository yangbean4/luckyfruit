import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:luckyfruit/models/index.dart'
    show LevelRoule, Issued, DrawInfo, CityInfo, TreeConfig;
import 'package:luckyfruit/provider/tree_group.dart';
import './money_group.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/config/app.dart' show Event_Name;
import 'package:luckyfruit/utils/mo_ad.dart';

class LuckyGroup with ChangeNotifier {
  // 检查广告间隔的时间间隔 单位:秒
  static const int CheckTimeInterval = 1;
  // 存储 等级数据 的key
  static const String CACHE_COIN_RULE = 'CACHE_COIN_RULE';
  // 存储 等级数据 version 的key
  static const String CACHE_COIN_RULE_VERSION = 'CACHE_COIN_RULE_VERSION';

  // 存储 手机抽奖 的key
  static const String CACHE_DRAW_INFO = 'CACHE_DRAW_INFO';
  // 存储 手机抽奖 version 的key
  static const String CACHE_DRAW_INFO_VERSION = 'CACHE_DRAW_INFO_VERSION';

  // 存储 城市图配置 的key
  static const String CACHE_CITY_INFO = 'CACHE_CITY_INFO';
  // 存储 城市图配置 version 的key
  static const String CACHE_CITY_INFO_VERSION = 'CACHE_CITY_INFO_VERSION';

  // 存储 Issued 的key
  static const String CACHE_TREE_CONFIG = 'CACHE_TREE_CONFIG';
  // 存储 Issued version 的key
  static const String CACHE_TREE_CONFIG_VERSION = 'CACHE_TREE_CONFIG_VERSION';

  // 存储 Issued 的key
  static const String CACHE_DEPLY = 'CACHE_DEPLY';
  // 存储 Issued version 的key
  static const String CACHE_DEPLY_VERSION = 'CACHE_DEPLY_VERSION';

  static const String RECRIVE_TIME_CACHE = 'RECRIVE_TIME_CACHE';

  String acct_id;

  // 该模块下的初始化数据加载完成
  bool _dataLoad = false;
  bool get dataLoad => _dataLoad;

  // 检查广告间隔的_Check数组
  List<_Check> _checkList = [];

  // 等级数据
  List<LevelRoule> _levelRouleList;
  List<LevelRoule> get levelRouleList => _levelRouleList;

  List<CityInfo> _cityInfoList;
  List<CityInfo> get cityInfoList => _cityInfoList;

  DrawInfo _drawInfo;
  DrawInfo get drawInfo => _drawInfo;

  // 是否显示双倍的入口按钮
  bool _showDouble = false;
  bool get showDouble => _showDouble;
  Timer _showDoubleTimer;

  /// 是否显示金币雨
  bool _showCoinRain = false;
  bool get showCoinRain => _showCoinRain;
  set setShowCoinRain(bool show) {
    _showCoinRain = show;
    notifyListeners();
  }

  // 当前是双倍
  bool _showAuto = false;
  bool get showAuto => _showAuto;
  Timer _showAutoTimer;

  // 是否显示🎈
  bool _showballoon = false;
  bool get showballoon => _showballoon;
  Timer _showballoonTimer;

  TreeConfig treeConfig;

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

  // 后端返回的数据 如果为空说明是第一次领取
  String last_draw_time;
  // 领奖倒计时
  Duration _getGoldCountdown;
  Duration get getGoldCountdown => _getGoldCountdown;

  void setGoldContDownDuration(Duration duration) =>
      _getGoldCountdown = duration;

  int _receriveTime;
  // 领取时长
  int get receriveTime => _receriveTime;

  // 从后端获取的配置Json
  Issued _issued;
  Issued get issed => _issued;

  void doubleStart() {
    _showDouble = false;
    EVENT_BUS.emit(MoneyGroup.SET_INCREASE, _issued.reward_multiple);
    notifyListeners();
  }

  void doubleEnd() {
    _showDouble = false;
    EVENT_BUS.emit(MoneyGroup.SET_INCREASE, 1);
    notifyListeners();
  }

  void autoStart() {
    _showAuto = false;
    EVENT_BUS.emit(TreeGroup.AUTO_MERGE_START);
    notifyListeners();
  }

  void autoEnd() {
    _showAuto = false;
    EVENT_BUS.emit(TreeGroup.AUTO_MERGE_END, 1);
    notifyListeners();
  }

// 计算领取倒计时
  _transTime(String _last_draw_time) async {
    String cache = await Storage.getItem(LuckyGroup.RECRIVE_TIME_CACHE);
    DateTime lastTime;
    if (cache == null) {
      // 如果没有上次领取的时间 就从现在开始计时
      lastTime = DateTime.now();
      Storage.setItem(LuckyGroup.RECRIVE_TIME_CACHE, DateTime.now().toString());
    } else {
      lastTime = DateTime.parse(cache);
    }
    DateTime nextTime =
        lastTime.add(Duration(seconds: int.parse(_last_draw_time ?? '0')));

    _receriveTime =
        last_draw_time == null || last_draw_time == '' || last_draw_time == '0'
            ? 1800
            : int.parse(last_draw_time);

    last_draw_time = _last_draw_time;
    _getGoldCountdown = DateTime.now().isBefore(nextTime)
        ? nextTime.difference(DateTime.now())
        : Duration(seconds: 0);

    notifyListeners();
  }

// 领取金币
  receiveCoin(num coin) {
    // 这次是第一次领取 接下来是30分钟
    bool noLast =
        last_draw_time == null || last_draw_time == '' || last_draw_time == '0';
    _getGoldCountdown = Duration(minutes: noLast ? 30 : 60);
    _receriveTime = (noLast ? 30 : 60) * 60;
    Service().receiveCoin({
      'acct_id': acct_id,
      'coin': coin,
    });
    Storage.setItem(LuckyGroup.RECRIVE_TIME_CACHE, DateTime.now().toString());
    //将获取的金币增加到账户上
    EVENT_BUS.emit(MoneyGroup.ADD_GOLD, coin.toDouble());
  }

/**
 * last_draw_time : 上一次领取时间戳 用于 30/60分钟的领取
 * configVersion: 后端下发的配置版本号
 */
  init(String last_draw_time, String configVersion, String _acct_id) async {
    acct_id = _acct_id;
    _transTime(last_draw_time);

    //观看广告 ;重制最后看广告时间
    EVENT_BUS.on(MoAd.VIEW_AD, (_) => showAd());

    // 开启定时器;控制显示🎈和右侧按钮
    // 利用Future.wait 的并发 同时处理
    await Future.wait([
      // treeConfig
      checkVersion(
              cacheKey: LuckyGroup.CACHE_TREE_CONFIG,
              cacheVersionKey: LuckyGroup.CACHE_TREE_CONFIG_VERSION,
              version: configVersion,
              ajax: Service().fruiterUnivalent)
          .then((issuedJson) {
        if (issuedJson == null) {
          return;
        }
        treeConfig = TreeConfig.fromJson({
          // issuedJson
          "content": json.decode(issuedJson['content']),
          "tree_content": json.decode(issuedJson['tree_content']),
          "recover_content": json.decode(issuedJson['recover_content']),
        });
      }),
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
      // 获取签到/手机抽奖的数据
      checkVersion(
              cacheKey: LuckyGroup.CACHE_DRAW_INFO,
              cacheVersionKey: LuckyGroup.CACHE_DRAW_INFO_VERSION,
              version: configVersion,
              ajax: Service().getDrawInfo)
          .then((issuedJson) {
        _drawInfo = DrawInfo.fromJson(issuedJson);
      }),
      // 城市图配置
      checkVersion(
              cacheKey: LuckyGroup.CACHE_CITY_INFO,
              cacheVersionKey: LuckyGroup.CACHE_CITY_INFO_VERSION,
              version: configVersion,
              ajax: Service().getcityList)
          .then((issuedJson) {
        _cityInfoList =
            (issuedJson as List).map((e) => CityInfo.fromJson(e)).toList();
      }),
    ]);
    _rightBtnShow();
    _dataLoad = true;
    // 等所有的请求结束,通知更新
    notifyListeners();
  }

  _rightBtnShow() {
    if (issed?.game_timeLen != null) {
      // 退出时保存数据 并取消记时器
      EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
        _showDoubleTimer?.cancel();
      });
      Timer.periodic(Duration(seconds: issed?.game_timeLen), (timer) {
        _showDoubleTimer = timer;
        adTimeCheck(Duration(seconds: issed?.two_adSpace), () {
          _showDouble = true;
          notifyListeners();

          // 设置的时间后 隐藏
          Future.delayed(Duration(seconds: issed?.double_coin_remain_time))
              .then((e) {
            _showDouble = false;
            notifyListeners();
          });
        });
      });
    }

    if (issed?.automatic_game_timelen != null) {
      // 退出时保存数据 并取消记时器
      EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
        _showAutoTimer?.cancel();
      });
      Timer.periodic(Duration(seconds: issed?.automatic_game_timelen), (timer) {
        _showAutoTimer = timer;
        adTimeCheck(Duration(seconds: issed?.automatic_two_adSpace), () {
          _showAuto = true;
          notifyListeners();

          // 设置的时间后 隐藏
          Future.delayed(Duration(seconds: issed?.automatic_remain_time))
              .then((e) {
            _showAuto = false;
            notifyListeners();
          });
        });
      });
    }

    if (issed?.balloon_timeLen != null) {
      // 退出时保存数据 并取消记时器
      EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
        _showballoonTimer?.cancel();
      });
      Timer.periodic(Duration(seconds: issed?.balloon_timeLen), (timer) {
        _showballoonTimer = timer;
        adTimeCheck(Duration(seconds: issed?.balloon_adSpace), () {
          _showballoon = true;
          notifyListeners();

          // 设置的时间后 隐藏
          Future.delayed(Duration(seconds: issed?.automatic_remain_time))
              .then((e) {
            _showballoon = false;
            notifyListeners();
          });
        });
      });
    }
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
    // dynamic ajaxJson = await ajax({'version': version});
    // return ajaxJson;

    String res = await Storage.getItem(cacheVersionKey);
    if (res == version) {
      String cache = await Storage.getItem(cacheKey);
      if (cache != 'null' && cache != null) {
        return json.decode(cache);
      }
    }
    dynamic ajaxJson = await ajax({'version': version});
    Storage.setItem(cacheVersionKey, version);
    Storage.setItem(cacheKey, json.encode(ajaxJson));
    return ajaxJson;
  }

  // 处理广告时长间隔
  adTimeCheck(Duration interval, Function callBack) {
    // 如果此时check数组为空���启动检查
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
        _check = _checkList.firstWhere((check) => check.interval < diff,
            orElse: () => null);
      }

      if (_check != null) {
        // 如果有则执行移除这条回调
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
