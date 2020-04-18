import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/unlockNewTreeLevel.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/primary_btn.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:provider/provider.dart';

class TopLevelMergeWidget extends StatefulWidget {
  final Function onReceivedResultFun;

  TopLevelMergeWidget({Key key, this.onReceivedResultFun}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TopLevelMergeWidgetState();

  bool _enableClose = true;

  bool enableClose() => _enableClose;
}

class TopLevelMergeWidgetState extends State<TopLevelMergeWidget>
    with SingleTickerProviderStateMixin {
  int runCount = 0;
  List inOrder = [0, 1, 2, 3, 5, 9, 8, 7, 6, 4];
  List circleOrder = [0, 1, 2, 3, 9, 4, 8, 7, 6, 5];
  Timer timer;
  bool enableOnTap = true;
  UnlockNewTreeLevel newLevel;
  int position;

  // 选中的树的类型
  String curTreeType;

  // 选中的树的名字
  String curTreeName;

  // 基础圈数, 一圈走动10次
  static const int Default_Turns = 10;

  List treeTypeListInOrder = [
    TreeType.Type_Wishing,
    TreeType.Type_Continents_Asian,
    TreeType.Type_TimeLimited_Bonus,
    TreeType.Type_Continents_African,
    TreeType.Type_Globle_Bonus,
    TreeType.Type_Continents_American,
    TreeType.Type_Hops_Male,
    TreeType.Type_Continents_European,
    TreeType.Type_Hops_Female,
    TreeType.Type_Continents_Oceania,
  ];

  List treeNameListInOrder = [
    "Wishing Tree",
    "Asian Tree",
    "Limited Time Bonus Tree",
    "African Tree",
    "Bonus tree",
    "American Tree",
    "Hop Tree(male)",
    "European Tree",
    "Hop Tree(Female)",
    "Oceania Tree",
  ];

  List sizeList = [
    [158, 174],
    [158, 154],
    [178, 154],
    [173, 151],
    [164, 153],
    [171, 154],
    [175, 154],
    [175, 149],
    [178, 151],
    [178, 155],
  ];

  @override
  void initState() {
    super.initState();
  }

  void start() {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    _lotteryTimer();
    checkBonusTreeWhenUnlockingTopLevel(treeGroup?.acct_id, Tree.MAX_LEVEL)
        .then((result) {
      // 获取指定位置
      if (result?.tree_type == null || result?.tree_type == 0) {
        Layer.toastWarning("Unable to merge");
        return;
      }

      newLevel = result;
      position = getPositionWithType(result.tree_type);
      // position = 1;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  /**
      const GIFT_TYPE_NONE = 0; // 没有奖品
      const GIFT_TYPE_TIME_LIMIT_TREE = 1; // 限时分红树
      const GIFT_TYPE_GLOBAL_TREE = 2; // 全球分红树
      const GIFT_TYPE_FEMALE_FLOWER = 3;  // 雌花
      const GIFT_TYPE_MALE_FLOWER = 4; // 雄花
      const GIFT_TYPE_WISH_TREE = 5;  // 许愿树
      const GIFT_TYPE_AMERICAN_TREE = 6; //美洲
      const GIFT_TYPE_EUROPEAN_TREE = 7; //欧洲
      const GIFT_TYPE_ASIAN_TREE = 8; // 亚洲
      const GIFT_TYPE_OCEANIA_TREE = 9; // 大洋洲
      const GIFT_TYPE_AFRICAN_TREE = 10; // 非洲树
   */
  Future<UnlockNewTreeLevel> checkBonusTreeWhenUnlockingTopLevel(
      String acctId, int level) async {
    dynamic stateMap =
        await Service().unlockNewLevel({'acct_id': acctId, "level": level});

    // 测试代码
    // dynamic stateMap;
    // String test =
    //     """{"tree_type": 10,"tree_id": 21,"amount": 11.0,"duration": 300}""";
    // stateMap = json.decode(test);

    if (stateMap == null) {
      return null;
    }
    UnlockNewTreeLevel newLevel = UnlockNewTreeLevel.fromJson(stateMap);
    return newLevel;
  }

  List<Color> colorsOnSpinBtn = const <Color>[
    Color(0xFF42CE66),
    Color(0xFF42CE66),
  ];

  toggleEnableStatue(bool enable) {
    if (!mounted) {
      return;
    }

    setState(() {
      if (!enable) {
        // 禁用时按钮颜色
        colorsOnSpinBtn = [
          Color(0xFF8CDC9F),
          Color(0xFF8CDC9F),
        ];
      } else {
        colorsOnSpinBtn = [
          Color(0xFF42CE66),
          Color(0xFF42CE66),
        ];
      }
      enableOnTap = enable;
      widget._enableClose = enable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
//          color: Colors.blue,
          image: DecorationImage(
              image: AssetImage("assets/image/top_level_merge_bg.png"),
              fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setWidth(30),
            horizontal: ScreenUtil().setWidth(30)),
        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(45)),
        child: gridWrapperView(),
      ),
      GestureDetector(
          onTap: enableOnTap
              ? () {
                  start();
                  toggleEnableStatue(false);
                }
              : null,
          child: PrimaryButton(
              width: 600,
              height: 124,
              colors: colorsOnSpinBtn,
              child: Center(
                  child: Text(
                "Spin",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  height: 1,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontFamily.bold,
                  fontSize: ScreenUtil().setWidth(52),
                ),
              ))))
    ]);
  }

  Widget gridWrapperView() {
    int index = 0;
    List wrap = List(10).map((val) {
      print(
          "gridWrapperView index= $index, ${sizeList[index][0]}, ${sizeList[index][1]}");
      return Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
          decoration: BoxDecoration(
//             color: Colors.red,
            image: index++ == inOrder[runCount % inOrder.length]
                ? DecorationImage(
                    alignment: Alignment.center,
                    image: AssetImage(
                        "assets/image/top_level_merge_item_selected.png"),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Container(
//               color: Colors.red,
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
              child: Image.asset(
                "assets/tree/merge/${treeTypeListInOrder[circleOrder[index - 1]]}.png",
                width: ScreenUtil().setWidth(sizeList[index - 1][0]),
                height: ScreenUtil().setWidth(sizeList[index - 1][1]),
              )));
    }).toList();

    wrap.insert(
        5,
        Container(
          width: ScreenUtil().setWidth(353),
          height: ScreenUtil().setWidth(220),
          decoration: BoxDecoration(
//              color: Colors.yellow,
              image: DecorationImage(
            image: AssetImage("assets/image/top_level_random_merge.png"),
            fit: BoxFit.cover,
          )),
        ));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
      child: Wrap(
          // spacing: ScreenUtil().setWidth(15),
//        runSpacing: ScreenUtil().setWidth(15),
          alignment: WrapAlignment.spaceAround,
//        runAlignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: wrap),
    );
  }

  // // 九宫格匀速计时器
  void _lotteryTimer() {
    timer = Timer(Duration(milliseconds: 200), () {
      setState(() {
        runCount = (runCount + 1);
        print("_lotteryTimer setState 中runCount的值为 $runCount");
      });

      if (runCount <= Default_Turns) {
        // 首先转动基础圈数，这个时候顺便等待抽奖接口异步结果
        _lotteryTimer();
      } else if (runCount <= Default_Turns * 2 + (position ?? 0) - 3) {
        // 转满基础圈数���，计算出多转一圈 + 结果索引 - 缓速步数，进行最后几步的匀速转动
        _lotteryTimer();
      } else if (position == null) {
        if (runCount >= Default_Turns * 2) {
          Layer.toastWarning("Failed, Try Again Later");
          //失败后启用按钮点击
          toggleEnableStatue(true);
          return;
        }
        _lotteryTimer();
      } else {
        // 匀速结果，进入开奖前缓速转动
        _slowLotteryTimer(300);
      }
    });
  }

  // 九��格缓速计时器
  void _slowLotteryTimer(ms) {
    print("_slowLotteryTimer 中runCount的值为 $runCount");
    timer = Timer(Duration(milliseconds: ms), () {
      setState(() {
        runCount++;
      });
      if (runCount < Default_Turns * 2 + position) {
        // 如果当前步数没有达到结果位置，继续缓速转动，并在下一步增长缓速时间，实现越来越慢的开奖效果
        _slowLotteryTimer((ms * 1.7).ceil());
      } else {
        // 已转到开奖位置，弹窗提醒
        print("开奖啦");
        widget.onReceivedResultFun(curTreeType, curTreeName, newLevel);
        timer?.cancel();
        timer = null;
      }
    });
  }

  int getPositionWithType(int type) {
    // 界面上对应的位置,1开始
    int position;
    switch (type) {
      case 1:
        position = 3;
        break;
      case 2:
        position = 5;
        break;
      case 3:
        position = 9;
        break;
      case 4:
        position = 7;
        break;
      case 5:
        position = 1;
        break;
      case 6:
        position = 6;
        break;
      case 7:
        position = 8;
        break;
      case 8:
        position = 2;
        break;
      case 9:
        position = 10;
        break;
      case 10:
        position = 4;
        break;
      default:
        return null;
    }

    curTreeType = treeTypeListInOrder[position - 1];
    curTreeName = treeNameListInOrder[position - 1];
    return position;
  }
}
