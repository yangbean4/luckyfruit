package goodluck.lucky.money.mergegarden.win.cash;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.text.TextUtils;
import android.util.Log;

/**
 * Created by liangyongyang on 2018/12/8.
 * <p>
 * 监听应用安装卸载
 */

public class AppInstallReceiver extends BroadcastReceiver {

    private static final String TAG = "AppInstallReceiver";
    private final String ADD_APP = "android.intent.action.PACKAGE_ADDED";
    private final String REMOVE_APP = "android.intent.action.PACKAGE_REMOVED";

    @Override
    public void onReceive(final Context context, final Intent intent) {
        try {
            if (intent == null || context == null) {
                return;
            }

            Runnable runnable = new Runnable() {
                @Override
                public void run() {

                    String packageName = null;
                    try {
                        packageName = intent.getDataString();
                        if (TextUtils.isEmpty(packageName)) {
                            return;
                        }
                        int index = packageName.indexOf(":") + 1;
                        if (packageName.length() < index) {
                            return;
                        }
                        packageName = packageName.split(":")[1];
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    if (packageName == null || TextUtils.isEmpty(packageName)) {
                        return;
                    }
                    if (packageName.equals(context.getPackageName())) {//sdk宿主app，不处理自己包所在的安装广播
                        return;
                    }

                    String action = intent.getAction();
                    if (ADD_APP.equals(action)) {
                        if (BuildConfig.DEBUG) {
                            Log.i("tago", "安装了:" + packageName);
                        }

                        //上报安装的增量
                        new InstallReport().init(context, packageName);
                    }
                    if (REMOVE_APP.equals(action)) {
                        if (BuildConfig.DEBUG) {
                            Log.i("tago", "卸载了:" + packageName + " context: " + context);
                        }
                        //上报卸载的减量
                        new UnInstallReport().init(context, packageName);
                    }
                }
            };

            new Thread(runnable).start();

        } catch (Exception e) {
            Log.i("tago", "AppInstallReceiver: exception " + e.toString());
        }
    }

    /*
     *获取程序的版本号
     */
    public String getAppVersion(Context context, String packname) {
        try {
            PackageManager pm = context.getPackageManager();
            PackageInfo packinfo = pm.getPackageInfo(packname, 0);
            return packinfo.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * 获取App的title
     */
    public String getAppTitle(Context context, String pkgName) {
        ApplicationInfo ai = null;
        PackageManager pm = null;
        try {
            pm = context.getPackageManager();
            ai = pm.getApplicationInfo(pkgName, 0);
        } catch (final PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return (String) (ai != null ? pm.getApplicationLabel(ai) : "unknown");
    }
}
