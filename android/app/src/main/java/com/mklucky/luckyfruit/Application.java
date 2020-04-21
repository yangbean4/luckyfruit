/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-04-01 11:49:52
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-04-20 16:40:15
 */
package goodluck.lucky.money.mergegarden.win.cash;

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
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    GeneratedPluginRegistrant.registerWith(registry);
  }
}