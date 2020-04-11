import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:provider/provider.dart';

class MoneyAmountFadingWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoneyAmountFadingState();
}

class MoneyAmountFadingState extends State with TickerProviderStateMixin {
  AnimationController controller;
  bool _textVisible = true;
  Animation<double> textPositionBottomAnimation;
  Animation<double> textContainerSizeAnimation;

  @override
  void initState() {
    super.initState();

    controller = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    textPositionBottomAnimation = Tween<double>(
      begin: ScreenUtil().setWidth(100),
      end: ScreenUtil().setWidth(300),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );

    textContainerSizeAnimation = Tween<double>(
      begin: 50.0,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );

    Future.delayed(Duration(milliseconds: 1000), () {
      _textVisible = false;
    });
    controller.forward();
    controller.addStatusListener((statue) {
      MoneyGroup moneyGroup = Provider.of<MoneyGroup>(context, listen: false);
      moneyGroup.setShowDollarAmountFading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        builder: (BuildContext context, Widget child) {
          return Positioned(
            bottom: textPositionBottomAnimation.value,
            right: ScreenUtil().setWidth(100),
            child: AnimatedOpacity(
              opacity: _textVisible ? 1 : 0,
              duration: Duration(milliseconds: 1000),
              child: Container(
                //TODO 数字获取
                child: Text("+\$100",
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: FontFamily.bold,
                      fontSize:
                          ScreenUtil().setSp(textContainerSizeAnimation.value),
                    )),
              ),
            ),
          );
        },
        animation: controller);
  }
}
