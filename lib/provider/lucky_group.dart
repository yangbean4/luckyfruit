import 'package:flutter/material.dart';
import 'dart:async';

import 'package:luckyfruit/models/index.dart';
import './money_group.dart';
import 'package:luckyfruit/utils/event_bus.dart';

class _Check {
  Duration interval;
  void Function() callBack;
  _Check({this.callBack, this.interval});
}

class LuckyGroup with ChangeNotifier {
  static const int CheckTimeInterval = 1;
  // 全球分红树昨日分红
  double _dividend = 400;
  double get dividend => _dividend;

  // 检查广告间隔的_Check数组
  List<_Check> _checkList = [];

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
  Issued _issued = Issued.fromJson({
    "game_timeLen": 1200,
    "two_adSpace": 1200,
    "reward_multiple": 3,
    "limited_time": 200,
    "automatic_time": 300,
    "random_m_level": 3,
    "random_space_time": 10,
    "purchase_tree_level": 4,
    "compose_numbers": 5,
    "automatic_game_timelen": 200,
    "automatic_two_adSpace": 200,
    "balloon_timeLen": 200,
    "balloon_adSpace": 200,
    "automatic_remain_time": 200,
    "balloon_remain_time": 20,
    "box_remain_time": 200,
    "balloon_time": 200,
  });

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

  init() {}
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
