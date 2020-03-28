import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/primary_btn.dart';

class TopLevelMergeWidget extends StatefulWidget {
  final Function onReceivedResultFun;

  TopLevelMergeWidget({Key key, this.onReceivedResultFun}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TopLevelMergeWidgetState();
}

class TopLevelMergeWidgetState extends State<TopLevelMergeWidget>
    with SingleTickerProviderStateMixin {
  int runCount = 0;
  List inOrder = [0, 1, 2, 3, 5, 9, 8, 7, 6, 4];
  Timer timer;
  bool enableOnTap = true;
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 2), () {
    //   _lotteryTimer();
    // });
  }

  void start() {
    _lotteryTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        // color: Colors.red,
        // width: 800,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/image/top_level_merge_bg.png"),
              fit: BoxFit.fill),
        ),
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setWidth(40),
            horizontal: ScreenUtil().setWidth(50)),

        margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(45)),
        child: gridWrapperView(),
      ),
      GestureDetector(
          onTap: enableOnTap
              ? () {
                  setState(() {
                    enableOnTap = false;
                    Future.delayed(Duration(milliseconds: 200), () {
                      _lotteryTimer();
                    });
                  });
                }
              : null,
          child: PrimaryButton(
              width: 600,
              height: 124,
              child: Center(
                  child: Text(
                "Claim",
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
      print("gridWrapperView index= $index");
      return Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          decoration: BoxDecoration(
            // color: Colors.red,
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
              // color: Colors.green,
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              child: Image.asset(
                "assets/image/dividend_tree.png",
                width: ScreenUtil().setWidth(130),
                height: ScreenUtil().setWidth(142),
              )));
    }).toList();

    wrap.insert(
        5,
        Container(
            // colofr: Colors.yellow,
            width: ScreenUtil().setWidth(365),
            height: ScreenUtil().setWidth(142),
            alignment: Alignment.center,
            child: Center(
                child: Stack(children: <Widget>[
              Text(
                "Random \nMerge",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1,
                    foreground: new Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = ScreenUtil().setWidth(15)
                      ..color = Color(0xFF36B45A),
                    fontFamily: FontFamily.bold,
                    fontSize: ScreenUtil().setSp(56),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Random \nMerge",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    height: 1,
                    fontFamily: FontFamily.bold,
                    fontSize: ScreenUtil().setSp(56),
                    fontWeight: FontWeight.bold),
              )
            ]))));

    return Wrap(
        spacing: ScreenUtil().setWidth(25),
        runSpacing: ScreenUtil().setWidth(25),
        alignment: WrapAlignment.center,
        children: wrap);
  }

  // // 九宫格匀速计时器
  void _lotteryTimer() {
    timer = Timer(Duration(milliseconds: 200), () {
      setState(() {
        runCount = (runCount + 1);
        print("_lotteryTimer setState 中runCount的值为 $runCount");
      });

      if (runCount <= 10) {
        // 首先转动基础圈数，这个时候顺便等待抽奖接口异步结果
        _lotteryTimer();
      } else if (runCount <= 10 * (1 + 1) + 2 - 3) {
        // 转满基础圈数后，计算出多转一圈 + 结果索引 - 缓速步数，进行最后几步的匀速转动
        _lotteryTimer();
      } else {
        // 匀速结果，进入开奖前缓速转动
        _slowLotteryTimer(300);
      }
    });
  }

  // 九宫格缓速计时器
  void _slowLotteryTimer(ms) {
    print("_slowLotteryTimer 中runCount的值为 $runCount");
    timer = Timer(Duration(milliseconds: ms), () {
      setState(() {
        runCount++;
      });
      if (runCount < 10 * (1 + 1) + 2) {
        // 如果当前步数没有达到结果位置，继续缓速转动，并在下一步增长缓速时间，实现越来越慢的开奖效果
        _slowLotteryTimer((ms * 1.7).ceil());
      } else {
        // 已转到开奖位置，弹窗提醒
        print("开奖啦》》》");
        widget.onReceivedResultFun();
        timer?.cancel();
        timer = null;
      }
    });
  }
}
