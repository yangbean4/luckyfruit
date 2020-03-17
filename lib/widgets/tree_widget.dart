import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/public/elliptical_widget.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/mould/tree.mould.dart';

import 'count_down.dart';
import 'layer.dart';

// 树+等级树根
class TreeWidget extends StatelessWidget {
  final num imgWidth;
  final num imgHeight;
  final String imgSrc;
  final num labelWidth;
  final num labelHeight;
  final bool primary;
  final String label;
  final Tree tree;
  final Widget image;
  // 是否显示右上角倒计时图案，限时分红树时需要使用
  final bool showCountDown;
  const TreeWidget(
      {Key key,
      this.imgWidth,
      this.imgHeight,
      this.imgSrc,
      this.labelWidth,
      this.labelHeight,
      this.label,
      this.tree,
      this.primary,
      this.showCountDown = false,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num _labelHeight = labelHeight ?? (labelWidth / 2);
    return Container(
      width: imgWidth,
      height: _labelHeight + imgHeight - imgHeight * 0.118,
      child: Stack(overflow: Overflow.visible, children: <Widget>[
        Positioned(
          bottom: _labelHeight - imgHeight * 0.118,
          // child: image ??
          //     Image.asset(
          //       imgSrc ?? tree?.treeImgSrc,
          //       width: imgWidth,
          //       height: imgHeight,
          //     )
          child: Container(
            width: imgWidth,
            height: imgHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imgSrc ?? tree?.treeImgSrc),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: (imgWidth - labelWidth) / 2,
            child: EllipticalWidget(
              width: labelWidth,
              height: _labelHeight,
              color: primary ? MyTheme.primaryColor : Colors.white,
              child: Center(
                  child: Text(
                label ?? tree?.grade.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: !primary ? MyTheme.primaryColor : Colors.white,
                    fontFamily: FontFamily.bold,
                    fontSize: ScreenUtil().setWidth(40),
                    height: 1,
                    fontWeight: FontWeight.w600),
              )),
            )),
        this.showCountDown
            ? Positioned(
                top: ScreenUtil().setWidth(0),
                right: ScreenUtil().setWidth(0),
                child: CountdownFormatted(
                    duration: Duration(seconds: 20),
                    onFinish: () {
                      print("限时分红树倒计时完成");
                      Layer.limitedTimeBonusTreeEndUp(context, tree);
                    },
                    builder: (context, String str) {
                      return Text(
                        str,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            backgroundColor: Colors.grey,
                            height: 1,
                            fontFamily: FontFamily.bold,
                            fontSize: ScreenUtil().setWidth(20),
                            fontWeight: FontWeight.bold),
                      );
                    }))
            : Container()
      ]),
    );
  }
}
