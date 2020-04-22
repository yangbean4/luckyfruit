import 'dart:math';

import 'package:flutter/material.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart'
    show LevelRoule, CityInfo, DeblokCity;
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/pages/map/map.dart' show MapPrizeModal;
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/bgm.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/widgets/layer.dart';

import './lucky_group.dart';
import './money_group.dart';
import './tree_group.dart';
import './user_model.dart';

class TourismMap with ChangeNotifier {
  static const int MAX_LEVEL = 50;

  // 1个城市对应多少等级
  static const int LEVEL_SPLIT = 5;

  // 对TreeGroup Provider引用
  MoneyGroup moneyGroup;
  LuckyGroup _luckyGroup;
  TreeGroup _treeGroup;
  UserModel _userModel;

  // 该模块下的初始化数据加载完成
  bool _dataLoad = false;

  bool get dataLoad => _dataLoad;

  String _acct_id;

  TourismMap();

  double _allgold;

// 解锁新城市 map按钮处的提示点
  bool _newCitydeblock = false;
  bool get newCitydeblock => _newCitydeblock;

  set newCitydeblock(bool type) {
    _newCitydeblock = type;
    notifyListeners();
  }

  // 是否已经init
  bool _hasInit = false;

// 解锁城市奖励金币
  num get boxMoney =>
      (_luckyGroup.issed?.box_time ?? 200) * _treeGroup.makeGoldSped;

  //当前金币总数
  // double get goldNum => moneyGroup?.allgold ?? 0;
  // 等级配置
  List<LevelRoule> get levelRouleList => _luckyGroup?.levelRouleList ?? [];

  LevelRoule get levelRoule =>
      levelRouleList.firstWhere((item) => item.level == level,
          orElse: () => levelRouleList.isEmpty ? null : levelRouleList[0]);

  // 升级需要的金币
  double get levelUpUse => levelRoule == null
      ? 100000
      : double.parse(levelRoule.need_coin_prefix) *
          pow(10, int.parse(levelRoule.need_coin_times));

  // 当前等级
  // String _level = '1';
  String get level =>
      _userModel?.userInfo?.level ?? _userModel?.value?.level ?? '1';

  // 当前等级进度  0.xx
  double get schedule {
    double cc = _allgold == null || levelUpUse == null
        ? 0
        : ((_allgold * 100) ~/ levelUpUse) / 100;

    // print('_allgold:$_allgold;levelUpUse:$levelUpUse---------$cc');
    return cc;
  }

  List<CityInfo> get cityInfoList => _luckyGroup.cityInfoList;

// 获取已解锁城市列表
  List<DeblokCity> _deblokCityList;

  List<DeblokCity> get deblokCityList => _deblokCityList;

  String _cityId = '1';

  String get cityId => _cityId;

  CityInfo get cityInfo => cityInfoList?.firstWhere((c) => c.id == _cityId,
      orElse: () => cityInfoList[0]);

  // 当前城市 cityInfo.name
  // String _city => cityInfo.code;

  String get city => cityInfo.code;

  String get _cityName => cityInfo.code.replaceAll(' ', '').toLowerCase();

  String get cityImgSrc => 'assets/city/$_cityName.png';

  String get carImgSrc => 'assets/city/car.png';

  String get manImgSrc => 'assets/city/man.png';

// 获取已经解锁的城市列表
  Future<List<DeblokCity>> getDeblokCityList() async {
    List cityJson = await Service().getDeblokCityList({'acct_id': _acct_id});
    _deblokCityList =
        (cityJson ?? []).map((e) => DeblokCity.fromJson(e)).toList();
    notifyListeners();
  }

// 解锁新的城市 查询是否中限时分红树
  Future<Map> goDeblokCity(String city) async {
    Map ajax = await Service().unlockNewCity({
      'acct_id': _acct_id,
      'city': city ?? _cityId,
      'is_full': _treeGroup.isFull ? 1 : 0
    });

    getDeblokCityList();

    return ajax;
  }

  goDeblokCityEnd(Map ajax) {
    if (ajax != null) {
      _treeGroup.addTree(
          tree: Tree(
        grade: Tree.MAX_LEVEL,
        type: TreeType.Type_TimeLimited_Bonus,
        duration: ajax['duration'],
        amount: ajax['amount'],
        showCountDown: true,
        treeId: ajax['tree_id'],
        timePlantedLimitedBonusTree: DateTime.now().millisecondsSinceEpoch,
      ));
    } else {
      EVENT_BUS.emit(MoneyGroup.ADD_GOLD, boxMoney);
    }
  }

  /// 是否显示地图页引导动画
  bool _showMapGuidance = false;

  bool get showMapGuidance => _showMapGuidance;

  set setShowMapGuidance(bool show) {
    _showMapGuidance = show;
    notifyListeners();
  }

  // // 打开宝箱 领奖
  // openCityBox(int type) {
  //   if (type == 1) {
  //   }
  // }

  levelUp() async {
    final _level = int.parse(level) + 1;
    Map<String, dynamic> data = {
      'acct_id': _acct_id,
      '_allgold': 0,
      'level': _level.toString()
    };
    BurialReport.report('captain_level', {'level': _level.toString()});

    // 解锁城市
    // _cityId = (_level ~/ TourismMap.LEVEL_SPLIT + 1).toString();
    LevelRoule levelRoule = levelRouleList.firstWhere(
        (item) => item.level == _level.toString(),
        orElse: () => levelRouleList.isEmpty ? null : levelRouleList[0]);

    // 抽奖弹窗
    if (levelRoule.deblock_city != _cityId) {
      data['deblock_city'] = levelRoule.deblock_city;
      _cityId = levelRoule.deblock_city;
      _newCitydeblock = true;
      BurialReport.report('unlock_city', {'city_number': _cityId.toString()});

      notifyListeners();
      MapPrizeModal().show(cityInfo);
    }

    await Service().updateUserInfo(data);
    _userModel.getUserInfo();
    // notifyListeners();

    // 先触发更新 保证在弹窗中显示的是新城市
  }

  void init(MoneyGroup _moneyGroup, LuckyGroup luckyGroup, TreeGroup treeGroup,
      UserModel userModel) {
    _acct_id = userModel.value.acct_id;
    moneyGroup = _moneyGroup;
    _luckyGroup = luckyGroup;
    _treeGroup = treeGroup;
    _userModel = userModel;

    _cityId = userModel.value.deblock_city ?? '1';
    _hasInit = true;
    _dataLoad = true;
    notifyListeners();

    // 金币增加检查是否升级
    EVENT_BUS.on(MoneyGroup.ADD_ALL_GOLD, (allgold) {
      // 避免 EVENT_BUS的队列中出现 连续两次ADD_ALL_GOLD 都触发升级
      // 这时 第一次触发时有 ACC_ALL_GOLD 但是其处理会迟于第二次的ADD_ALL_GOLD
      if (_allgold == 0 && allgold > levelUpUse) {
        return;
      }

      if (_allgold != 0 &&
          allgold > levelUpUse &&
          int.parse(level) < TourismMap.MAX_LEVEL) {
        // 清除金币
        _allgold = 0;
        EVENT_BUS.emit(MoneyGroup.ACC_ALL_GOLD);
        levelUp();

        double getGlod = double.parse(levelRoule.award_coin_prefix) *
            pow(10, int.parse(levelRoule.award_coin_time));
        Bgm.userlevelup();
        // 弹窗领取升级奖励
        Layer.levelUp((int.parse(level) + 1).toString(), getGlod: getGlod,
            onOk: () {
          EVENT_BUS.emit(MoneyGroup.ADD_GOLD, getGlod);
        });
      }
      _allgold = allgold;

      notifyListeners();
    });
  }
}
