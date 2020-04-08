import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/widgets/frame_animation_image.dart';

class FullPage extends StatelessWidget {
  final Function onFinish;
  final int length;
  final String pathTmp;
  final int interval;
  const FullPage(
      {Key key, this.onFinish, this.length, this.pathTmp, this.interval})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        bottom: ScreenUtil().setWidth(360),
        child: Container(
          width: ScreenUtil().setWidth(900),
          height: ScreenUtil().setWidth(1212),
          // width: ScreenUtil().setWidth(1080),
          // height: ScreenUtil().setWidth(1920),
          // color: Colors.red,
          child: FrameAnimationImage(
              // 'assets/image/merge/merge_$e.png'
              List<String>.generate(
                  length, (e) => pathTmp.replaceAll('{index}', e.toString())),
              width: ScreenUtil().setWidth(900),
              height: ScreenUtil().setWidth(1212),
              // width: ScreenUtil().setWidth(1080),
              // height: ScreenUtil().setWidth(1920),
              interval: interval ?? 800,
              onFinish: onFinish),
        ));
  }
}
