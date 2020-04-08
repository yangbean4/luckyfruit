import 'package:flutter/material.dart';

// 帧动画Image
class FrameAnimationImage extends StatefulWidget {
  final List<String> _assetList;
  final double width;
  final double height;
  final int interval;
  final void Function() onFinish;

  FrameAnimationImage(this._assetList,
      {this.width, this.height, this.interval = 200, this.onFinish});

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

  @override
  void initState() {
    super.initState();

    // 把所有图片都加载进内容，否则每一帧加载时会卡顿
    for (int i = 0; i < widget._assetList.length; ++i) {
      images.add(Image.asset(widget._assetList[i],
          width: widget.width, height: widget.height, gaplessPlayback: true));
    }

    final int imageCount = widget._assetList.length;

    // 启动动画controller
    _controller = new AnimationController(
        duration: Duration(milliseconds: widget.interval), vsync: this);

    _animation = new Tween<double>(begin: 0, end: imageCount.toDouble())
        .animate(_controller);

    runAction();
    // ..addStatusListener((AnimationStatus status) {
    //   if (status == AnimationStatus.completed) {
    //     // _controller.forward(from: 0.0); // 完成后重新开始
    //     widget.onFinish();
    //   }
    // });

    // _controller.forward();
  }

  runAction() async {
    await _controller.forward();
    widget.onFinish();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        int ix = _animation.value.floor() % widget._assetList.length;
        return images[ix];
      },
    );
    // return Stack(alignment: AlignmentDirectional.center, children: images);
  }
}
