import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/pages/trip/game/huge_win.dart';
import 'package:luckyfruit/pages/trip/game/times_reward.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'dart:math';

import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/modal_title.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class LuckyWheelWrapperWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
      body: Center(
        child: Container(
          width: ScreenUtil().setWidth(900),
          height: ScreenUtil().setWidth(1140),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtil().setWidth(100)),
            ),
          ),
          child: Stack(overflow: Overflow.visible, children: [
            Positioned(
                top: -ScreenUtil().setWidth(54),
                child: Container(
                    width: ScreenUtil().setWidth(900),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: LuckyWheelWidget(null))),
            Positioned(
                top: ScreenUtil().setWidth(60),
                right: ScreenUtil().setWidth(60),
                child: Container(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/image/close_icon_modal_top_right.png',
                      width: ScreenUtil().setWidth(40),
                      height: ScreenUtil().setWidth(40),
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}

class LuckyWheelWidget extends StatefulWidget {
  Modal modal;

  LuckyWheelWidget(this.modal);

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
  static const defaultNumOfTurns = 3 * 2.0;

  Animation<double> animation;
  AnimationController controller;

  // 弱网环境下，最大尝试圈数，超过后还没有返回抽奖结果则放弃
  int maxRetryNum = 3;
  // 当前剩下的券的数量
  int ticketCount = 0;
  String testJson = """{
        "gift_id": 2,
        "coin": 9300
    }""";

  num coinNum = 0;

  startSpin() {
    // controller.value = 0;
    controller.forward();
  }

  initState() {
    super.initState();

    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    ticketCount = userModel?.value?.ticket;
    // ticketCount = 8;
    controller = new AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    Animation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    // 要旋转的总弧度值
    double endRadian = defaultNumOfTurns;
    curTween = Tween<double>(begin: 0.0, end: endRadian);
    animation = curTween.animate(curve)
      // ..addListener(() {
      //   if (mounted)
      //     setState(() {
      //       // print(
      //       //     "setState() animation.value= ${animation.value}, controller.value= ${controller.value}");
      //       // angle = animation.value;
      //     });
      // })
      ..addStatusListener((status) {
        print("status= $status, finalPos=$finalPos");
        if (status == AnimationStatus.completed) {
          if (finalPos <= 0) {
            if (maxRetryNum <= 0) {
              Layer.toastWarning("Failed, Try Agagin Later");
              controller.reset();
            } else {
              maxRetryNum--;
              controller.value = 0;
              controller.forward();
            }
          } else {
            showRewardWindowWithFinalPostion(finalPos);
          }
        }
      });
  }

  Future<dynamic> getLuckResult(BuildContext context) async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
    dynamic luckResultMap;
    luckResultMap = await Service().getLuckyWheelResult(
        {'acct_id': treeGroup.acct_id, 'coin_speed': treeGroup.makeGoldSped});

    //TODO 测试用 模拟一个网络请求状态
    // luckResultMap = json.decode(testJson);
    print("luckResultMap= $luckResultMap");
    return luckResultMap;
  }

  ///接口中取到结果后更新
  updateTween() {
    double needAngle = _getAngelWithSelectedPosition(finalPos);
    curTween.end = curTween.end + needAngle;
    if (controller.isAnimating) {
      controller.forward();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(670),
            height: ScreenUtil().setWidth(670),
            // color: Colors.red,
            child: Image.asset(
              "assets/image/lucky_wheel_round_board.png",
            ),
          ),
          RepaintBoundary(
            child: AnimatedBuilder(
                animation: animation,
                child: Container(
                  width: ScreenUtil().setWidth(600),
                  height: ScreenUtil().setWidth(600),
                  // color: Colors.green,
                  child: Image.asset(
                    "assets/image/lucky_wheel_gift_bg.png",
                    width: ScreenUtil().setWidth(600),
                    height: ScreenUtil().setWidth(600),
                  ),
                ),
                builder: (BuildContext context, Widget child) {
                  print(animation.value);
                  return Transform.rotate(
                    angle: animation.value * pi,
                    alignment: Alignment.center,
                    child: child,
                  );
                }),
          ),
          Container(
              width: ScreenUtil().setWidth(270),
              height: ScreenUtil().setWidth(270),
              // color: Colors.blue,
              child: Image.asset(
                "assets/image/lucky_wheel_arrow.png",
              )),
        ],
      ),
      Container(
        // color: Colors.blue,
        margin: EdgeInsets.only(
          top: ScreenUtil().setWidth(20),
          // bottom: ScreenUtil().setWidth(30),
        ),
        child: ModalTitle("TICKET x ${ticketCount < 0 ? 0 : ticketCount}"),
      ),
      Container(
        // color: Colors.red,
        margin: EdgeInsets.only(
          bottom: ScreenUtil().setWidth(45),
        ),
        child: Text(
          "After depleted，\nyou'll get 10 free tickets at 00:00",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xFF7C7C7C),
              fontSize: ScreenUtil().setWidth(36),
              fontFamily: FontFamily.regular,
              fontWeight: FontWeight.w400),
        ),
      ),
      Padding(
          padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(36)),
          child: Selector<UserModel, Tuple3<UserInfo, String, User>>(
            selector: (context, provider) => Tuple3(
                provider?.userInfo, provider?.value?.acct_id, provider.value),
            builder: (_, data, __) {
              return AdButton(
                btnText: ticketCount <= 0 ? 'Get 5 Tickets' : "Spin",
                useAd: ticketCount <= 0,
                onCancel: () {
                  widget?.modal?.hide();
                },
                onOk: () {
                  if (controller.isAnimating) {
                    print("controller.isAnimating");
                    return;
                  }

                  if (ticketCount <= 0) {
                    //TODO 观看广告添加抽奖券的逻辑 updateUser with ad_times
                    Service().addTicket({'acct_id': data?.item2}).then((value) {
                      // 到这里不管addTicket接口返回成功或失败, 广告次数都已经用过一次了
                      if (value == null || value['code'] != 0) {
                        // 添加失败
                        Layer.toastWarning("Tickets Times used up");
                        if (mounted) setState(() {});
                      } else {
                        // 添加成功
                        Layer.toastSuccess("Get Ticket Success");
                        // handleStartSpin(data?.item3);

                        if (mounted) {
                          setState(() {
                            // 得到了5张券,更新本地数量
                            // TODO 是否是增加5次?还是从接口取?
                            data.item3.ticket += 5;
                            ticketCount = data.item3.ticket;
                          });
                        }
                      }
                    });
                    return;
                  }

                  handleStartSpin(data?.item3);
                },
                tips: ticketCount <= 0
                    ? "Number of videos reset at 12:00 am&pm (${data?.item1?.ad_times ?? 0} times left)"
                    : null,
              );
            },
          ))
    ]);
  }

  handleStartSpin(User user) {
    // 重置为3
    maxRetryNum = 3;
    getLuckResult(context).then((luckResultMap) {
      if (luckResultMap == null) {
        print("luckResultMap = null");
        // 动态设置断点
        debugger(when: luckResultMap == null);
        finalPos = -1;
        updateTween();
        return;
      }
      finalPos = luckResultMap['gift_id'] as num;
      coinNum = luckResultMap['coin'] as num;
      print("返回的gift_id=$finalPos，coin=$coinNum");

      if (mounted) {
        setState(() {
          ticketCount--;
          user?.ticket = ticketCount < 0 ? 0 : ticketCount;
        });
      }

      updateTween();
    });
    curTween.end = defaultNumOfTurns;

    controller.value = _getAngelWithSelectedPosition(finalPos) /
        ((animation.value) + _getAngelWithSelectedPosition(finalPos));
    startSpin();
  }

  double _getAngelWithSelectedPosition(int pos) {
    var x = 0.14, y = 0.22, z = 1 / 2;
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
    int luckyWheelType;
    switch (finalPosition) {
      case 8:
        Layer.show5TimesTreasureWindow(TimesRewardWidget.TYPE_5_TIMES);
        return;
      case 7:
        luckyWheelType = LuckyWheelWinResultWindow.TYPE_MEGE_WIN;
        break;
      case 6:
        luckyWheelType = LuckyWheelWinResultWindow.TYPE_HUGE_WIN;
        break;
      case 5:
        luckyWheelType = LuckyWheelWinResultWindow.TYPE_JACKPOT_WIN;
        break;
      case 4:
        Layer.show5TimesTreasureWindow(TimesRewardWidget.TYPE_10_TIMES);
        return;
      case 3:
        luckyWheelType = LuckyWheelWinResultWindow.TYPE_MEGE_WIN;
        break;
      case 2:
        luckyWheelType = LuckyWheelWinResultWindow.TYPE_HUGE_WIN;
        break;
      case 1:
        luckyWheelType = LuckyWheelWinResultWindow.TYPE_BIG_WIN;
        break;
      default:
        break;
    }

    Layer.showLuckWheelWinResultWindow(luckyWheelType, coinNum);
    //将获取的金币增加到账户上
    EVENT_BUS.emit(MoneyGroup.ADD_GOLD, coinNum.toDouble());
  }
}
