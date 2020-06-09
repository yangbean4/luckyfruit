// 通用的 按钮部分
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/utils/mo_ad.dart';
import 'package:provider/provider.dart';

class AdButton extends StatefulWidget {
  static final String CLOSE_ON_TOP_RIGHT = "close_on_top_right";

  // 是否使用广告
  final bool useAd;

  final String ad_code;

  // 按钮文字
  final String btnText;

  // 取消按钮的文字
  final String cancelText;

  // 取消的回调
  final Function onCancel;

  // 提示
  final String tips;
  final Color tipsColor;

  // 取消按钮显示的时间
  final Duration interval;

  // 点击确定按钮
  final Function(bool) onOk;

  final bool disable;

  final num width;
  final num height;
  final Widget child;
  final num fontSize;

  /// 取值为1和2，代表使用哪个mopub unit id请求广告，默认为1
  final num adUnitIdFlag;

  final List<Color> colorsOnBtn;
  final List<Color> colorsOnBtnDisabled;
  final String adIconPath;
  final Map<String, String> adLogParam;
  final List<Shadow> tipsShadows;
  final bool showTopRightIcon;
  final bool enableAnimation;

  AdButton(
      {Key key,
      this.useAd = true,
      this.btnText,
      this.adUnitIdFlag = 1,
      this.cancelText = 'No,Thanks',
      this.onCancel,
      this.tipsShadows,
      this.colorsOnBtn = const <Color>[
        Color(0xFF42CE66),
        Color(0xFF42CE66),
      ],
      this.colorsOnBtnDisabled,
      this.adIconPath = "assets/image/ad_icon.png",
      this.tips = 'Number of videos reset at 12am&12pm ({{times}} times left)',
      this.tipsColor,
      this.interval = const Duration(seconds: 2),
      this.onOk,
      this.width = 600,
      this.height = 124,
      this.child,
      this.disable = false,
      this.fontSize = 64,
      this.adLogParam,
      this.showTopRightIcon = false,
      this.enableAnimation = false,
      this.ad_code})
      : super(key: key);

  @override
  _AdButtonState createState() => _AdButtonState();
}

class _AdButtonState extends State<AdButton> {
  bool showCancel = false;
  List<Widget> children;
  Map<String, String> adLogParam = {};

  @override
  void initState() {
    super.initState();
    if (widget.interval != null) {
      Future.delayed(widget.interval).then((e) {
        if (mounted) {
          setState(() {
            showCancel = true;
          });
        }
      });
    }

    if (widget.child == null) {
      EVENT_BUS.on(AdButton.CLOSE_ON_TOP_RIGHT, (val) {
        print("close_on_top_right_");
        BurialReport.report('ad_rewarded', {
          'type': '6',
          'ad_code': widget.ad_code,
          "union_id": adLogParam['union_id'],
          'is_new': "1"
        });
      });
    }
  }

  // didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    adLogParam =
        widget.adLogParam ?? Util.getVideoLogParams(_userModel?.value?.acct_id);
    if ((widget.adLogParam == null && widget.useAd) ||
        widget.ad_code == '202') {
      BurialReport.report('ad_rewarded', {
        'type': '0',
        'ad_code': widget.ad_code,
        "union_id": adLogParam['union_id'],
        // 针对auto merge，第一次出现时出现新手引导，且不用看广告
        'is_new': (widget.ad_code == '202' && !widget.useAd) ? "0" : "1"
      });

      BurialReport.reportAdjust(BurialReport.Adjust_Event_Token_Ads_Entr_Imp);
    }
  }

  @override
  void dispose() {
    print("close_on_top_right_dispose");
    EVENT_BUS.off(AdButton.CLOSE_ON_TOP_RIGHT);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Function onTap = widget.onOk != null && !widget.disable
        ? () {
            if (widget.useAd) {
              BurialReport.report('ad_rewarded', {
                'type': '1',
                'ad_code': widget.ad_code,
                "union_id": adLogParam['union_id'],
                'is_new': "1"
              });
              // widget?.onOk();

              MopubAd.getInstance(context).showRewardVideo(widget.adUnitIdFlag,
                  () {
                //success
                widget?.onOk(true);
              }, (error) {
                //failed
                print("$error");
                if (widget?.onCancel != null) {
                  widget?.onCancel();
                }
              }, ad_code: widget.ad_code, adLogParam: adLogParam);

//              MoAd.getInstance(context).viewAd(context).then((res) {
//                if (res) {
//                  // 看广告成功
//                  widget?.onOk();
//                } else {
//                  if (widget?.onCancel != null) {
//                    widget?.onCancel();
//                  }
//                  // 看广告失败,弹框提示
//                  Layer.toastWarning("Number of videos has used up");
//                }
//              });
            } else {
              widget.onOk(false);

              // 针对auto merge，第一次出现时出现新手引导，且不用看广告
              if (widget.ad_code == '202') {
                BurialReport.report('ad_rewarded', {
                  'type': '1',
                  'ad_code': widget.ad_code,
                  "union_id": adLogParam['union_id'],
                  'is_new': "0"
                });
              }
            }
          }
        : () {};
    return widget.child != null
        ? GestureDetector(
            onTap: onTap,
            child: widget.child,
          )
        : Container(
            // height: ScreenUtil().setWidth(widget.useAd ? 260 : 124),
            width: ScreenUtil().setWidth(760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _AdButtonTitleWidget(adButton: widget, onTap: onTap),
                widget.useAd && widget.onCancel != null
                    ? GestureDetector(
                        onTap: () {
                          widget.onCancel();
                          BurialReport.report('ad_rewarded', {
                            'type': '4',
                            'ad_code': widget.ad_code,
                            "union_id": adLogParam['union_id'],
                            'is_new': "1"
                          });
                        },
                        child: Container(
                            width: ScreenUtil().setWidth(760),
                            padding:
                                EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                            child: FourthText(
                                !showCancel ? '' : widget.cancelText)),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                      ),
                widget.tips != null
                    ? Container(
                        width: ScreenUtil().setWidth(760),
                        child: Selector<UserModel, int>(
                            selector: (context, provider) =>
                                provider.userInfo.ad_times,
                            builder: (_, int ad_times, __) {
                              return Text(
                                widget.tips
                                    .replaceAll('{{times}}', '$ad_times'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: widget.tipsColor == null
                                      ? MyTheme.tipsColor
                                      : widget.tipsColor,
                                  height: 1,
                                  shadows: widget.tipsShadows,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: FontFamily.regular,
                                  fontSize: ScreenUtil().setSp(30),
                                ),
                              );
                            }),
                        margin: EdgeInsets.only(top: ScreenUtil().setWidth(28)),
                      )
                    : Container(),
              ],
            ),
          );
  }
}

class _AdButtonTitleWidget extends StatefulWidget {
  final Function onTap;

  final AdButton adButton;

  _AdButtonTitleWidget({this.adButton, this.onTap});

  @override
  __AdButtonTitleWidgetState createState() => __AdButtonTitleWidgetState();
}

class __AdButtonTitleWidgetState extends State<_AdButtonTitleWidget>
    with TickerProviderStateMixin {
  Animation<double> scaleAnimation;
  AnimationController scaleAnimationController;
  bool isDispose = false;

  @override
  void initState() {
    super.initState();
    scaleAnimationController = new AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    final CurvedAnimation treeCurve = new CurvedAnimation(
        parent: scaleAnimationController, curve: Curves.easeIn);
    scaleAnimation =
        new Tween(begin: 1.0, end: widget.adButton.enableAnimation ? 1.1 : 1.0)
            .animate(treeCurve)
              ..addStatusListener((status) {
                print("scaleAnimation_status_$status");
                if (status == AnimationStatus.dismissed) {
                  runAction();
                }
              });
    runAction();
  }

  Future<void> runAction() async {
    if (isDispose) {
      return;
    }
    await scaleAnimationController?.forward();
    await scaleAnimationController?.reverse();
  }

  @override
  void dispose() {
    isDispose = true;
    scaleAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: scaleAnimation,
        builder: (BuildContext context, Widget child) {
          return GestureDetector(
            onTap: widget.onTap,
            child: Transform.scale(
              scale: scaleAnimation.value,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(widget.adButton.width),
                    height: ScreenUtil().setWidth(widget.adButton.height),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(
                        ScreenUtil().setWidth(widget.adButton.width / 2),
                      )),
                      color: widget.adButton.disable
                          ? MyTheme.darkGrayColor
                          : null,
                      boxShadow: [
                        //阴影
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 2.0),
                      ],
                      gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                          colors: widget.adButton.disable
                              ? (widget.adButton.colorsOnBtnDisabled ??
                                  widget.adButton.colorsOnBtn)
                              : widget.adButton.colorsOnBtn),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.adButton.useAd && !widget.adButton.disable
                            ? Padding(
                                padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(33)),
                                child: Image.asset(
                                  widget.adButton.adIconPath,
                                  width: ScreenUtil().setWidth(75),
                                  height: ScreenUtil().setWidth(75),
                                ),
                              )
                            : Container(),
                        SizedBox(width: ScreenUtil().setWidth(24)),
                        ModalTitle(
                          widget.adButton.btnText,
                          color: Colors.white,
                          fontsize: widget.adButton.fontSize,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  widget.adButton.showTopRightIcon
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: Image.asset(
                            'assets/image/value2.png',
                            width: ScreenUtil().setWidth(124),
                            height: ScreenUtil().setWidth(108),
                          ))
                      : Positioned(top: 0, right: 0, child: Container())
                ],
              ),
            ),
          );
        });
  }
}
