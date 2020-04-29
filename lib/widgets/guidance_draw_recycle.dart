import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart' show Consts;
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tree_group.dart' show Position, TreeGroup;
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/breathe_text.dart';
import 'package:provider/provider.dart';

class _InvertedCRRectClipper extends CustomClipper<Path> {
  double radius;
  Position position1;
  Position position2;

  _InvertedCRRectClipper(this.radius, this.position1, this.position2);

  @override
  Path getClip(Size size) {
    double _x = position1.x - position2.x;
    double _y = position1.y - position2.y;

    double dr = radius / sqrt(pow(_x, 2) + pow(_y, 2));
    double dx = (dr * _y).abs();
    double dy = (dr * _x).abs();
    double range = asin(dy / sqrt(pow(_x, 2) + pow(_y, 2)));

    List<Position> posArr = [
      Position(x: position1.x - dx, y: position1.y - dy),
      Position(x: position1.x + dx, y: position1.y + dy),
      Position(x: position2.x + dx, y: position2.y + dy),
      Position(x: position2.x - dx, y: position2.y - dy),
    ];

    // List<Position> pointArr = new List(4);
    // double _minLevel = posArr.map((tree) => tree.x).reduce(min);
    // Position tree = posArr.firstWhere((tree) => tree.x == _minLevel);
    // pointArr[0] = tree;
    // posArr.remove(tree);
    // double _max = posArr.map((tree) => tree.x).reduce(max);
    // Position pos = posArr.firstWhere((tree) => tree.x == _max);
    // pointArr[2] = pos;
    // posArr.remove(pos);
    // pointArr[1] = posArr[0];
    // pointArr[3] = posArr[1];

    Path path = Path();
    path
      ..moveTo(posArr[0].x, posArr[0].y)
      // ..lineTo(pointArr[1].x, pointArr[1].y)
      // ..lineTo(pointArr[2].x, pointArr[2].y)
      // ..lineTo(pointArr[3].x, pointArr[3].y)
      // ..lineTo(pointArr[1].x, pointArr[1].y)
      ..arcTo(
          new Rect.fromLTWH(position1.x - radius, position1.y - radius,
              radius * 2, radius * 2),
          0,
          pi,
          false)
      ..lineTo(posArr[2].x, posArr[2].y)
      // ..lineTo(pointArr[3].x, pointArr[3].y)
      ..arcTo(
          new Rect.fromLTWH(position2.x - radius, position2.y - radius,
              radius * 2, radius * 2),
          range,
          range + pi,
          false)
      ..lineTo(posArr[3].x, posArr[3].y)

      // ..lineTo(0.0, 100.0)
      ..close()
      // ..addOval(Rect.fromLTWH(
      //     position1.x - radius, position1.y - radius, radius * 2, radius * 2))
      // ..addOval(Rect.fromLTWH(
      //     position2.x - radius, position2.y - radius, radius * 2, radius * 2))
      ..addRect(Rect.fromLTWH(
          0.0, 0.0, ScreenUtil().setWidth(1080), ScreenUtil().setWidth(2500)))
      ..fillType = PathFillType.evenOdd;

    return path;
//     return new Path()
//       ..addRRect(RRect.fromRectAndRadius(
//           Rect.fromLTRB(10, 10, 90, 50),
// //          Rect.fromLTRB(
// //              leftPos, topPos, leftPos+radius * 2.1, 100),
//           Radius.circular(70)))
//       ..addRect(Rect.fromLTWH(
//           0.0, 0.0, ScreenUtil().setWidth(1080), ScreenUtil().setWidth(2500)))
//       ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class InvertedCircleClipper extends CustomClipper<Path> {
  double radius;
  double dy;

  InvertedCircleClipper(this.radius, this.dy);

  @override
  Path getClip(Size size) {
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

class GuidanceFingerInRRectWidget extends StatelessWidget {
  final double left;
  final double top;

  GuidanceFingerInRRectWidget(this.left, this.top);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        // 屏幕高-金币速度视图bottom值 +statusBarHeight+手指height
        top: top + ScreenUtil().setWidth(150),
        left: left,
        child: Container(
            child: Image.asset(
          "assets/image/guidance_finger.png",
          width: ScreenUtil().setWidth(120),
          height: ScreenUtil().setWidth(130),
        )));
  }
}

class GuidanceDrawRecycleWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GuidanceDrawRecycleState();
}

class _GuidanceDrawRecycleState extends State<GuidanceDrawRecycleWidget>
    with TickerProviderStateMixin {
  CurvedAnimation curveEaseIn;
  AnimationController controller;
  Animation<double> leftPosAnimation;

  Tween<double> scaleTween;
  bool enableFingerAnimatino = false;
  double dy = 0.0;

  Position startPosition = Position(x: 0.0, y: 0.0);
  Position endPosition = Position(x: 0.0, y: 0.0);
  Position treePosition;
  @override
  void initState() {
    super.initState();
    BurialReport.report('page_imp', {'page_code': '031'});

    controller = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
    curveEaseIn =
        new CurvedAnimation(parent: controller, curve: Curves.easeOut);

    leftPosAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curveEaseIn);

    // WidgetsBinding.instance.addPostFrameCallback((_) {

    //   _playAnimation();
    // });
  }

  _playAnimation() async {
    Future.delayed(Duration(microseconds: 50)).then((_) {
      startPosition = _Util.getCenter(
          Consts.treeGroupGlobalKey[treePosition.y][treePosition.x]);
      endPosition = _Util.getCenter(Consts.globalKeyAddTreeBtn);
      controller..repeat();
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<LuckyGroup, Position>(
      selector: (context, provider) => provider.showRecycleRectGuidance,
      builder: (_, Position position, __) {
        bool show = position != null;
        // show = false;
        if (show) {
          print('--------------------_playAnimation----------');
          _playAnimation();
        }
        treePosition = position;
        return AnimatedBuilder(
            builder: (BuildContext context, Widget child) {
              double left =
                  (endPosition.x - startPosition.x) * leftPosAnimation.value +
                      startPosition.x;
              double top =
                  (endPosition.y - startPosition.y) * leftPosAnimation.value +
                      startPosition.y;
//                print("topPosAnimation?.value: ${topPosAnimation?.value}, $dy");
              return show
                  ? Stack(
                      children: <Widget>[
                        ClipPath(
                          clipper: InvertedCircleClipper1(
                            ScreenUtil().setWidth(200),
                            dx: left,
                            dy: top,
                          ),
                          child: GestureDetector(
                              onTap: () {
                                LuckyGroup lucky = Provider.of<LuckyGroup>(
                                    context,
                                    listen: false);
                                lucky.showRecycleRectGuidance = null;
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(1080),
                                height: ScreenUtil().setWidth(2500),
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              )),
                        ),
                        Positioned(
                            // 屏幕高-金币速度视图bottom值 +statusBarHeight+手指height
                            top: top,
                            left: left - ScreenUtil().setWidth(80),
                            child: BreatheAnimation(
                              child: Container(
                                  child: Image.asset(
                                "assets/image/guidance_finger.png",
                                width: ScreenUtil().setWidth(120),
                                height: ScreenUtil().setWidth(130),
                              )),
                            ))
//                          enableFingerAnimatino
//                              ? GuidanceFingerInRRectWidget(
//                                  fingerLeftPosAnimation.value, dy)
//                              : Container(),
                      ],
                    )
                  : Container();
            },
            animation: controller);
      },
    );
  }
}

class _Util {
  static Offset getOffset(GlobalKey globalKey) {
    RenderBox renderBox = globalKey.currentContext?.findRenderObject();
    Offset offset = renderBox?.localToGlobal(Offset.zero);
    return offset;
  }

  static Size getSize(GlobalKey globalKey) => globalKey.currentContext.size;

  static Position getCenter(GlobalKey globalKey) {
    Offset offset = getOffset(globalKey);
    Size size = getSize(globalKey);
    return new Position(
        x: (offset.dx + size.width / 2), y: offset.dy + size.height / 2);
  }
}

class InvertedCircleClipper1 extends CustomClipper<Path> {
  double radius;
  double dy;
  double dx;

  InvertedCircleClipper1(this.radius, {this.dx, this.dy});

  @override
  Path getClip(Size size) {
    return new Path()
      ..addOval(Rect.fromCircle(center: Offset(dx, dy), radius: radius))
      ..addRect(Rect.fromLTWH(
          0.0, 0.0, ScreenUtil().setWidth(1080), ScreenUtil().setHeight(1920)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
