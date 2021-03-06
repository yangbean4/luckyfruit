import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/pages/trip/game/game.dart' show PositionLT;
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/theme/public/modal_title.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:luckyfruit/widgets/shake_button.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:provider/provider.dart';

typedef Widget _BuilderFun(BuildContext context,
    {Animation<double> top, Animation<double> size});

class Treasure extends StatefulWidget {
  Treasure({Key key}) : super(key: key);

  @override
  _TreasureState createState() => _TreasureState();
}

class _TreasureState extends State<Treasure> {
  String adCode = '205';
  Map<String, String> adLogParam = {};

  report() {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    adLogParam = Util.getVideoLogParams(_userModel?.value?.acct_id);
    BurialReport.report('ad_rewarded', {
      'type': '0',
      'ad_code': adCode,
      "union_id": adLogParam['union_id'],
      'is_new': "1"
    });
  }

  _showModal(Tree tree) {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    Modal(
        onCancel: () {},
        childrenBuilder: (Modal modal) => <Widget>[
              ModalTitle('Free Mango Tree'),
              SizedBox(
                height: ScreenUtil().setWidth(42),
              ),
              TreeWidget(
                tree: tree,
                imgHeight: ScreenUtil().setWidth(236),
                imgWidth: ScreenUtil().setWidth(216),
                labelWidth: ScreenUtil().setWidth(80),
                primary: true,
              ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
                  child: AdButton(
                      ad_code: adCode,
                      adUnitIdFlag: 1,
                      btnText: 'Got it',
                      adLogParam: adLogParam,
                      onCancel: () {
                        treeGroup.pickTreasure(false);
                        modal.hide();
                      },
                      onOk: (isFromAd) {
                        treeGroup.pickTreasure(true);
                        modal.hide();
                      }))
            ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TreeGroup, Tree>(
        builder: (context, Tree tree, child) {
          if (tree == null) {
            adLogParam = null;

            return Container();
          } else {
            if (adLogParam == null) {
              report();
            }
            // 将宝盒的坐标转成
            PositionLT positionLT = PositionLT(x: tree.x, y: tree.y);
            return _TreasureAnimation(
              builder: (ctx, {Animation<double> top, Animation<double> size}) {
                // 上半部分高度   game的padding 补充值
                num _top = 940 + 60 + 200 + positionLT.top;
                return Positioned(
                  bottom: ScreenUtil().setWidth(1920 - (_top * top.value)),
                  // 左侧定位值 便宜量 补充值
                  left: ScreenUtil()
                      .setWidth(positionLT.left + positionLT.xSpace + 30),
                  child: ShakeAnimation(
                    timeInterval: Duration(seconds: 4),
                    animateTime: Duration(milliseconds: 800),
                    angle: pi / 30,
                    child: GestureDetector(
                        onTap: () {
                          BurialReport.report('ad_rewarded', {
                            'type': '5',
                            'ad_code': adCode,
                            "union_id": adLogParam['union_id'],
                            'is_new': "1"
                          });
                          _showModal(tree);
                        },
                        child: Center(
                            child: Image.asset(
                          'assets/image/game_treasure.png',
                          width: ScreenUtil().setWidth(148),
                          height: ScreenUtil().setWidth(143 + 20 * size.value),
                        ))),
                  ),
                );
              },
            );
          }
        },
        selector: (context, provider) => provider.treasureTree);
  }
}

class _TreasureAnimation extends StatefulWidget {
  final _BuilderFun builder;
  final Duration animateTime;

  _TreasureAnimation(
      {Key key,
      @required this.builder,
      this.animateTime = const Duration(milliseconds: 500)})
      : super(key: key);

  @override
  _TreasureAnimationState createState() => _TreasureAnimationState();
}

class _TreasureAnimationState extends State<_TreasureAnimation>
    with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.animateTime,
      vsync: this,
    )
      ..value = 0.0
      ..forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return _GrowTransition(controller: controller, builder: widget.builder);
  }
}

class _GrowTransition extends StatelessWidget {
  _GrowTransition({Key key, this.controller, this.builder})
      :
        // 位置
        positionTop = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.2, curve: Curves.easeInToLinear))),
        // 大小
        enlargeSize = Tween<double>(
          begin: -1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.8, 1.0, curve: Curves.bounceInOut))),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> enlargeSize;
  final Animation<double> positionTop;
  final _BuilderFun builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, Widget child) {
        return builder(context, top: positionTop, size: enlargeSize);
      },
    );
  }
}
