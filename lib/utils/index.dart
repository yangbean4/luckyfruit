import 'dart:math';
import 'dart:convert';

// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:provider/provider.dart';

class Util {
  static String formatNumber(num number, {int fixed}) {
    List<String> dan = [
      '',
      'K',
      'M',
      'B',
      'T',
      'aa',
      'ab',
      'ac',
      'ad',
      'ae',
      'af',
      'ag',
      'ah',
      'ai',
      'aj',
      'ak',
      'al',
      'am',
      'an'
    ];
    number = number ?? 0;
    int index = dan.asMap().keys.toList().lastIndexWhere((t) {
      // print(
      //     "formatNumber: number=$number, t=$t, 相除=${number / pow(10.0, 3 * t + 1)}");
      return number / pow(10.0, 3 * t + 1) > 1;
    });
    String result = index <= 0
        ? number.toStringAsFixed(fixed ?? 2)
        : (number / pow(10.0, 3 * index)).toStringAsFixed(2) + dan[index];

    // print("format_result= $result");
    return result;
  }

  static Map<String, dynamic> decodeStr(String str) {
    Map<String, dynamic> map = {};
    try {
      map = json.decode(str);
    } catch (e) {}
    return map;
  }

  /// 格式化时间戳
  static String formatDate(
      {int time, DateTime dateTime, String format = 'yyyy-MM-dd HH:mm'}) {
    var data = dateTime ?? new DateTime.fromMillisecondsSinceEpoch(time * 1000);
    var formater = new DateFormat(format);
    return formater.format(data);
  }

  /// 截取字符串
  static subStr(String str, int len, {String ellipsis = '...'}) {
    if (str.length <= len) return str;
    return str.substring(0, len) + ellipsis;
  }

  static getUUid() {
    final red1 = new Random().nextInt(99);
    final red2 = new Random().nextInt(999);
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    return '${red1}_${red2}_${time}';
  }

  static String formatCountDownTimer(Duration duration) {
    if (duration.inHours >= 1) return formatByHours(duration);
    if (duration.inMinutes >= 0) return formatByMinutes(duration);

    return formatBySeconds(duration);
  }

  static String formatBySeconds(Duration duration) =>
      twoDigits(duration.inSeconds.remainder(60));

  static String formatByMinutes(Duration duration) {
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return '$twoDigitMinutes:${formatBySeconds(duration)}';
  }

  static String formatByHours(Duration duration) {
    return '${twoDigits(duration.inHours)}:${formatByMinutes(duration)}';
  }

  static String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  /// 获取用户观看广告记录接口上报的参数
  //TODO 广告看完之后上报接口, 各个字段需要再完善
  static Map<String, String> getVideoLogParams(BuildContext context) {
    UserModel user = Provider.of<UserModel>(context, listen: false);
    return {
      "acct_id": user?.value?.acct_id,
      "app_id": "temp",
      "offerid": "temp",
      "country": "temp",
      "app_version": "temp",
      "sdk_san_version": "temp",
      "session_id": Util.getUUid(),
      "platform": "temp",
      "placement_id": "temp",
      "pidType": "temp",
    };
  }
}
