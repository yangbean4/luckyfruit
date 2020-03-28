import 'package:flutter/material.dart';
import 'dart:math';

import './money_group.dart';
import './lucky_group.dart';
import './tree_group.dart';
import 'package:luckyfruit/models/index.dart'
    show LevelRoule, CityInfo, DeblokCity;
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/pages/map/map.dart' show MapPrizeModal;
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/config/app.dart';

class TourismMap with ChangeNotifier {
  static const int MAX_LEVEL = 50;
  // 1个城市对应多少等级
  static const int LEVEL_SPLIT = 5;
  // 对TreeGroup Provider引用
  MoneyGroup moneyGroup;
  LuckyGroup _luckyGroup;
  TreeGroup _treeGroup;
  String _acct_id;
  TourismMap();
  double _allgold;
  // 是否已经init
  bool _hasInit = false;
// 解锁城市奖励金币
  num get boxMoney =>
      (_luckyGroup.issed?.box_time ?? 200) * moneyGroup.makeGoldSped;

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

  List<CityInfo> get cityInfoList => _luckyGroup.cityInfoList;

// 获取已解锁城市列表
  List<DeblokCity> _deblokCityList;
  List<DeblokCity> get deblokCityList => _deblokCityList;

  String _cityId = '1';

  String get cityId => _cityId;

  CityInfo get cityInfo => cityInfoList.firstWhere((c) => c.id == _cityId,
      orElse: () => cityInfoList[0]);

  // 当前城市
  String _city = 'hawaii';

  String get city => _city;

  String get cityImgSrc => 'assets/city/$city/city.png';

  String get carImgSrc => 'assets/city/$city/car.png';

  String get manImgSrc => 'assets/city/$city/man.png';

// 获取已经解锁的城市列表
  Future<List<DeblokCity>> getDeblokCityList() async {
    List cityJson = await Service().getDeblokCityList({'acct_id': _acct_id});
    _deblokCityList =
        (cityJson ?? []).map((e) => DeblokCity.fromJson(e)).toList();
    notifyListeners();
  }

// 解锁新的城市 查询是否中限时分红树
  Future<bool> goDeblokCity() async {
    Map ajax = await Service().unlockNewCity({
      'acct_id': _acct_id,
      'city': _cityId,
      'is_full': _treeGroup.isFull ? 1 : 0
    });
    if (ajax != null) {
      _treeGroup.addTree(
          tree: Tree(
        grade: Tree.MAX_LEVEL,
        type: TreeType.Type_BONUS,
        duration: ajax['duration'],
        amount: ajax['amount'],
      ));
    } else {
      EVENT_BUS.emit(MoneyGroup.ADD_GOLD, boxMoney);
    }
    getDeblokCityList();

    return ajax == null;
  }

  // // 打开宝箱 领奖
  // openCityBox(int type) {
  //   if (type == 1) {
  //   }
  // }

  levelUp() {
    Map<String, dynamic> data = {
      'acct_id': _acct_id,
      '_allgold': 0,
      'level': _level
    };
    if (int.parse(_level) % (TourismMap.LEVEL_SPLIT) == 0) {
      // 解锁城市
      _cityId = (int.parse(_level) / TourismMap.LEVEL_SPLIT + 1).toString();

      data['deblock_city'] = _cityId;
      notifyListeners();
      // 先触发更新 保证在弹窗中显示的是新城市
      // 抽奖弹窗
      MapPrizeModal().show(cityInfo);
    }
    Service().saveMoneyInfo(data);
  }

  void init(MoneyGroup _moneyGroup, LuckyGroup luckyGroup, TreeGroup treeGroup,
      String level, String acct_id) {
    _acct_id = acct_id;
    moneyGroup = _moneyGroup;
    _luckyGroup = luckyGroup;
    _treeGroup = treeGroup;
    _level = level;
    _hasInit = true;
    notifyListeners();

    // 金币增加检查是否升级
    EVENT_BUS.on(MoneyGroup.ADD_ALL_GOLD, (allgold) {
      _allgold = allgold;
      if (goldNum > levelUpUse && int.parse(_level) < TourismMap.MAX_LEVEL) {
        _level = (int.parse(_level) + 1).toString();
        levelUp();

        // 清除金币
        EVENT_BUS.emit(MoneyGroup.ACC_ALL_GOLD);

        double getGlod = double.parse(levelRoule.award_coin_prefix) *
            pow(10, int.parse(levelRoule.award_coin_time));
        // 弹窗领取升级奖励
        Layer.levelUp(_level, getGlod: getGlod, onOk: () {
          EVENT_BUS.emit(MoneyGroup.ADD_GOLD, getGlod);
        });
      }

      notifyListeners();
    });
  }
}
