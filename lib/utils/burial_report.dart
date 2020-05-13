import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:luckyfruit/config/app.dart' show Event_Name;

import './event_bus.dart';
import './method_channel.dart';

class BurialReport {
  /// 完成fb登陆
  static const String Adjust_Event_Token_Completed_Registration = "amn2y7";

  /// 完成新手引导,即解锁3级树木
  static const String Adjust_Event_Token_Completed_Tutorial = "ux4oig";

  /// 解锁6级树木
  static const String Adjust_Event_Token_Achieved_Level_6 = "c6ivye";

  /// 用户点击invite
  static const String Adjust_Event_Token_Invite = "2pmatk";

  /// 用户点击mine→my wallet
  static const String Adjust_Event_Token_My_Wallet = "yvpwzv";

  /// 广告入口展示成功上报，每展示成功1次，上报1次
  static const String Adjust_Event_Token_Ads_Entr_Imp = "mh11kd";

  /// 用户观看视频次数，每观看1次广告，上报1次(此处的观看1次为广告展示成功)
  static const String Adjust_Event_Token_Ads_Imp = "teckq0";

  /// 用户达到奖励节点次数，该用户达到奖励节点，上报1次
  static const String Adjust_Event_Token_Ads_Bouns = "4k8nqh";

  static String userId;
  static String sessionid;
  static String subSessionid;
  static String configVersion;
  static String appVersion;
  static String isM;

  static DateTime _lastTime;

  static init(String _userId,
      {String config_version, String app_version, String fbID, String is_m}) {
    userId = _userId;
    configVersion = config_version;
    appVersion = app_version;
    isM = is_m;

    ChannelBus().callNativeMethod("tga_login",
        arguments: {'identifyID': _userId, 'loginID': fbID ?? ''});

    String time = DateTime.now().millisecondsSinceEpoch.toString();
    sessionid = '${_userId}_$time';
    subSessionid = DateTime.now().millisecondsSinceEpoch.toString();

    EVENT_BUS.on(Event_Name.APP_PAUSED, (e) {
      _lastTime = DateTime.now();
    });

    EVENT_BUS.on(Event_Name.APP_RESUMED, (e) {
      Duration diff = DateTime.now().difference(_lastTime ?? DateTime.now());
      if (diff > Duration(seconds: 5)) {
        subSessionid = DateTime.now().millisecondsSinceEpoch.toString();
      }
    });
  }

  static report(String event_name, Map<String, String> map) {
    map['event_name'] = event_name;
    map['config_version'] = configVersion;
    map['app_version'] = appVersion;
    map['time'] = DateTime.now().toUtc().toString();
    map['is_m'] = isM;

    Map<String, String> data = _getData(map);
    ChannelBus().callNativeMethod("tga_track", arguments: jsonEncode(data));
    print(data);
  }

  static Map<String, String> _getData(Map<String, String> data) {
    Map<String, String> res = {
      'userid': data['userid'] ?? userId,
      'sessionid': sessionid,
      "sub_sessionid": subSessionid
    };
    res.addAll(data);
    return res;
  }

  static reportAdjust(String token) {
    print("reportAdjust_$token");
    AdjustEvent adjustEvent = new AdjustEvent(token);
    Adjust.trackEvent(adjustEvent);
  }
}
