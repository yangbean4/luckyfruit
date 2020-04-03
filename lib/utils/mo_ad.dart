import './event_bus.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/index.dart';

class MoAd {
  static const String VIEW_AD = 'VIEW_AD';
  static String USER_ID;

  static Future<bool> viewAd() async {
    Layer.loading('.....');
    await Future.delayed(Duration(seconds: 1));
    // 通知观看广告
    EVENT_BUS.emit(VIEW_AD);
    Layer.loadingHide();

    // 观看广告后上报观看次数接口
    Service().videoAdsLog(Util.getVideoLogParams(MoAd.USER_ID));
    return true;
  }
}
