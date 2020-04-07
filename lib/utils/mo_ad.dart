import 'package:flutter/cupertino.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:provider/provider.dart';

import './event_bus.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/index.dart';

class MoAd {
  static const String VIEW_AD = 'VIEW_AD';
  static String USER_ID;

  static Future<bool> viewAd(BuildContext context) async {
    UserModel user = Provider.of<UserModel>(context, listen: false);
    if (user.userInfo.ad_times == 0) {
      Layer.toastWarning("Number of videos has used up");
      return false;
    }

    if (user.userInfo.ad_times != null) {
      if (user.userInfo.ad_times > 0) {
        user.userInfo.ad_times--;
      } else {
        user.userInfo.ad_times = 0;
      }
    }

    bool result = false;
    Layer.loading('.....');
    await Future.delayed(Duration(seconds: 1));
    // 通知观看广告
    EVENT_BUS.emit(VIEW_AD);
    Layer.loadingHide();

    // 观看广告后上报观看次数接口
    await Service()
        .videoAdsLog(Util.getVideoLogParams(MoAd.USER_ID))
        .then((res) {
      result = res['code'] == 0;
      print("videoAdsLog result: $result");
    });
    print("viewAd return $result");
    return result;
  }
}
