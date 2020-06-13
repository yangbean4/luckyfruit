import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/widgets/frame_animation_image.dart';
import 'package:luckyfruit/widgets/opcity_animation.dart';
import 'package:provider/provider.dart';

import './tree_item.dart';
import './tree_no_animation.dart';

class GridItem extends StatefulWidget {
  final Tree tree;
  final Tree animateTargetTree;
  final Tree animateSourceTree;
  final FlowerPoint flowerPoint;

  final GlobalKey flowerKey;

  final bool showAnimation;
  final bool enableDrag;
  final Function(GlobalKey) onTap;

  GridItem({
    Key key,
    this.tree,
    this.animateTargetTree,
    this.flowerKey,
    this.animateSourceTree,
    this.enableDrag = true,
    this.onTap,
    this.flowerPoint,
  })  : showAnimation = animateTargetTree != null,
        super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> with TickerProviderStateMixin {
  AnimationController _controller;
  bool showFlower = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
        treeGroup.removeAnimateTargetTree(widget.animateSourceTree);
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _tree = TreeItem(widget.tree);
    FlowerPoint flowerPoint = widget.flowerPoint;
    int flower = flowerPoint != null && flowerPoint.showGridAnimate
        ? flowerPoint.count
        : 0;
    int reverseFlower = flowerPoint != null && flowerPoint.showGridReverse
        ? flowerPoint.count
        : 0;
    Widget opcityChild = Container(
      width: ScreenUtil().setWidth(120),
      height: ScreenUtil().setWidth(41),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Image.asset(
          'assets/image/flower/img_flower.png',
          key: widget.flowerKey,
          width: ScreenUtil().setWidth(40),
          height: ScreenUtil().setWidth(41),
        ),
        Center(
            child: Stack(children: <Widget>[
          Text(
            'x $flower',
            style: TextStyle(
                height: 1,
                foreground: new Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = ScreenUtil().setWidth(8)
                  ..color = Color.fromRGBO(196, 61, 27, 1),
                fontFamily: FontFamily.bold,
                fontSize: ScreenUtil().setSp(30),
                fontWeight: FontWeight.bold),
          ),
          Text(
            'x $flower',
            style: TextStyle(
                color: Colors.white,
                height: 1,
                fontFamily: FontFamily.bold,
                fontSize: ScreenUtil().setSp(30),
                fontWeight: FontWeight.bold),
          )
        ]))
      ]),
    );

    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setWidth(210),
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null && widget.tree != null) {
            widget.onTap(widget.key);
          }
        },
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setWidth(100),
                    decoration: BoxDecoration(
                        color: MyTheme.grayColor,
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(ScreenUtil().setWidth(200) / 2,
                              ScreenUtil().setWidth(100) / 2),
                        )))),

            widget.tree != null
                ? widget.animateSourceTree == null
                    ? Positioned(
                        bottom: ScreenUtil().setWidth(25),
                        child: Center(
                            child: Selector<TreeGroup, Function>(
                                selector: (context, provider) =>
                                    provider.transRecycle,
                                shouldRebuild: (pre, next) => false,
                                builder:
                                    (context, Function transRecycle, child) {
                                  return widget.enableDrag
                                      ? Draggable(
                                          child: _tree,
                                          onDragStarted: () =>
                                              transRecycle(widget.tree),
                                          onDragEnd: (_) => transRecycle(null),
                                          // feedback: _tree,
                                          feedback:
                                              TreeNoAnimation(widget.tree),
                                          data: widget.tree,
                                          childWhenDragging: Container())
                                      : _tree;
                                })),
                      )
                    : _TreeMerge(
                        animateTargetTree: widget.animateTargetTree,
                        animateSourceTree: widget.animateSourceTree,
                      )
                : Container(),
            widget.showAnimation
                ? Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: ScreenUtil().setWidth(200),
                      height: ScreenUtil().setWidth(200),
                      // child: Lottie.asset(
                      //   'assets/lottiefiles/merge.json',
                      //   controller: _controller,
                      //   onLoaded: (composition) {
                      //     _controller.duration = composition.duration;
                      //     _controller
                      //       ..value = 0
                      //       ..forward();
                      //   },
                      // ),

                      child: FrameAnimationImage(
                        List<String>.generate(
                            19, (e) => 'assets/image/merge/merge_$e.png'),
                        width: ScreenUtil().setWidth(200),
                        interval: 300,
                        height: ScreenUtil().setWidth(200),
                        onFinish: () {
                          TreeGroup treeGroup =
                              Provider.of<TreeGroup>(context, listen: false);

                          treeGroup.removeAnimateTargetTree(
                              widget.animateSourceTree);
                        },
                      ),
                    ),
                  )
                : Container(),

            flower != 0
                ? Positioned(
                    left: ScreenUtil().setWidth(152),
                    bottom: ScreenUtil().setWidth(27),
                    child: OpacityAnimation(
                      animateTime: Duration(milliseconds: 700),
                      onForwardFinish: () {
                        TreeGroup treeGroup =
                            Provider.of<TreeGroup>(context, listen: false);
                        treeGroup.flowerGridAnimateEnd(flowerPoint);
                      },
                      child: opcityChild,
                    ),
                  )
                // ,)
                : Container(),
            reverseFlower != 0
                ? Positioned(
                    left: ScreenUtil().setWidth(152),
                    bottom: ScreenUtil().setWidth(27),
                    child: OpacityAnimation(
                      reverse: true,
                      animateTime: Duration(milliseconds: 700),
                      onForwardFinish: () {
                        TreeGroup treeGroup =
                            Provider.of<TreeGroup>(context, listen: false);
                        treeGroup.flowerGridAnimatReEnd(flowerPoint);
                      },
                      child: opcityChild,
                    ),
                  )
                : Container(),
            // Positioned(child: null)
          ],
        ),
      ),
    );
  }
}

class _TreeMerge extends StatefulWidget {
  final Tree animateTargetTree;
  final Tree animateSourceTree;

  _TreeMerge({Key key, this.animateTargetTree, this.animateSourceTree})
      : super(key: key);

  @override
  __TreeMergeState createState() => __TreeMergeState();
}

class __TreeMergeState extends State<_TreeMerge> with TickerProviderStateMixin {
  Animation<double> treeAnimation;
  AnimationController treeAnimationController;

  void initState() {
    super.initState();
    treeAnimationController = new AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    final CurvedAnimation treeCurve =
        new CurvedAnimation(parent: treeAnimationController, curve: _MyCurve());
    treeAnimation = new Tween(
      begin: 0.0,
      end: 1.1,
    ).animate(treeCurve);
    runAction();
  }

  @override
  void dispose() {
    treeAnimationController?.dispose();

    super.dispose();
  }

  runAction() async {
    await treeAnimationController.forward();
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
    treeGroup.treeMergeAnimateEnd(widget.animateTargetTree);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: ScreenUtil().setWidth(25),
      left: ScreenUtil().setWidth(-50),
      child: Container(
        width: ScreenUtil().setWidth(300),
        height: ScreenUtil().setWidth(190),
        child: Stack(
          children: <Widget>[
            AnimatedBuilder(
                animation: treeAnimation,
                builder: (BuildContext context, Widget child) {
                  return Positioned(
                    bottom: 0,
                    left: ScreenUtil().setWidth(80 * treeAnimation.value - 30),
                    child: TreeNoAnimation(widget.animateSourceTree),
                  );
                }),
            AnimatedBuilder(
                animation: treeAnimation,
                builder: (BuildContext context, Widget child) {
                  return Positioned(
                    bottom: 0,
                    right: ScreenUtil().setWidth(80 * treeAnimation.value - 30),
                    child: TreeNoAnimation(widget.animateTargetTree),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class _MyCurve extends Curve {
  @override
  double transformInternal(double t) {
    return t < 0.8 ? 1 - 1.25 * t : 5 * t - 4;
  }
}
