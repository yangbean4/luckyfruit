/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-29 19:35:46
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-10 19:05:32
 */

import 'dart:math';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/utils/position.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FlowerFlyingAnimation extends StatefulWidget {
  FlowerFlyingAnimation({Key key}) : super(key: key);

  @override
  _FlowerFlyingAnimationState createState() => _FlowerFlyingAnimationState();
}

class _FlowerFlyingAnimationState extends State<FlowerFlyingAnimation> {
  Offset offsetEnd;
  List<List<Offset>> offsetStrList;

  static Offset getPhonePositionInfoWithGlobalKey(GlobalKey globalKey) {
    Offset offset = Offset(0, 0);
    RenderBox renderBox = globalKey.currentContext?.findRenderObject();
    offset = renderBox?.localToGlobal(Offset.zero);
    return offset;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        offsetEnd =
            getPhonePositionInfoWithGlobalKey(Consts.globalKeyFlowerPosition);
        offsetStrList = getOffset();
      });
    });
  }

  List<List<Offset>> getOffset() {
    List<List<Offset>> grids = List(GameConfig.Y_AMOUNT);
    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      List<Offset> yFlower = List(GameConfig.X_AMOUNT);

      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        yFlower[x] =
            getPhonePositionInfoWithGlobalKey(Consts.treeGroupGlobalKey[y][x]);
      }
      grids[y] = yFlower;
    }
    return grids;
  }

  List<Widget> renderGridforPos(BuildContext context) {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context);
    List<List<FlowerPoint>> flowerMatrix = treeGroup.flowerMatrix;

    List<Widget> grids = [];

    for (int y = 0; y < GameConfig.Y_AMOUNT; y++) {
      for (int x = 0; x < GameConfig.X_AMOUNT; x++) {
        FlowerPoint flowerPoint = flowerMatrix[y][x];

        grids.add(Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setHeight(1920),
            child: _FlyFlower(
              flowerFlyPoint: flowerPoint,
              offsetEnd: offsetEnd,
              offsetStrList: offsetStrList,
              onFinish: () {
                TreeGroup treeGroup =
                    Provider.of<TreeGroup>(context, listen: false);
                treeGroup.flowerFlyAnimatReEnd(flowerPoint);
              },
            ),
          ),
        ));
      }
    }
    return grids;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        top: 0,
        child: Container(
          width: ScreenUtil().setWidth(1080),
          height: ScreenUtil().setHeight(1920),
          // color: Colors.red,
          child: Stack(
            children: renderGridforPos(context),
          ),
        ));
  }
}

class _FlyFlower extends StatelessWidget {
  final FlowerPoint flowerFlyPoint;
  final Function onFinish;
  final Offset offsetEnd;
  final List<List<Offset>> offsetStrList;

  _FlyFlower(
      {Key key,
      this.flowerFlyPoint,
      this.onFinish,
      this.offsetStrList,
      this.offsetEnd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Offset offsetSt;

    if (flowerFlyPoint != null && offsetEnd != null) {
      offsetSt = offsetStrList[flowerFlyPoint.y][flowerFlyPoint.x];
    }
    return offsetSt != null &&
            offsetEnd != null &&
            flowerFlyPoint != null &&
            flowerFlyPoint.count != 0 &&
            flowerFlyPoint.showFlyAnimate
        ? _FlyGroup(
            onFinish: onFinish,
            count: 1,
            endPos: Position(
                x: offsetEnd.dx + ScreenUtil().setWidth(15),
                y: offsetEnd.dy + ScreenUtil().setWidth(15)),
            startCenter: Position(
                x: offsetSt.dx + ScreenUtil().setWidth(172),
                y: offsetSt.dy + ScreenUtil().setWidth(160)),
            radius: ScreenUtil().setWidth(20),
            animateTime: Duration(milliseconds: 1000),
            child: Container(
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(41),
              child: Image.asset(
                'assets/image/flower/img_flower.png',
                width: ScreenUtil().setWidth(40),
                height: ScreenUtil().setWidth(41),
              ),
            ),
          )
        : Container();
  }
}

typedef Widget _BuilderFun(BuildContext context,
    {Animation<double> top, Animation<double> size, Animation<double> opacity});

class _FlyGroup extends StatefulWidget {
  final Widget child;
  // 终点位置
  final Position endPos;
  // 开始的中心点位置
  final Position startCenter;
  // 散落的半径
  final double radius;
  // start的个数
  final int count;
  final Function onFinish;
  final Duration animateTime;

  _FlyGroup(
      {Key key,
      this.endPos,
      this.startCenter,
      this.animateTime = const Duration(milliseconds: 600),
      this.radius,
      this.count = 10,
      this.child,
      this.onFinish})
      : super(key: key);

  @override
  __FlyGroupState createState() => __FlyGroupState();
}

class __FlyGroupState extends State<_FlyGroup> {
  List<_Star> starList;
  @override
  void initState() {
    super.initState();
    starList = List.generate(
        widget.count, (e) => _Star(widget.startCenter, widget.radius));
  }

  @override
  Widget build(BuildContext context) {
    double ex = widget.endPos.x;
    double ey = widget.endPos.y;
    return RepaintBoundary(
      child: FlyAnimation(
          onFinish: widget.onFinish,
          animateTime: widget.animateTime,
          builder: (ctx,
              {Animation<double> top,
              Animation<double> size,
              Animation<double> opacity}) {
            return Stack(
                children: starList.map((_Star star) {
              double sx = star.position.x;
              double sy = star.position.y;

              return Positioned(
                  left: sx + (ex - sx) * top.value,
                  top: sy + (ey - sy) * top.value,
                  child: Transform.scale(
                      alignment: Alignment.center,
                      scale: size.value,
                      child: Opacity(
                          opacity: opacity.value, child: widget.child)));
            }).toList());
          }),
    );
  }
}

class _Star {
  // 开始的中心点位置
  final Position startCenter;
  // 散落的半径
  final double radius;

  Position position;
  _Star(this.startCenter, this.radius) {
    double x = 1 - (Random().nextInt(200) / 100) * radius + startCenter.x;
    double y = 1 - (Random().nextInt(200) / 100) * radius + startCenter.y;
    position = Position(x: x, y: y);
  }
}

class FlyAnimation extends StatefulWidget {
  final Duration animateTime;
  final _BuilderFun builder;
  final Function onFinish;

  FlyAnimation({
    Key key,
    this.animateTime = const Duration(milliseconds: 600),
    this.builder,
    this.onFinish,
  }) : super(key: key);

  @override
  _FlyAnimationState createState() => _FlyAnimationState();
}

class _FlyAnimationState extends State<FlyAnimation>
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
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onFinish();
          controller.reset();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
            curve: Interval(0.65, 1.0, curve: Curves.easeIn))),
        // 大小
        enlargeSize = Tween<double>(
          begin: 1.0,
          end: 2.0,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.6, curve: Curves.bounceInOut))),
        opacityAnimation = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(1.0, 1.0, curve: Curves.bounceInOut))),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> enlargeSize;
  final Animation<double> positionTop;
  final Animation<double> opacityAnimation;
  final _BuilderFun builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, Widget child) {
        return builder(context,
            top: positionTop, size: enlargeSize, opacity: opacityAnimation);
      },
    );
  }
}
