package goodluck.lucky.money.mergegarden.win.cash;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Looper;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.DisplayMetrics;

import java.io.File;
import java.util.Locale;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * Created by bonan on 2019/7/19
 */
public class SenUtils {

    private static String TAG = "SenUtils";

    public static boolean isNetworkConnected(Context context) {
        if (context == null) {
            return false;
        }
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetwork = cm.getActiveNetworkInfo();
        if (activeNetwork == null) {
            return false;
        }
        return activeNetwork.isConnected();
    }

    /**
     * 检查当前线程是否为UI线程
     *
     * @return Is UI thread
     */
    public static boolean checkIsUIThread() {
        if (Looper.myLooper() == null) {
            return false;
        }
        return Looper.myLooper().equals(Looper.getMainLooper());
    }

    public static int dpToPx(long dp) {
        DisplayMetrics displayMetrics = Resources.getSystem().getDisplayMetrics();
        int px = (int) ((float) dp * displayMetrics.density + 0.5F);
        return px;
    }

    /**
     * @return 系统版本号
     */
    public static String getOsVersion() {
        return Build.VERSION.RELEASE;
    }

    /**
     * @return Returns the language code of this Locale.
     */
    public static String getLanguage() {
        return Locale.getDefault().getLanguage();
    }

    /**
     * @return Returns the country/region code for this locale
     */
    public static String getCountry() {
        return Locale.getDefault().getCountry();
    }

    /**
     * @return The version name of this package
     */
    public static String getVersionName(Context context, String pkgStr) {
        PackageManager pm = context.getPackageManager();
        PackageInfo pi;
        try {
            pi = pm.getPackageInfo(pkgStr, 0);
            return pi == null ? "" : pi.versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * The version code of this package
     */
    public static int getAppVersionCode(Context context) {
        try {
            PackageManager manager = context.getPackageManager();
            PackageInfo info = manager.getPackageInfo(context.getPackageName(),
                    0);
            return info.versionCode;
        } catch (Exception e) {
            e.printStackTrace();
            return 1;
        }
    }

    /**
     * 获取App的title
     */
    public static String getAppTitle(Context context, String pkgName) {
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

    private static boolean validateLength(String key, int minLength, int maxLength) {
        return (key != null) && (key.length() >= minLength) && (key.length() <= maxLength);
    }

    private static boolean validateAlphanumeric(String key) {
        if (key == null) {
            return false;
        }
        String pattern = "^[a-zA-Z0-9\\-]*$";
        return key.matches(pattern);
    }

    public static String getPackageName(Context context) {
        if (context == null) {
            return "";
        }
        return context.getPackageName();
    }

    public static String getWebViewVersion(String webviewUA, String regularExp) {
        String webviewVersion = "";
        if (TextUtils.isEmpty(webviewUA)) {
            return null;
        }
        Pattern pat = Pattern.compile(regularExp);
        Matcher mat = pat.matcher(webviewUA);
        if (mat.find()) {
            String webviewVersionTemp = mat.group(0);
            pat = Pattern.compile("([0-9.]+)");
            mat = pat.matcher(webviewVersionTemp);
            if (mat.find()) {
                webviewVersion = mat.group(0);
            }
        }
        return webviewVersion;
    }

    public static String getPublisherApplicationVersion(Context context, String packageName) {
        String result = "";
        try {
            result = context.getPackageManager().getPackageInfo(packageName, 0).versionName;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return result;
    }

    public static String getCurrentTimeZone() {
        TimeZone tz = TimeZone.getDefault();
        return tz.getDisplayName(false, TimeZone.SHORT);
    }

    /**
     * 是否开启了开发者模式
     */
    public static boolean checkWhetherEnableDeveloperModel(Context context) {
        if (context == null) {
            return false;
        }
        return Settings.Secure.getInt(context.getContentResolver(), Settings.Secure.ADB_ENABLED, 0) > 0;
    }

    /**
     * 检测设备是否充电状态
     */
    public static boolean checkDevicePluggedIn(Context context) {
        if (context == null) {
            return false;
        }
        boolean isPlugged;
        Intent intent = context.registerReceiver(null,
                new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
        if (intent == null) {
            return false;
        }
        int plugged = intent.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1);
        isPlugged = plugged == BatteryManager.BATTERY_PLUGGED_AC || plugged == BatteryManager.BATTERY_PLUGGED_USB;
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.JELLY_BEAN) {
            isPlugged = isPlugged || plugged == BatteryManager.BATTERY_PLUGGED_WIRELESS;
        }
        return isPlugged;
    }

    /**
     * 设备电量
     *
     * @param context
     * @return
     */
    public static int getDeviceBatteryLevel(Context context) {
        if (context == null) {
            return -1;
        }
        Intent batteryInfoIntent = context.registerReceiver(null,
                new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
        if (batteryInfoIntent == null) {
            return -1;
        }
        return batteryInfoIntent.getIntExtra("level", 0);
    }

    /**
     * 检查root权限
     */
    public static boolean isRoot() {
        // eng/userdebug版本，自带root权限
        if (getroSecureProp() == 0) {
            return true;
        }
        //user版本，继续查su文件
        return isSUExist();
    }

    private static int getroSecureProp() {
        int secureProp;
        String roSecureObj = getProperty("ro.secure");
        if (roSecureObj == null) {
            secureProp = 1;
        } else {
            if ("0".equals(roSecureObj)) {
                secureProp = 0;
            } else {
                secureProp = 1;
            }
        }
        return secureProp;
    }

    private static boolean isSUExist() {
        String[] paths = {"/sbin/su",
                "/system/bin/su",
                "/system/xbin/su",
                "/data/local/xbin/su",
                "/data/local/bin/su",
                "/system/sd/xbin/su",
                "/system/bin/failsafe/su",
                "/data/local/su"};
        for (String path : paths) {
            File file = new File(path);
            if (file.exists()) {
                return true;
            }
        }
        return false;
    }

    private static String getProperty(String propName) {
        String value = null;
        Object roSecureObj;
        try {
            roSecureObj = Class.forName("android.os.SystemProperties")
                    .getMethod("get", String.class)
                    .invoke(null, propName);
            if (roSecureObj != null) {
                value = (String) roSecureObj;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return value;
    }


    public static void installPrevention(final Context context) {
        if (context == null || context.getApplicationContext() == null) {
            return;
        }
        // TODO 先关闭，后面再打开
//        Prevention.install(context.getApplicationContext(), new PreventionExceptionHandler() {
//            @Override
//            protected void onUncaughtExceptionHappened(Thread thread, Throwable throwable) {
//                if (SenLogger.DEBUG) {
//                    SenLogger.e(TAG, "onUncaughtExceptionHappened " + throwable);
//                }
//                SenCrashHandler.instance(context.getApplicationContext()).saveHttpExceptions(throwable);
//            }
//
//            @Override
//            protected void onBandageExceptionHappened(Throwable throwable) {
//                if (SenLogger.DEBUG) {
//                    SenLogger.e(TAG, "onBandageExceptionHappened " + throwable);
//                }
//                SenCrashHandler.instance(context.getApplicationContext()).saveHttpExceptions(throwable);
//            }
//
//            @Override
//            protected void onEnterSafeMode() {
//                if (SenLogger.DEBUG) {
//                    SenLogger.e(TAG, "onEnterSafeMode");
//                }
//            }
//
//            @Override
//            protected void onMayBeBlackScreen(Throwable e) {
//                if (SenLogger.DEBUG) {
//                    SenLogger.e(TAG, "onMayBeBlackScreen " + e);
//                }
//            }
//        });
    }

}