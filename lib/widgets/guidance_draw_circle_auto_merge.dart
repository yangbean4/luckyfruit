import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class InvertedCircleClipper extends CustomClipper<Path> {
  double radius;
  double dx;
  double dy;

  InvertedCircleClipper(this.radius, this.dx, this.dy);

  @override
  Path getClip(Size size) {
    print("InvertedCircleClipper_dx_dy: $dx, $dy, $radius");
    return new Path()
      ..addOval(Rect.fromCircle(
          center: Offset(
              dx + ScreenUtil().setWidth(105), dy + ScreenUtil().setWidth(105)),
          radius: radius))
      ..addRect(Rect.fromLTWH(
          0.0, 0.0, ScreenUtil().setWidth(1080), ScreenUtil().setWidth(2500)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class GuidanceDrawCircleAutoMergeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceDrawCircleState();
}

class _GuidanceDrawCircleState extends State<GuidanceDrawCircleAutoMergeWidget>
    with TickerProviderStateMixin {
  CurvedAnimation curveEaseIn;
  AnimationController controller;
  Animation<double> scaleAnimation;
  Tween<double> scaleTween;
  double dy = 0.0;
  double dx = 0.0;
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
      end: ScreenUtil().setWidth(110),
    );

    scaleAnimation = scaleTween.animate(curveEaseIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          LuckyGroup luckyGroup =
              Provider.of<LuckyGroup>(context, listen: false);
          luckyGroup.setShowAutoMergeFingerGuidance = true;
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("addPostFrameCallback_dx_dy: $dx, $dy");
      dx = Util.getAutoMergeInfoWithGlobalKey()?.dx ?? 0.0;
      dy = Util.getAutoMergeInfoWithGlobalKey()?.dy ?? 0.0;
    });
  }

  _playAnimation() async {
    try {
      print("Draw Circle _playAnimation");
      if (!hasReported) {
        hasReported = true;
//        BurialReport.report('page_imp', {'page_code': '030'});
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
            selector: (context, provider) =>
                provider.showAutoMergeCircleGuidance,
            builder: (_, bool show, __) {
              if (show) {
                _playAnimation();
              }
              return show
                  ? ClipPath(
                      clipper:
                          InvertedCircleClipper(scaleAnimation.value, dx, dy),
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
