import 'package:flutter/material.dart';

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
            setState(() {
              show = true;
            });
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
    return show
        ? AlightingAnimation(builder: (ctx, Animation<double> animation) {
            return Positioned(
              top: ScreenUtil().setWidth(1400 * animation.value),
              left: ScreenUtil().setWidth(400),
              child: GestureDetector(
                  onTap: () {
                    _showModal();
                  },
                  child: Image.asset(
                    'assets/image/balloon.png',
                    width: ScreenUtil().setWidth(216),
                    height: ScreenUtil().setWidth(309),
                  )),
            );
          })
        : Container();
    ;
  }
}
