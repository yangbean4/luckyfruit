import 'package:flutter/material.dart';

import './money_group.dart';

class TourismMap with ChangeNotifier {
  // 对TreeGroup Provider引用
  MoneyGroup moneyGroup;
  TourismMap();

  //当前金币总数
  double get goldNum => moneyGroup.gold;

  // 当前等级
  int get level => 1;

  // 当前等级进度
  double get schedule => goldNum / 100000000000;

  // 当前城市
  String _city = 'hawaii';

  String get city => _city;

  String get cityImgSrc => 'assets/city/$city/city.png';

  String get carImgSrc => 'assets/city/$city/car.png';

  String get manImgSrc => 'assets/city/$city/man.png';

  void init(MoneyGroup _moneyGroup) {
    moneyGroup = _moneyGroup;
  }
}
