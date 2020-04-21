import 'dart:convert';

import './index.dart';
import './event_bus.dart';
import 'package:luckyfruit/config/app.dart' show Event_Name;
import './method_channel.dart';

class BurialReport {
  static String userId;
  static String sessionid;
  static String subSessionid;
  static String configVersion;
  static String appVersion;

  static DateTime _lastTime;

  static init(String _userId, {String config_version, String app_version}) {
    userId = _userId;
    configVersion = config_version;
    appVersion = app_version;

    String time = Util.formatDate(dateTime: DateTime.now());
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
}
