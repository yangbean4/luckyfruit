import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luckyfruit/config/app.dart' show Consts, Event_Name;
import 'package:luckyfruit/models/index.dart'
    show LevelRoule, Issued, DrawInfo, CityInfo, TreeConfig, ShaerConfig;
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/utils/mo_ad.dart';
import 'package:luckyfruit/utils/storage.dart';

import './money_group.dart';

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

  ShaerConfig shaerConfig;
  // 等级数据
  List<LevelRoule> _levelRouleList;

  List<LevelRoule> get levelRouleList => _levelRouleList;

  List<CityInfo> _cityInfoList;

  List<CityInfo> get cityInfoList => _cityInfoList;

  DrawInfo _drawInfo;

  DrawInfo get drawInfo => _drawInfo;

  /// 是否显示添加树circle指引
  bool _showCircleGuidance = false;

  bool get showCircleGuidance => _showCircleGuidance;

  set setShowCircleGuidance(bool show) {
    _showCircleGuidance = show;
    notifyListeners();
  }

  /// 是否显示回收指引
  Position _showRecycleRectGuidance;

  Position get showRecycleRectGuidance => _showRecycleRectGuidance;

  set showRecycleRectGuidance(Position show) {
    _showRecycleRectGuidance = show;
    notifyListeners();
  }

  /// 是否显示合成树rrect指引
  bool _showRRectGuidance = false;

  bool get showRRectGuidance => _showRRectGuidance;

  set setShowRRectGuidance(bool show) {
    _showRRectGuidance = show;
    notifyListeners();
  }

  /// 是否显示大转盘引导动画
  bool _showLuckyWheelGuidance = false;

  bool get showLuckyWheelGuidance => _showLuckyWheelGuidance;

  set setShowLuckyWheelGuidance(bool show) {
    _showLuckyWheelGuidance = show;
    notifyListeners();
  }

  /// 是否显示大转盘解锁动画
  bool _showLuckyWheelUnlock = false;

  bool get showLuckyWheelUnlock => _showLuckyWheelUnlock;

  set setShowLuckyWheelUnlock(bool show) {
    _showLuckyWheelUnlock = show;
    notifyListeners();
  }

  /// 是否显示firstGetMoney
  bool _showFirstGetMoney = false;

  bool get showFirstGetMoney => _showFirstGetMoney;

  set setShowFirstGetMoney(bool show) {
    _showFirstGetMoney = show;
    notifyListeners();
  }

  /// 是否显示大转盘上面的锁icon
  bool _showLuckyWheelLockIcon = true;

  bool get showLuckyWheelLockIcon => _showLuckyWheelLockIcon;

  void setShowLuckyWheelLockIcon(bool show, {bool notify = true}) {
    _showLuckyWheelLockIcon = show;
    if (notify) {
      notifyListeners();
    }
  }

  /// 是否显示大转盘上方的红点
  bool _showLuckyWheelDot = false;

  bool get showLuckyWheelDot => _showLuckyWheelDot;

  void setShowLuckyWheelDot(bool show, {bool notify = true}) {
    _showLuckyWheelDot = show;
    if (notify) {
      notifyListeners();
    }
  }

  // 是否显示🎈
  bool _showballoon = false;

  bool get showballoon => _showballoon;

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

  // 是否显示双倍的入口按钮
  bool _showDouble = false;

  bool get showDouble => _showDouble;

  bool _isDouble = false;

  bool get isDouble => _isDouble;

  void doubleStart() {
    _isDouble = true;
    hideDoubleAndNextRun();
    EVENT_BUS.emit(MoneyGroup.SET_INCREASE, _issued.reward_multiple);
    _double_coin_time = issed?.double_coin_time;
    _runDoubleTimer();
    notifyListeners();
  }

  int _double_coin_time;
  int get double_coin_time => _double_coin_time;
  set double_coin_time(int value) {
    _double_coin_time = value;
    notifyListeners();
  }

  Timer doubleTimer;
  _runDoubleTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      double_coin_time = double_coin_time - 1;
      doubleTimer = timer;
      if (double_coin_time <= 1) {
        timer.cancel();
        doubleEnd();
      }
    });
  }

  void doubleEnd() {
    _isDouble = false;
    EVENT_BUS.emit(MoneyGroup.SET_INCREASE, 1);
    notifyListeners();
  }

  // 当前是双倍
  bool _showAuto = false;

  bool get showAuto => _showAuto;

  bool _isAuto = false;

  bool get isAuto => _isAuto;

  void autoStart() {
    _isAuto = true;
    hideAutoAndNextRun();
    EVENT_BUS.emit(TreeGroup.AUTO_MERGE_START);
    _automatic_time = issed?.automatic_time;
    _runAutoTimer();
    notifyListeners();
  }

  int _automatic_time;
  int get automatic_time => _automatic_time;
  set automatic_time(int value) {
    _automatic_time = value;
    notifyListeners();
  }

  Timer autoTimer;
  _runAutoTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      automatic_time = automatic_time - 1;
      autoTimer = timer;
      if (automatic_time <= 1) {
        timer.cancel();
        autoEnd();
      }
    });
  }

  void autoEnd() {
    _isAuto = false;
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
    // _getGoldCountdown = Duration(minutes: 60);
    // _receriveTime = (60) * 60;
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
  init(String last_draw_time, String configVersion, String share_version,
      String _acct_id) async {
    acct_id = _acct_id;
    _transTime(last_draw_time);

    //观看广告 ;重制最后看广告时间
    EVENT_BUS.on(Event_Name.VIEW_AD, (_) => showAd());

    Storage.getItem(Consts.SP_KEY_UNLOCK_WHEEL).then((value) {
      if (value == null) {
        _showLuckyWheelLockIcon = true;
      }
    });

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
          "highlevel_purchaselevel":
              json.decode(issuedJson['highlevel_purchaselevel']),
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

      checkVersion(
              cacheKey: 'share_version',
              cacheVersionKey: 'share_version',
              version: share_version,
              ajax: Service().getShareLink)
          .then((issuedJson) {
        shaerConfig = ShaerConfig.fromJson(issuedJson);
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

  hideDoubleAndNextRun() {
    _showDouble = false;
    notifyListeners();

    _timerRun(
        time1: issed?.two_adSpace,
        run1: () {
          _showDouble = true;
        },
        time2: issed.double_coin_remain_time,
        run2: () {
          // 如果为true的话说明是超时了 开启下次轮转
          if (_showDouble == true) {
            hideDoubleAndNextRun();
          }
        });
  }

  hideAutoAndNextRun() {
    _showAuto = false;
    notifyListeners();

    _timerRun(
        time1: issed?.automatic_two_adSpace,
        run1: () {
          _showAuto = true;
        },
        time2: issed.automatic_remain_time,
        run2: () {
          if (_showAuto == true) {
            hideAutoAndNextRun();
          }
        });
  }

  hideBallonAndNextRun() {
    _showballoon = false;
    notifyListeners();
    _timerRun(
        time1: issed?.balloon_adSpace,
        run1: () {
          _showballoon = true;
        },
        time2: issed.automatic_remain_time,
        run2: () {
          // _showballoon = false;
          hideBallonAndNextRun();
        });
  }

  // 开始定时器
  _timerRun({int time1, int time2, Function run1, Function run2}) {
    // 广告间隔后显示入口
    Future.delayed(Duration(seconds: time1)).then((e) {
      run1();
      notifyListeners();
      // 设置的时间后 隐藏
      Future.delayed(Duration(seconds: time2)).then((e) {
        run2();
        notifyListeners();
      });
    });
  }

  _rightBtnShow() {
    if (issed?.game_timeLen != null) {
      _timerRun(
          time1: issed?.game_timeLen,
          // time1: 10,
          run1: () {
            _showDouble = true;
          },
          time2: issed.double_coin_remain_time,
          run2: () {
            if (_showDouble == true) {
              hideDoubleAndNextRun();
            }
          });
    }

    if (issed?.automatic_game_timelen != null) {
      _timerRun(
          time1: issed?.automatic_game_timelen,
          run1: () {
            _showAuto = true;
          },
          time2: issed.automatic_remain_time,
          run2: () {
            if (_showAuto == true) {
              hideAutoAndNextRun();
            }
          });
    }

    if (issed?.balloon_timeLen != null) {
      _timerRun(
          time1: issed?.balloon_timeLen,
          run1: () {
            _showballoon = true;
          },
          time2: issed.automatic_remain_time,
          run2: () {
            // _showballoon = false;
            hideBallonAndNextRun();
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
        showAd();
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
