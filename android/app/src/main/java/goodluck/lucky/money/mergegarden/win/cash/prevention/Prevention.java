package goodluck.lucky.money.mergegarden.win.cash.prevention;

import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.lang.reflect.Field;

import goodluck.lucky.money.mergegarden.win.cash.prevention.compat.ActivityKillerV15_V20;
import goodluck.lucky.money.mergegarden.win.cash.prevention.compat.ActivityKillerV21_V23;
import goodluck.lucky.money.mergegarden.win.cash.prevention.compat.ActivityKillerV24_V25;
import goodluck.lucky.money.mergegarden.win.cash.prevention.compat.ActivityKillerV26;
import goodluck.lucky.money.mergegarden.win.cash.prevention.compat.ActivityKillerV28;
import goodluck.lucky.money.mergegarden.win.cash.prevention.compat.IActivityKiller;

import static android.os.Build.VERSION.SDK_INT;


/**
 * Created by bonan on 2019/10/15
 */

public final class Prevention {

    private static IActivityKiller sActivityKiller;
    private static PreventionExceptionHandler sExceptionHandler;
    private static boolean sInstalled = false;//标记位，避免重复安装卸载
    private static boolean sIsSafeMode;
    // 调用install之前已经设置了的ExceptionHandler，如果没有设置过，就是系统默认的ExceptionHandler
    private static Thread.UncaughtExceptionHandler originExcepHandler;
    private static String pkgName;

    private Prevention() {
    }

    public static boolean isInstalled() {
        return sInstalled;
    }

    public static void install(final Context ctx, PreventionExceptionHandler exceptionHandler) {
        Log.i("tago", String.format("before_ins_imp: %s", sInstalled));
        if (sInstalled) {
            return;
        }
        try {
            //解除 android P 反射限制
            if (SDK_INT >= 28) {
                PreventionReflection.unseal(ctx);
            }
        } catch (Throwable throwable) {
        }
        sInstalled = true;
        sExceptionHandler = exceptionHandler;
        pkgName = ctx.getPackageName();

        initActivityKiller();

        originExcepHandler = Thread.getDefaultUncaughtExceptionHandler();
        Thread.setDefaultUncaughtExceptionHandler(new MyUncaughtExceptionHandler());
    }

    public static class MyUncaughtExceptionHandler implements Thread.UncaughtExceptionHandler {

        @Override
        public void uncaughtException(Thread t, Throwable ex) {
            String crashes = getCrashDetailFromThrowable(ex);
            // 如果是宿主的崩溃，直接return
            if (shouldIgnoreThisException(crashes, t, ex)) {
                return;
            }

            if (sExceptionHandler != null) {
                sExceptionHandler.uncaughtExceptionHappened(t, ex);
            }
            if (t == Looper.getMainLooper().getThread()) {
//              isChoreographerException(ex);
                safeMode();
            }
        }
    }

    private static String getCrashDetailFromThrowable(Throwable throwable) {
        if (throwable == null) {
            return "";
        }
        Writer writer = new StringWriter();
        PrintWriter printWriter = new PrintWriter(writer);
        throwable.printStackTrace(printWriter);
        Throwable cause = throwable.getCause();
        while (null != cause) {
            throwable.printStackTrace(printWriter);
            cause = cause.getCause();
        }
        printWriter.close();
        return writer.toString();
    }

    /**
     * 是否是宿主的Crash
     */
    private static boolean shouldIgnoreThisException(String crashMsg, Thread t, Throwable throwable) {

        // 如果crash里包含了SDK包名，进一步判断去除Prevention关键字所在行之后的信息是否还包含SDK包名
//        String finalCrashMsg = getCrashMsgAfterRemovePreventionKeyWords(crashMsg);
//        String finalCrashMsg = crashMsg;
//        if (TextUtils.isEmpty(finalCrashMsg)) {
//
//            Throwable finalThrowable;
//            if (TextUtils.equals(crashMsg, finalCrashMsg)) {
//                // 不包含「Prevention.java:」关键字时，还使用系统生成的throwable
//                finalThrowable = throwable;
//            } else {
//                // 否则，就是用自己创建的throwable
//                finalThrowable = new Throwable(finalCrashMsg);
//                finalThrowable.setStackTrace(new StackTraceElement[0]);
//            }
//
//            // 使用默认设置的 ExceptionHandler处理，比如上报到Bugly
//            if (originExcepHandler != null) {
//                originExcepHandler.uncaughtException(t, finalThrowable);
//            } else {
//                System.exit(0);
//            }
//            return true;
//        } else {
//            return false;
//        }
        return false;
    }

    /**
     * 如果崩溃信息发生在hookmH方法中时，崩溃信息会带有Prevention类的包名，
     * 需要把这一行删除后再使用 shouldIgnoreThisException 方法判断
     */
    private static String getCrashMsgAfterRemovePreventionKeyWords(String crashMsg) {
        if (TextUtils.isEmpty(crashMsg)) {
            return "";
        }

        // 如果不包含com.sen包名，则不用再往下进行了，直接返回原信息
        if (!crashMsg.contains("com.sen.")) {
            return crashMsg;
        }

        // 如果包含com.sen包名，还需要继续把Prevention关键字所在行删除后再判断是否还包含com.sen包名
        String[] split = crashMsg.split("\n");
        for (int i = 0; i < split.length; i++) {
            if (split[i].contains("Prevention.java:")) {
                split[i] = "";
            }
        }

        String result = TextUtils.join("\n", split);
        return result.replaceAll("\n+", "\n");
    }

    /**
     * 替换ActivityThread.mH.mCallback，实现拦截Activity生命周期，直接忽略生命周期的异常的话会导致黑屏，目前
     * 会调用ActivityManager的finishActivity结束掉生命周期抛出异常的Activity
     */
    private static void initActivityKiller() {
        //各版本android的ActivityManager获取方式，finishActivity的参数，token(binder对象)的获取不一样
        if (Build.VERSION.SDK_INT >= 28) {
            sActivityKiller = new ActivityKillerV28();
        } else if (Build.VERSION.SDK_INT >= 26) {
            sActivityKiller = new ActivityKillerV26();
        } else if (Build.VERSION.SDK_INT == 25 || Build.VERSION.SDK_INT == 24) {
            sActivityKiller = new ActivityKillerV24_V25();
        } else if (Build.VERSION.SDK_INT >= 21 && Build.VERSION.SDK_INT <= 23) {
            sActivityKiller = new ActivityKillerV21_V23();
        } else if (Build.VERSION.SDK_INT >= 15 && Build.VERSION.SDK_INT <= 20) {
            sActivityKiller = new ActivityKillerV15_V20();
        } else if (Build.VERSION.SDK_INT < 15) {
            sActivityKiller = new ActivityKillerV15_V20();
        }

        try {
            hookmH();
        } catch (Throwable e) {
        }
    }

    private static void hookmH() throws Exception {
        final int LAUNCH_ACTIVITY = 100;
        final int PAUSE_ACTIVITY = 101;
        final int PAUSE_ACTIVITY_FINISHING = 102;
        final int STOP_ACTIVITY_HIDE = 104;
        final int RESUME_ACTIVITY = 107;
        final int DESTROY_ACTIVITY = 109;
        final int NEW_INTENT = 112;
        final int RELAUNCH_ACTIVITY = 126;
        Class activityThreadClass = Class.forName("android.app.ActivityThread");
        Object activityThread = activityThreadClass.getDeclaredMethod("currentActivityThread").invoke(null);
        Field mhField = activityThreadClass.getDeclaredField("mH");
        mhField.setAccessible(true);
        final Handler mhHandler = (Handler) mhField.get(activityThread);
        Field callbackField = Handler.class.getDeclaredField("mCallback");
        callbackField.setAccessible(true);
        callbackField.set(mhHandler, new Handler.Callback() {
            @Override
            public boolean handleMessage(Message msg) {
                if (Build.VERSION.SDK_INT >= 28) {
                    return handleBuildVersionAbove28(mhHandler, msg);
                }
                switch (msg.what) {
                    case LAUNCH_ACTIVITY:// startActivity--> activity.attach  activity.onCreate  r.activity!=null  activity.onStart  activity.onResume
                        try {
                            mhHandler.handleMessage(msg);
                        } catch (Throwable throwable) {
                            sActivityKiller.finishLaunchActivity(msg);
                            notifyException(throwable);
                        }
                        return true;
                    case RESUME_ACTIVITY://回到activity onRestart onStart onResume
                        try {
                            mhHandler.handleMessage(msg);
                        } catch (Throwable throwable) {
                            sActivityKiller.finishResumeActivity(msg);
                            notifyException(throwable);
                        }
                        return true;
                    case PAUSE_ACTIVITY_FINISHING://按返回键 onPause
                        try {
                            mhHandler.handleMessage(msg);
                        } catch (Throwable throwable) {
                            sActivityKiller.finishPauseActivity(msg);
                            notifyException(throwable);
                        }
                        return true;
                    case PAUSE_ACTIVITY://开启新页面时，旧页面执行 activity.onPause
                        try {
                            mhHandler.handleMessage(msg);
                        } catch (Throwable throwable) {
                            sActivityKiller.finishPauseActivity(msg);
                            notifyException(throwable);
                        }
                        return true;
                    case STOP_ACTIVITY_HIDE://开启新页面时，旧页面执行 activity.onStop
                        try {
                            mhHandler.handleMessage(msg);
                        } catch (Throwable throwable) {
                            sActivityKiller.finishStopActivity(msg);
                            notifyException(throwable);
                        }
                        return true;
                    case DESTROY_ACTIVITY:// 关闭activity onStop  onDestroy
                        try {
                            mhHandler.handleMessage(msg);
                        } catch (Throwable throwable) {
                            notifyException(throwable);
                        }
                        return true;
                }
                return false;
            }
        });
    }

    private static boolean handleBuildVersionAbove28(Handler mhHandler, Message msg) {
        final int EXECUTE_TRANSACTION = 159;
        if (msg.what == EXECUTE_TRANSACTION) {
            try {
                mhHandler.handleMessage(msg);
            } catch (Throwable throwable) {
                sActivityKiller.finishLaunchActivity(msg);
                notifyException(throwable);
            }
            return true;
        }
        return false;
    }

    private static void notifyException(Throwable ex) {
        String crashes = getCrashDetailFromThrowable(ex);
        // 如果是宿主的崩溃，直接return
        if (shouldIgnoreThisException(crashes,
                Looper.getMainLooper().getThread(), ex)) {
            return;
        }

        if (sExceptionHandler == null) {
            return;
        }
        if (isSafeMode()) {
            sExceptionHandler.bandageExceptionHappened(ex);
        } else {
            sExceptionHandler.uncaughtExceptionHappened(Looper.getMainLooper().getThread(), ex);
            safeMode();
        }
    }

    public static boolean isSafeMode() {
        return sIsSafeMode;
    }

    private static void safeMode() {
        sIsSafeMode = true;
        if (sExceptionHandler != null) {
            sExceptionHandler.enterSafeMode();
        }
        while (true) {
            try {
                Looper.loop();
            } catch (Throwable e) {
//                isChoreographerException(e);
                // 如果是宿主的崩溃，直接return
                // 「场景：先sdk崩溃进入了safeMode()方法，
                //       然后宿主崩溃走的这里，所以需要判断一下」
                String crashes = getCrashDetailFromThrowable(e);
                if (shouldIgnoreThisException(crashes,
                        Looper.getMainLooper().getThread(), e)) {
                    return;
                }
                if (sExceptionHandler != null) {
                    sExceptionHandler.bandageExceptionHappened(e);
                }
            }
        }
    }

    /**
     * view measure layout draw时抛出异常会导致Choreographer挂掉
     * <p>
     * 建议直接杀死app。以后的版本会只关闭黑屏的Activity
     *
     * @param e
     */
    private static void isChoreographerException(Throwable e) {
        if (e == null || sExceptionHandler == null) {
            return;
        }
        StackTraceElement[] elements = e.getStackTrace();
        if (elements == null) {
            return;
        }

        for (int i = elements.length - 1; i > -1; i--) {
            if (elements.length - i > 20) {
                return;
            }
            StackTraceElement element = elements[i];
            if ("android.view.Choreographer".equals(element.getClassName())
                    && "Choreographer.java".equals(element.getFileName())
                    && "doFrame".equals(element.getMethodName())) {
                //黑屏时建议直接杀死app
                sExceptionHandler.mayBeBlackScreen(e);
                System.exit(0);
                return;
            }
        }
    }
}