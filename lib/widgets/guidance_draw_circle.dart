import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class InvertedCircleClipper extends CustomClipper<Path> {
  double radius;
  double dy;

  InvertedCircleClipper(this.radius, this.dy);

  @override
  Path getClip(Size size) {
    print("InvertedCircleClipper_dy: $dy");
    return new Path()
      ..addOval(Rect.fromCircle(
          center: Offset(
              ScreenUtil().setWidth(1080 / 2), dy + ScreenUtil().setWidth(64)),
          radius: radius))
      ..addRect(Rect.fromLTWH(
          0.0, 0.0, ScreenUtil().setWidth(1080), ScreenUtil().setWidth(2500)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class GuidanceDrawCircleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceDrawCircleState();
}

class _GuidanceDrawCircleState extends State<GuidanceDrawCircleWidget>
    with TickerProviderStateMixin {
  CurvedAnimation curveEaseIn;
  AnimationController controller;
  Animation<double> scaleAnimation;
  Tween<double> scaleTween;
  double dy = 0.0;
  bool hasReported = false;

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 1000), vsync: this);
    curveEaseIn =
        new CurvedAnimation(parent: controller, curve: Curves.easeOutBack);

    scaleTween = Tween<double>(
      begin: ScreenUtil().setWidth(2000),
      end: ScreenUtil().setWidth(200),
    );

    scaleAnimation = scaleTween.animate(curveEaseIn);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("addPostFrameCallback_dy: $dy");
      dy = Util.getAddTreeBtnInfoWithGlobalKey()?.dy ?? 0.0;
    });
  }

  _playAnimation() async {
    try {
      print("Draw Circle _playAnimation");
      if (!hasReported) {
        hasReported = true;
        BurialReport.report('page_imp', {'page_code': '030'});
      }

      // controller.value = 0;
      // controller.reset();
      //先正向执行动画
      await controller.forward().orCancel;
      //再反向执行动画
      // await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (BuildContext context, Widget child) {
        return Selector<LuckyGroup, bool>(
            selector: (context, provider) => provider.showCircleGuidance,
            builder: (_, bool show, __) {
              if (show) {
                _playAnimation();
              }
              return show
                  ? ClipPath(
                      clipper: InvertedCircleClipper(scaleAnimation.value, dy),
                      child: Container(
                        width: ScreenUtil().setWidth(1080),
                        height: ScreenUtil().setWidth(2500),
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    )
                  : Container();
            });
      },
      animation: controller,
    );
  }
}
