// 通用的 按钮部分
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/theme/public/public.dart';

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
  AdButton(
      {Key key,
      this.useAd,
      this.btnText,
      this.cancelText = 'No,Thanks',
      this.onCancel,
      this.tips = 'Number of videos reset at 12:00 am&pm (9 times left)',
      this.interval = const Duration(seconds: 3)})
      : super(key: key);

  @override
  _AdButtonState createState() => _AdButtonState();
}

class _AdButtonState extends State<AdButton> {
  bool showCancel;
  List<Widget> children;
  @override
  void initState() {
    super.initState();
    if (widget.interval != null) {
      Future.delayed(widget.interval).then((e) {
        setState(() {
          showCancel = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setWidth(widget.useAd ? 246 : 124),
      width: ScreenUtil().setWidth(720),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
              child: Container(
            width: ScreenUtil().setWidth(600),
            height: ScreenUtil().setWidth(124),
            decoration: BoxDecoration(
                image: DecorationImage(
              alignment: Alignment.center,
              image: AssetImage('assets/image/ad_btn.png'),
              fit: BoxFit.cover,
            )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.useAd
                    ? Image.asset(
                        'assets/image/ad_icon.png',
                        width: ScreenUtil().setWidth(75),
                        height: ScreenUtil().setWidth(75),
                      )
                    : Container(),
                ModalTitle(
                  widget.btnText,
                  color: Colors.white,
                )
              ],
            ),
          )),
          widget.useAd
              ? GestureDetector(
                  onTap: widget.onCancel,
                  child: ThirdText(showCancel ? '' : widget.cancelText),
                )
              : Container(),
          widget.useAd ? FourthText(widget.tips) : Container()
        ],
      ),
    );
  }
}