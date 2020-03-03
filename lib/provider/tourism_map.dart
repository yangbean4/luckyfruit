import 'package:flutter/material.dart';

class TourismMap with ChangeNotifier {
  TourismMap();
  // 当前城市
  String _city = 'hawaii';

  String get city => _city;

  String get cityImgSrc => 'assets/city/$city/city.png';

  String get carImgSrc => 'assets/city/$city/car.png';

  String get manImgSrc => 'assets/city/$city/man.png';
}
