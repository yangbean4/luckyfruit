import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/widgets/circular_progress_widget.dart';

class LottoPage extends StatefulWidget {
  @override
  _LottoPageState createState() => _LottoPageState();
}

class _LottoPageState extends State<LottoPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: <Color>[
                Color(0xFFF1D34E),
                Color(0xffF59A22),
              ]),
        ),
        child: Column(
          children: <Widget>[
            LottoHeaderWidget(),
            LottoHeaderImageWidget(),
            SizedBox(
              height: ScreenUtil().setWidth(150),
            ),
            LottoItemPickWidget(),
          ],
        ));
  }
}

class LottoHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(1080),
      height: ScreenUtil().setWidth(218),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment(0.0, -1.0),
            end: Alignment(0.0, 1.0),
            colors: <Color>[
              Color(0xffFFDC3F),
              Color(0xffFF9508),
            ]),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Text(
            "Lotto",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              height: 1,
              fontFamily: FontFamily.semibold,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().setSp(72),
            ),
          ),
          Positioned(
            right: ScreenUtil().setWidth(28),
            bottom: ScreenUtil().setWidth(8),
            child: Text(
              Util.formatDate(dateTime: DateTime.now(), format: 'yyyy-MM-dd'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                height: 1,
                fontFamily: FontFamily.semibold,
                fontWeight: FontWeight.w500,
                fontSize: ScreenUtil().setSp(48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LottoHeaderImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Image.asset(
            "assets/image/lotto_bg_top.png",
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(145),
          ),
          Positioned(
            top: ScreenUtil().setWidth(70),
            child: Image.asset(
              "assets/image/lotto_balls.png",
              width: ScreenUtil().setWidth(615),
              height: ScreenUtil().setWidth(180),
            ),
          ),
        ],
      ),
    );
  }
}

class LottoItemPickWidget extends StatefulWidget {
  @override
  _LottoItemPickWidgetState createState() => _LottoItemPickWidgetState();
}

class _LottoItemPickWidgetState extends State<LottoItemPickWidget> {
  List selectedNumList = [];
  bool pick6 = false;

  bool onHandleClickItem(String item, bool enable) {
    if (item == null) {
      return selectedNumList.length < (pick6 ? 6 : 5) || enable;
    }
    setState(() {
      if (enable) {
        selectedNumList.add(item);
      } else {
        selectedNumList.remove(item);
      }
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(24),
              vertical: ScreenUtil().setWidth(30)),
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(21),
              right: ScreenUtil().setWidth(21),
              bottom: ScreenUtil().setWidth(30)),
          decoration: BoxDecoration(
            color: Color(0xFFFCFAE8),
            borderRadius: BorderRadius.all(Radius.circular(
              ScreenUtil().setWidth(30),
            )),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(400),
                height: ScreenUtil().setWidth(95),
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment(0.0, -1.0),
                      end: Alignment(0.0, 1.0),
                      colors: <Color>[
                        Color(0xff39D780),
                        Color(0xff28A06E),
                      ]),
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(
                    ScreenUtil().setWidth(30),
                  )),
                ),
                child: Text(
                  "Pick 5 Numbers",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: FontFamily.semibold,
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().setSp(48),
                  ),
                ),
              ),
              Wrap(
                  spacing: ScreenUtil().setWidth(10),
                  runSpacing: ScreenUtil().setWidth(31),
                  children: getCircularWidgetList(onHandleClickItem)),
            ],
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(30),
        ),
        SelectedLottoWidget(selectedNumList, pick6),
        SizedBox(
          height: ScreenUtil().setWidth(80),
        ),
        AdButton(
          adUnitIdFlag: 1,
          colorsOnBtn: <Color>[
            Color(0xffF1D34E),
            Color(0xffF59A22),
          ],
          onOk: () {
            if (selectedNumList.length < 5) {
              // 随机取几个值
              getRandomNum();
            } else if (selectedNumList.length == 5) {
              // 取完五个之后，再去取第六个 (Continue)
              setState(() {
                pick6 = true;
              });
            } else {
              // 选中了6个之后（Submit）

            }
          },
          useAd: false,
          btnText: selectedNumList.length == 6
              ? 'Submit'
              : (pick6 || selectedNumList.length < 5)
                  ? 'Quick Pick'
                  : 'Continue',
          tips: null,
        ),
      ],
    );
  }

  List<Widget> getCircularWidgetList(Function(String, bool) clickCallback) {
    int index = 0;
    CircularProgressType type = CircularProgressType.Type_Normal;

    return List(60).map((e) {
//      type = CircularProgressType.Type_Normal;
//      if (index % 5 == 0) {
//        type = CircularProgressType.Type_Lucky_One;
//      } else if (index % 3 == 0) {
//        type = CircularProgressType.Type_Lucky_Two;
//      }

      if (selectedNumList.contains(index.toString()) && !pick6) {
        type = CircularProgressType.Type_Lucky_One;
      } else if (selectedNumList.length == 6 &&
          selectedNumList[5] == index.toString()) {
        type = CircularProgressType.Type_Lucky_Two;
      } else {
        type = CircularProgressType.Type_Normal;
      }
      return CircularProgressWidget(
        (index++).toString(),
        type: type,
        clickCallback: clickCallback,
      );
    }).toList();
  }

  getRandomNum() {
    int length = selectedNumList.length;
    for (int i = 0; i < 5 - length; i++) {
      String result;
      do {
        result = Random().nextInt(59).toString();
        print("getRandomNum_$result");
      } while (selectedNumList.contains(result));

      selectedNumList.add(result);
    }
    setState(() {});
  }
}

class SelectedLottoWidget extends StatefulWidget {
  List selectedNumList = [];
  bool pick6 = false;

  SelectedLottoWidget(this.selectedNumList, this.pick6);

  @override
  _SelectedLottoWidgetState createState() => _SelectedLottoWidgetState();
}

class _SelectedLottoWidgetState extends State<SelectedLottoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(1080),
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
        decoration: BoxDecoration(
          color: Color(0xFFFCFAE8),
          boxShadow: [
            //阴影
            BoxShadow(
                color: Colors.black26,
                offset: Offset(2.0, 2.0),
                blurRadius: 2.0),
          ],
          borderRadius: BorderRadius.all(Radius.circular(
            ScreenUtil().setWidth(85),
          )),
        ),
        child: Wrap(
            spacing: ScreenUtil().setWidth(64),
            alignment: WrapAlignment.center,
            children: getSelectedLottoWidget()));
  }

  List<Widget> getSelectedLottoWidget() {
    Widget emptyItem = Container(
      width: ScreenUtil().setWidth(108),
      height: ScreenUtil().setWidth(108),
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(26)),
      decoration: BoxDecoration(
        color: Color(0xFFDFDFDF),
        shape: BoxShape.circle,
        boxShadow: [
          const BoxShadow(
            color: Color(0xFF000000),
          ),
          const BoxShadow(
            color: Color(0xFFDFDFDF),
            spreadRadius: -12.0,
            blurRadius: 12.0,
          ),
        ],
      ),
    );

    List<Widget> widgetList = [];
    for (int i = 0; i < widget.selectedNumList.length; i++) {
      widgetList.add(Container(
          width: ScreenUtil().setWidth(108),
          height: ScreenUtil().setWidth(108),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(26)),
          child: CircularProgressWidget(
            widget.selectedNumList[i],
            type: i == 5
                ? CircularProgressType.Type_Lucky_Two
                : CircularProgressType.Type_Lucky_One,
            size: 108,
          )));
    }

    for (int i = 0;
        i < (widget.pick6 ? 6 : 5) - widget.selectedNumList.length;
        i++) {
      widgetList.add(emptyItem);
    }

    return widgetList;
  }
}
