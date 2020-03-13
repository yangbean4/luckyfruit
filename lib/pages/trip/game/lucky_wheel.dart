import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:oktoast/oktoast.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'dart:math';

class LuckyWheelWidget extends StatefulWidget {

  Animation<double> animation;
  AnimationController controller;


  startSpin() {
    controller.forward();
  }

  @override
  State<StatefulWidget> createState() => LuckyWheelWidgetState();
}

class LuckyWheelWidgetState extends State<LuckyWheelWidget>
    with SingleTickerProviderStateMixin {


  // 当前旋转的角度
  double angle = 0;
  // 结束后要选中的位置
  int finalPos = 6;

  initState() {
    super.initState();
    widget.controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    Animation curve =
        CurvedAnimation(parent: widget.controller, curve: Curves.easeInOutBack);

    // 要旋转的总弧度值
    double endRadian = 6 * pi + _getAngelWithSelectedPosition(finalPos);
    widget.animation = Tween(begin: 0.0, end: endRadian).animate(curve)
      ..addListener(() {
        // print("addListener animation.value = ${animation.value}");
        setState(() {
          angle = widget.animation.value;
        });
      })
      ..addStatusListener((status) {
        print("status= $status");
        if(status == AnimationStatus.completed){
          widget.controller.value = 0;
        }
      });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(600),
          height: ScreenUtil().setWidth(600),
          // color: Colors.red,
          child: Image.asset(
            "assets/image/lucky_wheel_round_board.png",
          ),
        ),
        Transform.rotate(
          angle: angle,
          child: Container(
            width: ScreenUtil().setWidth(550),
            height: ScreenUtil().setWidth(550),
            // color: Colors.green,
            child: Image.asset(
              "assets/image/lucky_wheel_gift_bg.png",
            ),
          ),
        ),
        Container(
          width: ScreenUtil().setWidth(200),
          height: ScreenUtil().setWidth(200),
          // color: Colors.blue,
          child: Image.asset(
            "assets/image/lucky_wheel_arrow.png",
          ),
        ),
      ],
    );
  }

  double _getAngelWithSelectedPosition(int pos) {
    var x = 0.14 * pi, y = 0.22 * pi, z = pi / 2;
    switch (pos) {
      case 1:
        return x;
        break;
      case 2:
        return x + y;
        break;
      case 3:
        return z + x;
        break;
      case 4:
        return z + x + y;
        break;
      case 5:
        return 2 * z + x;
        break;
      case 6:
        return 2 * z + x + y;
        break;
      case 7:
        return 3 * z + x;
        break;
      case 8:
        return 3 * z + x + y;
        break;
      default:
        return 0;
    }
  }
}
