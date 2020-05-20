import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart' show Event_Name;
import 'package:luckyfruit/theme/public/primary_btn.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:oktoast/oktoast.dart';

class Modal extends StatefulWidget {
  ToastFuture _future;

  static const int DismissDuration = 1000;
  final String okText;
  final Function onOk;

  // 返回值:是否启用onCancel的点击事件
  final Function onCancel;

  // final BuildContext context;
  final Widget footer;

  // 垂直填充
  final double verticalPadding;

  // 水平填充
  final double horizontalPadding;
  final double marginBottom;
  List<Widget> children;
  final num width;
  final List<Widget> stack;

  // 在children中需要用到Modal实例(如调用隐藏)时可以使用childrenBuilder
  final List<Widget> Function(Modal modal) childrenBuilder;
  final bool autoHide;
  final Color decorationColor;
  final closeType;
  final int dismissDurationInMilliseconds;
  final List<Color> btnColors;
  final String closeIconPath;
  final int closeIconDelayedTime;
  bool closeIconDelayedOver = false;

  Modal(
      {this.okText,
      // this.context,
      this.onOk,
      this.onCancel,
      this.children,
      this.footer,
      this.closeIconPath,
      this.btnColors = const <Color>[
        Color.fromRGBO(49, 200, 84, 1),
        Color.fromRGBO(36, 185, 71, 1)
      ],
      this.childrenBuilder,
      this.width = 840,
      this.stack = const [],
      this.verticalPadding = 90,
      this.horizontalPadding = 40,
      this.marginBottom = 70,
      this.autoHide = true,
      this.closeIconDelayedTime = 4,
      this.dismissDurationInMilliseconds = 0,
      this.closeType = CloseType.CLOSE_TYPE_TOP_RIGHT,
      this.decorationColor = Colors.white})
      // 要求 stack 定位元素必须是 Positioned
      : assert(stack.every((it) => it is Positioned));

  /// 隐藏Modal
  hide() {
    Future.delayed(Duration(milliseconds: dismissDurationInMilliseconds),
        () => _future.dismiss());
    EVENT_BUS.emit(Event_Name.MODAL_HIDE);
  }

  // 显示modal
  show() {
    EVENT_BUS.emit(Event_Name.MODAL_SHOW);

    _future = showToastWidget(
      this,
      dismissOtherToast: false,
      duration: Duration(days: 1),
      handleTouch: true,
      animationCurve: Curves.easeIn,
      // OffsetAnimationBuilder OpacityAnimationBuilder
      animationBuilder: Miui10AnimBuilder(),
      // context: context,
    );
  }

  @override
  State<StatefulWidget> createState() => _ModalWidgetState();
}

class _ModalWidgetState extends State<Modal> with WidgetsBindingObserver {
  _createButton(String text, Function fn) => GestureDetector(
      onTap: fn,
      child: PrimaryButton(
          width: 600,
          height: 124,
          colors: widget.btnColors,
          child: Center(
              child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              height: 1,
              fontWeight: FontWeight.bold,
              fontSize: ScreenUtil().setSp(56),
            ),
          ))));

  @override
  void initState() {
    super.initState();

    widget.children = widget.children ?? widget.childrenBuilder(widget);
    if (widget.okText != null) {
      widget.children?.add(_createButton(widget.okText, () {
        if (widget.autoHide) {
          this.widget.hide();
        }
        if (widget.onOk != null) {
          widget.onOk();
        }
      }));
    }

    if (widget.onCancel != null &&
        widget.closeType == CloseType.CLOSE_TYPE_TOP_RIGHT) {
      Future.delayed(Duration(seconds: widget.closeIconDelayedTime), () {
        setState(() {
          widget.closeIconDelayedOver = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final topWidget = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(children: [
          Container(
            width: ScreenUtil().setWidth(widget.width),
            margin: EdgeInsets.only(
              bottom: ScreenUtil().setWidth(widget.marginBottom),
            ),
            padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setWidth(widget.verticalPadding),
              horizontal: ScreenUtil().setWidth(widget.horizontalPadding),
            ),
            decoration: BoxDecoration(
              color: widget.decorationColor,
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenUtil().setWidth(100)),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: widget.children,
            ),
          ),
          widget.closeType == CloseType.CLOSE_TYPE_TOP_RIGHT &&
                  widget.closeIconDelayedOver &&
                  widget.onCancel != null
              ? Positioned(
                  top: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20),
                  child: Container(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.hide();
                        if (widget.onCancel != null) {
                          widget.onCancel();
                        }
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setWidth(120),
                        child: Center(
                            child: Image.asset(
                          widget.closeIconPath ??
                              'assets/image/close_icon_modal_top_right.png',
                          width: ScreenUtil().setWidth(40),
                          height: ScreenUtil().setWidth(40),
                        )),
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
    if (widget.footer != null) {
      widgetList.add(widget.footer);
    } else if (widget.footer == null &&
        widget.closeType == CloseType.CLOSE_TYPE_BOTTOM_CENTER &&
        widget.onCancel != null) {
      widgetList.add(GestureDetector(
        onTap: () {
          if (widget.onCancel() != false) {
            widget.hide();
          }
        },
        child: Container(
            width: ScreenUtil().setWidth(200),
            height: ScreenUtil().setWidth(200),
            child: Center(
                child: Image.asset(
              widget.closeIconPath ??
                  'assets/image/close_icon_modal_bottom_center.png',
              width: ScreenUtil().setWidth(40),
              height: ScreenUtil().setWidth(40),
            ))),
      ));
    }

    List<Widget> stackC = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgetList,
      )
    ]..addAll(widget.stack);

    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Center(child: Stack(overflow: Overflow.visible, children: stackC)),
    );
  }
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
