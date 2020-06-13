import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/main.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

//循环放大和缩小效果
class RevengeGoldFlowingFlyGroup extends StatefulWidget {
  @override
  _RevengeGoldFlowingFlyGroupState createState() =>
      _RevengeGoldFlowingFlyGroupState();
}

class _RevengeGoldFlowingFlyGroupState extends State<RevengeGoldFlowingFlyGroup>
    with SingleTickerProviderStateMixin {
  Animation<RelativeRect> animation; //动画对象
  AnimationController controller; //动画控制器

  List<int> list = [];

  Offset offsetOfStart;
  double beginLeft;
  double beginRight;
  double distance;

  @override
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Initialize.luckyGroup.showRevengeGoldFlowing = false;
        }
      });
    list = List.generate(40, (index) => index).toList();
    distance = ScreenUtil().setWidth(500);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LuckyGroup, Tuple2<bool, GlobalKey>>(
        selector: (context, provider) =>
            Tuple2(provider.showRevengeGoldFlowing, provider.revengeShovelKey),
        builder: (_, tuple2, __) {
          if (tuple2.item1) {
            offsetOfStart = Util.getOffset(tuple2.item2);
            beginLeft = offsetOfStart.dx;
            beginRight = ScreenUtil().setWidth(1080) -
                (offsetOfStart.dx + ScreenUtil().setWidth(100));

            controller.value = 0;
            controller.forward();
          }
          return tuple2.item1
              ? Stack(children: list.map((e) => getWidget(e)).toList())
              : Container();
        });
  }

  Widget getWidget(int index) {
    double randomD = (index - 25) * ScreenUtil().setWidth(6);
    return PositionedTransition(
      rect: TestTween(
        delay: Random().nextDouble(),
        begin: RelativeRect.fromLTRB(
            beginLeft,
            offsetOfStart.dy + ScreenUtil().setWidth(100),
            beginRight,
            ScreenUtil().setWidth(100)),
        end: RelativeRect.fromLTRB(
            beginLeft + randomD,
            offsetOfStart.dy - distance,
            beginRight - randomD,
            ScreenUtil().setWidth(100)),
      ).animate(controller),
      child: Container(
        alignment: Alignment.topCenter,
//        color: Colors.red,
        child: Image.asset(
          "assets/image/coin_rain_icon${Random().nextInt(5) + 1}.png",
          width: ScreenUtil().setWidth(80),
          height: ScreenUtil().setWidth(80),
        ),
      ),
    );
  }

  @override
  dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }
}

class TestTween extends RelativeRectTween {
  final double delay;

  TestTween({RelativeRect begin, RelativeRect end, this.delay})
      : super(begin: begin, end: end);

  @override
  RelativeRect lerp(double t) {
    return super.lerp((sin((t - delay) * pi * 3 / 4) + 1) / 2);
  }
}
