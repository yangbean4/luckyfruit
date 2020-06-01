import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
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
          Selector<LuckyGroup, Tuple2>(
              selector: (context, provider) => Tuple2(
                  provider.lottoAwardShowupFlag1,
                  provider.lottoReceivePrizeRecords.length > 0
                      ? provider.lottoReceivePrizeRecords[0]
                      : 0),
              builder: (_, tuple2, __) {
                return tuple2.item1
                    ? LottoAwardShowupItemWidget(
                        positonLeft: 35,
                        goldNumGrade: tuple2.item2,
                        callback: () {
                          LuckyGroup luckyGroup =
                              Provider.of<LuckyGroup>(context, listen: false);
                          luckyGroup.lottoAwardShowupFlag2 = true;
                        })
                    : Container();
              }),
          Selector<LuckyGroup, Tuple2>(
              selector: (context, provider) => Tuple2(
                  provider.lottoAwardShowupFlag2,
                  provider.lottoReceivePrizeRecords.length > 1
                      ? provider.lottoReceivePrizeRecords[1]
                      : 0),
              builder: (_, tuple2, __) {
                return tuple2.item1
                    ? LottoAwardShowupItemWidget(
                        positonLeft: 395,
                        goldNumGrade: tuple2.item2,
                        callback: () {
                          LuckyGroup luckyGroup =
                              Provider.of<LuckyGroup>(context, listen: false);
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
                        callback: () {})
                    : Container();
              }),
        ],
      ),
    );
  }
}
