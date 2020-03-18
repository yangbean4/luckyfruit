import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import './alighting.dart';
import 'package:luckyfruit/widgets/modal.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/money_group.dart';

class Balloon extends StatefulWidget {
  Balloon({Key key}) : super(key: key);

  @override
  _BalloonState createState() => _BalloonState();
}

class _BalloonState extends State<Balloon> {
  bool show = false;
  LuckyGroup luckyGroup;
  bool visibity = true;

  // 下发的配置
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    LuckyGroup _luckyGroup = Provider.of<LuckyGroup>(context);

    if (_luckyGroup != null) {
      final issed = _luckyGroup.issed;
      luckyGroup = _luckyGroup;
      if (issed?.balloon_timeLen != null) {
        Future.delayed(Duration(seconds: issed?.balloon_timeLen)).then((e) {
          luckyGroup.adTimeCheck(Duration(seconds: issed?.balloon_adSpace), () {
            if (mounted) {
              setState(() {
                show = true;
              });
            }
          });
        });
      }
    }
  }

  _showModal() {
    MoneyGroup moneyGroup = Provider.of<MoneyGroup>(context, listen: false);
    num getGlod = moneyGroup.makeGoldSped * luckyGroup.issed?.balloon_time;
    Modal(
        childrenBuilder: (Modal modal) => <Widget>[
              ModalTitle('Cash Bouns'),
              Image.asset(
                'assets/image/more_gold.png',
                width: ScreenUtil().setWidth(227),
                height: ScreenUtil().setWidth(140),
              ),
              SecondaryText("You‘ve got"),
              GoldText(
                Util.formatNumber(getGlod),
                iconSize: 72,
                textSize: 66,
              ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
                  child: AdButton(
                      btnText: 'Free',
                      onCancel: modal.hide,
                      onOk: () {
                        moneyGroup.addGold(getGlod);
                        modal.hide();
                        luckyGroup?.showAd();
                      }))
            ]).show();
  }

  @override
  Widget build(BuildContext context) {
    num width = 1080 / 4;
    return show
        ? AlightingAnimation(
            begin: 0.0,
            end: 1.0,
            animateTime:
                Duration(seconds: luckyGroup.issed?.balloon_remain_time),
            builder: (ctx, Animation<double> animation) {
              return Positioned(
                top: ScreenUtil().setWidth((1920 + 216) * animation.value),
                left: ScreenUtil().setWidth(
                    width * (2 + math.sin(animation.value * math.pi * 4))),
                child: GestureDetector(
                    onTap: () {
                      _showModal();
                      setState(() {
                        visibity = false;
                      });
                    },
                    child: Image.asset(
                      'assets/image/balloon.png',
                      width: ScreenUtil().setWidth(visibity ? 216 : 0),
                      height: ScreenUtil().setWidth(visibity ? 309 : 0),
                    )),
              );
            })
        : Container();
  }
}
