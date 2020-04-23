import 'package:flutter/cupertino.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:provider/provider.dart';

import './event_bus.dart';
import 'method_channel.dart';

class MoAd {
  static const String VIEW_AD = 'VIEW_AD';
  static MoAd _instance;
  UserModel _userModel;
  String ad_code;
  Function successCallback;
  Function(String error) failCallback;
  bool reachRewardPoint = false;

  MoAd(BuildContext context) {
    _userModel = Provider.of<UserModel>(context, listen: false);
    // 注册广告加载完成通知
    channelBus.registerReceiver(Event_Name.mopub_load_reward_video_success,
        (arg) => onRewardedVideoLoadSuccess(arg));
    // 注册广告加载失败通知
    channelBus.registerReceiver(Event_Name.mopub_load_reward_video_failure,
        (arg) => onRewardedVideoLoadFailure(arg));
    // 注册广告播放完成通知
    channelBus.registerReceiver(Event_Name.mopub_reward_video_complete,
        (arg) => onRewardedVideoCompleted(arg));
    // 注册广告播放关闭通知
    channelBus.registerReceiver(Event_Name.mopub_reward_video_closed,
        (arg) => onRewardedVideoClosed(arg));

    // 首次加载广告
    loadRewardAds();
  }

  static MoAd getInstance(BuildContext context) {
    if (_instance == null) {
      _instance = MoAd(context);
    }
    return _instance;
  }

  void onRewardedVideoLoadSuccess(arg) {
    print("onRewardAdsLoadSuccess: $arg");
  }

  void onRewardedVideoLoadFailure(arg) {
    print("onRewardedVideoLoadFailure: $arg");
    loadRewardAds();
  }

  void onRewardedVideoStarted(arg) {
    BurialReport.report('ad_rewarded', {'type': '2', 'ad_code': ad_code});
  }

// 完成
  void onRewardedVideoCompleted(arg) {
    print("onRewardedVideoCompleted: $arg");
    reachRewardPoint = true;

    BurialReport.report('ad_rewarded', {'type': '3', 'ad_code': ad_code});

    // 观看广告次数减一
    if (_userModel?.userInfo?.ad_times != null) {
      if (_userModel.userInfo.ad_times > 0) {
        _userModel.userInfo.ad_times--;
      } else {
        _userModel.userInfo.ad_times = 0;
      }
    }

    // 通知观看广告
    EVENT_BUS.emit(VIEW_AD);
    Service().videoAdsLog(Util.getVideoLogParams(_userModel?.value?.acct_id));
  }

  void onRewardedVideoClosed(arg) {
    print(
        "onRewardedVideoClosed: arg:$arg, reachRewardPoint:$reachRewardPoint");
    if (reachRewardPoint && successCallback != null) {
      successCallback();
    }

    // TODO 测试下观看失败的情况（取消观看）
    if (!reachRewardPoint && failCallback != null) {
      failCallback(arg);
    }

    loadRewardAds();
  }

  //TODO 加上重试限制
  ///开始加载激励视频广告
  void loadRewardAds() async {
    print("loadRewardAds");
    channelBus.callNativeMethod(Event_Name.mopub_load_reward_video);
  }

  isMopubRewardVideoReady() async {
    return channelBus.callNativeMethod(Event_Name.mopub_is_reward_video_ready);
  }

  ///开始展示激励视频广告
  void showRewardVideo(
    Function successCallback,
    Function(String) failCallback, {
    String ad_code,
  }) async {
    print("showRewardVideo");

    if (_userModel?.userInfo?.ad_times == 0) {
      Layer.toastWarning("Number of videos has used up");
      return;
    }

    reachRewardPoint = false;
    this.successCallback = successCallback;
    this.failCallback = failCallback;
    this.ad_code = ad_code;
    bool isReady =
        await channelBus.callNativeMethod(Event_Name.mopub_show_reward_video);
    if (!isReady) {
      Layer.toastWarning("Ad not ready yet");
    }
  }
}
