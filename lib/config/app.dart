// 放全局的事件句柄
import 'package:flutter/material.dart';

class Event_Name {
  // APP退出
  static const APP_PAUSED = 'APP_PAUSED';
  static const APP_RESUMED = 'APP_RESUMED';

  static const JUMP_TO_HOME = 'JUMP_TO_HOME';
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
  // 更新弹幕时间间隔
  static const int BarrageTimer = 5 * 60;

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
  static GlobalKey globalKeyBottomBar = new GlobalKey(debugLabel: 'key_bottom_bar');
  static GlobalKey globalKeyWheel = new GlobalKey(debugLabel: 'key_lucky_wheel');
  static GlobalKey globalKeyAddTreeBtn = new GlobalKey(debugLabel: 'key_add_tree');
  static GlobalKey globalKeyTreeGrid = new GlobalKey(debugLabel: 'key_tree_grid');
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

  static const Map TreeBottomColorList = {
    "1": [Color.fromRGBO(47, 229, 114, 1), Color.fromRGBO(33, 223, 110, 1)],
    "2": [Color.fromRGBO(32, 194, 69, 1), Color.fromRGBO(66, 204, 98, 1)],
    "3": [Color.fromRGBO(49, 217, 124, 1), Color.fromRGBO(66, 204, 98, 1)],
    "4": [Color.fromRGBO(61, 223, 132, 1), Color.fromRGBO(58, 209, 144, 1)],
    "5": [Color.fromRGBO(84, 205, 95, 1), Color.fromRGBO(72, 190, 82, 1)],
    "6": [Color.fromRGBO(49, 208, 154, 1), Color.fromRGBO(38, 190, 123, 1)],
    "7": [Color.fromRGBO(2, 198, 117, 1), Color.fromRGBO(0, 177, 82, 1)],
    "8": [Color.fromRGBO(0, 201, 53, 1), Color.fromRGBO(11, 180, 62, 1)],
    "9": [Color.fromRGBO(53, 202, 120, 1), Color.fromRGBO(34, 177, 45, 1)],
    "10": [Color.fromRGBO(21, 190, 116, 1), Color.fromRGBO(9, 153, 55, 1)],
    "11": [Color.fromRGBO(149, 192, 31, 1), Color.fromRGBO(97, 179, 22, 1)],
    "12": [Color.fromRGBO(27, 217, 34, 1), Color.fromRGBO(42, 177, 17, 1)],
    "13": [Color.fromRGBO(130, 220, 32, 1), Color.fromRGBO(105, 195, 24, 1)],
    "14": [Color.fromRGBO(129, 187, 0, 1), Color.fromRGBO(156, 175, 0, 1)],
    "15": [Color.fromRGBO(187, 214, 34, 1), Color.fromRGBO(166, 196, 13, 1)],
    "16": [Color.fromRGBO(230, 230, 18, 1), Color.fromRGBO(198, 195, 4, 1)],
    "17": [Color.fromRGBO(206, 208, 9, 1), Color.fromRGBO(181, 183, 0, 1)],
    "18": [Color.fromRGBO(243, 223, 47, 1), Color.fromRGBO(219, 178, 25, 1)],
    "19": [Color.fromRGBO(245, 183, 14, 1), Color.fromRGBO(236, 158, 12, 1)],
    "20": [Color.fromRGBO(232, 112, 25, 1), Color.fromRGBO(221, 84, 18, 1)],
    "21": [Color.fromRGBO(115, 178, 7, 1), Color.fromRGBO(109, 165, 14, 1)],
    "22": [Color.fromRGBO(145, 204, 0, 1), Color.fromRGBO(135, 180, 0, 1)],
    "23": [Color.fromRGBO(153, 204, 102, 1), Color.fromRGBO(106, 165, 52, 1)],
    "24": [Color.fromRGBO(145, 158, 29, 1), Color.fromRGBO(130, 140, 39, 1)],
    "25": [Color.fromRGBO(101, 202, 101, 1), Color.fromRGBO(77, 176, 77, 1)],
    "26": [Color.fromRGBO(130, 228, 65, 1), Color.fromRGBO(77, 195, 20, 1)],
    "27": [Color.fromRGBO(79, 226, 45, 1), Color.fromRGBO(49, 210, 18, 1)],
    "28": [Color.fromRGBO(121, 246, 91, 1), Color.fromRGBO(50, 222, 63, 1)],
    "29": [Color.fromRGBO(12, 237, 126, 1), Color.fromRGBO(2, 212, 86, 1)],
    "30": [Color.fromRGBO(8, 227, 138, 1), Color.fromRGBO(0, 198, 104, 1)],
    "31": [Color.fromRGBO(40, 198, 152, 1), Color.fromRGBO(2, 164, 126, 1)],
    "32": [Color.fromRGBO(35, 220, 79, 1), Color.fromRGBO(18, 169, 56, 1)],
    "33": [Color.fromRGBO(105, 220, 22, 1), Color.fromRGBO(68, 177, 14, 1)],
    "34": [Color.fromRGBO(167, 210, 40, 1), Color.fromRGBO(116, 165, 30, 1)],
    "35": [Color.fromRGBO(169, 201, 19, 1), Color.fromRGBO(166, 186, 17, 1)],
    "36": [Color.fromRGBO(217, 196, 35, 1), Color.fromRGBO(199, 176, 32, 1)],
    "37": [Color.fromRGBO(237, 194, 12, 1), Color.fromRGBO(226, 157, 20, 1)],
    "38": [Colors.yellow, Colors.orange],
  };
}
