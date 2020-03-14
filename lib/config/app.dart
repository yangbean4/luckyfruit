// 放全局的事件句柄
enum Event_Name {
  // APP退出
  APP_PAUSED,
}

// 游戏相关设置
class GameConfig {
  static const int X_AMOUNT = 4;
  static const int Y_AMOUNT = 3;
}

class AnimationConfig {
  static const num TreeAnimationTime = 8;
  static const num AlightingTime = 20;
}

class App {
  // 离线也有收益的时长 单位秒
  static const num UN_LINE_TIME = 20 * 60;
  static const String AESKEY = '06BB48CFA768694D';
  static const String BASE_URL =
      'http://171.8.199.211:8109/public/index.php?r=';
  static const String METHOD_CHANNEL = "com.xyjy.flutterchannel/method";
  static const String EVENT_CHANNEL = "com.xyjy.flutterchannel/event";
}
