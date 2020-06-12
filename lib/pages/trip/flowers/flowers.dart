/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-28 15:32:27
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-12 18:23:03
 */
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/invite_award.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/pages/trip/garden_news/garden_news.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/widgets/expand_animation.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/widgets/receive_award_animate.dart';
import 'package:luckyfruit/widgets/opcity_animation.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Flowers extends StatefulWidget {
  bool showMsg = false;
  Function showMsgHandel;

  Flowers({Key key, this.showMsg, this.showMsgHandel}) : super(key: key);

  @override
  _FlowersState createState() => _FlowersState();
}

class _FlowersState extends State<Flowers> with TickerProviderStateMixin {
  bool showAnimation = false;
  GifController gifController;
  AnimationController _controller;
  bool dialogIsShow = false;
  int period = 500;
  // 花瓣数目队列
  List<int> flowerNumber = [];
  bool showAddFlowerAnimation = false;

  Offset getPhonePositionInfoWithGlobalKey(GlobalKey globalKey) {
    Offset offset = Offset(0, 0);
    RenderBox renderBox = globalKey.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    return offset;
  }

  @override
  void initState() {
    super.initState();
// bus通知执行动画， 如果没执行完 先中止上次的动画，然后开始新的动画
    EVENT_BUS.on(TreeGroup.ADD_FLOWER_NUMBER, (_) {
      if (showAnimation || showAddFlowerAnimation) {
        animateEnd();
      }
      flowerNumber.add(_);
      Future.delayed(Duration(microseconds: 10)).then((e) {
        setState(() {
          showAddFlowerAnimation = true;
        });
      });
    });

    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        print(status);
        if (status == AnimationStatus.completed) {
          Offset offsetEnd =
              getPhonePositionInfoWithGlobalKey(Consts.globalKeyFlowerPosition);
          _controller.reset();

          if (offsetEnd.dx > 0) {
            _showSpin();
          } else {
            _controller.forward();
          }
        }
      });
    gifController = GifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gifController.repeat(
          min: 0, max: 9, period: Duration(milliseconds: period));
    });
  }

  animateEnd() {
    if (flowerNumber[0] != null) {
      TreeGroup tourismMap = Provider.of<TreeGroup>(context, listen: false);
      tourismMap.hasFlowerCount += flowerNumber[0];
      flowerNumber.removeAt(0);
    }

    setState(() {
      showAnimation = false;
      showAddFlowerAnimation = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    gifController.dispose();
    super.dispose();
  }

  _showSpin() {
    if (!dialogIsShow) {
      dialogIsShow = true;
      showDialog(
          context: context,
          builder: (_) => _LuckyModel(onClose: () {
                dialogIsShow = false;
              }));
    }
  }

  @override
  Widget build(BuildContext context) {
    int width = 740;

    return Positioned(
        bottom: ScreenUtil().setWidth(910),
        right: ScreenUtil().setWidth(60),
        child: Container(
            width: ScreenUtil().setWidth(960),
            height: ScreenUtil().setWidth(105),
            // color: Colors.red,
            // level flowernumber animationUseflower
            child: Selector<TreeGroup, Tuple2<int, int>>(
              selector: (context, provider) => Tuple2(
                provider.hasMaxLevel,
                provider.hasFlowerCount,
              ),
              builder: (_, data, __) {
                int level = data.item1;
                int flowernumber = data.item2;

                double flowersProgess =
                    min(flowernumber / TreeGroup.FLOWER_LUCKY_NUMBER, 1);
                return Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      left: ScreenUtil().setWidth((960 - width) / 2),
                      top: ScreenUtil().setWidth(22),
                      child: Container(
                        width: ScreenUtil().setWidth(width),
                        height: ScreenUtil().setWidth(50),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/image/flower/img_red.png'),
                                alignment: Alignment.center,
                                repeat: ImageRepeat.repeatX,
                                fit: BoxFit.contain)),
                        child: null,
                      ),
                    ),
                    showAnimation
                        ? Positioned(
                            left: ScreenUtil().setWidth((960 - width) / 2),
                            top: ScreenUtil().setWidth(22),
                            child: Container(
                              width: ScreenUtil().setWidth(width),
                              height: ScreenUtil().setWidth(50),
                              child: GifImage(
                                controller: gifController,
                                image: AssetImage("assets/image/flower/sg.gif"),
                              ),
                            ),
                          )
                        : Container(),
                    // Positioned(
                    //   left: ScreenUtil().setWidth((960 - width) / 2),
                    //   top: ScreenUtil().setWidth(22),
                    //   child: Container(
                    //     width: ScreenUtil().setWidth(width),
                    //     height: ScreenUtil().setWidth(50),
                    //     child: GifImage(
                    //       controller: gifController,
                    //       image: AssetImage("assets/image/flower/sg.gif"),
                    //     ),
                    //     // child: Lottie.asset(
                    //     //   'assets/lottiefiles/flower_light/data.json',
                    //     //   width: ScreenUtil().setWidth(180),
                    //     //   height: ScreenUtil().setWidth(182),
                    //     // ),
                    //   ),
                    // ),
                    Positioned(
                      right: ScreenUtil().setWidth((960 - width) / 2),
                      top: ScreenUtil().setWidth(22),
                      child: Container(
                        width:
                            ScreenUtil().setWidth(width * (1 - flowersProgess)),
                        height: ScreenUtil().setWidth(50),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/image/flower/img_bg_2.png'),
                                alignment: Alignment.center,
                                repeat: ImageRepeat.repeatX,
                                fit: BoxFit.cover)),
                        child: null,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/image/flower/img_bg_1.png',
                        width: ScreenUtil().setWidth(960),
                        height: ScreenUtil().setWidth(105),
                      ),
                    ),
                    showAddFlowerAnimation
                        ? Positioned(
                            left: ScreenUtil().setWidth((940 - width) / 2),
                            top: ScreenUtil().setWidth(18),
                            child: OpacityAnimation(
                              animateTime: Duration(milliseconds: 200),
                              onFinish2: () {
                                setState(() {
                                  showAnimation = true;
                                  // gifController.reset();
                                  Future.delayed(Duration(
                                          milliseconds: (period).toInt()))
                                      .then((value) {
                                    animateEnd();
                                  });
                                });
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(width + 20),
                                height: ScreenUtil().setWidth(56),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/image/flower/img_light_1.png'),
                                        alignment: Alignment.center,
                                        repeat: ImageRepeat.repeatX,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          )
                        : Container(),

                    // Positioned(
                    //   left: ScreenUtil().setWidth((940 - width) / 2),
                    //   top: ScreenUtil().setWidth(18),
                    //   child: Container(
                    //     width: ScreenUtil().setWidth(width + 20),
                    //     height: ScreenUtil().setWidth(56),
                    //     decoration: BoxDecoration(
                    //         image: DecorationImage(
                    //             image: AssetImage(
                    //                 'assets/image/flower/img_light_1.png'),
                    //             alignment: Alignment.center,
                    //             repeat: ImageRepeat.repeatX,
                    //             fit: BoxFit.cover)),
                    //   ),
                    // ),
                    Positioned(
                      left: ScreenUtil().setWidth(18),
                      top: ScreenUtil().setWidth(8),
                      child: showAddFlowerAnimation
                          ? ExpandAnimation(
                              animateTime: Duration(milliseconds: 200),
                              count: 1,
                              child: Image.asset(
                                'assets/image/flower/img_flower.png',
                                key: Consts.globalKeyFlowerPosition,
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setWidth(82),
                              ),
                            )
                          : Image.asset(
                              'assets/image/flower/img_flower.png',
                              key: Consts.globalKeyFlowerPosition,
                              width: ScreenUtil().setWidth(80),
                              height: ScreenUtil().setWidth(82),
                            ),
                    ),
                    Positioned(
                        right: flowernumber >= TreeGroup.FLOWER_LUCKY_NUMBER
                            ? ScreenUtil().setWidth(-22)
                            : ScreenUtil().setWidth(18),
                        top: flowernumber >= TreeGroup.FLOWER_LUCKY_NUMBER
                            ? ScreenUtil().setWidth(-42)
                            : ScreenUtil().setWidth(8),
                        child: GestureDetector(
                          // behavior: HitTestBehavior.translucent,
                          onTap: () {
                            UserModel userModel =
                                Provider.of<UserModel>(context, listen: false);

                            if (userModel.value.is_m == 0) {
                              return;
                            }

                            if (flowernumber >= TreeGroup.FLOWER_LUCKY_NUMBER) {
                              if (mounted) {
                                _showSpin();
                              }
                              BurialReport.report(
                                  'event_entr_click', {'entr_code': '18'});
                            } else {
                              widget.showMsgHandel();
                            }
                          },
                          child: flowernumber >= TreeGroup.FLOWER_LUCKY_NUMBER
                              ? Lottie.asset(
                                  'assets/lottiefiles/flower_spin/data.json',
                                  controller: _controller,
                                  onLoaded: (composition) {
                                    _controller.duration = composition.duration;
                                    _controller.forward();
                                  },
                                  width: ScreenUtil().setWidth(180),
                                  height: ScreenUtil().setWidth(182),
                                )
                              : Image.asset(
                                  'assets/image/flower/btn_zp.png',
                                  width: ScreenUtil().setWidth(80),
                                  height: ScreenUtil().setWidth(82),
                                ),
                        )),
                    widget.showMsg
                        ? Positioned(
                            right: ScreenUtil().setWidth(-40),
                            top: ScreenUtil().setWidth(50),
                            child: Image.asset(
                              'assets/image/flower/img_prizes.png',
                              width: ScreenUtil().setWidth(749),
                              height: ScreenUtil().setWidth(432),
                            ),
                          )
                        : Container(),
                    // 小于8级 🔒
                    // level < TreeGroup.CAN_GET_FLOWER_LEVEL
                    //     ? Positioned(
                    //         left: 0,
                    //         right: 0,
                    //         child: Image.asset(
                    //           'assets/image/flower/img_sl.png',
                    //           width: ScreenUtil().setWidth(960),
                    //           height: ScreenUtil().setWidth(105),
                    //         ),
                    //       )
                    //     : Container(),
                  ],
                );
              },
            )));
  }
}

class _LuckyModel extends StatefulWidget {
  final void Function() onClose;

  _LuckyModel({Key key, this.onClose}) : super(key: key);

  @override
  __LuckyModelState createState() => __LuckyModelState();
}

class __LuckyModelState extends State<_LuckyModel>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Tween<double> curTween;
  int giftId;
  Map<String, dynamic> res;
  Duration duration = Duration(milliseconds: 1500);

  // 默认3圈
  static const defaultNumOfTurns = 3 * 2.0;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    BurialReport.report('page_imp', {'page_code': '037'});
    controller = new AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    Animation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    double endRadian = defaultNumOfTurns;
    curTween = Tween<double>(begin: 0.0, end: endRadian);

    animation = curTween.animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (giftId != null) {
            switch (giftId) {
              case 2:
                {
                  Invite_award invite_award = Invite_award.fromJson(res);

                  TreeGroup treeGroup =
                      Provider.of<TreeGroup>(context, listen: false);
                  goAward(1, DwardType.tree,
                      callback: () => {
                            treeGroup.flowerMakeTree = Tree(
                              grade: Tree.MAX_LEVEL,
                              type: TreeType.Type_TimeLimited_Bonus,
                              duration: invite_award.duration,
                              amount: invite_award.amount.toDouble(),
                              showCountDown: true,
                              treeId: invite_award.tree_id,
                              timePlantedLimitedBonusTree:
                                  DateTime.now().millisecondsSinceEpoch,
                            )
                          });

                  break;
                }
              case 1:
                {
                  MoneyGroup moneyGroup =
                      Provider.of<MoneyGroup>(context, listen: false);

                  int gold = (moneyGroup.makeGoldSped *
                          int.parse(res['duration'].toString()))
                      .toInt();
                  goAward(gold, DwardType.gold,
                      callback: () => {moneyGroup.addGold(gold.toDouble())});

                  break;
                }
              case 0:
                TreeGroup treeGroup =
                    Provider.of<TreeGroup>(context, listen: false);
                int lottoNumber = int.tryParse(res['ticket_num'].toString());
                goAward(lottoNumber, DwardType.lotto,
                    callback: () =>
                        {treeGroup.lottoAnimationNumber = lottoNumber});

                break;
              case 3:
                LuckyGroup treeGroup =
                    Provider.of<LuckyGroup>(context, listen: false);

                goAward(1, DwardType.attack, callback: () {
                  treeGroup.attackNumTotal += 1;
                  GardenNews.show(context);
                });
                break;
            }
          }
        }
      });
    // _handleStartSpin();
  }

  void goAward(int count, String type, {Function callback}) {
    ReceiveAwardAnimate.show(context,
        animationTime: duration,
        awardAcount: count,
        awardType: type, callback: () {
      if (callback != null) {
        callback();
      }
      onCloseWindow(context);
    });
  }

  void onCloseWindow(BuildContext context) {
    Navigator.pop(context);
    widget.onClose();
  }

  ///接口中取到结果后更新
  updateTween() {
    double needAngle =
        giftId == 0 ? 1 : giftId == 2 ? 0 : giftId == 3 ? 1.5 : 0.5;
    curTween.end = curTween.end + needAngle;
    controller.forward();
  }

  _handleStartSpin() async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
    Map<String, dynamic> luckResultMap;
    luckResultMap = await Service().exchangeRouletteGift({
      'acct_id': treeGroup.acct_id,
    });

    // TODO 测试
//     String test = """
//    {
// "gift_id": 0,
//     "gift_name": "Lotto X 2",
//     "ticket_num": 2
//    }
//    """;
//     luckResultMap = json.decode(test);
    res = luckResultMap;
    if (luckResultMap == null) {
      Layer.toastWarning("Failed, Try Agagin Later");
      controller.reset();
      onCloseWindow(context);
    } else {
      TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
      treeGroup.hasFlowerCount = 0;
      giftId = luckResultMap['gift_id'] as num;
      BurialReport.report(
          'flower_spin_result', {'spin_result': (giftId + 1).toString()});
      updateTween();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        body: Stack(children: [
          Center(
            child: Container(
              width: ScreenUtil().setWidth(900),
              height: ScreenUtil().setWidth(900),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      width: ScreenUtil().setWidth(900),
                      child: RepaintBoundary(
                        child: AnimatedBuilder(
                            animation: animation,
                            child: Container(
                              width: ScreenUtil().setWidth(900),
                              height: ScreenUtil().setWidth(900),
//                   color: Colors.green,
                              child: Image.asset(
                                'assets/image/flower/spin_bg.png',
                                width: ScreenUtil().setWidth(900),
                                height: ScreenUtil().setWidth(900),
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
                    ),
                  ),
                  // Positioned(
                  //     top: ScreenUtil().setWidth(40),
                  //     right: ScreenUtil().setWidth(40),
                  //     child: GestureDetector(
                  //       behavior: HitTestBehavior.translucent,
                  //       onTap: () {
                  //         onCloseWindow(context);
                  //       },
                  //       child: Container(
                  //         padding: EdgeInsets.all(10),
                  //         child: Image.asset(
                  //           'assets/image/close_icon_modal_bottom_center.png',
                  //           width: ScreenUtil().setWidth(50),
                  //           height: ScreenUtil().setWidth(50),
                  //         ),
                  //       ),
                  //     )),
                  Positioned(
                    child: Center(
                        child: GestureDetector(
                      key: Consts.globalKeyFlowerBtn,
                      onTap: () {
                        BurialReport.report('flower_bouns', {'type': '1'});
                        // controller.forward();
                        _handleStartSpin();
                      },
                      child: Lottie.asset(
                        'assets/lottiefiles/btn_light/data.json',
                        width: ScreenUtil().setWidth(340),
                        height: ScreenUtil().setWidth(404),
                      ),
                    )),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
