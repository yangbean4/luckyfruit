import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/main.dart';
import 'package:luckyfruit/utils/index.dart';

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
        duration: const Duration(milliseconds: 2000), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Initialize.luckyGroup.showRevengeGoldFlowing = false;
        }
      });
    list = List.generate(50, (index) => index).toList();

    offsetOfStart = Util.getOffset(Consts.treeGroupGlobalKey[2][2]);
    beginLeft = offsetOfStart.dx;
    beginRight = ScreenUtil().setWidth(1080) -
        (offsetOfStart.dx + ScreenUtil().setWidth(80));
    distance = ScreenUtil().setWidth(500);
  }

  Widget getWidget(int index) {
    double randomD = (index - 25) * ScreenUtil().setWidth(12);
    return PositionedTransition(
      rect: TestTween(
        delay: Random().nextDouble(),
        begin: RelativeRect.fromLTRB(beginLeft, offsetOfStart.dy, beginRight,
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
  Widget build(BuildContext context) {
    controller.value = 0;
    controller.forward();
    return Stack(children: list.map((e) => getWidget(e)).toList());
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
