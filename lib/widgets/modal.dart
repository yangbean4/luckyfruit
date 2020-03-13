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
  List<Widget> children;
  // 在children中需要用到Modal实例(如调用隐藏)时可以使用childrenBuilder
  final List<Widget> Function(Modal modal) childrenBuilder;

  Modal(
      {this.okText,
      this.onOk,
      this.onCancel,
      this.children,
      this.footer,
      this.childrenBuilder});

  /// 隐藏Modal
  hide() {
    _future.dismiss();
  }

  // 显示modal
  show() {
    children = children ?? childrenBuilder(this);
    if (okText != null) {
      children?.add(_createButton(okText, () {
        this.hide();
        if (onOk != null) {
          onOk();
        }
      }));
    }

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
        onTap: () {
          hide();
          if (onCancel != null) {
            onCancel();
          }
        },
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
