import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/pages/trip/game/huge_win.dart';
import 'package:luckyfruit/pages/trip/game/times_reward.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'dart:math';

import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/public/fourth_text.dart';
import 'package:luckyfruit/theme/public/modal_title.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:provider/provider.dart';

class LuckyWheelWidget extends StatefulWidget {
  Animation<double> animation;
  AnimationController controller;

  startSpin() {
    controller.value = 0;
    controller.forward();
  }

  @override
  State<StatefulWidget> createState() => LuckyWheelWidgetState();
}

class LuckyWheelWidgetState extends State<LuckyWheelWidget>
    with SingleTickerProviderStateMixin {
  // 当前旋转的角度
  double angle = 0;
  // 结束后要选中的位置，按设计图顶点位置(Big Win)从1开始顺时针排序，
  int finalPos = 0;
  Tween<double> curTween;
  // 默认3圈
  static const defaultNumOfTurns = 3 * 2 * pi;

  // 弱网环境下，最大尝试圈数，超过后还没有返回抽奖结果则放弃
  int maxRetryNum = 3;
  // 当前剩下的券的数量
  int ticketCount;
  String testJson = """{
        "gift_id": 2,
        "coin": 9000
    }""";

  initState() {
    super.initState();

    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    ticketCount = userModel?.value?.ticket;
    //TODO 测试
    ticketCount = 8;
    widget.controller = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

    Animation curve =
        CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut);

    // 要旋转的总弧度值
    double endRadian = defaultNumOfTurns;
    curTween = Tween<double>(begin: 0.0, end: endRadian);
    widget.animation = curTween.animate(curve)
      ..addListener(() {
        setState(() {
          print("setState() widget.animation.value= ${widget.animation.value}");
          // angle = widget.animation.value;
        });
      })
      ..addStatusListener((status) {
        print("status= $status, finalPos=$finalPos");
        if (status == AnimationStatus.completed) {
          if (finalPos <= 0) {
            if (maxRetryNum <= 0) {
              Layer.toastWarning("抽奖失败，请重试");
              widget.controller.reset();
            } else {
              maxRetryNum--;
              widget.controller.value = 0;
              widget.controller.forward();
            }
          } else {
            showRewardWindowWithFinalPostion(finalPos);
          }
        }
      });
  }

  Future<int> getLuckResult(BuildContext context) async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
    dynamic luckResultMap;
    // luckResultMap = await Service()
    //     .getLuckyWheelResult({'acct_id': treeGroup.acct_id, 'coin_speed': 100});

    //TODO 测试用 模拟一个网络请求状态
    await Future.delayed(Duration(seconds: 2));
    luckResultMap = json.decode(testJson);
    print("luckResultMap= $luckResultMap");
    finalPos = luckResultMap['gift_id'] as num;
    //TODO 测试
    finalPos = ticketCount;

    int coin = luckResultMap['coin'] as num;
    print("返回的gift_id=$finalPos，coin=$coin");
    return coin;
  }

  ///接口中取到结果后更新
  updateTween() {
    double needAngle = _getAngelWithSelectedPosition(finalPos);
    curTween.end = curTween.end + needAngle;
    if (widget.controller.isAnimating) {
      widget.controller.forward();
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(760),
            height: ScreenUtil().setWidth(760),
            // color: Colors.red,
            child: Image.asset(
              "assets/image/lucky_wheel_round_board.png",
            ),
          ),
          Transform.rotate(
            angle: widget.animation.value,
            child: Container(
              width: ScreenUtil().setWidth(700),
              height: ScreenUtil().setWidth(700),
              // color: Colors.green,
              child: Image.asset(
                "assets/image/lucky_wheel_gift_bg.png",
              ),
            ),
          ),
          Container(
              width: ScreenUtil().setWidth(300),
              height: ScreenUtil().setWidth(300),
              // color: Colors.blue,
              child: Image.asset(
                "assets/image/lucky_wheel_arrow.png",
              )),
        ],
      ),
      Container(
        // color: Colors.blue,
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(40),
          bottom: ScreenUtil().setWidth(40),
        ),
        child: ModalTitle("TICKET x ${ticketCount}"),
      ),
      Container(
        // color: Colors.red,
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setWidth(50),
        ),
        child: FourthText(
          "After depleted，you'll get 10 free tickets at 00:00",
          color: Color(0xFF7C7C7C),
        ),
      ),
      Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(90)),
          child: AdButton(
            btnText: ticketCount <= 0 ? 'Get 5 Tickets' : "Spin",
            useAd: ticketCount <= 0,
            onOk: () {
              if (ticketCount <= 0) {
                Layer.toastWarning("Tickets not enough, watch ad to get more");
                //TODO 添加抽奖券的逻辑
                Service().addTicket({'acct_id': 67}).then((value) {
                  if (value == null || value['code'] != 0) {
                    // 添加失败
                    Layer.toastWarning("Times used up");
                  } else {
                    // 添加成功
                    Layer.toastSuccess("Get Ticket Success");
                  }
                });
                return;
              }
              ticketCount--;

              // 重置为3
              maxRetryNum = 3;
              getLuckResult(context).then((coin) {
                updateTween();
              });
              curTween.end = defaultNumOfTurns;
              widget.startSpin();
            },
            tips: null,
          ))
    ]);
  }

  double _getAngelWithSelectedPosition(int pos) {
    var x = 0.14 * pi, y = 0.22 * pi, z = pi / 2;
    switch (pos) {
      case 8:
        return x + y;
        break;
      case 7:
        return z + x;
        break;
      case 6:
        return z + x + y;
        break;
      case 5:
        return 2 * z + x;
        break;
      case 4:
        return 2 * z + x + y;
        break;
      case 3:
        return 3 * z + x;
        break;
      case 2:
        print("_getAngelWithSelectedPosition $pos ${3 * z + x + y}");
        return 3 * z + x + y;
        break;
      case 1:
        return x;
        break;
      default:
        return 0;
    }
  }

  void showRewardWindowWithFinalPostion(int finalPosition) {
    switch (finalPosition) {
      case 8:
        Layer.show5TimesTreasureWindow(TimesRewardWidget.TYPE_5_TIMES);
        break;
      case 7:
        Layer.showLuckWheelWinResultWindow(
            LuckyWheelWinResultWindow.TYPE_MEGE_WIN);
        break;
      case 6:
        Layer.showLuckWheelWinResultWindow(
            LuckyWheelWinResultWindow.TYPE_HUGE_WIN);
        break;
      case 5:
        Layer.showLuckWheelWinResultWindow(
            LuckyWheelWinResultWindow.TYPE_JACKPOT_WIN);
        break;
      case 4:
        Layer.show5TimesTreasureWindow(TimesRewardWidget.TYPE_10_TIMES);
        break;
      case 3:
        Layer.showLuckWheelWinResultWindow(
            LuckyWheelWinResultWindow.TYPE_MEGE_WIN);
        break;
      case 2:
        Layer.showLuckWheelWinResultWindow(
            LuckyWheelWinResultWindow.TYPE_HUGE_WIN);
        break;
      case 1:
        Layer.showLuckWheelWinResultWindow(
            LuckyWheelWinResultWindow.TYPE_BIG_WIN);
        break;
      default:
        break;
    }
  }
}
