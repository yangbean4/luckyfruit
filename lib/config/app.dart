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

  static const String message_notification = 'message_notification';

  static const String set_message_notification = 'set_message_notification';
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
  static String appVersion = "";
  // 存储金币的时间间隔 单位秒
  static const int SAVE_INTERVAL = 30;
  // 离线也有收益的时长 单位秒
  static const num UN_LINE_TIME = 2 * 60 * 60;
  // 离线时长小于10分钟 没有离线奖励
  static const num NO_UN_LINE_TIME = 10 * 60;

  static const String AESKEY = '06BB48CFA768694D';
  static const String BASE_URL =
      'http://171.8.199.211:8109/public/index.php?r=';
  static const String METHOD_CHANNEL = "com.bean.flutterchannel/method";
  static const String EVENT_CHANNEL = "com.bean.flutterchannel/event";

  static const SETTING_PRIVACY_URL =
      "https://docs.google.com/document/d/e/2PACX-1vRK9NVeaDGbetbE3uTfpd5q7PtbFkEUbmsFK9kOKJfcXLMAXqEewlrjzeOoUP2xLxfShrYmDYfBdY80/pub";
  static const SETTING_TERMS_URL =
      "https://docs.google.com/document/d/e/2PACX-1vTYBsMQvFgHM65YgTbjjVaxp2hXH9k5jVgzKsHSI_rwnyTEE7KycVzNTj9fPxxlt8fSwiMTPBuHE3dA/pub";

  // 运行在release模式时为true,为debug或Profile模式时为false
  static const IS_IN_RELEASE = bool.fromEnvironment("dart.vm.product");
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

  /// 能获取奖励的树(特指限时分红树)
  static const Type_TimeLimited_Bonus = "bonus";

  /// 啤酒花雌树
  static const Type_Hops_Female = "hops_female";

  /// 五洲树
  static const Type_Continents_Asian = "continents_asian";
  static const Type_Continents_African = "continents_african";
  static const Type_Continents_American = "continents_american";
  static const Type_Continents_European = "continents_european";
  static const Type_Continents_Oceania = "continents_oceania";

  /// 五洲树列表
  static const Continents_Trees_List = [
    Type_Continents_Asian,
    Type_Continents_African,
    Type_Continents_American,
    Type_Continents_European,
    Type_Continents_Oceania
  ];

  /// 雌雄花树
  static const Hops_Trees_List = [Type_Hops_Male, Type_Hops_Female];

  /// 全部最高等级树
  static const All_Max_Level_Trees = [
    Type_Globle_Bonus,
    Type_Wishing,
    Type_Hops_Male,
    Type_Hops_Female,
    Type_Continents_American,
    Type_Continents_European,
    Type_Continents_Asian,
    Type_Continents_African,
    Type_Continents_Oceania,
    Type_TimeLimited_Bonus,
  ];
}

/// 放置常量的类
class Consts {
  // 手动切换底部栏使用
  static GlobalKey globalKey = new GlobalKey(debugLabel: 'key_bottom_bar');
  static final String SP_KEY_GUIDANCE_WELCOME = "sp_key_guidance_welcome";
  static final String SP_KEY_GUIDANCE_MAP = "sp_key_guidance_map";
  static final String SP_KEY_GUIDANCE_WHEEL = "sp_key_guidance_wheel";
  static final String SP_KEY_UNLOCK_WHEEL = "sp_key_unlock_wheel";

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

  /// grade1到grade37级别的树木名称
  static const TreeNameWithGrade = [
    "Grape Tree",
    "Noni Fruit Tree",
    "Papaya Tree",
    "Guava Tree",
    "Cactus Tree",
    "Mexican Persimmon Tree",
    "Soursop Tree",
    "Gerber Fruit Tree",
    "Cherries Tree",
    "Avocado Tree",
    "Blueberry Tree",
    "Apple Tree",
    "Apricot Tree",
    "Nectarine Tree",
    "Fig Tree",
    "Pear Tree",
    "Pomegranate Tree",
    "Blackcurrant Tree",
    "Raspberry Tree",
    "Olive Tree",
    "Pineapple Tree",
    "Pitaya Tree",
    "Banana Tree",
    "Date Palm Tree",
    "Coconut Tree",
    "Orange Tree",
    "Litchi Tree",
    "Grapefruit Tree",
    "Longan Tree",
    "Mango Tree",
    "Rambutan Tree",
    "Durian Tree",
    "Mulberry Tree",
    "Jackfruit Tree",
    "Mangosteen Tree",
    "Star Fruit Tree",
    "Waxapple Tree"
  ];

  /// 全部38级别的树木,带有type
  static const TreeNameWithType = {
    TreeType.Type_Continents_Asian: "Asian Tree",
    TreeType.Type_Continents_African: "African Tree",
    TreeType.Type_Continents_Oceania: "Oceania Tree",
    TreeType.Type_Continents_European: "European Tree",
    TreeType.Type_Continents_American: "American Tree",
    TreeType.Type_Hops_Female: "Hops Tree(female)",
    TreeType.Type_Hops_Male: "Hops Tree(male)",
    TreeType.Type_Wishing: "Wishing Tree",
    TreeType.Type_TimeLimited_Bonus: "Limited Time Bouns Tree",
    TreeType.Type_Globle_Bonus: "Bouns Tree"
  };
}
