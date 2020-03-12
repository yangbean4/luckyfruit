import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:luckyfruit/theme/index.dart';

class Modal {
  ToastFuture _future;

  final String okText;
  final Function onOk;
  final Function onCancel;
  final Widget footer;
  final List<Widget> children;
  final bool autoHide;

  Modal(
      {this.okText,
      this.onOk,
      this.onCancel,
      this.children,
      this.footer,
      this.autoHide = true});

  /// 隐藏Modal
  hide() {
    _future.dismiss();
  }

  // 显示modal
  show() {
    List<Widget> btnList = [];
    if (okText != null) {
      btnList.add(_createButton(okText, () {
        if (autoHide) {
          this.hide();
        }
        if (onOk != null) {
          onOk();
        }
      }));
    }

    children?.addAll(btnList);
    final cancel = () {
      this.hide();
      if (onCancel != null) {
        onCancel();
      }
    };
    final topWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: ScreenUtil().setWidth(840),
            margin: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(70),
            ),
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setWidth(90),
              horizontal: ScreenUtil().setWidth(120),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil().setWidth(100)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ]);

    List<Widget> widgetList = [topWidget];
    if (footer != null) {
      widgetList.add(footer);
    } else if (footer == null && onCancel != null) {
      widgetList.add(GestureDetector(
        onTap: cancel,
        child: Image.asset(
          'assets/image/close.png',
          width: ScreenUtil().setWidth(54),
          height: ScreenUtil().setWidth(54),
        ),
      ));
    }

    Widget widget = Container(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgetList,
        )));

    _future = showToastWidget(
      widget,
      dismissOtherToast: true,
      duration: Duration(days: 1),
      handleTouch: true,
    );
  }

  _createButton(String text, Function fn) => ButtonTheme(
        minWidth: ScreenUtil().setWidth(600),
        height: ScreenUtil().setWidth(124),
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(62)),
        ),
        buttonColor: MyTheme.primaryColor,
        disabledColor: const Color.fromRGBO(193, 193, 193, 1),
        child: RaisedButton(
          onPressed: fn,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setWidth(52),
            ),
          ),
        ),
      );
}
