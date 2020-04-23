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
import 'package:tuple/tuple.dart';
import 'package:luckyfruit/models/index.dart' show Issued;

class Balloon extends StatefulWidget {
  Balloon({Key key}) : super(key: key);

  @override
  _BalloonState createState() => _BalloonState();
}

class _BalloonState extends State<Balloon> {
  bool visibity = true;

  _showModal(num balloon_time) {
    MoneyGroup moneyGroup = Provider.of<MoneyGroup>(context, listen: false);
    num getGlod = moneyGroup.makeGoldSped * balloon_time;
    Modal(
        childrenBuilder: (Modal modal) => <Widget>[
              ModalTitle('Cash Bonus'),
              SizedBox(height: ScreenUtil().setWidth(40)),
              Image.asset(
                'assets/image/coin_full_bag.png',
                width: ScreenUtil().setWidth(229),
                height: ScreenUtil().setWidth(225),
              ),
              SecondaryText("You‘ve got"),
              SizedBox(height: ScreenUtil().setWidth(45)),
              GoldText(
                Util.formatNumber(getGlod),
                iconSize: 72,
                textSize: 66,
              ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
                  child: AdButton(
                      ad_code: '204',
                      btnText: 'Free',
                      onCancel: modal.hide,
                      onOk: () {
                        LuckyGroup luckyGroup =
                            Provider.of<LuckyGroup>(context, listen: false);

                        moneyGroup.addGold(getGlod);
                        modal.hide();
                        luckyGroup?.showAd();
                      }))
            ]).show();
  }

  @override
  Widget build(BuildContext context) {
    num width = 1080 / 4;
    return Selector<LuckyGroup, Tuple2<Issued, bool>>(
        selector: (context, luckyGroup) =>
            Tuple2(luckyGroup.issed, luckyGroup.showballoon),
        builder: (_, data, __) {
          Issued issed = data.item1;

          final bool show = data.item2;

          return show
              ? AlightingAnimation(
                  begin: 0.0,
                  end: 1.0,
                  animateTime: Duration(seconds: issed?.balloon_remain_time),
                  builder: (ctx, Animation<double> animation) {
                    return Positioned(
                      top:
                          ScreenUtil().setWidth((1920 + 216) * animation.value),
                      left: ScreenUtil().setWidth(width *
                          (2 + math.sin(animation.value * math.pi * 4))),
                      child: GestureDetector(
                          onTap: () {
                            _showModal(issed.balloon_time);
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
        });
  }
}
