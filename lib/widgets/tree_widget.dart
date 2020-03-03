import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/theme/elliptical_widget.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/mould/tree.mould.dart';

// 树+等级树根
class TreeWidget extends StatelessWidget {
  final num imgWidth;
  final num imgHeight;
  final String imgSrc;
  final num labelWidth;
  final bool primary;
  final String label;
  final Tree tree;
  const TreeWidget(
      {Key key,
      this.imgWidth,
      this.imgHeight,
      this.imgSrc,
      this.labelWidth,
      this.label,
      this.tree,
      this.primary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: imgWidth,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: imgWidth,
              height: imgHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgSrc ?? tree?.treeImgSrc),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            EllipticalWidget(
              width: labelWidth,
              height: labelWidth / 2,
              color: primary ? MyTheme.primaryColor : Colors.white,
              child: Center(
                  child: Text(
                label ?? tree?.grade.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: !primary ? MyTheme.primaryColor : Colors.white,
                    fontSize: ScreenUtil().setWidth(24),
                    fontWeight: FontWeight.w600),
              )),
            )
          ]),
    );
  }
}
