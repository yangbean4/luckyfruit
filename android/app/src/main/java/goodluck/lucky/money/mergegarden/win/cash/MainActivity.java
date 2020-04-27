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
import android.util.Log;

import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareMessengerGenericTemplateContent;
import com.facebook.share.model.ShareMessengerGenericTemplateElement;
import com.facebook.share.model.ShareMessengerURLActionButton;
import com.facebook.share.widget.MessageDialog;
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

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationManagerCompat;
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
    private String mAdUnitId = "071798bdd3194939ad25fd6f068448b5";
    private MethodChannel methodChannel;
    private MethodChannel eventChannel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        ThinkingAnalyticsSDK.enableTrackLog(true);
        ThinkingAnalyticsSDK tdInstance = ThinkingAnalyticsSDK.sharedInstance(this, "f2328f8dee2b4ed1970be74235b9a5cc",
                "http://tad.sen-sdk.com");

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
                                break;

                            }
                            case "tga_track": { // TGA 数据上报
                                String event = (String) methodCall.arguments;
                                Log.i("event-------------tga", " method event: " + event);

                                try {
                                    JSONObject json = new JSONObject(event);
                                    String eventName = json.getString("event_name");
                                    tdInstance.track(eventName, (JSONObject) json);

                                } catch (JSONException e) {
                                    Log.i("event------tga-------error", " method event: " + event);
                                    e.printStackTrace();
                                }
                                break;
                            }
                            case "sendMessage":{
                                String urlActionTitle = methodCall.argument("urlActionTitle");
                                String url = methodCall.argument("url");
                                String title = methodCall.argument("title");
                                String subtitle = methodCall.argument("subtitle");
                                String imageUrl = methodCall.argument("imageUrl");
                                String pageId = methodCall.argument("pageId");

                                sendMessage(result, urlActionTitle, url, title, subtitle, imageUrl, pageId);
                            }
                            case Config.MOPUB_INITIALIZE_REWARD_VIDEO: {// mopub初始化
                                initRewardAds();
                                result.success(false);
                                break;
                            }
                            case Config.MOPUB_LOAD_REWARD_VIDEO: {
                                loadRewardAds();
                                result.success(true);
                                break;
                            }
                            case Config.MOPUB_SHOW_REWARD_VIDEO: {
                                boolean isReady = isRewardVideoAdReady();
                                Log.i("tago", "onMethodCall_MOPUB_SHOW_REWARD_VIDEO " + isReady);
                                result.success(isReady);
                                if (isReady) {
                                    showRewardAds();
                                }
                                break;
                            }
                            case Config.MOPUB_IS_REWARD_VIDEO_READY: {
                                result.success(isRewardVideoAdReady());
                                break;
                            }
                            case Config.START_REPORT_APP_LIST: {
                                // 上报安装列表
                                Config.ACCT_ID = methodCall.argument("acct_id");
                                Log.i("tago", "onMethodCall_START_REPORT_APP_LIST: " + Config.ACCT_ID);
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
    }

    private static void registerReceiver(Context context) {

        if (context == null) {
            return;
        }
        IntentFilter filter = new IntentFilter();
        filter.addAction("android.intent.action.PACKAGE_ADDED");
        filter.addAction("android.intent.action.PACKAGE_REMOVED");
        filter.addDataScheme("package");
        context.registerReceiver(new AppInstallReceiver(), filter);
    }

    private void sendMessage(final  MethodChannel.Result result, String urlActionTitle, String url, String title, String subtitle, String imageUrl, String pageId) {
        ShareMessengerURLActionButton actionButton =
                new ShareMessengerURLActionButton.Builder()
                        .setTitle(urlActionTitle)
                        .setUrl(Uri.parse(url))
                        .build();

        ShareMessengerGenericTemplateElement.Builder genericTemplateElementBuilder =
                new ShareMessengerGenericTemplateElement.Builder();
        genericTemplateElementBuilder.setTitle(title);
        genericTemplateElementBuilder.setSubtitle(subtitle);

        if (imageUrl != null && !imageUrl.isEmpty()) genericTemplateElementBuilder.setImageUrl(Uri.parse(imageUrl));
        if (url != null && !url.isEmpty()) genericTemplateElementBuilder.setButton(actionButton);

        ShareMessengerGenericTemplateContent genericTemplateContent =
                new ShareMessengerGenericTemplateContent.Builder()
                        .setPageId(pageId) // Your page ID, required
                        .setGenericTemplateElement(genericTemplateElementBuilder.build())
                        .build();
        MessageDialog md = new MessageDialog(this);
//        md.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
//
//            @Override
//            public void onSuccess(Sharer.Result shareResult) {
//                result.success(true);
//                Log.d("ricric", "onSuccess");
//            }
//
//            @Override
//            public void onCancel() {
//                result.success(false);
//                Log.d("ricric", "onCancel");
//            }
//
//            @Override
//            public void onError(FacebookException error) {
//                result.success(false);
//                Log.d("ricric", "error => " + error);
//            }
//        });
        if (md.canShow(genericTemplateContent)) {
//            md.show(activity, genericTemplateContent);
            MessageDialog.show(this, genericTemplateContent);
        }
    }


    public void initRewardAds() {
        Log.i("tago", "initRewardAds");
        if (isRewardVideoAdInitialized) {
            return;
        }
        SdkConfiguration.Builder configBuilder = new SdkConfiguration.Builder(mAdUnitId);
        if (BuildConfig.DEBUG) {
            configBuilder.withLogLevel(DEBUG);
        } else {
            configBuilder.withLogLevel(INFO);
        }
        MoPub.initializeSdk(this, configBuilder.build(), initSdkListener());
        MoPubRewardedVideos.setRewardedVideoListener(this);

        isRewardVideoAdInitialized = true;
    }

    public void loadRewardAds() {
        Log.i("tago", "loadRewardAds");
        MoPubRewardedVideos.loadRewardedVideo(mAdUnitId,
                new MoPubRewardedVideoManager.RequestParameters("", "", null, "sample_app_customer_id"));
    }

    public boolean isRewardVideoAdReady() {
        return MoPubRewardedVideos.hasRewardedVideo(mAdUnitId);
    }

    public void showRewardAds() {
        Log.i("tago", "showRewardAds");
        boolean isReady = isRewardVideoAdReady();
        Log.i("tago", "isRewardVideoAdReady: " + isReady);
        if (isReady) {
            MoPubRewardedVideos.showRewardedVideo(mAdUnitId, "");
        }
    }

    private SdkInitializationListener initSdkListener() {
        return new SdkInitializationListener() {
            @Override
            public void onInitializationFinished() {
                Log.i("tago", "onInitializationFinished");
            }
        };
    }

    @Override
    public void onRewardedVideoLoadSuccess(@NonNull String adUnitId) {
        Log.i("tago", "onRewardedVideoLoadSuccess");

        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_LOAD_REWARD_VIDEO_SUCCESS);
        json.put("data", adUnitId);

        basicMessageChannel.send(json, new BasicMessageChannel.Reply() {
            @Override
            public void reply(Object reply) {
                Log.i("tago", "reply: " + reply);
            }
        });
    }

    @Override
    public void onRewardedVideoLoadFailure(@NonNull String adUnitId, @NonNull MoPubErrorCode errorCode) {
        Log.i("tago", "onRewardedVideoLoadFailure " + errorCode);
        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_LOAD_REWARD_VIDEO_FAILURE);
        json.put("data", "param");

        basicMessageChannel.send(json, new BasicMessageChannel.Reply() {
            @Override
            public void reply(Object reply) {
                Log.i("tago", "reply: " + reply);
            }
        });
    }

    @Override
    public void onRewardedVideoStarted(@NonNull String adUnitId) {
        Log.i("tago", "onRewardedVideoStarted");

        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_REWARD_VIDEO_STARTED);
        json.put("data", "params");

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
        Log.i("tago", "onRewardedVideoClicked");
    }

    @Override
    public void onRewardedVideoClosed(@NonNull String adUnitId) {
        Log.i("tago", "onRewardedVideoClosed");

        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_REWARD_VIDEO_CLOSED);
        json.put("data", "params");

        basicMessageChannel.send(json, new BasicMessageChannel.Reply() {
            @Override
            public void reply(Object reply) {
                Log.i("tago", "reply: " + reply);
            }
        });
    }

    @Override
    public void onRewardedVideoCompleted(@NonNull Set<String> adUnitIds, @NonNull MoPubReward reward) {
        Log.i("tago", "onRewardedVideoCompleted");

        Map<String, Object> json = new HashMap<>();
        json.put("name", Config.MOPUB_REWARD_VIDEO_COMPLETE);
        json.put("data", "params");

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
    }

    @Override
    public void onResume() {
        super.onResume();
        MoPub.onResume(this);
    }
}
