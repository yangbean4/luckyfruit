import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/position.dart';

class Util {
  /// 金币相关的保留一位小数，money相关的保留两位小数
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
    RegExp reg = new RegExp(r"(\d)((?:\d{3})+\b)");
    String result = index <= 0
        ? number.toStringAsFixed(fixed ?? 2)
        : (number / pow(10.0, 3 * index))
                .toStringAsFixed(fixed ?? 2)
                .replaceAllMapped(
                    reg, (match) => "${match.group(1)},${match.group(2)}") +
            dan[index];

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

  static String RandomString(int strlen) {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    Random rnd = Random(DateTime.now().millisecondsSinceEpoch);
    String result = "";
    for (var i = 0; i < strlen; i++) {
      result += chars[rnd.nextInt(chars.length)];
    }
    return result;
  }

  static Offset getWheelInfoWithGlobalKey() {
    Offset offset = Offset(0, 0);
    RenderBox renderBox =
        Consts.globalKeyWheel.currentContext.findRenderObject();
    offset = renderBox.localToGlobal(Offset.zero);
    print("luckWheel:localToGlobal ${offset}");
    return offset;
  }

  static Offset getAddTreeBtnInfoWithGlobalKey() {
    Offset offset = Offset(0, 0);
    RenderBox renderBox =
        Consts.globalKeyAddTreeBtn.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    print("addTreeBtn:localToGlobal ${offset}");
    return offset;
  }

  static Offset getTreeGridInfoWithGlobalKey() {
    Offset offset = Offset(0, 0);
    RenderBox renderBox =
        Consts.globalKeyTreeGrid.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    print("treeGrid:localToGlobal ${offset}");
    return offset;
  }

  static Offset getTripIconInfoWithGlobalKey() {
    Offset offset = Offset(0, 0);
    RenderBox renderBox =
        Consts.globalKeyTripIcon.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    print("tripicon:localToGlobal ${offset}");
    return offset;
  }

  static Offset getGoldPositionInfoWithGlobalKey() {
    Offset offset = Offset(0, 0);
    RenderBox renderBox =
        Consts.globalKeyGoldPosition.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    print("goldPosition:localToGlobal ${offset}");
    return offset;
  }

  static Offset getAutoMergeInfoWithGlobalKey() {
    Offset offset = Offset(0, 0);
    RenderBox renderBox =
        Consts.globalKeyAutoMerge.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    return offset;
  }

  static double getBottomBarInfoWithGlobalKey() {
    Size size = Consts.globalKeyBottomBar.currentContext?.size;
    print("bottombar:localToGlobal ${size.width}, ${size.height}");
    return size.height;
  }

  /// 获取用户观看广告记录接口上报的参数
  static Map<String, String> getVideoLogParams(String acct_id) {
    return {
      "acct_id": acct_id,
      "session_id": BurialReport.sessionid,
      "union_id":
          "${acct_id}_${DateTime.now().millisecondsSinceEpoch}_${RandomString(6)}",
    };
  }

  static Offset getOffset(GlobalKey globalKey) {
    RenderBox renderBox = globalKey.currentContext?.findRenderObject();
    Offset offset = renderBox?.localToGlobal(Offset.zero);
    return offset;
  }

  static Size getSize(GlobalKey globalKey) => globalKey.currentContext?.size;

  static Position getCenter(GlobalKey globalKey) {
    Offset offset = getOffset(globalKey);
    Size size = getSize(globalKey);
    return new Position(
        x: (offset.dx + size.width / 2), y: offset.dy + size.height / 2);
  }
}
