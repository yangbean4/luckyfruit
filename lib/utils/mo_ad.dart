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
  // static const String VIEW_AD = 'VIEW_AD';
  static MoAd _instance;
  UserModel _userModel;
  String ad_code;
  LuckyGroup _luckyGroup;
  Function successCallback;
  Function(String error) failCallback;
  bool reachRewardPoint = false;
  int retryCount = 0;
  int retryDelayedTimeInSeconds = 60;
  int loadingTimeInSeconds = 10;
  Map<String, String> videoLogParam = {};

  // 是否自动弹出广告
  bool autoPopupAds = false;

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

    loadingTimeInSeconds = _luckyGroup?.issed?.ad_reset_time ?? 3;
  }

  static MoAd getInstance(BuildContext context) {
    if (_instance == null) {
      _instance = MoAd(context);
    }
    return _instance;
  }

  void onRewardedVideoLoadSuccess(arg) {
    print("onRewardAdsLoadSuccess: $arg, $autoPopupAds");
    retryCount = 0;
//    Layer.loadingHide();
    if (autoPopupAds) {
      channelBus.callNativeMethod(Event_Name.mopub_show_reward_video,
          arguments: <String, dynamic>{'adUnitIdFlag': arg});
    }
  }

  void onRewardedVideoLoadFailure(arg) {
    retryCount++;
    Layer.loadingHide();
    print("onRewardedVideoLoadFailure: $arg, retryCount:$retryCount");
    if (retryCount <= 3) {
      loadRewardAds(arg);
    } else {
      retryCount = 0;

      print("retryDelayedTimeInSeconds: ${_luckyGroup?.issed?.ad_reset_time}");
      // x时长后重新请求
      num delay =
          _luckyGroup?.issed?.ad_reset_time ?? retryDelayedTimeInSeconds;
      Future.delayed(Duration(seconds: delay), () {
        print("retry load ad after $delay delay...");
        loadRewardAds(arg);
      });
    }
  }

  ///开始播放广告
  void onRewardedVideoStarted(arg) {
    print("onRewardedVideoStarted_");
    BurialReport.report('ad_rewarded', {
      'type': '2',
      'ad_code': ad_code,
      "union_id": videoLogParam['union_id']
    });

    BurialReport.reportAdjust(
        BurialReport.Adjust_Event_Token_Ads_Imp);

    // 关闭声效
    EVENT_BUS.emit(Event_Name.VIEW_AD);
  }

  // 完成
  void onRewardedVideoCompleted(arg) {
    print("onRewardedVideoCompleted: $arg");
    reachRewardPoint = true;

    BurialReport.report('ad_rewarded', {
      'type': '3',
      'ad_code': ad_code,
      "union_id": videoLogParam['union_id']
    });

    BurialReport.reportAdjust(
        BurialReport.Adjust_Event_Token_Ads_Bouns);

    // 观看广告次数减一
    if (_userModel?.userInfo?.ad_times != null) {
      if (_userModel.userInfo.ad_times > 0) {
        _userModel.userInfo.ad_times--;
      } else {
        _userModel.userInfo.ad_times = 0;
      }
    }

    Service().videoAdsLog(videoLogParam);
  }

  void onRewardedVideoClosed(arg) {
    print(
        "onRewardedVideoClosed: arg:$arg, reachRewardPoint:$reachRewardPoint");
    if (reachRewardPoint && successCallback != null) {
      successCallback();
    }

    if (!reachRewardPoint && failCallback != null) {
      failCallback(arg);
    }

    EVENT_BUS.emit(Event_Name.VIEW_AD_END);
    loadRewardAds(arg);
  }

  ///开始加载激励视频广告
  void loadRewardAds(int adUnitIdFlag) async {
    print("loadRewardAds_$adUnitIdFlag");
    channelBus.callNativeMethod(Event_Name.mopub_load_reward_video,
        arguments: <String, dynamic>{'adUnitIdFlag': adUnitIdFlag});
  }

//  isMopubRewardVideoReady() async {
//    return channelBus.callNativeMethod(Event_Name.mopub_is_reward_video_ready);
//  }

  ///开始展示激励视频广告
  void showRewardVideo(
    int adUnitIdFlag,
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
    bool isReady = await channelBus.callNativeMethod(
        Event_Name.mopub_show_reward_video,
        arguments: <String, dynamic>{'adUnitIdFlag': adUnitIdFlag});
    if (!isReady) {
//      Layer.toastWarning("Ad not ready yet");
      // 如果观看时发现广告还没有准备好，就弹出loading，并去请求广告
      loadRewardAds(adUnitIdFlag);
      Layer.loading('Wait A Second');
      autoPopupAds = true;
      await Future.delayed(Duration(seconds: loadingTimeInSeconds));
      autoPopupAds = false;
      print("close loading after delay");
      Layer.loadingHide();
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
    EVENT_BUS.emit(Event_Name.VIEW_AD);
    Layer.loadingHide();

    // 观看广告后上报观看次数接口
    await Service().videoAdsLog(
        // Util.getVideoLogParams(user?.value?.acct_id),
        videoLogParam).then((res) {
      result = res['code'] == 0;
      print("videoAdsLog result: $result");
    });
    print("viewAd return $result");
    return result;
  }
}
