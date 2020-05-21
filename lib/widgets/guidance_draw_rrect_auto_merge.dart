import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';

class _InvertedCRRectClipper extends CustomClipper<Path> {
  double radius;
  double leftPos;
  double topPos;

  _InvertedCRRectClipper(this.radius, this.leftPos, this.topPos);

  @override
  Path getClip(Size size) {
    return new Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(leftPos, topPos + ScreenUtil().setWidth(25),
              ScreenUtil().setWidth(345), ScreenUtil().setWidth(130)),
          Radius.circular(70)))
      ..addRect(Rect.fromLTWH(
          0.0, 0.0, ScreenUtil().setWidth(1080), ScreenUtil().setWidth(2500)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class GuidanceDrawRRectAutoMergeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceDrawCircleState();
}

class _GuidanceDrawCircleState extends State<GuidanceDrawRRectAutoMergeWidget>
    with TickerProviderStateMixin {
  CurvedAnimation curveEaseIn;
  AnimationController controller;
  Animation<double> scaleAnimation;
  Animation<double> leftPosAnimation;
  Animation<double> topPosAnimation;
  Animation<double> fingerLeftPosAnimation;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dy = Util.getAutoMergeInfoWithGlobalKey()?.dy ?? 0.0;
      dx = Util.getAutoMergeInfoWithGlobalKey()?.dx ?? 0.0;
      print("addPostFrameCallback_dy: $dy, $dx");

      topPosAnimation = Tween<double>(
        begin: -dy,
        end: dy,
//      begin: -ScreenUtil().setWidth(1920 - 930 - 10 + 86),
//      end: ScreenUtil().setWidth(1920 - 930 - 10 + 86),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            0.0,
            1.0,
            curve: Curves.easeOutCubic,
          ),
        ),
      )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            LuckyGroup luckyGroup =
                Provider.of<LuckyGroup>(context, listen: false);
            luckyGroup.setShowAutoMergeFingerGuidance = true;
          }
        });

      leftPosAnimation = Tween<double>(
        begin: dx,
        end: dx,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(
            0.0,
            1.0,
            curve: Curves.easeOutCubic,
          ),
        ),
      );
    });
  }

  _playAnimation() async {
//    if (!hasReported) {
//      hasReported = true;
//      BurialReport.report('page_imp', {'page_code': '031'});
//    }

    try {
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

                print("topPosAnimation?.value: ${topPosAnimation?.value}, $dy");
                return show
                    ? Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper: _InvertedCRRectClipper(
                                0,
                                leftPosAnimation?.value ??
                                    -ScreenUtil().setWidth(200),
                                topPosAnimation?.value ??
                                    -ScreenUtil().setWidth(200)),
                            child: Container(
                              width: ScreenUtil().setWidth(1080),
                              height: ScreenUtil().setWidth(2500),
                              color: Color.fromRGBO(0, 0, 0, 0.5),
                            ),
                          ),
                        ],
                      )
                    : Container();
              });
        },
        animation: controller);
  }
}
