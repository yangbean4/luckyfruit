import 'dart:math';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Util {
  static String formatNumber(num number, {int fixed}) {
    List<String> dan = ['', 'K', 'M', 'B', 'T', 'aa', 'ab'];
    number = number ?? 0;
    int index = dan
        .asMap()
        .keys
        .toList()
        .lastIndexWhere((t) => number / pow(10, 3 * t + 1) > 1);

    return index <= 0
        ? number.toStringAsFixed(fixed ?? 2)
        : (number / pow(10, 3 * index)).toStringAsFixed(2) + dan[index];
  }

  static Map<String, dynamic> decodeStr(String str) {
    Map<String, dynamic> map = {};
    try {
      map = json.decode(str);
    } catch (e) {}
    return map;
  }

  /// 格式化时间戳
  static String formatDate(int time, String format) {
    var data = new DateTime.fromMillisecondsSinceEpoch(time * 1000);
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

  /// 打开url
  static launchUrl(String url) async {
    try {
      if (await canLaunch(url)) {
        return await launch(url);
      } else {
        print('无法打开 $url');
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
