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
  String text = '';
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
    setState(() {
      index = 0;
      show = false;
    });

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
    BarrageMsg msg = barrageMsgList[index];

    String _text =
        'Congratulations!"${msg.nickname}"gets ${msg.num} ,${msg.module == '1' ? 'can redeem phone' : ''} immediately!                     ';
    if (mounted) {
      setState(() {
        index = (index + 1) % barrageMsgList.length;
        show = true;
        text = _text;
      });
    }

    Future.delayed(Duration(milliseconds: 300), () {
      controller
          ?.animateTo(ScreenUtil().setWidth(_text.length * 30 + 820),
              duration: Duration(milliseconds: animationTime),
              curve: Curves.easeOutQuad)
          ?.then((e) {
        Future.delayed(Duration(milliseconds: animationTime), () {
          if (mounted) {
            setState(() {
              show = false;
            });
          }
        });
      });
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    timer.cancel();
    showTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return show
        ? Positioned(
            left: ScreenUtil().setWidth(130),
            top: ScreenUtil().setWidth(220),
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
                    Text(
                      text,
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setWidth(30),
                        height: 1,
                      ),
                    ),
                  ])),
            ))
        : Container();
  }
}
