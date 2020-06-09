import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart' show Issued;
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/widgets/circular_progress_route.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class RightBtns extends StatefulWidget {
  final String type;

  RightBtns({Key key, this.type}) : super(key: key);

  @override
  _RightBtnsState createState() => _RightBtnsState();
}

class _RightBtnsState extends State<RightBtns>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  renderItem({
    String type,
    Widget top,
    Widget bottom,
    String topString,
    String bottomString,
    Color color,
    bool userNoAdImg = false,
  }) {
    return Container(
      width: ScreenUtil().setWidth(294),
      height: ScreenUtil().setWidth(124),
      decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ScreenUtil().setWidth(20)),
            bottomLeft: Radius.circular(ScreenUtil().setWidth(20)),
          )),
      child: Row(
        children: <Widget>[
          // Positioned(
          //   left: ScreenUtil().setWidth(24),
          //   bottom: ScreenUtil().setWidth(0),
          //   child:
          Container(
            width: ScreenUtil().setWidth(116),
            height: ScreenUtil().setWidth(108),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/image/iright_btn_$type.png'),
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight)),
          ),
          // ),
          // Positioned(
          //     right: ScreenUtil().setWidth(24),
          //     bottom: ScreenUtil().setWidth(14),
          //     child:
          Container(
            width: ScreenUtil().setWidth(150),
            height: ScreenUtil().setWidth(76),
            alignment: Alignment(0.5, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                top == null
                    ? Text(
                        topString,
                        style: TextStyle(
                            height: 1,
                            color: Colors.white,
                            fontFamily: FontFamily.bold,
                            fontSize: ScreenUtil().setWidth(36),
                            fontWeight: FontWeight.bold),
                      )
                    : top,
                bottom == null
                    ? Text(
                        bottomString,
                        style: TextStyle(
                            height: 1,
                            color: Colors.white,
                            fontFamily: FontFamily.semibold,
                            fontSize: ScreenUtil().setWidth(36),
                            fontWeight: FontWeight.w500),
                      )
                    : bottom,
              ],
            ),
            // ),
          ),
        ],
      ),
    );
  }

  runderBottomString(String bottomString) {
    return Text(
      bottomString,
      style: TextStyle(
          color: Color.fromRGBO(255, 242, 94, 1),
          fontFamily: FontFamily.semibold,
          fontSize: ScreenUtil().setWidth(32),
          fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    return Selector<LuckyGroup,
        Tuple7<LuckyGroup, bool, bool, bool, bool, int, int>>(
      selector: (context, luckyGroup) => Tuple7(
        luckyGroup,
        luckyGroup.showDouble,
        luckyGroup.showAuto,
        luckyGroup.isDouble,
        luckyGroup.isAuto,
        luckyGroup.double_coin_time,
        luckyGroup.automatic_time,
      ),
      builder: (_, data, __) {
        LuckyGroup _luckyGroup = data.item1;
        Issued issed = data.item1.issed;

        bool showDouble = data.item2;
        bool showAuto = data.item3;
        bool isDouble = data.item4;
        bool isAuto = data.item5;
        int doubleTime = data.item6;
        int autoTime = data.item7;

        return Container(
//            width: ScreenUtil().setWidth(294),
//            height: ScreenUtil().setWidth(180),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.type == 'double' && showDouble
                    ? AdButton(
                        ad_code: '201',
                        adUnitIdFlag: 1,
                        onOk: (isFromAd) {
                          luckyGroup.doubleStart();
                        },
                        child: _ActiveItem(
                          size: 180,
                          typeChild: Positioned(
                            child: Lottie.asset(
                              'assets/lottiefiles/double/data.json',
                              width: ScreenUtil().setWidth(180),
                              height: ScreenUtil().setWidth(180),
                            ),
                          ),
                          totalDuration: issed?.double_coin_remain_time ?? 10,
                          emainingDuration:
                              _luckyGroup.doubleAaintainTime ?? 10,
                        ))
                    : Container(),
                widget.type == 'double' && isDouble
                    ? renderItem(
                        type: 'double',
                        topString: 'Earn X${issed?.reward_multiple}',
                        bottom: runderBottomString(
                          Util.formatCountDownTimer(
                              Duration(seconds: doubleTime ?? 2)),
                        ))
                    : Container(),
                widget.type == 'auto' && showAuto
                    ? AdButton(
                        ad_code: '202',
                        adUnitIdFlag: 2,
                        key: Consts.globalKeyAutoMerge,
                        useAd: !luckyGroup.showAutoMergeCircleGuidance,
                        onOk: (isFromAd) {
                          //success
                          luckyGroup.setShowAutoMergeCircleGuidance = false;
                          luckyGroup.setShowAutoMergeFingerGuidance = false;
                          luckyGroup.autoStart();
                          luckyGroup.autoMergeDurationFromLuckyWheel = 0;
                          setState(() {
                            isAuto = true;
                          });
                        },
                        child: _ActiveItem(
                          size: 210,
                          typeChild: Positioned(
//                            left: ScreenUtil().setWidth(-30),
//                            top: ScreenUtil().setWidth(-30),
                            child:
                                // Image.asset(
                                //   'assets/image/auto_merge.gif',
                                //   width: ScreenUtil().setWidth(260),
                                //   height: ScreenUtil().setWidth(260),
                                // )
                                Lottie.asset(
                              'assets/lottiefiles/automerge/auto.json',
                              width: ScreenUtil().setWidth(210),
                              height: ScreenUtil().setWidth(210),
                            ),
                          ),
                          totalDuration: issed?.automatic_remain_time ?? 10,
                          emainingDuration: _luckyGroup.atuoMaintainTime ?? 10,
                        ))
                    : Container(),
                widget.type == 'auto' && isAuto
                    ? renderItem(
                        type: 'auto',
                        topString: 'Auto',
                        bottom: runderBottomString(
                          Util.formatCountDownTimer(
                              Duration(seconds: autoTime)),
                        ))
                    : Container(),
              ],
            ));
      },
    );
  }
}

class _ActiveItem extends StatefulWidget {
  final Widget typeChild;
  final int totalDuration;
  final int emainingDuration;
  final int size;

  _ActiveItem(
      {Key key,
      this.typeChild,
      this.totalDuration,
      this.emainingDuration,
      this.size})
      : super(key: key);

  @override
  __ActiveItemState createState() => __ActiveItemState();
}

class __ActiveItemState extends State<_ActiveItem>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
        vsync: this, duration: Duration(seconds: widget.totalDuration));
    final CurvedAnimation treeCurve =
        new CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    scaleAnimation = new Tween(begin: 1.0, end: 0.0).animate(treeCurve);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(widget.size),
      height: ScreenUtil().setWidth(widget.size),
      decoration: BoxDecoration(
        color: Color.fromRGBO(161, 61, 33, 1),
        borderRadius: BorderRadius.all(Radius.circular(
          ScreenUtil().setWidth(103),
        )),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
              left: ScreenUtil().setWidth(0),
              top: ScreenUtil().setWidth(0),
              child: Container(
                width: ScreenUtil().setWidth(widget.size),
                height: ScreenUtil().setWidth(widget.size),
                child: Center(
                    child: AnimatedBuilder(
                        animation: scaleAnimation,
                        builder: (BuildContext context, Widget child) {
                          return GradientCircularProgressIndicator(
                            colors: [
                              Color.fromRGBO(31, 235, 51, 1),
                              Color.fromRGBO(31, 235, 51, 1)
                            ],
                            radius: ScreenUtil().setWidth(widget.size / 2),
                            stokeWidth: ScreenUtil().setWidth(12),
                            backgroundColor: Color.fromRGBO(161, 61, 33, 1),
                            value: 1.0 - _animationController.value,
                          );
                        })),
              )),
          widget.typeChild,
        ],
      ),
    );
  }
}
