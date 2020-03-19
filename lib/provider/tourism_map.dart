import 'package:flutter/material.dart';
import 'dart:math';

import './money_group.dart';
import './lucky_group.dart';
import 'package:luckyfruit/models/index.dart' show LevelRoule;
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/service/index.dart';

class TourismMap with ChangeNotifier {
  // 对TreeGroup Provider引用
  MoneyGroup moneyGroup;
  LuckyGroup _luckyGroup;
  String _acct_id;
  TourismMap();
  double _allgold;
  // 是否已经init
  bool _hasInit = false;

  //当前金币总数
  double get goldNum => moneyGroup?.allgold ?? 0;
  // 等级配置
  List<LevelRoule> get levelRouleList => _luckyGroup?.levelRouleList ?? [];
  LevelRoule get levelRoule =>
      levelRouleList.firstWhere((item) => item.level == _level,
          orElse: () => levelRouleList.isEmpty ? null : levelRouleList[0]);
  // 升级需要的金币
  double get levelUpUse => levelRoule == null
      ? 100000
      : double.parse(levelRoule.need_coin_prefix) *
          pow(10, int.parse(levelRoule.need_coin_times));

  // 当前等级
  String _level = '1';
  String get level => _level;

  // 当前等级进度  0.xx
  double get schedule => _allgold == null || levelUpUse == null
      ? 0
      : ((_allgold * 100) ~/ levelUpUse) / 100;

  // 当前城市
  String _city = 'hawaii';

  String get city => _city;

  String get cityImgSrc => 'assets/city/$city/city.png';

  String get carImgSrc => 'assets/city/$city/car.png';

  String get manImgSrc => 'assets/city/$city/man.png';

  levelUp() {
    Service()
        .saveMoneyInfo({'acct_id': _acct_id, '_allgold': 0, 'level': _level});
  }

  void init(MoneyGroup _moneyGroup, LuckyGroup luckyGroup, String level,
      String acct_id) {
    _acct_id = acct_id;
    moneyGroup = _moneyGroup;
    _luckyGroup = luckyGroup;
    _level = level;
    _hasInit = true;
    notifyListeners();

    // 金币增加检查是否升级
    EVENT_BUS.on(MoneyGroup.ADD_ALL_GOLD, (allgold) {
      _allgold = allgold;
      if (goldNum > levelUpUse) {
        _level = (int.parse(_level) + 1).toString();
        levelUp();

        // 清除金币
        EVENT_BUS.emit(MoneyGroup.ACC_ALL_GOLD);

        double getGlod = double.parse(levelRoule.award_coin_prefix) *
            pow(10, int.parse(levelRoule.award_coin_time));
        // 弹窗领取升级奖励
        Layer.levelUp(
            level: _level,
            getGlod: getGlod,
            onOk: () {
              EVENT_BUS.emit(MoneyGroup.ADD_GOLD, getGlod);
            });
        // TODO: 调用接口保存等级数据
      }

      notifyListeners();
    });
  }
}
