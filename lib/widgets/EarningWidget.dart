import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/routes/my_navigator.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class EarningWidget extends StatefulWidget {
  final EarningWidgetType type;

  EarningWidget(this.type);

  @override
  _EarningWidgetState createState() => _EarningWidgetState();
}

class _EarningWidgetState extends State<EarningWidget>
    with TickerProviderStateMixin {
  String imgPath;
  String title;
  String desc;
  num amount;

  Animation<double> scaleAnimation;
  AnimationController scaleAnimationController;

  bool isDispose = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == EarningWidgetType.Earning_Type_Bonus) {
      imgPath = "assets/tree/bonus.png";
      title = "Today";
      desc = "Got It";
    } else {
      imgPath = "assets/image/bg_dollar.png";
      title = "Mine";
      desc = "Cash Out";
    }

    scaleAnimationController = new AnimationController(
      duration: Duration(
          milliseconds: 1000 * AnimationConfig.TreeAnimationTime ~/ 25),
      vsync: this,
    );
    final CurvedAnimation treeCurve = new CurvedAnimation(
        parent: scaleAnimationController, curve: Curves.easeIn);
    scaleAnimation = new Tween(begin: 1.0, end: 1.2).animate(treeCurve);
  }

  Future<void> runAction() async {
    if (isDispose) {
      return;
    }
    await scaleAnimationController?.forward();
    await scaleAnimationController?.reverse();
  }

  @override
  void dispose() {
    isDispose = true;
    scaleAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isTree = widget.type == EarningWidgetType.Earning_Type_Bonus;
    return AnimatedBuilder(
        animation: scaleAnimation,
        builder: (BuildContext context, Widget child) {
          // print("scaleAnimation: ${scaleAnimation.value}");
          return GestureDetector(
            onTap: () {
              if (widget.type == EarningWidgetType.Earning_Type_Bonus) {
                MyNavigator().pushNamed(context, 'Dividend');
              } else {
                MyNavigator().pushNamed(context, 'WithDrawPage',
                    arguments: Util.formatNumber(amount));
              }
            },
            child: Container(
              width: ScreenUtil().setWidth(isTree ? 300 : 320),
              height: ScreenUtil().setWidth(isTree ? 92 : 80),
              alignment: Alignment(isTree ? 0.1 : -0.1, 0.4),
              margin:
                  EdgeInsets.only(top: ScreenUtil().setWidth(isTree ? 0 : 10)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'assets/image/top_btn_${isTree ? 'tree' : 'cash'}.png'),
                      alignment: Alignment.center,
                      fit: BoxFit.fill)),
              child: Selector<MoneyGroup, Tuple2<num, num>>(
                  selector: (context, provider) => Tuple2(
                      provider?.treeGroup?.globalDividendTree?.amount,
                      provider?.money),
                  builder: (context, Tuple2 result, child) {
                    if (amount != result.item2 &&
                        widget.type == EarningWidgetType.Earning_Type_CASH) {
                      runAction();
                    }
                    amount = result.item2;
                    return Transform.scale(
                      scale: scaleAnimation.value,
                      child: Text(
                          widget.type == EarningWidgetType.Earning_Type_Bonus
                              ? '\$${Util.formatNumber(result.item1)}'
                              : "\$${Util.formatNumber(result.item2)}",
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(32),
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    );
                  }),
            ),
          );
        });
  }
}

enum EarningWidgetType {
  Earning_Type_Bonus,
  Earning_Type_CASH,
}
