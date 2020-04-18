import 'dart:async';
import 'dart:math' show max;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import 'package:luckyfruit/models/index.dart' show BarrageMsg;
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/config/app.dart' show App;

class Barrage extends StatefulWidget {
  Barrage({Key key}) : super(key: key);

  @override
  _BarrageState createState() => _BarrageState();
}

class _BarrageState extends State<Barrage> {
  List<BarrageMsg> barrageMsgList = [];
  String userId;
  Timer timer;
  Timer showTimer;
  int index;
  int animationTime = 8000;
  bool show = false;
  ScrollController controller =
      ScrollController(keepScrollOffset: false, initialScrollOffset: 0.0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      UserModel userModel = Provider.of<UserModel>(context, listen: false);
      userId = userModel.value.acct_id;
      getList();
    });
    Timer.periodic(Duration(seconds: App.BarrageTimer), (_timer) {
      timer = _timer;
      getList();
    });
  }

  getList() async {
    showTimer?.cancel();
    if (mounted) {
      setState(() {
        index = 0;
        show = false;
      });
    }

    List list = await Service().getBarrageList({'acct_id': userId});
    barrageMsgList = list.map((e) => BarrageMsg.fromJson(e)).toList();

    if (barrageMsgList.length != 0) {
      Timer.periodic(
          Duration(
              milliseconds: max(
                  // 取分时 和 动画时长的最大值
                  App.BarrageTimer * 1000 ~/ (list.length + 1),
                  animationTime)), (_timer) {
        showTimer = _timer;
        showNext();
      });
    }
  }

  showNext() {
    if (mounted) {
      setState(() {
        index = (index + 1) % barrageMsgList.length;
        show = true;
      });

      Future.delayed(Duration(milliseconds: 300), () {
        if (mounted) {
          try {
            controller?.animateTo(ScreenUtil().setWidth(820 * 2),
                duration: Duration(milliseconds: animationTime),
                curve: Curves.easeIn);
            Future.delayed(Duration(milliseconds: animationTime), () {
              if (mounted) {
                setState(() {
                  show = false;
                });
              }
            });
          } catch (e) {}
        }
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    timer?.cancel();
    showTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    BarrageMsg msg = barrageMsgList.isNotEmpty ? barrageMsgList[index] : null;
    return show && msg != null
        ? Positioned(
            left: ScreenUtil().setWidth(130),
            top: ScreenUtil().setWidth(150),
            child: Container(
              width: ScreenUtil().setWidth(820),
              height: ScreenUtil().setWidth(44),
              color: Color.fromRGBO(0, 0, 0, 0.5),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: controller,
                  child: Row(children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(820),
                      height: ScreenUtil().setWidth(44),
                    ),
                    Text.rich(
                      TextSpan(text: 'Congratulations!"', children: [
                        TextSpan(
                            text: msg.nickname,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 207, 23, 1))),
                        TextSpan(text: '" gets '),
                        TextSpan(
                            text: msg.num,
                            style: TextStyle(
                                color: Color.fromRGBO(255, 76, 47, 1))),
                        TextSpan(
                            text:
                                ',${msg.module == '1' ? 'can redeem phone' : ''} immediately!'),
                      ]),
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setWidth(30),
                        height: 1,
                      ),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(820),
                      height: ScreenUtil().setWidth(44),
                    ),
                  ])),
            ))
        : Container();
  }
}
