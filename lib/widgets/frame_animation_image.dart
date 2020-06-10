/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-04-21 14:48:57
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-10 16:25:28
 */
import 'package:flutter/material.dart';

// 帧动画Image
class FrameAnimationImage extends StatefulWidget {
  final List<String> _assetList;
  final double width;
  final double height;
  final int interval;
  final bool repeat;
  final void Function() onFinish;

  FrameAnimationImage(this._assetList,
      {this.width,
      this.height,
      this.interval = 200,
      this.repeat = false,
      this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return _FrameAnimationImageState();
  }
}

class _FrameAnimationImageState extends State<FrameAnimationImage>
    with TickerProviderStateMixin {
  // 动画控制
  Animation<double> _animation;
  AnimationController _controller;
  List<Widget> images = [];
  bool check = false;

  @override
  void initState() {
    super.initState();

    // 把所有图片都加载进内容，否则每一帧加载时会卡顿
    for (int i = 0; i < widget._assetList.length; ++i) {
      images.add(Container(
        // color: Colors.orange,
        width: widget.width, height: widget.height,
        // alignment: Alignment.topCenter,
        child: Image.asset(
          widget._assetList[i],
          gaplessPlayback: true,
          fit: BoxFit.fill,
        ),
      ));
    }

    final int imageCount = widget._assetList.length;

    // 启动动画controller
    _controller = new AnimationController(
        duration: Duration(milliseconds: widget.interval), vsync: this);

    _animation = new Tween<double>(begin: 0, end: imageCount.toDouble())
        .animate(_controller);
    runAction();
  }

  runAction() async {
    if (widget.repeat) {
      await _controller.repeat().orCancel;
    } else {
      if (!check && mounted) {
        await _controller.forward();
      }
      // try {
      // } catch (e) {}
    }
    widget.onFinish();
  }

  @override
  void dispose() {
    _controller.dispose();
    check = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          int ix = _animation.value.floor() % widget._assetList.length;
          return images[ix];
        },
      ),
    );
    // return Stack(alignment: AlignmentDirectional.center, children: images);
  }
}
