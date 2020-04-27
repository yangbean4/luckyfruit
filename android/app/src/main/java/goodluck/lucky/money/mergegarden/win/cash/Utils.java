package goodluck.lucky.money.mergegarden.win.cash;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

/**
 * Created by bonan on 2020/4/26
 */
class Utils {
    public static String getVersionCode(Context context, String pkgStr) {
        PackageManager pm = context.getPackageManager();
        PackageInfo pi;
        try {
            pi = pm.getPackageInfo(pkgStr, 0);
            String versionName = pi == null ? "" : pi.versionName;
            return versionName;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        return "";
    }
}
