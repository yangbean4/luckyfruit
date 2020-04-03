import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/theme/index.dart';
import './tree_item.dart';
import './tree_no_animation.dart';
import 'package:luckyfruit/widgets/frame_animation_image.dart';

class GridItem extends StatefulWidget {
  final Tree tree;
  final Tree animateTargetTree;
  final Tree animateSourceTree;

  final bool showAnimation;
  GridItem({Key key, this.tree, this.animateTargetTree, this.animateSourceTree})
      : showAnimation = animateTargetTree != null,
        super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> with TickerProviderStateMixin {
  AnimationController _controller;

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

    return Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setWidth(210),
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
                              builder: (context, Function transRecycle, child) {
                                return Draggable(
                                    child: _tree,
                                    onDragStarted: () =>
                                        transRecycle(widget.tree),
                                    onDragEnd: (_) => transRecycle(null),
                                    // feedback: _tree,
                                    feedback: TreeNoAnimation(widget.tree),
                                    data: widget.tree,
                                    childWhenDragging: Container());
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
                        height: ScreenUtil().setWidth(200), onFinish: () {
                      TreeGroup treeGroup =
                          Provider.of<TreeGroup>(context, listen: false);

                      treeGroup
                          .removeAnimateTargetTree(widget.animateSourceTree);
                    }),
                  ),
                )
              : Container(),
          // Positioned(child: null)
        ],
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
