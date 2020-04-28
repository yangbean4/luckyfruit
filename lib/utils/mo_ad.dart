import 'package:flutter/cupertino.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
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
  LuckyGroup _luckyGroup;
  Function successCallback;
  Function(String error) failCallback;
  bool reachRewardPoint = false;
  int retryCount = 0;
  int retryDelayedTimeInSeconds = 60;
  Map<String, String> videoLogParam;

  MoAd(BuildContext context) {
    _userModel = Provider.of<UserModel>(context, listen: false);
    _luckyGroup = Provider.of<LuckyGroup>(context, listen: false);

    // 注册广告加载完成通知
    channelBus.registerReceiver(Event_Name.mopub_load_reward_video_success,
        (arg) => onRewardedVideoLoadSuccess(arg));
    // 注册广告加载失败通知
    channelBus.registerReceiver(Event_Name.mopub_load_reward_video_failure,
        (arg) => onRewardedVideoLoadFailure(arg));
    // 注册广告播放开始通知
    channelBus.registerReceiver(Event_Name.mopub_reward_video_started,
        (arg) => onRewardedVideoStarted(arg));
    // 注册广告播放完成通知
    channelBus.registerReceiver(Event_Name.mopub_reward_video_complete,
        (arg) => onRewardedVideoCompleted(arg));
    // 注册广告播放关闭通知
    channelBus.registerReceiver(Event_Name.mopub_reward_video_closed,
        (arg) => onRewardedVideoClosed(arg));
  }

  static MoAd getInstance(BuildContext context) {
    if (_instance == null) {
      _instance = MoAd(context);
    }
    return _instance;
  }

  void onRewardedVideoLoadSuccess(arg) {
    print("onRewardAdsLoadSuccess: $arg");
    retryCount = 0;
  }

  void onRewardedVideoLoadFailure(arg) {
    retryCount++;
    print("onRewardedVideoLoadFailure: $arg, retryCount:$retryCount");
    if (retryCount <= 3) {
      loadRewardAds();
    } else {
      retryCount = 0;

      print("retryDelayedTimeInSeconds: ${_luckyGroup?.issed?.ad_reset_time}");
      // x时长后重新请求
      Future.delayed(
          Duration(
              seconds: _luckyGroup?.issed?.ad_reset_time ??
                  retryDelayedTimeInSeconds), () {
        loadRewardAds();
      });
    }
  }

  ///开始播放广告
  void onRewardedVideoStarted(arg) {
    print("onRewardedVideoStarted_");
    BurialReport.report('ad_rewarded', {
      'type': '2',
      'ad_code': ad_code,
      "union_id": videoLogParam['videoLogParam']
    });
    // 关闭声效
    EVENT_BUS.emit(Event_Name.APP_PAUSED);
  }

  // 完成
  void onRewardedVideoCompleted(arg) {
    print("onRewardedVideoCompleted: $arg");
    reachRewardPoint = true;

    BurialReport.report('ad_rewarded', {
      'type': '3',
      'ad_code': ad_code,
      "union_id": videoLogParam['videoLogParam']
    });

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
    Service().videoAdsLog(videoLogParam);
  }

  void onRewardedVideoClosed(arg) {
    print(
        "onRewardedVideoClosed: arg:$arg, reachRewardPoint:$reachRewardPoint");
    // 恢复声效播放
    EVENT_BUS.emit(Event_Name.APP_RESUMED);
    if (reachRewardPoint && successCallback != null) {
      successCallback();
    }

    if (!reachRewardPoint && failCallback != null) {
      failCallback(arg);
    }

    loadRewardAds();
  }

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
    Map<String, String> adLogParam,
  }) async {
    print("showRewardVideo");
    videoLogParam =
        adLogParam ?? Util.getVideoLogParams(_userModel?.value?.acct_id);
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

  /// 测试用
  Future<bool> viewAd(BuildContext context) async {
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
        .videoAdsLog(Util.getVideoLogParams(user?.value?.acct_id))
        .then((res) {
      result = res['code'] == 0;
      print("videoAdsLog result: $result");
    });
    print("viewAd return $result");
    return result;
  }
}
