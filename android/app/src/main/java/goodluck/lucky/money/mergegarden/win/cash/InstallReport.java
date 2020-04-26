package goodluck.lucky.money.mergegarden.win.cash;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings;

import org.json.JSONArray;
import org.json.JSONObject;

/**
 * Desc:   com.mobi.sdk
 * Author: Administrator
 * Date:   2018/6/27 0027
 */
class InstallReport {

    /**
     * 安装增量上报
     *
     * @param context 上下文
     * @param pkg     包名
     */
    public synchronized void init(final Context context, final String pkg) {
        try {
            AppListUploader.upLoadAppInstallAndRemove(context, createJsonData(context, pkg));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 生成安装/卸载 日志的上传数据内容
     *
     * @param packageName packageName
     * @return 上传数据内容
     */
    private JSONObject createJsonData(Context context, String packageName) {
        try {
            if (context == null) {
                return new JSONObject();
            }

            JSONObject jsonObject = new JSONObject();
            JSONObject item = new JSONObject();
            jsonObject.put("aid", Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID));
            jsonObject.put("acct_id", Config.ACCT_ID);
            jsonObject.put("pkg_name", context.getPackageName());
            jsonObject.put("app_version", Utils.getVersionCode(context, context.getPackageName()));
            jsonObject.put("osv", Build.VERSION.RELEASE);
            jsonObject.put("status", AppListUploader.STATUS_INSTALL);
            jsonObject.put("is_app_init", 0);

            try {
                PackageInfo info = context.getPackageManager().getPackageInfo(packageName, 0);
                item.put("version", info.versionName);
                item.put("i_pkg_name", packageName);
//            //有此标识是是增量上报 app记录：0 卸载  1 安装
//            item.put("status", 1);
                item.put("install_time", "" + System.currentTimeMillis());
            } catch (PackageManager.NameNotFoundException ex) {
                ex.printStackTrace();
            }
            JSONArray jsonArray = new JSONArray();
            jsonArray.put(item);
            jsonObject.put("pkgs", jsonArray);

            return jsonObject;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

}