import 'dart:async';
import 'dart:math';

import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/config/app.dart';
import './tree_animation.dart';

class TreeItem extends StatefulWidget {
  final Tree tree;
  TreeItem(
    this.tree, {
    Key key,
  }) : super(key: key);

  @override
  _TreeItemState createState() => _TreeItemState();
}

class _TreeItemState extends State<TreeItem> with TickerProviderStateMixin {
  AnimationController controller;

  // 控制是否显示 金币
  bool showGold = false;
  Timer timer;
  bool isDispose;
  @override
  void initState() {
    super.initState();
    isDispose = false;

    controller = AnimationController(
      duration:
          Duration(milliseconds: 1000 * AnimationConfig.TreeAnimationTime ~/ 8),
      vsync: this,
    );
    const period =
        Duration(milliseconds: 1000 ~/ AnimationConfig.TreeAnimationTime);
    Future.delayed(Duration(
            seconds: Random().nextInt(AnimationConfig.TreeAnimationTime ~/ 2)))
        .then((e) {
      Timer.periodic(period, (_timer) {
        if (!isDispose) {
          timer = _timer;
          controller.forward();
        } else {
          timer?.cancel();
        }
      });
    });
  }

  @override
  dispose() {
    isDispose = true;
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }

  // Future<void> runAction() async {
  //   await controller.forward().orCancel;
  //   // try {
  //   //   await controller.forward().orCancel;
  //   // } catch (e){

  //   // }
  //   // on TickerCanceled {
  //   //   print('1233');
  //   //   // the animation got canceled, probably because we were disposed
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return TreeAnimation(controller: controller, tree: widget.tree);
  }
}
