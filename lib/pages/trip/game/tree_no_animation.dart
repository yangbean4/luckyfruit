import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/theme/public/elliptical_widget.dart';
import 'package:luckyfruit/theme/index.dart';

Widget TreeNoAnimation(Tree tree) => Container(
      width: ScreenUtil().setWidth(200),
      height: ScreenUtil().setWidth(205),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          // Positioned(
          //     bottom: 0,
          //     left: ScreenUtil().setWidth(50),
          //     child: EllipticalWidget(
          //       width: ScreenUtil().setWidth(100),
          //       height: ScreenUtil().setWidth(50),
          //       color: MyTheme.darkGrayColor,
          //     )),
          Positioned(
              bottom: ScreenUtil().setWidth(10),
              child: TreeWidget(
                tree: tree,
                imgHeight: ScreenUtil().setWidth(140),
                imgWidth: ScreenUtil().setWidth(200),
                labelWidth: ScreenUtil().setWidth(60),
                primary: true,
              ))
        ],
      ),
    );
