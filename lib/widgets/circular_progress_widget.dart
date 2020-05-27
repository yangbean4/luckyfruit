import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/widgets/circular_progress_route.dart';
import 'package:luckyfruit/widgets/layer.dart';

enum CircularProgressType { Type_Normal, Type_Lucky_One, Type_Lucky_Two }

class CircularProgressWidget extends StatefulWidget {
  CircularProgressType type;
  String text;
  num size;
  Function(String, bool) clickCallback;
  bool enable;

  CircularProgressWidget(
    this.text, {
    this.size = 90,
    this.clickCallback,
    this.type = CircularProgressType.Type_Normal,
  }) : enable = type != CircularProgressType.Type_Normal;

  @override
  _CircularProgressWidgetState createState() => _CircularProgressWidgetState();
}

class _CircularProgressWidgetState extends State<CircularProgressWidget> {
  @override
  void initState() {
    super.initState();
  }

  getPaintColorsWithType() {
    if (widget.type == CircularProgressType.Type_Normal) {
      return [
        Color(0xFFFA8231),
        Color(0xFFE85719),
        Color(0xFFFA8231),
      ];
    } else if (widget.type == CircularProgressType.Type_Lucky_One) {
      return [
        Colors.yellow[700],
        Colors.yellow[200],
        Colors.yellow[700],
      ];
    } else {
      return [
        Colors.deepPurpleAccent[700],
        Colors.purple[200],
        Colors.deepPurpleAccent[700],
      ];
    }
  }

  getTextColorWithType() {
    if (widget.type == CircularProgressType.Type_Normal) {
      return Colors.white;
    }
    return Colors.black;
  }

  getBgColorWithType() {
    if (widget.type == CircularProgressType.Type_Normal) {
      return [
        Color(0xFFFA8231),
        Color(0xFFE85719),
      ];
    }
    return [
      Colors.white,
      Colors.white,
    ];
  }

  getRadiusWithType() {
    if (widget.type == CircularProgressType.Type_Normal) {
      return 0.0;
    }
    return ScreenUtil().setWidth(49);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.clickCallback == null) {
          return;
        }

        if (!widget.clickCallback(null, widget.enable)) {
          Layer.toastWarning("Location is full");
          return;
        }

        String text = widget?.text?.toString() ?? "--";
        widget.enable = !widget.enable;
        widget.clickCallback(
          text,
          widget.enable,
        );

        print("GestureDetector_${widget?.text}");
      },
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, 1.0),
                  colors: getBgColorWithType()),
              shape: BoxShape.circle),
          width: ScreenUtil().setWidth(widget.size),
          height: ScreenUtil().setWidth(widget.size),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              GradientCircularProgressIndicator(
                colors: getPaintColorsWithType(),
                radius: getRadiusWithType(),
                stokeWidth: ScreenUtil().setWidth(15),
                value: 1.0,
              ),
              Text(
                widget?.text?.toString() ?? '--',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: getTextColorWithType(),
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(60),
                ),
              )
            ],
          )),
    );
  }
}
