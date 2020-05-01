/*
 * @Description:
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-04-01 11:49:52
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-04-23 12:31:40
 */
package goodluck.lucky.money.mergegarden.win.cash;

import android.content.Context;

import com.applovin.sdk.AppLovinSdk;
import com.facebook.FacebookSdk;
import com.facebook.LoggingBehavior;

import java.util.ArrayList;

import androidx.multidex.MultiDex;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterFirebaseMessagingService.setPluginRegistrant(this);

        if (BuildConfig.DEBUG) {
            FacebookSdk.setIsDebugEnabled(true);
            FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
        }
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);
    }

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}