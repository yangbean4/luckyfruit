import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

import 'package:luckyfruit/provider/tree_group.dart';
import 'package:provider/provider.dart';

class LuckyWheelWidget extends StatefulWidget {
  Animation<double> animation;
  AnimationController controller;

  startSpin() {
    controller.value = 0;
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
  int finalPos = 0;
  Tween<double> curTween;

  String testJson = """{
        "gift_id": 2,
        "coin": 9000
    }""";

  initState() {
    super.initState();
    widget.controller = new AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

    Animation curve =
        CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut);

    // 要旋转的总弧度值
    double endRadian = 3 * 2 * pi + _getAngelWithSelectedPosition(finalPos);
    curTween = Tween<double>(begin: 0.0, end: endRadian);
    widget.animation = curTween.animate(curve)
      ..addListener(() {
        setState(() {
          print("setState() widget.animation.value= ${widget.animation.value}");
          // angle = widget.animation.value;
        });
      })
      ..addStatusListener((status) {
        print("status= $status");
        if (status == AnimationStatus.completed && finalPos == 0) {
          widget.controller.value = 0;
          widget.controller.forward();
        }
      });

    getLuckResult(context).then((coin) {
      updateTween();
    });
  }

  Future<int> getLuckResult(BuildContext context) async {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
    dynamic luckResultMap;
    // luckResultMap = await Service()
    //     .getLuckyWheelResult({'acct_id': treeGroup.acct_id, 'coin_speed': 100});

    //TODO 测试用
    luckResultMap = json.decode(testJson);
    print("luckResultMap= $luckResultMap");
    finalPos = luckResultMap['gift_id'] as num;
    int coin = luckResultMap['coin'] as num;
    print("返回的gift_id=$finalPos，coin=$coin");
    return coin;
  }

  ///接口中取到结果后更新
  updateTween() {
    double needAngle = _getAngelWithSelectedPosition(finalPos);
    curTween.end = curTween.end + needAngle;
    if (widget.controller.isAnimating) {
      widget.controller.forward();
    }
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
          angle: widget.animation.value,
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
            child: GestureDetector(
              onTap: () {
                print("onTap onTap...");
                updateTween();
              },
              child: Image.asset(
                "assets/image/lucky_wheel_arrow.png",
              ),
            )),
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
