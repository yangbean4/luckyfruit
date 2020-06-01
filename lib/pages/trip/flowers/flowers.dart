/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-28 15:32:27
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-01 19:04:13
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/invite_award.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/widgets/opcity_animation.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Flowers extends StatefulWidget {
  Flowers({Key key}) : super(key: key);

  @override
  _FlowersState createState() => _FlowersState();
}

class _FlowersState extends State<Flowers> {
  bool showMsg = false;
  bool showAnimation = false;
  @override
  Widget build(BuildContext context) {
    int width = 740;

    return Container(
        width: ScreenUtil().setWidth(960),
        height: ScreenUtil().setWidth(105),
        // color: Colors.red,
        // level flowernumber animationUseflower
        child: Selector<TreeGroup, Tuple4<int, int, int, TreePoint>>(
          selector: (context, provider) => Tuple4(
              provider.hasMaxLevel,
              provider.hasFlowerCount,
              provider.animationUseflower,
              provider.flowerPoint),
          builder: (_, data, __) {
            int level = data.item1;
            int flowernumber = data.item2;
            int animationUseflower = data.item3;
            TreePoint flowerPoint = data.item4;

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
                            image:
                                AssetImage('assets/image/flower/img_red.png'),
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
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/image/flower/sg.gif'),
                                  alignment: Alignment.center,
                                  repeat: ImageRepeat.repeatX,
                                  fit: BoxFit.contain)),
                          child: null,
                        ),
                      )
                    : Container(),
                Positioned(
                  right: ScreenUtil().setWidth((960 - width) / 2),
                  top: ScreenUtil().setWidth(22),
                  child: Container(
                    width: ScreenUtil().setWidth(width * (1 - flowersProgess)),
                    height: ScreenUtil().setWidth(50),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/image/flower/img_bg_2.png'),
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
                animationUseflower != 0 && flowerPoint == null
                    ? Positioned(
                        left: ScreenUtil().setWidth((940 - width) / 2),
                        top: ScreenUtil().setWidth(18),
                        child: OpacityAnimation(
                          onFinish: () {
                            setState(() {
                              showAnimation = true;
                              Future.delayed(Duration(milliseconds: 100))
                                  .then((value) {
                                setState(() {
                                  showAnimation = false;
                                });
                                TreeGroup tourismMap = Provider.of<TreeGroup>(
                                    context,
                                    listen: false);
                                tourismMap.hasFlowerCount += animationUseflower;
                                tourismMap.animationUseflower = 0;
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
                Positioned(
                  left: ScreenUtil().setWidth(18),
                  top: ScreenUtil().setWidth(8),
                  child: Image.asset(
                    'assets/image/flower/img_flower.png',
                    key: Consts.globalKeyFlowerPosition,
                    width: ScreenUtil().setWidth(80),
                    height: ScreenUtil().setWidth(82),
                  ),
                ),
                Positioned(
                    right: ScreenUtil().setWidth(18),
                    top: ScreenUtil().setWidth(8),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (flowernumber >= TreeGroup.FLOWER_LUCKY_NUMBER) {
                          showDialog(
                              context: context, builder: (_) => _LuckyModel());
                        } else {
                          showDialog(
                              context: context, builder: (_) => _LuckyModel());
                          setState(() {
                            showMsg = true;
                          });
                        }
                      },
                      child: Image.asset(
                        'assets/image/flower/btn_zp.png',
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setWidth(82),
                      ),
                    )),
                showMsg
                    ? Positioned(
                        right: ScreenUtil().setWidth(-40),
                        top: ScreenUtil().setWidth(50),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showMsg = false;
                            });
                          },
                          // behavior: HitTestBehavior.translucent,
                          child: Image.asset(
                            'assets/image/flower/img_prizes.png',
                            width: ScreenUtil().setWidth(749),
                            height: ScreenUtil().setWidth(432),
                          ),
                        ))
                    : Container(),
                // 小于8级 🔒
                level < TreeGroup.CAN_GET_FLOWER_LEVEL
                    ? Positioned(
                        left: 0,
                        right: 0,
                        child: Image.asset(
                          'assets/image/flower/img_sl.png',
                          width: ScreenUtil().setWidth(960),
                          height: ScreenUtil().setWidth(105),
                        ),
                      )
                    : Container(),
              ],
            );
          },
        ));
  }
}

class _LuckyModel extends StatefulWidget {
  _LuckyModel({Key key}) : super(key: key);

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
                  GetReward.showLimitedTimeBonusTree(invite_award.duration, () {
                    treeGroup.addTree(
                        tree: Tree(
                      grade: Tree.MAX_LEVEL,
                      type: TreeType.Type_TimeLimited_Bonus,
                      duration: invite_award.duration,
                      amount: invite_award.amount.toDouble(),
                      showCountDown: true,
                      treeId: invite_award.tree_id,
                      timePlantedLimitedBonusTree:
                          DateTime.now().millisecondsSinceEpoch,
                    ));
                  });
                  break;
                }
              case 1:
                {
                  MoneyGroup moneyGroup =
                      Provider.of<MoneyGroup>(context, listen: false);

                  double gold =
                      moneyGroup.makeGoldSped * int.parse(res['duration']);
                  GetReward.showGoldWindow(gold, () {
                    moneyGroup.addGold(gold);
                  });
                  break;
                }
              case 0:
                {}
            }
          }
        }
      });
  }

  void onCloseWindow(BuildContext context) {
    Navigator.pop(context);
  }

  ///接口中取到结果后更新
  updateTween() {
    double needAngle = giftId == 0 ? 0.33 : giftId == 2 ? 0 : 0.66;
    curTween.end = curTween.end + needAngle;
    if (controller.isAnimating) {
      controller.forward();
    }
  }

  _handleStartSpin() async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
    Map<String, dynamic> luckResultMap;
    luckResultMap = await Service().exchangeRouletteGift({
      'acct_id': treeGroup.acct_id,
    });
    res = luckResultMap;
    if (luckResultMap == null) {
      Layer.toastWarning("Failed, Try Agagin Later");
      controller.reset();
    } else {
      giftId = luckResultMap['gift_id'] as num;
      updateTween();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        body: Center(
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
                Positioned(
                    top: ScreenUtil().setWidth(40),
                    right: ScreenUtil().setWidth(40),
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        onCloseWindow(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          'assets/image/close_icon_modal_bottom_center.png',
                          width: ScreenUtil().setWidth(50),
                          height: ScreenUtil().setWidth(50),
                        ),
                      ),
                    )),
                Positioned(
                  child: Center(
                      child: GestureDetector(
                    onTap: () {
                      _handleStartSpin();
                    },
                    child: Image.asset(
                      'assets/image/flower/spin.png',
                      width: ScreenUtil().setWidth(340),
                      height: ScreenUtil().setWidth(404),
                    ),
                  )),
                )
              ],
            ),
          ),
        ));
  }
}
