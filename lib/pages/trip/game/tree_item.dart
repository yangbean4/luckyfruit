/**
 * 这个是用了两个controller
 */
import 'dart:async';
import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/bgm.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:provider/provider.dart';

const num TreeAnimationTime = AnimationConfig.TreeAnimationTime;

class TreeItem extends StatefulWidget {
  final Tree tree;

  TreeItem(
    this.tree, {
    Key key,
  }) : super(key: key);

  @override
  _TreeItemState createState() => _TreeItemState();
}

class _TreeItemState extends State<TreeItem> with TickerProviderStateMixin {
  Animation<double> treeAnimation;
  AnimationController treeAnimationController;
  Animation<double> goldAnimation;
  AnimationController goldAnimationController;

  // 控制是否显示 金币
  bool showGold = false;
  Timer timer;
  bool isDispose;

  @override
  void initState() {
    super.initState();
    isDispose = false;
    treeAnimationController = new AnimationController(
      duration: Duration(milliseconds: 1000 * TreeAnimationTime ~/ 25),
      vsync: this,
    );
    final CurvedAnimation treeCurve = new CurvedAnimation(
        parent: treeAnimationController, curve: Curves.easeIn);

    goldAnimationController = new AnimationController(
      // 树放大的时候开始动画,与树的动画时间一致
      duration: Duration(milliseconds: 1000 * TreeAnimationTime ~/ 12),
      vsync: this,
    );
    final CurvedAnimation goldCurve = new CurvedAnimation(
        parent: goldAnimationController, curve: Curves.easeIn);

    goldAnimation = new Tween(begin: -20.0, end: -30.0).animate(goldCurve)
      ..addStatusListener((status) {
        setState(() {
          showGold = status == AnimationStatus.forward;
        });
      });

    treeAnimation = new Tween(begin: 1.0, end: 1.2).animate(treeCurve);

    const period = const Duration(seconds: TreeAnimationTime);
    Future.delayed(Duration(seconds: Random().nextInt(TreeAnimationTime ~/ 2)))
        .then((e) {
      Timer.periodic(period, (_timer) {
        if (!isDispose) {
          timer = _timer;
          runAction();
        } else {
          timer?.cancel();
        }
      });
    });
  }

  Future<void> runAction() async {
    try {
      Bgm.coinIncrease();
      await Future.delayed(Duration(milliseconds: 800));
      await treeAnimationController?.forward();

      goldAnimationController
        ..value = 0.0
        ..forward();

      await treeAnimationController?.reverse();
      // await Future.delayed(Duration(milliseconds: 300));
      MoneyGroup moneyGroup = Provider.of<MoneyGroup>(context, listen: false);
      // moneyGroup.treeAddGold(widget.tree.gold * TreeAnimationTime);

      if (widget.tree.type == TreeType.Type_TimeLimited_Bonus &&
          widget.tree?.amount != null &&
          widget.tree?.duration != null &&
          widget.tree?.amount > 0 &&
          widget.tree?.duration > 0) {
        // 跟金币同步更新余额（限时分红树产生的）
        double speedPerSecond =
            widget.tree?.amount / widget.tree?.originalDuration?.toDouble();

        double gold;
        bool lastMoney=false;
        if (widget.tree?.duration < TreeAnimationTime) {
          gold = widget.tree.amount - widget.tree.limitedBonusedAmount;
          lastMoney = true;
        } else {
          gold = speedPerSecond * TreeAnimationTime;
          widget.tree.limitedBonusedAmount += gold;
        }

        moneyGroup.timeLimitedTreeAddMoney(gold, isLastLTTreeMoney: lastMoney);
        print(
            "timeLimitedTreeAddMoney: $speedPerSecond, $gold， ${widget.tree?.duration}");
      }
    } catch (e) {}
  }

  @override
  dispose() {
    isDispose = true;
    timer?.cancel();
    treeAnimationController.dispose();
    goldAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setWidth(185),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          // Positioned(
          //     bottom: 0,
          //     left: ScreenUtil().setWidth(50),
          //     child: EllipticalWidget(
          //       width: ScreenUtil().setWidth(100),
          //       height: ScreenUtil().setWidth(50),
          //       color: MyTheme.darkGrayColor,
          //     )),
          AnimatedBuilder(
              animation: treeAnimation,
              builder: (BuildContext context, Widget child) {
                return Positioned(
                  bottom: 0,
                  left: ScreenUtil().setWidth(-40 * treeAnimation.value) / 2,
                  child: TreeWidget(
                    tree: widget.tree,
                    showCountDown: widget.tree.showCountDown,
                    imgHeight: ScreenUtil().setWidth(168 * treeAnimation.value),
                    imgWidth: ScreenUtil().setWidth(240 * treeAnimation.value),
                    labelWidth: ScreenUtil().setWidth(72),
                    labelHeight: ScreenUtil().setWidth(44),
                    primary: true,
                    // image: Transform.scale(
                    //     alignment: Alignment.center,
                    //     scale: treeAnimation.value,
                    //     child: Image.asset(
                    //       widget.tree?.treeImgSrc,
                    //       width: ScreenUtil().setWidth(200),
                    //       height: ScreenUtil().setWidth(140),
                    //     )),
                  ),
                );
              }),
          // 为 0  的话不显示动画
          showGold && widget.tree.gold != 0
              ? AnimatedBuilder(
                  animation: goldAnimation,
                  builder: (BuildContext context, Widget child) {
                    return Positioned(
                        top: ScreenUtil().setWidth(goldAnimation.value),
                        left: ScreenUtil().setWidth((200 - 440) / 2),
                        child: Container(
                          width: ScreenUtil().setWidth(440),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/image/gold.png',
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(12),
                                  ),
                                  child: Text(
                                    '+' +
                                        Util.formatNumber(
                                            widget.tree.gold *
                                                TreeAnimationTime,
                                            fixed: 0),
                                    style: TextStyle(
                                      fontFamily: FontFamily.bold,
                                      color: MyTheme.secondaryColor,
                                      fontSize: ScreenUtil().setSp(40),
                                      height: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                            ],
                          ),
                        ));
                  })
              : Container(),
        ],
      ),
    );
  }
}
