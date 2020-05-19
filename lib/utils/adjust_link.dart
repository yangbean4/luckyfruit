import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';

class AdjustSdk {
  static String lableString;

  static initAdjustSdk(UserModel userModel) {
    AdjustConfig config =
        new AdjustConfig('p3j6r5u7mvi8', AdjustEnvironment.production);
//    config.logLevel = AdjustLogLevel.verbose;

    config.attributionCallback = (AdjustAttribution data) {
      print('[Adjust]: Attribution changed!');

      if (data.trackerToken != null) {
        print('[Adjust]: Tracker token: ' + data.trackerToken);
      }
      if (data.trackerName != null) {
        print('[Adjust]: Tracker name: ' + data.trackerName);
      }
      if (data.campaign != null) {
        print('[Adjust]: Campaign: ' + data.campaign);
      }
      if (data.network != null) {
        print('[Adjust]: Network: ' + data.network);
      }
      if (data.creative != null) {
        print('[Adjust]: Creative: ' + data.creative);
      }
      if (data.adgroup != null) {
        print('[Adjust]: Adgroup: ' + data.adgroup);
      }
      if (data.clickLabel != null) {
        print('[Adjust]: Click label: ' + data.clickLabel);
        lableString = data.clickLabel;
      }
      if (data.adid != null) {
        print('[Adjust]: Adid: ' + data.adid);
      }

      Service().inviteCode({
        'invite_code': lableString ?? "0",
        'tracker_name': data.trackerName ?? "0",
        'tracker_token': data.trackerToken ?? "0",
        'adjust_network': data.network ?? "0",
        'adjust_adid': data.adid ?? "0",
      }).then((dataMap) {
        if (dataMap == null || dataMap['is_m'] == null || userModel == null) {
          return;
        }
        print("update_is_m_from_adjust_${dataMap['is_m']}");
        userModel?.value?.is_m = dataMap['is_m'];
      });
    };

    Adjust.start(config);
  }
}
