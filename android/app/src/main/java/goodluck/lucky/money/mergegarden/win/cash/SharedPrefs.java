package goodluck.lucky.money.mergegarden.win.cash;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * Created by bonan on 2020/4/26
 */
class SharedPrefs {

    private static final String SHARED_PREFERENCES_NAME = "Mediation_Shared_Preferences_Merge";
    public static final String CACHE_APP_LIST = "cache_app_list";

    public static String getCacheAppList(Context context) {
        if (context == null) {
            return "";
        }
        SharedPreferences preferences = context.getSharedPreferences(SHARED_PREFERENCES_NAME, 0);
        return preferences.getString(CACHE_APP_LIST, "");
    }

    public static void setCacheAppList(Context context, String response) {
        if (context == null) {
            return;
        }
        SharedPreferences preferences = context.getSharedPreferences(SHARED_PREFERENCES_NAME, 0);
        SharedPreferences.Editor editor = preferences.edit();
        editor.putString(CACHE_APP_LIST, response);
        editor.commit();
    }
}
