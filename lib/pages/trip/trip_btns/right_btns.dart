import 'package:flutter/material.dart';
import 'package:luckyfruit/theme/index.dart';

import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/widgets/count_down.dart';

class RightBtns extends StatefulWidget {
  RightBtns({Key key}) : super(key: key);

  @override
  _RightBtnsState createState() => _RightBtnsState();
}

class _RightBtnsState extends State<RightBtns>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // 是否显示双倍的入口按钮
  bool showDouble = false;
  // 当前是双倍
  bool isDouble = false;

  bool showAuto = false;

  bool isAuto = false;
  LuckyGroup luckyGroup;
  // 下发的配置
  Issued issed;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LuckyGroup _luckyGroup = Provider.of<LuckyGroup>(context);

    if (_luckyGroup != null) {
      Issued _issed = _luckyGroup.issed;
      setState(() {
        luckyGroup = _luckyGroup;
        issed = _issed;
      });
      if (issed?.game_timeLen != null) {
        Future.delayed(Duration(seconds: issed?.game_timeLen)).then((e) {
          luckyGroup.adTimeCheck(Duration(seconds: _issed?.two_adSpace), () {
            setState(() {
              showDouble = true;
            });
            // 设置的时间后 隐藏
            Future.delayed(Duration(seconds: issed?.automatic_remain_time))
                .then((e) {
              setState(() {
                showDouble = false;
              });
            });
          });
        });
      }

      if (issed?.automatic_game_timelen != null) {
        Future.delayed(Duration(seconds: issed?.automatic_game_timelen))
            .then((e) {
          luckyGroup.adTimeCheck(
              Duration(seconds: _issed?.automatic_two_adSpace), () {
            setState(() {
              showAuto = true;
            });
            // 设置的时间后 隐藏
            Future.delayed(Duration(seconds: issed?.automatic_remain_time))
                .then((e) {
              setState(() {
                showAuto = false;
              });
            });
          });
        });
      }
    }
  }

  renderItem(
    String imgSrc, {
    Widget top,
    Widget bottom,
    String topString,
    String bottomString,
    Color color,
  }) {
    return Container(
      width: ScreenUtil().setWidth(288),
      height: ScreenUtil().setWidth(112),
      decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.6),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(ScreenUtil().setWidth(56)),
              topLeft: Radius.circular(ScreenUtil().setWidth(56)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imgSrc,
            width: ScreenUtil().setWidth(72),
            height: ScreenUtil().setWidth(72),
          ),
          Container(
            width: ScreenUtil().setWidth(166),
            height: ScreenUtil().setWidth(90),
            decoration: BoxDecoration(
              color: color,
              borderRadius: color != null
                  ? BorderRadius.all(Radius.circular(ScreenUtil().setWidth(10)))
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                top == null
                    ? ThirdText(
                        topString,
                        color: MyTheme.redColor,
                      )
                    : top,
                bottom == null
                    ? ThirdText(
                        bottomString,
                        color: Colors.white,
                      )
                    : bottom,
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        showDouble
            ? GestureDetector(
                onTap: () {
                  luckyGroup.doubleStart();
                  setState(() {
                    showDouble = false;
                    isDouble = true;
                  });
                },
                child: renderItem('assets/image/vadio.png',
                    bottomString: 'in ${issed?.limited_time} s',
                    top: GoldText('x${issed?.reward_multiple}',
                        iconSize: 36, textSize: 36, textColor: Colors.white),
                    color: Color.fromRGBO(49, 200, 84, 1)),
              )
            : Container(),
        isDouble
            ? renderItem(
                'assets/image/double_glod.png',
                topString: 'EarningsX${issed?.reward_multiple} s',
                bottom: CountdownFormatted(
                  duration: Duration(seconds: issed?.limited_time),
                  onFinish: () {
                    luckyGroup.doubleEnd();
                    setState(() {
                      showDouble = false;
                      isDouble = false;
                    });
                  },
                  builder: (ctx, time) {
                    return ThirdText(
                      time,
                      color: Colors.white,
                    );
                  },
                ),
              )
            : Container(),
        showAuto
            ? GestureDetector(
                onTap: () {
                  luckyGroup.autoStart();
                  setState(() {
                    showAuto = false;
                    isAuto = true;
                  });
                },
                child: renderItem('assets/image/vadio.png',
                    bottomString: 'in ${issed?.automatic_game_timelen} s',
                    topString: 'Auto Merge',
                    color: Color.fromRGBO(49, 200, 84, 1)),
              )
            : Container(),
        isAuto
            ? renderItem(
                'assets/image/auto.png',
                topString: 'Auto Merge',
                bottom: CountdownFormatted(
                  duration: Duration(seconds: issed?.automatic_game_timelen),
                  onFinish: () {
                    luckyGroup.autoEnd();
                    setState(() {
                      showAuto = false;
                      isAuto = false;
                    });
                  },
                  builder: (ctx, time) {
                    return ThirdText(
                      time,
                      color: Colors.white,
                    );
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
