import 'package:flutter/material.dart';

class LuckyGroup with ChangeNotifier {
  // 全球分红树昨日分红
  double _dividend = 400;
  double get dividend => _dividend;

  // 领奖倒计时
  Duration _getGoldCountdown = Duration(seconds: 1000);
  Duration get getGoldCountdown => _getGoldCountdown;
  // 从后端获取的配置Json
}
