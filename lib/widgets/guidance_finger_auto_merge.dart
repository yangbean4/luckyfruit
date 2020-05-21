import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class GuidanceFingerAutoMergeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceFingerState();
}

class _GuidanceFingerState extends State with TickerProviderStateMixin {
  CurvedAnimation curveEaseIn;
  AnimationController controller;
  Animation<double> scaleAnimation;
  double dy = 0.0;
  double dx = 0.0;

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    curveEaseIn =
        new CurvedAnimation(parent: controller, curve: Curves.easeOutBack);

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.6,
    ).animate(curveEaseIn);

    scaleAnimation.addListener(() {
      // print("positonBottom.addListener");
      // setState(() {});
    });

    scaleAnimation.addStatusListener((e) {
      // print("addStatusListener: $e");
      if (e == AnimationStatus.dismissed) {
        _playAnimation();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dy = Util.getAutoMergeInfoWithGlobalKey()?.dy ?? 0.0;
      dx = Util.getAutoMergeInfoWithGlobalKey()?.dx ?? 0.0;
      print("addPostFrameCallback_merge_d: $dx, $dy");
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    if (controller == null) {
      return;
    }
    try {
      //先正向执行动画
      await controller?.forward()?.orCancel;
      //再反向执行动画
      await controller?.reverse()?.orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LuckyGroup, bool>(
        selector: (context, provider) => provider.showAutoMergeFingerGuidance,
        builder: (_, bool show, __) {
          if (show) {
            _playAnimation();
          }
          return show
              ? AnimatedBuilder(
                  builder: (BuildContext context, Widget child) {
                    return Positioned(
                      left: dx +
                          ScreenUtil().setWidth(172) -
                          ScreenUtil().setWidth(210 / 2),
                      top: dy,
                      child: Transform.scale(
//                        scale: 0.1,
                        scale: dx <= 0 ? 0 : scaleAnimation?.value ?? 0,
                        //手指可以透传点击事件到下面widget
                        child: IgnorePointer(
                          child: Container(
                            // color: Colors.red[100],
                            child: Image.asset(
                              'assets/image/guidance_finger.png',
                              width: ScreenUtil().setWidth(210),
                              height: ScreenUtil().setWidth(280),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  animation: controller)
              : Container();
        });
  }
}
