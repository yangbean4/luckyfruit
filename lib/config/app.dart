// 放全局的事件句柄
import 'package:flutter/material.dart';

class Event_Name {
  // APP退出
  static const APP_PAUSED = 'APP_PAUSED';
  static const APP_RESUMED = 'APP_RESUMED';

  // 显示弹窗
  static const MODAL_SHOW = 'MODAL_SHOW';

  // 隐藏弹窗
  static const MODAL_HIDE = 'MODAL_HIDE';

  // 路由跳转
  static const String Router_Change = 'Router_Change';
}

// 游戏相关设置
class GameConfig {
  static const int X_AMOUNT = 4;
  static const int Y_AMOUNT = 3;
}

class AnimationConfig {
  // 树动画时间间隔
  static const num TreeAnimationTime = 8;
  // 气球降落 默认时间 单位秒
  static const num AlightingTime = 20;
  // 自动合成 动画时间 单位毫秒
  static const num AutoMergeTime = 200;
}

class App {
  // 存储金币的时间间隔 单位秒
  static const int SAVE_INTERVAL = 30;
  // 离线也有收益的时长 单位秒
  static const num UN_LINE_TIME = 2 * 60 * 60;
  // 离线时长小于10分钟 没有离线奖励
  static const num NO_UN_LINE_TIME = 10 * 60;

  static const String AESKEY = '06BB48CFA768694D';
  static const String BASE_URL =
      'http://171.8.199.211:8109/public/index.php?r=';
  static const String METHOD_CHANNEL = "com.xyjy.flutterchannel/method";
  static const String EVENT_CHANNEL = "com.xyjy.flutterchannel/event";
}

class TreeType {
  /// 全球分红树
  static const Type_Globle_Bonus = "globle_bonus_tree";

  /// 芒果树
  static const Type_Mango = "mango";

  /// 许愿树
  static const Type_Wishing = "wishing";

  /// 啤酒花雄树
  static const Type_Hops_Male = "hops_male";

  /// 能获取奖励的树(限时分红树等)
  static const Type_BONUS = "bonus";

  /// 啤酒花雌树
  static const Type_Hops_Female = "hops_female";

  /// 五洲树
  static const Type_Continents_Asian = "continents_asian";
  static const Type_Continents_African = "continents_african";
  static const Type_Continents_American = "continents_american";
  static const Type_Continents_European = "continents_european";
  static const Type_Continents_Oceania = "continents_oceania";
}

/// 放置常量的类
class Consts {
  // 手动切换底部栏使用
  static GlobalKey globalKey = new GlobalKey(debugLabel: 'key_bottom_bar');

  ///partner页面的加速等级对照表
  static const StageInfoListOfPartner = [
    [
      1,
      1.0,
      20.0,
    ],
    [
      2,
      1.1,
      50.0,
    ],
    [
      3,
      1.2,
      100.0,
    ],
    [
      4,
      1.3,
      200.0,
    ],
    [
      5,
      1.4,
      500.0,
    ],
    [
      6,
      1.5,
      1000.0,
    ],
    [
      7,
      1.6,
      2000.0,
    ],
    [
      8,
      1.7,
      3000.0,
    ],
    [
      9,
      1.8,
      4000.0,
    ],
    [
      10,
      2.0,
      5000.0,
    ],
  ];
}
