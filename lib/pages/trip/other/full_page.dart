import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/widgets/frame_animation_image.dart';

class FullPage extends StatelessWidget {
  final Function onFinish;
  final int length;
  final String pathTmp;
  final int interval;
  final double height;
  final double width;
  final bool repeat;
  const FullPage(
      {Key key,
      this.onFinish,
      this.length,
      this.pathTmp,
      this.interval,
      this.repeat,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // color: Colors.red,
      child: FrameAnimationImage(
          List<String>.generate(
              length, (e) => pathTmp.replaceAll('{index}', e.toString())),
          width: width,
          height: height,
          interval: interval ?? 800,
          repeat: repeat,
          onFinish: onFinish),
    );
  }
}
