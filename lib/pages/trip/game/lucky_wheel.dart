import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/modal_title.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class LuckyWheelWrapperWidget extends StatelessWidget {
  final bool fromAppLaunch;

  LuckyWheelWrapperWidget({this.fromAppLaunch = false});

  void onCloseWindow(BuildContext context) {
    Navigator.pop(context);

    // 关闭之后检查是否需要开始auto merge
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    if (luckyGroup.autoMergeDurationFromLuckyWheel > 0) {
      luckyGroup.autoStart();
    }

    if (fromAppLaunch) {
      Layer.checkShowInviteEventOrPartnerCash(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: ScreenUtil().setWidth(844),
          height: ScreenUtil().setWidth(1240),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment(0.0, -1.0),
                end: Alignment(0.0, 1.0),
                colors: <Color>[
                  Color(0xffF1D34E),
                  Color(0xffF59A22),
                ]),
            borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtil().setWidth(100)),
            ),
          ),
          child: Stack(overflow: Overflow.visible, children: [
            Positioned(
                top: -ScreenUtil().setWidth(80),
                child: Container(
                    width: ScreenUtil().setWidth(844),
                    padding: EdgeInsets.symmetric(horizontal: 10),
//                    color: Colors.red,
                    child: LuckyWheelWidget(null, onCloseWindow))),
            Positioned(
                top: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onCloseWindow(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/image/close_icon_modal_bottom_center.png',
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
  final Function(BuildContext) onCloseCallback;

  LuckyWheelWidget(this.modal, this.onCloseCallback);

  @override
  State<StatefulWidget> createState() => LuckyWheelWidgetState();
}

class LuckyWheelWidgetState extends State<LuckyWheelWidget>
    with SingleTickerProviderStateMixin {
  // 当前旋转的角度
  double angle = 0;

  // 结束后要选中的位置，按设计图顶点位置(Big Win)从1开始顺时针排序，
  int finalPos = 0;

  // 上一次转到的位置，只在上次是翻倍奖励的时候返回，其他时候返回0
  int prevPos = 0;

  /// 返回限时分红树时的数据字段
  num treeId;
  double amount;
  int treeType;

  Tween<double> curTween;

  // 默认3圈
  static const defaultNumOfTurns = 3 * 2.0;

  Animation<double> animation;
  AnimationController controller;

  // 弱网环境下，最大尝试圈数，超过后还没有返回抽奖结果则放弃
  int maxRetryNum = 3;

  // 当前剩下的券的数量
  int ticketCount = 0;

  // 当前剩余观看广告次数，用尽后不能再触发点击
  int watchAdForTicketTimes = 0;
  String testJson = """{"gift_id":6,"coin":1000,"prev":0,"duration":6}""";

  num coinNum = 0;
  int watched_ad = 0;
  int durationOfAutoMerge = 0;

  startSpin() {
    // controller.value = 0;
    controller.forward();
  }

  initState() {
    super.initState();

    BurialReport.report('page_imp', {'page_code': '007'});
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    ticketCount = userModel?.value?.ticket;
    watchAdForTicketTimes = userModel?.value?.ticket_time ?? 0;
//    watchAdForTicketTimes = 10;
//    ticketCount = 3;
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
    luckResultMap = await Service().getLuckyWheelResultV2({
      'acct_id': treeGroup.acct_id,
      'coin_speed': treeGroup.makeGoldSped,
      'watched_ad': watched_ad
    });

    watched_ad = 0;
    // 测试用 模拟一个网络请求状态
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
//          Container(
//            width: ScreenUtil().setWidth(670),
//            height: ScreenUtil().setWidth(670),
////             color: Colors.red,
////            child: Image.asset(
////              "assets/image/lucky_wheel_round_board.png",
////            ),
//          ),
          RepaintBoundary(
            child: AnimatedBuilder(
                animation: animation,
                child: Container(
                  width: ScreenUtil().setWidth(770),
                  height: ScreenUtil().setWidth(770),
//                   color: Colors.green,
                  child: Image.asset(
                    "assets/image/lucky_wheel_gift_bg.png",
                    width: ScreenUtil().setWidth(700),
                    height: ScreenUtil().setWidth(700),
                  ),
                ),
                builder: (BuildContext context, Widget child) {
                  return Transform.rotate(
                    angle: animation.value * pi,
                    alignment: Alignment.center,
                    child: child,
                  );
                }),
          ),
          Container(
              width: ScreenUtil().setWidth(200),
              height: ScreenUtil().setWidth(226),
//               color: Colors.blue,
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
        child: ModalTitle(
          "Ticket x ${ticketCount < 0 ? 0 : ticketCount}",
          shadows: [
            BoxShadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 2)
          ],
          color: Colors.white,
        ),
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
//              color: Color(0xFF7C7C7C),
              shadows: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 1), blurRadius: 2)
              ],
              color: Colors.white,
              fontSize: ScreenUtil().setWidth(36),
              fontFamily: FontFamily.regular,
              fontWeight: FontWeight.w400),
        ),
      ),
      Container(
          padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(36)),
          child: Selector<UserModel, Tuple3<UserInfo, String, User>>(
            selector: (context, provider) => Tuple3(
                provider?.userInfo, provider?.value?.acct_id, provider.value),
            builder: (_, data, __) {
              bool disable = watchAdForTicketTimes <= 0 && ticketCount <= 0;
              String btnText = disable
                  ? "Tickets Used Up"
                  : ticketCount <= 0 ? 'Get 5 Tickets' : "Spin";
              return AdButton(
                  ad_code: '212',
                  adUnitIdFlag: 1,
                  adIconPath: "assets/image/ad_icon_white.png",
                  colorsOnBtn: <Color>[
                    Color(0xffF1D34E),
                    Color(0xffF59A22),
                  ],
                  colorsOnBtnDisabled: [
                    Color(0xffD4992B),
                    Color(0xffD4992B),
                  ],
                  btnText: btnText,
                  descText: "reset at 00:00",
                  colorOfDisableedText: Color(0xffEEDD9B),
                  useAd: ticketCount <= 0,
                  disable: disable,
                  onCancel: () {
                    if (widget?.modal != null) {
                      widget?.modal?.hide();
                    } else if (widget.onCloseCallback != null) {
                      widget.onCloseCallback(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  onOk: (isFromAd) {
                    if (controller.isAnimating) {
                      print("controller.isAnimating");
                      return;
                    }
                    if (ticketCount <= 0) {
                      BurialReport.report('spin_wheel', {'type': '2'});

                      // 观看广告添加抽奖券的逻辑 updateUser with ad_times
                      Service()
                          .addTicket({'acct_id': data?.item2}).then((value) {
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
                              data.item3.ticket += 5;
                              ticketCount = data.item3.ticket;

                              int watchAdTicketFromServer =
                                  value['data'] != null
                                      ? value['data']['times']
                                      : 0;

                              print(
                                  "watchAdTicketFromServer_${watchAdTicketFromServer},"
                                  " originalTimes_${watchAdForTicketTimes}");
                              if (watchAdTicketFromServer > 0) {
                                data.item3.ticket_time =
                                    watchAdTicketFromServer;
                              } else {
                                data.item3.ticket_time--;
                              }
                              watchAdForTicketTimes = data.item3.ticket_time;

                              if (watchAdForTicketTimes <= 0) {
                                // 不能转大转盘了，则隐藏红点
                                LuckyGroup luckyGroup = Provider.of<LuckyGroup>(
                                    context,
                                    listen: false);
                                luckyGroup.setShowLuckyWheelDot(false);
                              }
                            });
                          }
                        }
                      });
                      return;
                    }
                    BurialReport.report('spin_wheel', {'type': '1'});

                    handleStartSpin(data?.item3);
                  },
                  tipsColor: Colors.white,
                  tipsShadows: [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 1),
                        blurRadius: 2)
                  ],
                  tips:
                      "Number of videos reset at 12am&12pm (${data?.item1?.ad_times ?? 0} times left)");
            },
          ))
    ]);
  }

  handleStartSpin(User user) {
    // 重置为3
    maxRetryNum = 3;
    finalPos = -1;
    prevPos = 0;
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
      prevPos = luckResultMap['prev'] as num;
      coinNum = luckResultMap['coin'] as num;
      durationOfAutoMerge = luckResultMap['duration'] as num;

      /// 以下是得到限时分红树时才会返回的
      treeId = luckResultMap['tree_id'] as num;
      amount = luckResultMap['amount'] as num;

      print("返回的gift_id=$finalPos，coin=$coinNum, "
          "durationOfAutoMerge=$durationOfAutoMerge, treeId=$treeId, amout=$amount");

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
    var x = 2 / 6;
    switch (pos) {
      case 6:
        return 3 / 2 * x;
        break;
      case 5:
        return 5 / 2 * x;
        break;
      case 4:
        return 7 / 2 * x;
        break;
      case 3:
        return 9 / 2 * x;
        break;
      case 2:
        return 11 / 2 * x;
        break;
      case 1:
        return 1 / 2 * x;
        break;
      default:
        return 0;
    }
  }

  /**
   *  1、1hour coins                   Huge
      2、The limited Bouns Tree
      3、15min  coins                  Big
      4、auto merge
      5、30min coins                   Mega
      6、attack
   */
  void showRewardWindowWithFinalPostion(int finalPosition) {
    switch (finalPosition) {
      case 1:
        // huge，1hour coin
        break;
      case 2:
        // The limited Bouns Tree
        break;
      case 3:
        // big，15min coin
        break;
      case 4:
        // 转到auto merge，每次一分钟
        LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
        luckyGroup.autoMergeDurationFromLuckyWheel += durationOfAutoMerge;
        Layer.showAutoMergeInLuckyWheel();
        return;
      case 5:
      // mega，30min coin
        break;
      case 6:
      // attack
        break;
      default:
        Layer.toastWarning("Failed, Please Try Agagin Later");
        return;
    }
  }
}
