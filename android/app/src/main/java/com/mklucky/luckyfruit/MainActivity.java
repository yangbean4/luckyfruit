/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-04-01 16:22:50
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-04-13 17:59:59
 */
package com.mklucky.luckyfruit;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import androidx.core.app.NotificationManagerCompat;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;

public class MainActivity extends FlutterActivity {
  private static final String METHOD_CHANNEL = "com.bean.flutterchannel/method";
  private static final String EVENT_CHANNEL = "com.bean.flutterchannel/event";

  BasicMessageChannel basicMessageChannel;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), METHOD_CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {

        if (methodCall.method.equals("message_notification")) {// 检查app是否开启了通知权限
          NotificationManagerCompat notification = NotificationManagerCompat.from(MainActivity.this);
          boolean isEnabled = notification.areNotificationsEnabled();
          result.success(isEnabled);
        } else if (methodCall.method.equals("set_message_notification")) {// 跳转到设置
          final String SETTINGS_ACTION = "android.settings.ACTION_APP_NOTIFICATION_SETTINGS";

          Intent intent = new Intent().setAction(SETTINGS_ACTION)
              .setData(Uri.fromParts("package", getApplicationContext().getPackageName(), null));
          startActivity(intent);
          return;

        }
      }
    });
  }
}
