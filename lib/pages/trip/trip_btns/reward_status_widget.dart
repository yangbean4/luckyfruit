import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/count_down.dart';
import 'package:provider/provider.dart';

enum RewardStatusType {
  DOUBLE_REWARD_INIT,
  DOUBLE_REWARD_START,
  AUTO_MERGE_INIT,
  AUTO_MERGE_START,
}

class RewardStatusWidget extends StatefulWidget {
  final RewardStatusType rewardType;
  final int countDownTimeInSeconds;
  RewardStatusWidget(
      {Key key,
      @required this.rewardType,
      @required this.countDownTimeInSeconds})
      : super(key: key);

  @override
  _RewardStatusWidgetState createState() => _RewardStatusWidgetState();
}

class _RewardStatusWidgetState extends State<RewardStatusWidget> {
  var bottomWidget, topWidget;
  var iconSrc;
  var bgColor = Colors.transparent;

  @override
  initState() {
    print("initState iconSrc= $iconSrc");

    switch (widget.rewardType) {
      case RewardStatusType.DOUBLE_REWARD_START:
        initWidgetsWithStartType("Earning X2");
        iconSrc = "assets/image/end_double_reward.png";
        break;
      case RewardStatusType.AUTO_MERGE_START:
        initWidgetsWithStartType("Auto Merge");
        iconSrc = "assets/image/end_auto_merge.png";
        break;
      case RewardStatusType.DOUBLE_REWARD_INIT:
        iconSrc = "assets/image/videoad_reward_status.png";
        bgColor = Colors.green;
        initWidgetsWithInitType("In 300s");
        topWidget = Row(children: [
          Image.asset(
            "assets/image/gold_double_reward.png",
            width: ScreenUtil().setWidth(36),
            height: ScreenUtil().setWidth(36),
          ),
          Text("x2",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: FontFamily.bold,
                  fontSize: ScreenUtil().setSp(36),
                  fontWeight: FontWeight.bold)),
        ]);
        break;
      case RewardStatusType.AUTO_MERGE_INIT:
        bgColor = Colors.green;
        iconSrc = "assets/image/videoad_reward_status.png";
        initWidgetsWithInitType("In ${widget.countDownTimeInSeconds}s");
        topWidget = Text("Auto Merge",
            style: TextStyle(
                color: Color.fromRGBO(255, 76, 47, 1),
                height: 1,
                fontFamily: FontFamily.bold,
                fontSize: ScreenUtil().setSp(28),
                fontWeight: FontWeight.bold));
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build iconSrc= $iconSrc");
    return Container(
      // color: Colors.green,
      padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ScreenUtil().setWidth(56)),
          bottomLeft: Radius.circular(ScreenUtil().setWidth(56)),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
            child: Image.asset(
              iconSrc,
              width: ScreenUtil().setWidth(72),
              height: ScreenUtil().setWidth(72),
            ),
          ),
          Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(20),
                  bottom: ScreenUtil().setWidth(10)),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(ScreenUtil().setWidth(10)),
                ),
              ),
              child: Column(
                children: [topWidget, bottomWidget],
              ))
        ],
      ),
    );
  }

  initWidgetsWithStartType(String topWidgetTitle) {
    bottomWidget = CountdownFormatted(
        duration: Duration(seconds: widget.countDownTimeInSeconds),
        onFinish: () {},
        builder: (context, Duration duration) {
          return Text(
            Util.formatCountDownTimer(duration),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: FontFamily.bold,
                fontSize: ScreenUtil().setSp(30),
                fontWeight: FontWeight.bold),
          );
        });
    topWidget = Text(
      topWidgetTitle,
      style: TextStyle(
          color: Color.fromRGBO(255, 76, 47, 1),
          height: 1,
          fontFamily: FontFamily.bold,
          fontSize: ScreenUtil().setSp(28),
          fontWeight: FontWeight.bold),
    );
  }

  initWidgetsWithInitType(String bottomWidgetTitle) {
    bottomWidget = Text(bottomWidgetTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontFamily: FontFamily.bold,
            fontSize: ScreenUtil().setSp(30),
            fontWeight: FontWeight.bold));
  }
}
