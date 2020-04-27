package goodluck.lucky.money.mergegarden.win.cash;

import android.text.TextUtils;
import android.util.Log;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;


public class HttpFunctions {
    private static final String TAG = "HttpFunctions";
    private static final int SERVER_REQUEST_TIMEOUT = 15000;
    private static final String SERVER_REQUEST_POST_METHOD = "POST";
    private static final String SERVER_REQUEST_ENCODING = "UTF-8";
    private static final String SERVER_BAD_REQUEST_ERROR = "Bad Request";

    public static String getStringFromPostUrl(String url, String json, IResponseListener listener) {
        OutputStream os = null;
        HttpURLConnection conn = null;
        BufferedReader reader = null;

        try {

            if (TextUtils.isEmpty(url)) {
                return null;
            }

            if (TextUtils.isEmpty(json)) {
                return null;
            }

            URL requestURL = new URL(url);
            if (BuildConfig.DEBUG) {
                Log.i("tago", "getStringFromPostUrl " + url);
            }

//            String authorizationString = SANUtils.getBase64Auth(userName, password);
            conn = (HttpURLConnection) requestURL.openConnection();
            conn.setReadTimeout(SERVER_REQUEST_TIMEOUT);
            conn.setConnectTimeout(SERVER_REQUEST_TIMEOUT);
            conn.setRequestMethod(SERVER_REQUEST_POST_METHOD);
            // 设置接收数据的格式
            conn.setRequestProperty("Accept", "application/json");
            // 设置发送数据的格式
            conn.setRequestProperty("Content-Type", "application/json");
//            conn.setRequestProperty("Authorization", authorizationString);
            conn.setDoInput(true);
            conn.setDoOutput(true);

            os = conn.getOutputStream();

            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(os, SERVER_REQUEST_ENCODING));

            writer.write(json);
            writer.flush();
            writer.close();

            int responseCode = conn.getResponseCode();
            if (responseCode != 200) {
                if (listener != null) {
                    listener.onError("responseCode=" + responseCode);
                }
                return null;
            }
            reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            StringBuilder stringBuilder = new StringBuilder();

            String line;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
            String result = stringBuilder.toString();
            if (TextUtils.isEmpty(result)) {
                //返回 null 就重新请求recoverlist 等。
                if (listener != null) {
                    listener.onError("time_out");
                }
                return null;
            }
            if (listener != null) {
                listener.onSuccess(result);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();

            if (listener != null) {
                listener.onError("time_out");
            }
            return null;
        } finally {
            try {
                if (os != null)
                    os.close();
                if (conn != null) {
                    conn.disconnect();
                }
                if (reader != null)
                    reader.close();
            } catch (Exception e) {
                e.printStackTrace();
            } catch (OutOfMemoryError outOfMemoryError) {
            } finally {
                reader = null;
                conn = null;
            }
        }
    }

    public interface IResponseListener {
        public abstract void onError(String error);

        public abstract void onSuccess(String msg);
    }
}


