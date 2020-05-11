package goodluck.lucky.money.mergegarden.win.cash.prevention.compat;

import android.os.Message;

/**
 * Created by bonan on 2019/10/15
 */

public interface IActivityKiller {

    void finishLaunchActivity(Message message);

    void finishResumeActivity(Message message);

    void finishPauseActivity(Message message);

    void finishStopActivity(Message message);


}
