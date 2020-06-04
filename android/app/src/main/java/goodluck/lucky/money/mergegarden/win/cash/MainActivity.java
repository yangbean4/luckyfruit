/*
 * @Description:
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-04-01 16:22:50
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-04-24 15:28:11
 */
package goodluck.lucky.money.mergegarden.win.cash;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import com.applovin.sdk.AppLovinSdk;
import com.mopub.common.MoPub;
import com.mopub.common.MoPubReward;
import com.mopub.common.SdkConfiguration;
import com.mopub.common.SdkInitializationListener;
import com.mopub.mobileads.MoPubErrorCode;
import com.mopub.mobileads.MoPubRewardedVideoListener;
import com.mopub.mobileads.MoPubRewardedVideoManager;
import com.mopub.mobileads.MoPubRewardedVideos;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationManagerCompat;
import cn.thinkingdata.android.TDConfig;
import cn.thinkingdata.android.ThinkingAnalyticsSDK;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static com.mopub.common.logging.MoPubLog.LogLevel.DEBUG;
import static com.mopub.common.logging.MoPubLog.LogLevel.INFO;

public class MainActivity extends FlutterActivity implements MoPubRewardedVideoListener {

    BasicMessageChannel basicMessageChannel;
    boolean isRewardVideoAdInitialized;
    private String mAdUnitId1 = "071798bdd3194939ad25fd6f068448b5";
    private String mAdUnitId2 = "5589f1cc81f543f19c895dc453aaa816";
    private String mTGAKey = "f2328f8dee2b4ed1970be74235b9a5cc";
    private MethodChannel methodChannel;
    private MethodChannel eventChannel;
    //    private CallbackManager callbackManager;
    ThinkingAnalyticsSDK tdInstance;
    private AppInstallReceiver appInstallReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SenUtils.installPrevention(this);
        GeneratedPluginRegistrant.registerWith(this);
        initTgaSDK();
//        final AppLovinSdk sdk = AppLovinSdk.getInstance(this);
//        ArrayList<String> list = new ArrayList<>();
//        list.add("91734d90-38e6-4998-8900-2c693ffd11fd");
//        sdk.getSettings().setTestDeviceAdvertisingIds(list);
//        AppLovinSdk.getInstance(this).getSettings().setVerboseLogging(true);
        AppLovinSdk.initializeSdk(this);
        appInstallReceiver = new AppInstallReceiver();
        new MethodChannel(getFlutterView(), Config.METHOD_CHANNEL)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        Log.i("onMethodCall", " method name: " + methodCall.method);
                        Log.i("onMethodCall", " method arguments: " + methodCall.arguments());

                        switch (methodCall.method) {
                            case "message_notification": {// 检查app是否开启了通知权限
                                NotificationManagerCompat notification = NotificationManagerCompat
                                        .from(MainActivity.this);
                                boolean isEnabled = notification.areNotificationsEnabled();
                                result.success(isEnabled);
                                break;
                            }
                            case "set_message_notification": {// 跳转到设置
                                final String SETTINGS_ACTION = "android.settings.ACTION_APP_NOTIFICATION_SETTINGS";

                                Intent intent = new Intent().setAction(SETTINGS_ACTION).setData(
                                        Uri.fromParts("package", getApplicationContext().getPackageName(), null));
                                startActivity(intent);
                                break;
                            }
                            case "tga_login": {
                                String identifyID = (String) methodCall.argument("identifyID");
                                String loginID = (String) methodCall.argument("loginID");
                                tdInstance.identify(identifyID);
                                tdInstance.login(loginID);
                                enableTgaAutoTrack(MainActivity.this);
                                break;

                            }
                            case "tga_track": { // TGA 数据上报
                                String event = (String) methodCall.arguments;
                                Log.i("event-tga-error", " method event: " + event);

                                try {
                                    JSONObject json = new JSONObject(event);
                                    String eventName = json.getString("event_name");
                                    tdInstance.track(eventName, (JSONObject) json);

                                } catch (JSONException e) {
                                    Log.i("event-tga-error", " method event: " + event);
                                    e.printStackTrace();
                                }
                                break;
                            }
//                            case "sendMessage": {
//                                String urlActionTitle = methodCall.argument("urlActionTitle");
//                                String url = methodCall.argument("url");
//                                String title = methodCall.argument("title");
//                                String subtitle = methodCall.argument("subtitle");
//                                String imageUrl = methodCall.argument("imageUrl");
//                                String pageId = methodCall.argument("pageId");
//
//                                sendMessage(result, urlActionTitle, url, title, subtitle, imageUrl, pageId);
//                                break;
//                            }
                            case Config.GET_DEVICE_MESSAGE_FROM_NATIVE:
                                boolean isDebug = SenUtils.checkWhetherEnableDeveloperModel(MainActivity.this);
                                boolean isUsb = SenUtils.checkDevicePluggedIn(MainActivity.this);
                                int batteryLevel = SenUtils.getDeviceBatteryLevel(MainActivity.this);
                                boolean isRoot = SenUtils.isRoot();
                                String language = SenUtils.getLanguage();

                                String geo = SenUtils.getCountry();
                                Log.i("tago", String.format("onCreate_params: " +
                                                "isDebug:%s, isUsb:%s, battery:%s, isRoot:%s, geo:%s, language:%s",
                                        isDebug, isUsb, batteryLevel, isRoot, geo, language));

                                Map<String, String> map = new HashMap<>();
                                map.put("is_debug", isDebug ? "1" : "0");
                                map.put("is_usb", isUsb ? "1" : "0");
                                map.put("battery", String.valueOf(batteryLevel));
                                map.put("is_jailbreak", isRoot ? "1" : "0");
                                map.put("geo", geo);
                                map.put("language", language);
                                result.success(map);
                                break;
                            case Config.MOPUB_INITIALIZE_REWARD_VIDEO: {// mopub初始化
                                initRewardAds();
                                result.success(false);
                                break;
                            }
                            case Config.MOPUB_LOAD_REWARD_VIDEO: {
                                if (methodCall == null) {
                                    return;
                                }
                                int adUnitIdFlag = methodCall.argument("adUnitIdFlag");
                                loadRewardAds(adUnitIdFlag == 2 ? mAdUnitId2 :
                                        mAdUnitId1);
                                result.success(true);
                                break;
                            }
                            case Config.MOPUB_SHOW_REWARD_VIDEO: {
                                if (methodCall == null) {
                                    return;
                                }
                                int adUnitIdFlag = methodCall.argument("adUnitIdFlag");
                                String adUnitId = adUnitIdFlag == 2 ? mAdUnitId2 : mAdUnitId1;
                                boolean isReady = isRewardVideoAdReady(adUnitId);
                                Log.i("tago", "onMethodCall_MOPUB_SHOW_REWARD_VIDEO_" + adUnitId + "_" + isReady);
                                result.success(isReady);
                                if (isReady) {
                                    showRewardAds(adUnitId);
                                }
                                break;
                            }
//                            case Config.MOPUB_IS_REWARD_VIDEO_READY: {
//                                if (methodCall == null) {
//                                    return;
//                                }
//                                int adUnitIdFlag = methodCall.argument("adUnitIdFlag");
//                                String adUnitId = adUnitIdFlag == 2 ? mAdUnitId2 : mAdUnitId1;
//                                result.success(isRewardVideoAdReady(adUnitId));
//                                break;
//                            }
                            case Config.START_REPORT_APP_LIST: {
                                if (methodCall == null) {
                                    return;
                                }
                                // 上报安装列表
                                Config.ACCT_ID = methodCall.argument("acct_id");
                                Config.enableAppMonitor = methodCall.argument("enableAppMonitor");

                                Log.i("tago", "onMethodCall_START_REPORT_APP_LIST: acctId="
                                        + Config.ACCT_ID + ", enable: " + Config.enableAppMonitor);

                                if (Config.enableAppMonitor == 0) {
                                    return;
                                }
                                AppListUploader.upLoadAppList(MainActivity.this, AppListUploader.STATUS_INSTALL, true);
                                break;
                            }
                        }
                    }
                });

        basicMessageChannel = new BasicMessageChannel<Object>(getFlutterView(), Config.EVENT_CHANNEL,
                StandardMessageCodec.INSTANCE);

        // 初始化 mopub SDK
        initRewardAds();
        // 监听安装卸载
        registerReceiver(this);

//        callbackManager = CallbackManager.Factory.create();
    }

    private void registerReceiver(Context context) {

        if (context == null) {
            return;
        }
        IntentFilter filter = new IntentFilter();
        filter.addAction("android.intent.action.PACKAGE_ADDED");
        filter.addAction("android.intent.action.PACKAGE_REMOVED");
        filter.addDataScheme("package");
        context.registerReceiver(appInstallReceiver, filter);
    }

//    private void sendMessage(final MethodChannel.Result result, String urlActionTitle, String url, String title, String subtitle, String imageUrl, String pageId) {
//
////        url= "https://mkfruit.com?sd=Merge%20trees%F0%9F%8E%84%2Cdecorating%20my%20garden%2Cearn%20rewards%F0%9F%8E%81%F0%9F%92%B5&si=https%3A%2F%2Fmergegarden-cdn.mkfruit.com%2Fcdn%2Fimg%2Ffb_share_merge.png&st=%F0%9F%92%B0%F0%9F%92%B0Believe%20it%20or%20not!%20I%20can%20earn%20money%20by%20merge%20garden%F0%9F%8F%A1%F0%9F%8F%A1!&amv=0&apn=goodluck.lucky.money.mergegarden.win.cash&link=https%3A%2F%2Fmergegarden-cdn.mkfruit.com%2Fcdn%2Fzip%2Findex.html%3Fcode%3D771";
////        url="https://mkfruit.com/Sohr";
//        ShareMessengerURLActionButton actionButton =
//                new ShareMessengerURLActionButton.Builder()
//                        .setTitle(urlActionTitle)
//                        .setUrl(Uri.parse(url))
//                        .build();
//
//        ShareMessengerGenericTemplateElement.Builder genericTemplateElementBuilder =
//                new ShareMessengerGenericTemplateElement.Builder();
//        genericTemplateElementBuilder.setTitle(title);
//        genericTemplateElementBuilder.setSubtitle(subtitle);
//
//        if (imageUrl != null && !imageUrl.isEmpty())
//            genericTemplateElementBuilder.setImageUrl(Uri.parse(imageUrl));
//        if (url != null && !url.isEmpty()) genericTemplateElementBuilder.setButton(actionButton);
//
//        ShareMessengerGenericTemplateContent genericTemplateContent =
//                new ShareMessengerGenericTemplateContent.Builder()
//                        .setPageId(Config.FACEBOOK_PAGE_ID) // Your page ID, required
//                        .setGenericTemplateElement(genericTemplateElementBuilder.build())
//                        .build();
//        MessageDialog md = new MessageDialog(this);
//        md.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
//
//            @Override
//            public void onSuccess(Sharer.Result shareResult) {
//                result.success(true);
//                Log.d("tago", "FacebookCallback_onSuccess");
//            }
//
//            @Override
//            public void onCancel() {
//                result.success(false);
//                Log.d("tago", "FacebookCallback_onCancel");
//            }
//
//            @Override
//            public void onError(FacebookException error) {
//                result.success(false);
//                Log.d("tago", "FacebookCallback_error => " + error);
//            }
//        });
//        if (md.canShow(genericTemplateContent)) {
//            MessageDialog.show(this, genericTemplateContent);
//        }
//    }

//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        callbackManager.onActivityResult(requestCode, resultCode, data);
//    }

    private void initTgaSDK() {
        ThinkingAnalyticsSDK.enableTrackLog(true);
        TDConfig config = TDConfig.getInstance(this, mTGAKey,
                "http://tad.sen-sdk.com");
        config.setDefaultTimeZone(TimeZone.getTimeZone("UTC"));
        tdInstance = ThinkingAnalyticsSDK.sharedInstance(config);
    }

    private void enableTgaAutoTrack(Context context) {
        List<ThinkingAnalyticsSDK.AutoTrackEventType> eventTypeList = new ArrayList<>();
        eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_INSTALL);
        eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_START);
        eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_END);
        eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_VIEW_SCREEN);
        eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_CLICK);
        eventTypeList.add(ThinkingAnalyticsSDK.AutoTrackEventType.APP_CRASH);
        ThinkingAnalyticsSDK.sharedInstance(context, mTGAKey).enableAutoTrack(eventTypeList);
    }

    public void initRewardAds() {
        Log.i("tago", "initRewardAds");
        if (isRewardVideoAdInitialized) {
            return;
        }
        SdkConfiguration.Builder configBuilder = new SdkConfiguration.Builder(mAdUnitId1);
        if (BuildConfig.DEBUG) {
            configBuilder.withLogLevel(DEBUG);
        } else {
            configBuilder.withLogLevel(INFO);
        }
        MoPub.initializeSdk(this, configBuilder.build(), initSdkListener());
        MoPubRewardedVideos.setRewardedVideoListener(this);

        isRewardVideoAdInitialized = true;
    }

    public void loadRewardAds(String adUnitId) {
        Log.i("tago", "loadRewardAds_" + adUnitId);
//        GooglePlayServicesRewardedVideo.GooglePlayServicesMediationSettings settings = new GooglePlayServicesRewardedVideo.GooglePlayServicesMediationSettings();
//        settings.setTestDeviceId("65942227-abd3-4fe5-8cd5-dbf7f2fc4cac");
//        settings.setTestDeviceId("91734d90-38e6-4998-8900-2c693ffd11fd");
        MoPubRewardedVideos.loadRewardedVideo(adUnitId,
                new MoPubRewardedVideoManager.RequestParameters("",
                        "", null, "sample_app_customer_id"));
    }

    public boolean isRewardVideoAdReady(String adUnitId) {
        boolean isReady = MoPubRewardedVideos.hasRewardedVideo(adUnitId);
        Log.i("tago", "isRewardVideoAdReady: " + isReady + "_" + adUnitId);
        return isReady;
    }

    public void showRewardAds(String adUnitId) {
        Log.i("tago", "showRewardAds_" + adUnitId);
        boolean isReady = isRewardVideoAdReady(adUnitId);
        Log.i("tago", "isRewardVideoAdReady: " + isReady);
        if (isReady) {
            MoPubRewardedVideos.showRewardedVideo(adUnitId, "");
        }
    }

    private SdkInitializationListener initSdkListener() {
        return new SdkInitializationListener() {
            @Override
            public void onInitializationFinished() {
                Log.i("tago", "onInitializationFinished");
                loadRewardAds(mAdUnitId1);
                loadRewardAds(mAdUnitId2);
                // ironsource的检查集成环境的方法
//                IntegrationHelper.validateIntegration(MainActivity.this);
            }
        };
    }

    @Override
    public void onRewardedVideoLoadSuccess(@NonNull String adUnitId) {
        Log.i("tago", "onRewardedVideoLoadSuccess_" + adUnitId);

        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_LOAD_REWARD_VIDEO_SUCCESS);
        json.put("data", TextUtils.equals(adUnitId, mAdUnitId1) ? 1 : 2);

        basicMessageChannel.send(json, new BasicMessageChannel.Reply() {
            @Override
            public void reply(Object reply) {
                Log.i("tago", "reply: " + reply);
            }
        });
    }

    @Override
    public void onRewardedVideoLoadFailure(@NonNull String adUnitId, @NonNull MoPubErrorCode errorCode) {
        Log.i("tago", "onRewardedVideoLoadFailure_" + adUnitId + "_error:" + errorCode);
        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_LOAD_REWARD_VIDEO_FAILURE);
        json.put("data", TextUtils.equals(adUnitId, mAdUnitId1) ? 1 : 2);

        basicMessageChannel.send(json, new BasicMessageChannel.Reply() {
            @Override
            public void reply(Object reply) {
                Log.i("tago", "reply: " + reply);
            }
        });
    }

    @Override
    public void onRewardedVideoStarted(@NonNull String adUnitId) {
        Log.i("tago", "onRewardedVideoStarted_" + adUnitId);

        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_REWARD_VIDEO_STARTED);
        json.put("data", TextUtils.equals(adUnitId, mAdUnitId1) ? 1 : 2);

        basicMessageChannel.send(json, new BasicMessageChannel.Reply() {
            @Override
            public void reply(Object reply) {
                Log.i("tago", "reply: " + reply);
            }
        });
    }

    @Override
    public void onRewardedVideoPlaybackError(@NonNull String adUnitId, @NonNull MoPubErrorCode errorCode) {
        Log.i("tago", "onRewardedVideoPlaybackError " + errorCode);
    }

    @Override
    public void onRewardedVideoClicked(@NonNull String adUnitId) {
        Log.i("tago", "onRewardedVideoClicked_" + adUnitId);
    }

    @Override
    public void onRewardedVideoClosed(@NonNull String adUnitId) {
        Log.i("tago", "onRewardedVideoClosed_" + adUnitId);

        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_REWARD_VIDEO_CLOSED);
        json.put("data", TextUtils.equals(adUnitId, mAdUnitId1) ? 1 : 2);

        basicMessageChannel.send(json, new BasicMessageChannel.Reply() {
            @Override
            public void reply(Object reply) {
                Log.i("tago", "reply: " + reply);
            }
        });
    }

    @Override
    public void onRewardedVideoCompleted(@NonNull Set<String> adUnitIds, @NonNull MoPubReward reward) {
        Log.i("tago", "onRewardedVideoCompleted_" + adUnitIds.toString()
                + ", contains(1)_" + adUnitIds.contains(mAdUnitId1));
        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_REWARD_VIDEO_COMPLETE);
        json.put("data", adUnitIds.contains(mAdUnitId1) ? 1 : 2);

        basicMessageChannel.send(json, new BasicMessageChannel.Reply() {
            @Override
            public void reply(Object reply) {
                Log.i("tago", "reply: " + reply);
            }
        });
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        MoPubRewardedVideos.setRewardedVideoListener(null);
        MoPub.onDestroy(this);
    }

    @Override
    public void onPause() {
        super.onPause();
        MoPub.onPause(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        MoPub.onStop(this);
        if (appInstallReceiver != null) {
            unregisterReceiver(appInstallReceiver);
        }
    }

    @Override
    public void onResume() {
        super.onResume();
        MoPub.onResume(this);
    }
}
