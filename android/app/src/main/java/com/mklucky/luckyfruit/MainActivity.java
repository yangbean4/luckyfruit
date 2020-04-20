/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-04-01 16:22:50
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-04-20 18:46:36
 */
package com.mklucky.luckyfruit;

import android.content.Intent;
import android.net.Uri;
//import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.core.app.NotificationManagerCompat;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import com.mklucky.luckyfruit.Config;

import org.json.JSONObject;

import cn.thinkingdata.android.ThinkingAnalyticsSDK;

public class MainActivity extends FlutterActivity {

  BasicMessageChannel basicMessageChannel;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    ThinkingAnalyticsSDK tdInstance = ThinkingAnalyticsSDK.sharedInstance(this, "f2328f8dee2b4ed1970be74235b9a5cc",
        "https://receiver.ta.thinkingdata.cn");

    new MethodChannel(getFlutterView(), Config.METHOD_CHANNEL)
        .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
            Log.i("onMethodCall", " method name: " + methodCall.method);
            Log.i("onMethodCall", " method arguments: " + methodCall.arguments());

            switch (methodCall.method) {
              case "message_notification": {// 检查app是否开启了通知权限
                NotificationManagerCompat notification = NotificationManagerCompat.from(MainActivity.this);
                boolean isEnabled = notification.areNotificationsEnabled();
                result.success(isEnabled);
                break;
              }
              case "set_message_notification": {// 跳转到设置
                final String SETTINGS_ACTION = "android.settings.ACTION_APP_NOTIFICATION_SETTINGS";

                Intent intent = new Intent().setAction(SETTINGS_ACTION)
                    .setData(Uri.fromParts("package", getApplicationContext().getPackageName(), null));
                startActivity(intent);
                break;
              }
              case "tga_track": { // TGA 数据上报
                String event = (String) methodCall.argument("event_name");
                tdInstance.track(event, (JSONObject) methodCall.arguments);
                break;
              }
            }
          }
        });
  }
}
