import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:luckyfruit/theme/public/primary_btn.dart';

class Modal {
  ToastFuture _future;

  final String okText;
  final Function onOk;
  final Function onCancel;
  final Widget footer;
  // 垂直填充
  final double verticalPadding;
  // 水平填充
  final double horizontalPadding;
  List<Widget> children;
  final num width;
  final List<Widget> stack;

  // 在children中需要用到Modal实例(如调用隐藏)时可以使用childrenBuilder
  final List<Widget> Function(Modal modal) childrenBuilder;
  final bool autoHide;
  final Color decorationColor;

  Modal(
      {this.okText,
      this.onOk,
      this.onCancel,
      this.children,
      this.footer,
      this.childrenBuilder,
      this.width = 840,
      this.stack = const [],
      this.verticalPadding = 90,
      this.horizontalPadding = 120,
      this.autoHide = true,
      this.decorationColor = Colors.white})
      // 要求 stack 定位元素必须是 Positioned
      : assert(stack.every((it) => it is Positioned));

  /// 隐藏Modal
  hide() {
    _future.dismiss();
  }

  // 显示modal
  show() {
    children = children ?? childrenBuilder(this);
    if (okText != null) {
      children?.add(_createButton(okText, () {
        if (autoHide) {
          this.hide();
        }
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
            width: ScreenUtil().setWidth(width),
            margin: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(70),
            ),
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setWidth(verticalPadding),
              horizontal: ScreenUtil().setWidth(horizontalPadding),
            ),
            decoration: BoxDecoration(
              color: decorationColor,
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
        child: Container(
            width: ScreenUtil().setWidth(200),
            height: ScreenUtil().setWidth(200),
            child: Center(
                child: Image.asset(
              'assets/image/close.png',
              width: ScreenUtil().setWidth(54),
              height: ScreenUtil().setWidth(54),
            ))),
      ));
    }

    List<Widget> stackC = [
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widgetList,
        ),
      )
    ]..addAll(stack);

    Widget widget = Container(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(child: Stack(overflow: Overflow.visible, children: stackC)),
    );

    _future = showToastWidget(
      widget,
      dismissOtherToast: false,
      duration: Duration(days: 1),
      handleTouch: true,
    );
  }

  // _createButton(String text, Function fn) => ButtonTheme(
  //       minWidth: ScreenUtil().setWidth(600),
  //       height: ScreenUtil().setWidth(124),
  //       shape: RoundedRectangleBorder(
  //         side: BorderSide.none,
  //         borderRadius: BorderRadius.all(Radius.circular(62)),
  //       ),
  //       buttonColor: MyTheme.primaryColor,
  //       disabledColor: const Color.fromRGBO(193, 193, 193, 1),
  //       child: RaisedButton(
  //         onPressed: fn,
  //         child: Text(
  //           text,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: ScreenUtil().setWidth(52),
  //           ),
  //         ),
  //       ),
  //     );

  _createButton(String text, Function fn) => GestureDetector(
      onTap: fn,
      child: PrimaryButton(
          width: 600,
          height: 124,
          child: Center(
              child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              height: 1,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setWidth(52),
            ),
          ))));
}
