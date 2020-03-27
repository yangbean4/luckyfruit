import 'package:flutter/material.dart';
import 'dart:math' show min;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:luckyfruit/theme/public/primary_btn.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/config/app.dart' show Event_Name;

class Modal {
  ToastFuture _future;

  final String okText;
  final Function onOk;
  final Function onCancel;
  // final BuildContext context;
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
  final closeType;

  Modal(
      {this.okText,
      // this.context,
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
      this.closeType = CloseType.CLOSE_TYPE_TOP_RIGHT,
      this.decorationColor = Colors.white})
      // 要求 stack 定位元素必须是 Positioned
      : assert(stack.every((it) => it is Positioned));

  /// 隐藏Modal
  hide() {
    _future.dismiss();
    EVENT_BUS.emit(Event_Name.MODAL_HIDE);
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
        Stack(children: [
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
          closeType == CloseType.CLOSE_TYPE_TOP_RIGHT && onCancel != null
              ? Positioned(
                  top: ScreenUtil().setWidth(60),
                  right: ScreenUtil().setWidth(60),
                  child: Container(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        hide();
                        if (onCancel != null) {
                          onCancel();
                        }
                      },
                      child: Image.asset(
                        'assets/image/close_icon_modal.png',
                        width: ScreenUtil().setWidth(50),
                        height: ScreenUtil().setWidth(50),
                      ),
                    ),
                  ))
              : Container(
                  width: 0,
                  height: 0,
                ),
        ])
      ],
    );

    List<Widget> widgetList = [topWidget];
    if (footer != null) {
      widgetList.add(footer);
    } else if (footer == null &&
        closeType == CloseType.CLOSE_TYPE_BOTTOM_CENTER &&
        onCancel != null) {
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
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgetList,
      )
    ]..addAll(stack);

    Widget widget = Container(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(child: Stack(overflow: Overflow.visible, children: stackC)),
    );

    EVENT_BUS.emit(Event_Name.MODAL_SHOW);

    _future = showToastWidget(
      widget,
      dismissOtherToast: false,
      duration: Duration(days: 1),
      handleTouch: true,
      animationCurve: Curves.easeIn,
      // OffsetAnimationBuilder OpacityAnimationBuilder
      animationBuilder: Miui10AnimBuilder(),
      // context: context,
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

enum CloseType { CLOSE_TYPE_TOP_RIGHT, CLOSE_TYPE_BOTTOM_CENTER }

class _Miui10AnimBuilder extends BaseAnimationBuilder {
  @override
  Widget buildWidget(
    BuildContext context,
    Widget child,
    AnimationController controller,
    double percent,
  ) {
    final opacity = min(1.0, percent + 0.2);
    final offset = (1 - percent) * 20;

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
          alignment: Alignment.center, scale: percent, child: child),
    );
  }
}
