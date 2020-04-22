// 通用的 按钮部分
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/utils/mo_ad.dart';
import 'package:provider/provider.dart';

class AdButton extends StatefulWidget {
  // 是否使用广告
  final bool useAd;

  // 按钮文字
  final String btnText;

  // 取消按钮的文字
  final String cancelText;

  // 取消的回调
  final Function onCancel;

  // 提示
  final String tips;

  // 取消按钮显示的时间
  final Duration interval;

  // 点击确定按钮
  final Function onOk;

  final bool disable;

  final num width;
  final num height;
  final Widget child;
  final num fontSize;

  AdButton(
      {Key key,
      this.useAd = true,
      this.btnText,
      this.cancelText = 'No,Thanks',
      this.onCancel,
      this.tips =
          'Number of videos reset at 12:00 am&pm ({{times}} times left)',
      this.interval = const Duration(seconds: 3),
      this.onOk,
      this.width = 600,
      this.height = 124,
      this.child,
      this.disable = false,
      this.fontSize = 64})
      : super(key: key);

  @override
  _AdButtonState createState() => _AdButtonState();
}

class _AdButtonState extends State<AdButton> {
  bool showCancel = false;
  List<Widget> children;

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
  }

  @override
  Widget build(BuildContext context) {
    Function onTap = widget.onOk != null && !widget.disable
        ? () {
            if (widget.useAd) {
              MoAd.getInstance(context).showRewardVideo(() {
                //success
                widget?.onOk();
              }, (error) {
                //failed
                print("$error");
                if (widget?.onCancel != null) {
                  widget?.onCancel();
                }
              });
            } else {
              widget.onOk();
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
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: ScreenUtil().setWidth(widget.width),
                    height: ScreenUtil().setWidth(widget.height),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(
                          ScreenUtil().setWidth(widget.width / 2),
                        )),
                        color: widget.disable ? MyTheme.darkGrayColor : null,
                        image: widget.disable
                            ? null
                            : DecorationImage(
                                alignment: Alignment.center,
                                image: AssetImage('assets/image/ad_btn.png'),
                                fit: BoxFit.cover,
                              )),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.useAd && !widget.disable
                            ? Padding(
                                padding: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(33)),
                                child: Image.asset(
                                  'assets/image/ad_icon.png',
                                  width: ScreenUtil().setWidth(75),
                                  height: ScreenUtil().setWidth(75),
                                ),
                              )
                            : Container(),
                        SizedBox(width: ScreenUtil().setWidth(24)),
                        ModalTitle(
                          widget.btnText,
                          color: Colors.white,
                          fontsize: widget.fontSize,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
                widget.useAd && widget.onCancel != null
                    ? GestureDetector(
                        onTap: widget.onCancel,
                        child: Padding(
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
                                  color: MyTheme.tipsColor,
                                  height: 1,
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
