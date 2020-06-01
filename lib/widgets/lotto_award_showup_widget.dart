import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/widgets/lotto_award_showup_Item_widget.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class LottoAwardShowupWidget extends StatefulWidget {
  @override
  _LottoAwardShowupWidgetState createState() => _LottoAwardShowupWidgetState();
}

class _LottoAwardShowupWidgetState extends State<LottoAwardShowupWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(1080),
      height: ScreenUtil().setHeight(1920),
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Stack(
        children: <Widget>[
          Selector<LuckyGroup, Tuple3>(
              selector: (context, provider) => Tuple3(
                  provider.lottoAwardShowupFlag1,
                  provider.lottoReceivePrizeRecords.length > 0
                      ? provider.lottoReceivePrizeRecords[0]
                      : 0,
                  provider.lottoReceivePrizeRecords.length <= 1),
              builder: (_, tuple3, __) {
                return tuple3.item1
                    ? LottoAwardShowupItemWidget(
                        positonLeft: 35,
                        goldNumGrade: tuple3.item2,
                        hidePlusIcon: tuple3.item3,
                        callback: () {
                          LuckyGroup luckyGroup =
                              Provider.of<LuckyGroup>(context, listen: false);
                          if (tuple3.item3) {
                            luckyGroup.showLottoAwardShowupCollect = true;
                            return;
                          }
                          luckyGroup.lottoAwardShowupFlag2 = true;
                        })
                    : Container();
              }),
          Selector<LuckyGroup, Tuple3>(
              selector: (context, provider) => Tuple3(
                  provider.lottoAwardShowupFlag2,
                  provider.lottoReceivePrizeRecords.length > 1
                      ? provider.lottoReceivePrizeRecords[1]
                      : 0,
                  provider.lottoReceivePrizeRecords.length <= 2),
              builder: (_, tuple3, __) {
                return tuple3.item1
                    ? LottoAwardShowupItemWidget(
                        positonLeft: 395,
                        goldNumGrade: tuple3.item2,
                        hidePlusIcon: tuple3.item3,
                        callback: () {
                          LuckyGroup luckyGroup =
                              Provider.of<LuckyGroup>(context, listen: false);
                          if (tuple3.item3) {
                            luckyGroup.showLottoAwardShowupCollect = true;
                            return;
                          }
                          luckyGroup.lottoAwardShowupFlag3 = true;
                        })
                    : Container();
              }),
          Selector<LuckyGroup, Tuple2>(
              selector: (context, provider) => Tuple2(
                  provider.lottoAwardShowupFlag3,
                  provider.lottoReceivePrizeRecords.length > 2
                      ? provider.lottoReceivePrizeRecords[2]
                      : 0),
              builder: (_, tuple2, __) {
                return tuple2.item1
                    ? LottoAwardShowupItemWidget(
                        goldNumGrade: tuple2.item2,
                        hidePlusIcon: true,
                        positonLeft: 755,
                        callback: () {
                          LuckyGroup luckyGroup =
                              Provider.of<LuckyGroup>(context, listen: false);
                          luckyGroup.showLottoAwardShowupCollect = true;
                        })
                    : Container();
              }),
          Selector<LuckyGroup, bool>(
              selector: (context, provider) =>
                  provider.showLottoAwardShowupCollect,
              builder: (_, show, __) {
                return show
                    ? Positioned(
                        left: ScreenUtil().setWidth(210),
                        bottom: ScreenUtil().setWidth(360),
                        child: GestureDetector(
                          onTap: () {
                            LuckyGroup luckyGroup =
                                Provider.of<LuckyGroup>(context, listen: false);
                            luckyGroup.showLottoAwardShowup = false;
                            // 返回到pick 5 numbers页面
                            luckyGroup.lottoPickedFinished = false;

                            // 金币增加到余额中
                            EVENT_BUS.emit(MoneyGroup.ADD_GOLD_LOTTO,
                                luckyGroup.getWinningNumnersOfLotto());
                          },
                          child: Container(
                            width: ScreenUtil().setWidth(660),
                            height: ScreenUtil().setWidth(136),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(
                                ScreenUtil().setWidth(68),
                              )),
                              gradient: LinearGradient(
                                  begin: Alignment(0.0, -1.0),
                                  end: Alignment(0.0, 1.0),
                                  colors: <Color>[
                                    Color(0xffF2D450),
                                    Color(0xffF59A22),
                                  ]),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Collect",
                              style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontFamily: FontFamily.semibold,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(66),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container();
              }),
        ],
      ),
    );
  }
}
