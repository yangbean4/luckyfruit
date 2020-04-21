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
              width: ScreenUtil().setWidth(378),
              height: ScreenUtil().setWidth(80),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(15),
              ),
              decoration: BoxDecoration(
//            color: Colors.red,
                  image: DecorationImage(
                alignment: Alignment.center,
                image: AssetImage('assets/image/dividend.png'),
                fit: BoxFit.fill,
              )),
              child: Stack(
                overflow: Overflow.visible,
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: ScreenUtil().setWidth(40),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(title,
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(24),
                                  fontFamily: FontFamily.bold,
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.blackColor)),
                          Selector<MoneyGroup, Tuple2<num, num>>(
                              selector: (context, provider) => Tuple2(
                                  provider
                                      ?.treeGroup?.globalDividendTree?.amount,
                                  provider?.money),
                              builder: (context, Tuple2 result, child) {
                                if (amount != result.item2 &&
                                    widget.type ==
                                        EarningWidgetType.Earning_Type_CASH) {
                                  runAction();
                                }
                                amount = result.item2;
                                return Text(
                                    widget.type ==
                                            EarningWidgetType.Earning_Type_Bonus
                                        ? '\$${Util.formatNumber(result.item1)}'
                                        : "\$${Util.formatNumber(result.item2)}",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(32),
                                        fontFamily: FontFamily.bold,
                                        fontWeight: FontWeight.bold,
                                        color: MyTheme.redColor));
                              })
                        ],
                      )),
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          alignment: Alignment.center,
                          image: AssetImage('assets/image/dividend_btn.png'),
                          fit: BoxFit.fill,
                        )),
                        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                        child: Text(desc,
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                fontFamily: FontFamily.bold,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF94C31))),
                      )
                    ],
                  ),
                  Positioned(
                    left: -ScreenUtil().setWidth(40),
                    child: Container(
//                color: Colors.blue,
                      key: widget.type == EarningWidgetType.Earning_Type_CASH
                          ? Consts.globalKeyMineCash
                          : null,
                      child: Image.asset(
                        imgPath,
                        width:
                            ScreenUtil().setWidth(110) * scaleAnimation.value,
                        height:
                            ScreenUtil().setWidth(110) * scaleAnimation.value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

enum EarningWidgetType {
  Earning_Type_Bonus,
  Earning_Type_CASH,
}
