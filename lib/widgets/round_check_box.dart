import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/theme/index.dart';

class RoundCheckBox extends StatefulWidget {
  var value = false;

  Function(bool) onChanged;
  String text;

  RoundCheckBox({Key key, @required this.value, this.text, this.onChanged})
      : super(key: key);

  @override
  _RoundCheckBoxState createState() => _RoundCheckBoxState();
}

class _RoundCheckBoxState extends State<RoundCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            widget.value = !widget.value;
            widget.onChanged(widget.value);
            setState(() {});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              widget.value
                  ? Icon(
                      Icons.check_circle,
                      size: ScreenUtil().setWidth(50),
                      color: Colors.orange,
                    )
                  : Icon(
                      Icons.panorama_fish_eye,
                      size: ScreenUtil().setWidth(50),
                      color: Colors.black,
                    ),
              SizedBox(
                width: ScreenUtil().setWidth(10),
              ),
              Text(
                widget.text,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF262626),
                    fontFamily: FontFamily.semibold,
                    fontSize: ScreenUtil().setSp(36)),
              )
            ],
          ),
        ));
  }
}
