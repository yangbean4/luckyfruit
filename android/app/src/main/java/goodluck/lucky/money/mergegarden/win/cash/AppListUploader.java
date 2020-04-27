package goodluck.lucky.money.mergegarden.win.cash;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.os.Build;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;
import java.util.List;

/**
 * Created by bonan on 2020/4/26
 */
class AppListUploader {

    private static final String PKG_NAME = "i_pkg_name";
    public static final int STATUS_INSTALL = 1;
    public static final int STATUS_UNINSTALL = 0;

    /**
     * 全量上传安装列表
     * 第二次上报新增和卸载
     *
     * @param context c
     */
    public static void upLoadAppList(final Context context, int status, boolean isFromInit) {
        List<PackageInfo> packageInfoList = getInstallPackageList(context);
        if (packageInfoList != null && !packageInfoList.isEmpty()) {
            final JSONArray jsonArray = new JSONArray();
            for (PackageInfo info : packageInfoList) {
                JSONObject object = new JSONObject();
                try {
                    object.put("i_pkg_name", info.packageName);
                    object.put("install_time", info.firstInstallTime);
                    object.put("version", info.versionName);
                    jsonArray.put(object);
                } catch (JSONException ex) {
                    ex.printStackTrace();
                }
            }

            JSONArray listApp = filterApp(context, jsonArray.toString());

            if (listApp != null && listApp.length() > 0) {
                final JSONObject jsonObject = new JSONObject();
                try {
                    //如果aid获取不到，就取uuid
                    jsonObject.put("aid", Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID));
                    jsonObject.put("acct_id", Config.ACCT_ID);
                    jsonObject.put("pkg_name", context.getPackageName());
                    jsonObject.put("app_version", Utils.getVersionCode(context, context.getPackageName()));
                    jsonObject.put("osv", Build.VERSION.RELEASE);
                    jsonObject.put("status", status);
                    jsonObject.put("is_app_init", isFromInit ? 1 : 0);
                    jsonObject.put("pkgs", listApp);
                } catch (JSONException ex) {
                    ex.printStackTrace();
                }
                if (BuildConfig.DEBUG) {
                    Log.i("tago", "upLoadAppList: " + jsonObject.toString());
                }

                if (jsonObject.length() <= 0) {
                    return;
                }
                //发送请求
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        String responsStrn = null;
                        try {

                            responsStrn = HttpFunctions.getStringFromPostUrl(Config.SERVER_URL_PREFIX + "/Report/installAppear",
                                    jsonObject.toString(), null);
                            if (BuildConfig.DEBUG) {
                                Log.i("tago", "ReportInstallOrUninstall responsStrn: " + responsStrn);
                            }

                            if (!TextUtils.isEmpty(responsStrn)) {
                                JSONObject encryptedResponseJson = new JSONObject(responsStrn);
                                //请求成功存储应用列表
                                if (encryptedResponseJson.optInt("code") == 0) {
                                    SharedPrefs.setCacheAppList(context, jsonArray.toString());
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }).start();
            }
        }

    }

    /**
     * 获取用户安装的应用列表
     *
     * @param context c
     * @return apps
     */
    private static List<PackageInfo> getInstallPackageList(Context context) {
        if (context == null) {
            return null;
        }
        try {
            List<PackageInfo> packages = context.getPackageManager().getInstalledPackages(0);
            if (packages != null && !packages.isEmpty()) {
                for (Iterator it = packages.iterator(); it.hasNext(); ) {
                    PackageInfo info = (PackageInfo) it.next();
                    if ((info.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0) {
                        it.remove();
                    }
                }
                return packages;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static JSONArray filterApp(Context context, String appList) {
        String cacheAppList = SharedPrefs.getCacheAppList(context);
        if (TextUtils.isEmpty(appList)) {
            return null;
        }

        try {
            if (TextUtils.isEmpty(cacheAppList)) {
                return new JSONArray(appList);
            }
            JSONArray tempArr = new JSONArray();
            JSONArray appArr = new JSONArray(appList);
            JSONArray cacheArr = new JSONArray(cacheAppList);

            //删除部分
            JSONArray deleteArr = new JSONArray();
            for (int i = 0; i < cacheArr.length(); i++) {
                JSONObject objectCrash = cacheArr.getJSONObject(i);
                boolean isExist = false;
                for (int j = 0; j < appArr.length(); j++) {
                    JSONObject objectNew = appArr.getJSONObject(j);
                    if (objectCrash.has(PKG_NAME) && objectNew.has(PKG_NAME) && objectCrash.getString(PKG_NAME).equals(objectNew.getString(PKG_NAME))) {
                        isExist = true;
                        break;
                    }
                }
                if (!isExist) {
                    objectCrash.put("status", 0);//已被卸载
                    deleteArr.put(objectCrash);
                }
            }

            for (int i = 0; i < deleteArr.length(); i++) {
                tempArr.put(deleteArr.getJSONObject(i));
            }
            //新增部分
            JSONArray addArr = new JSONArray();
            for (int i = 0; i < appArr.length(); i++) {
                JSONObject objectAdd = appArr.getJSONObject(i);
                boolean isUnExist = false;
                for (int j = 0; j < cacheArr.length(); j++) {
                    JSONObject objectCrash = cacheArr.getJSONObject(j);
                    if (objectCrash.has(PKG_NAME) && objectAdd.has(PKG_NAME) && objectCrash.getString(PKG_NAME).equals(objectAdd.getString(PKG_NAME))) {
                        isUnExist = true;
                        break;
                    }
                }
                if (!isUnExist) {
                    objectAdd.put("status", 1);//最近新安装
                    addArr.put(objectAdd);
                }
            }

            for (int i = 0; i < addArr.length(); i++) {
                tempArr.put(addArr.getJSONObject(i));
            }
            return tempArr;
        } catch (JSONException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 增量上报
     *
     * @param context  上下文
     * @param jsonData 上报内容
     * @throws Exception
     */
    public static void upLoadAppInstallAndRemove(Context context, final JSONObject jsonData) throws Exception {
        if (jsonData == null || context == null) {
            return;
        }

        //发送请求
        new Thread(new Runnable() {
            @Override
            public void run() {
                String responsStrn = null;
                try {
                    Log.i("tago", "upLoadAppInstallAndRemove_json: " + jsonData.toString());
                    responsStrn = HttpFunctions.getStringFromPostUrl(Config.SERVER_URL_PREFIX + "/Report/installAppear", jsonData.toString(), null);
                    if (BuildConfig.DEBUG) {
                        Log.i("tago", "upLoadAppInstallAndRemove responsStrn=" + responsStrn);
                    }

                } catch (Exception e) {
                    if (BuildConfig.DEBUG) {
                        Log.i("tago", "upLoadAppInstallAndRemove error: " + e.toString());
                    }
                }
            }
        }).start();
    }
}
