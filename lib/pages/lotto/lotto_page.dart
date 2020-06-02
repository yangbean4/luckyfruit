import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/widgets/circular_progress_widget.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class LottoPage extends StatefulWidget {
  @override
  _LottoPageState createState() => _LottoPageState();
}

class _LottoPageState extends State<LottoPage> {
  @override
  void initState() {
    super.initState();
  }

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
      child: Selector<LuckyGroup, Tuple2>(
          selector: (context, provider) => Tuple2(
              provider.lottoPickedFinished, provider.currentPeriodlottoList),
          builder: (_, tuple2, __) {
            return Column(
              children: <Widget>[
                LottoHeaderWidget(tuple2.item1),
                tuple2.item1
                    ? LottoStatusHeaderImageWidget()
                    : LottoHeaderImageWidget(),
                SizedBox(
                  height: ScreenUtil().setWidth(tuple2.item1 ? 30 : 150),
                ),
                tuple2.item1
                    ? LottoStatusShowcaseWidget(tuple2.item2)
                    : LottoItemPickWidget(),
              ],
            );
          }),
    );
  }
}

class LottoHeaderWidget extends StatelessWidget {
  bool showHelpEntrance;

  LottoHeaderWidget(this.showHelpEntrance);

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
          Positioned(
            left: ScreenUtil().setWidth(28),
            bottom: ScreenUtil().setWidth(8),
            child: Selector<LuckyGroup, int>(
                selector: (context, provider) => provider.lottoTicketNumTotal,
                builder: (_, lottoTicketNum, __) {
                  return Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/image/lotto_tickets_icon.png",
                        width: ScreenUtil().setWidth(136),
                        height: ScreenUtil().setWidth(105),
                      ),
                      Text(
                        ' X $lottoTicketNum',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: FontFamily.semibold,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenUtil().setSp(60),
                        ),
                      ),
                    ],
                  );
                }),
          ),
          // 左上角显示帮助按钮
          showHelpEntrance ? LottoHelpModalWidget() : Container(),
        ],
      ),
    );
  }
}

class LottoHelpModalWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: ScreenUtil().setWidth(28),
      top: ScreenUtil().setWidth(40),
      child: GestureDetector(
        onTap: () {
          Layer.showLottoHelpMessage();
        },
        child: ImageIcon(
          AssetImage("assets/image/exclamation_icon.png"),
          size: ScreenUtil().setWidth(60),
          color: Colors.white,
        ),
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
  List<String> selectedNumList = [];
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
  void initState() {
    super.initState();
    checkLottoHelpShowup();
  }

  checkLottoHelpShowup() {
    Storage.getItem("lotto_help").then((lotto_help) {
      if (lotto_help != null) {
        return;
      }
      Storage.getItem("lotto_help_update_time").then((value) {
        DateTime hisDate = DateTime.tryParse(value ?? "");
        print("hisDate:${hisDate?.day}, ${DateTime.now().day}");
        if (hisDate == null || DateTime.now().day != hisDate?.day) {
          Layer.showLottoHelpMessage();
          Storage.setItem("lotto_help_update_time",
              Util.formatDate(dateTime: DateTime.now()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedNumList.length == 6) {
      BurialReport.report('page_imp', {'page_code': '040'});
    } else if (pick6) {
      BurialReport.report('page_imp', {'page_code': '039'});
    } else {
      BurialReport.report('page_imp', {'page_code': '038'});
    }
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
                width: pick6
                    ? ScreenUtil().setWidth(533)
                    : ScreenUtil().setWidth(400),
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
                  pick6 ? 'Pick 1 Lucky Number' : "Pick 5 Numbers",
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
        Selector<LuckyGroup, LuckyGroup>(
            selector: (context, provider) => provider,
            builder: (_, luckyGroup, __) {
              return AdButton(
                adUnitIdFlag: 1,
                colorsOnBtn: <Color>[
                  Color(0xffF1D34E),
                  Color(0xffF59A22),
                ],
                onOk: () {
                  if (luckyGroup.isDisableToPickLotto()) {
                    Layer.toastWarning(
                        "3 chances per day, plaease try tomorrow");
                    return;
                  }

                  if (luckyGroup.checkLastOneHourLimit()) {
                    Layer.toastWarning(
                        'The lottery jackpot is about to be drawn, Welcome to the lotto jackpot after '
                        '${luckyGroup.getCountDownTimerStringOfLotto(containSeconds: true)}',
                        padding: 20,
                        width: 600);
                    return;
                  }
                  if (selectedNumList.length < 5) {
                    // 随机取几个值
                    getRandomNumForFirstFiveNum();
                  } else if (selectedNumList.length == 5) {
                    // 取完五个之后，再去取第六个 (Continue)
                    if (!pick6) {
                      setState(() {
                        pick6 = true;
                      });
                    } else {
                      // 第六个数，取随机数
                      getRandomNumForSixthNum();
                    }
                  } else {
                    // 选中了6个之后（Submit）
                    submitLottoData(luckyGroup);
                  }
                },
                useAd: false,
                btnText: selectedNumList.length == 6
                    ? 'Submit'
                    : (pick6 || selectedNumList.length < 5)
                        ? 'Quick Pick'
                        : 'Continue',
                tips: null,
              );
            }),
      ],
    );
  }

  /// 选完后提交信息
  submitLottoData(LuckyGroup luckyGroup) async {
    String firstFive = selectedNumList.sublist(0, 5).map((e) {
      return "${e},";
    }).join(',');

    dynamic addLottoData = await Service().addLottoData({
      'lottery_draw_num': firstFive,
      'lottery_plus_one_num': selectedNumList[5]
    });

    // TODO 测试
//    String test = """{
//        "residue_time":3
//        }""";
//    addLottoData = json.decode(test);

    if (addLottoData != null) {
      luckyGroup.lottoRemainingTimesToday = addLottoData['residue_time'] ?? 0;
    }

    luckyGroup.lottoPickedFinished = true;

    luckyGroup.currentPeriodlottoList.addAll(selectedNumList);
    luckyGroup.lottoTicketNumTotal = luckyGroup.lottoTicketNumTotal - 1;
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

  getRandomNumForFirstFiveNum() {
    selectedNumList.clear();
    for (int i = 0; i < 5; i++) {
      String result;
      do {
        result = Random().nextInt(59).toString();
        print("getRandomNum_$result");
      } while (selectedNumList.contains(result));

      selectedNumList.add(result);
    }
    setState(() {});
  }

  getRandomNumForSixthNum() {
    String result = Random().nextInt(59).toString();
    if (selectedNumList.length == 5) {
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

class LottoStatusHeaderImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(1080),
      height: ScreenUtil().setWidth(830),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Image.asset(
            "assets/image/lotto_bg_top.png",
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setWidth(145),
          ),
          Positioned(
            top: ScreenUtil().setWidth(70),
            left: ScreenUtil().setWidth(38),
            child: Container(
              child: Image.asset(
                "assets/image/lotto_status_balls.png",
                width: ScreenUtil().setWidth(1004),
                height: ScreenUtil().setWidth(760),
              ),
            ),
          ),
          Positioned(bottom: 0, child: LottoStatusRewardedWidget()),
          Selector<LuckyGroup, LuckyGroup>(
              selector: (context, provider) => provider,
              builder: (_, luckGroup, __) {
                if (luckGroup.isLottoRewardedTimeReached()) {
                  BurialReport.report('page_imp', {'page_code': '041'});
                } else {
                  BurialReport.report('page_imp', {'page_code': '042'});
                }
                return Align(
                  alignment: Alignment(.0, .1),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: luckGroup.isLottoRewardedTimeReached()
                          ? "Winning Numbers"
                          : "Winning Numbers In",
                      style: TextStyle(
                          fontFamily: FontFamily.semibold,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(48)),
                      children: <TextSpan>[
                        TextSpan(
                          text: luckGroup.isLottoRewardedTimeReached()
                              ? '\n${Util.formatNumber(luckGroup.getWinningNumnersOfLotto())}'
                              : "\n${luckGroup.getCountDownTimerStringOfLotto()}",
                          style: TextStyle(
                              fontFamily: FontFamily.bold,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(120)),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class LottoStatusRewardedWidget extends StatefulWidget {
  @override
  _LottoStatusRewardedWidgetState createState() =>
      _LottoStatusRewardedWidgetState();
}

class _LottoStatusRewardedWidgetState extends State<LottoStatusRewardedWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(1080),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Selector<LuckyGroup, LuckyGroup>(
              selector: (context, provider) => provider,
              builder: (_, luckGroup, __) {
                return luckGroup.isLottoRewardedTimeReached()
                    ? Container(
                        child: Wrap(
                            spacing: ScreenUtil().setWidth(64),
                            alignment: WrapAlignment.center,
                            children: getRewardedLottoWidget(
                                luckGroup.getWinningNumberList())))
                    : Container();
              }),
          Container(
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setWidth(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment(-1.0, 0.0),
                    end: Alignment(1.0, 0.0),
                    colors: <Color>[
                      Color(0xffF3BD3D),
                      Color(0xffFFEF29),
                      Color(0xffF3BD3D),
                    ]),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(
                  ScreenUtil().setWidth(30),
                )),
              )),
        ],
      ),
    );
  }

  getRewardedLottoWidget(List<String> winningList) {
    List<Widget> widgetList = [];
    for (int i = 0; i < 6; i++) {
      widgetList.add(FlipLottoItemWidget(
        i + 1,
        winningList[i],
        i,
        getRewarded: checkIfGetRewarded(i),
      ));
    }

    return widgetList;
  }

  bool checkIfGetRewarded(int index) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    Map<String, List<String>> pickedMap = {};
    for (int i = 0; i < luckyGroup.currentPeriodlottoList.length; i++) {
      List<String> listValue = pickedMap[(i % 6).toString()] ?? [];
      listValue.add(luckyGroup.currentPeriodlottoList[i]);
      pickedMap.putIfAbsent((i % 6).toString(), () => listValue);
    }

    if (pickedMap[index.toString()]
        .contains(luckyGroup.getWinningNumberList()[index])) {
      return true;
    }

    return false;
  }
}

class LottoStatusShowcaseWidget extends StatefulWidget {
  List<String> currentPeriodsLottoList;

  LottoStatusShowcaseWidget(this.currentPeriodsLottoList);

  @override
  _LottoStatusShowcaseWidgetState createState() =>
      _LottoStatusShowcaseWidgetState();
}

class _LottoStatusShowcaseWidgetState extends State<LottoStatusShowcaseWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Container(
              width: ScreenUtil().setWidth(1080),
              margin:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
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
                  ScreenUtil().setWidth(30),
                )),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                      "Your Numbers",
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
                      spacing: ScreenUtil().setWidth(64),
                      runSpacing: ScreenUtil().setWidth(20),
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: getShowcaseLottoWidget()),
                ],
              )),
//        SizedBox(
//          height: ScreenUtil().setWidth(30),
//        ),
          Selector<LuckyGroup, LuckyGroup>(
              selector: (context, provider) => provider,
              builder: (_, luckyGroup, __) {
                return Positioned(
                  bottom: ScreenUtil().setWidth(50),
                  left: ScreenUtil().setWidth(160),
                  child: AdButton(
                    adUnitIdFlag: 1,
                    colorsOnBtn: <Color>[
                      Color(0xffF1D34E),
                      Color(0xffF59A22),
                    ],
                    onOk: () {
                      if (luckyGroup.isLottoRewardedTimeReached()) {
                        // 开奖界面点击collect
                        hanldeLottoReceivePrize(luckyGroup);
                      } else {
                        // 倒计时界面重新选择
                        if (luckyGroup.isDisableToPickLotto()) {
                          Layer.toastWarning(
                              "3 chances per day, plaease try tomorrow");
                          return;
                        }
                        // lotto下赌注
                        BurialReport.report('lotto_bet', {});
                        luckyGroup.lottoPickedFinished = false;
                      }
                    },
                    // 1. 开奖界面的时候不需要看广告
                    // 2. 倒计时界面：
                    //    a. 如果一天里面的三次机会还没有用完，并且可用的券已经用完了
                    //    这个时候可以观看广告来进行一次抽取
                    useAd: (!luckyGroup.isLottoRewardedTimeReached() &&
                        luckyGroup.lottoRemainingTimesToday > 0 &&
                        luckyGroup.lottoTicketNumTotal <= 0),
//                    disable: luckyGroup.lottoRemainingTimes <= 0,
                    btnText: luckyGroup.isLottoRewardedTimeReached()
                        ? 'Collect'
                        : 'Bet',
                    tips: null,
                  ),
                );
              })
        ],
      ),
    );
  }

  /// 开奖界面点击领奖
  hanldeLottoReceivePrize(LuckyGroup luckyGroup) async {
    dynamic lottoReceivePrizeInfo = await Service().lottoReceivePrize({
      'awards_date': luckyGroup.currentLottoItem.awards_date,
    });

    // TODO 测试
//    String test = """
//    {"award_num": [3, 2, 1]}
//    """;
//    lottoReceivePrizeInfo = json.decode(test);

    if (lottoReceivePrizeInfo == null) {
      return;
    }
    luckyGroup.lottoReceivePrizeRecords =
        List<num>.from(lottoReceivePrizeInfo['award_num'] ?? []);
    luckyGroup.showLottoAwardShowup = true;

    // lotto领取奖励
    BurialReport.report('lotto_reward_collect', {});
  }

  List<Widget> getShowcaseLottoWidget() {
    List<Widget> widgetList = [];
    for (int i = 0; i < widget.currentPeriodsLottoList.length; i++) {
      bool getRewarded = checkIfGetRewarded(i);
      widgetList.add(Container(
          width: ScreenUtil().setWidth(108),
          height: ScreenUtil().setWidth(108),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(26)),
          child: CircularProgressWidget(
            widget.currentPeriodsLottoList[i],
            type: getRewarded
                ? CircularProgressType.Type_Lucky_Three
                : (i + 1) % 6 == 0
                    ? CircularProgressType.Type_Lucky_Two
                    : CircularProgressType.Type_Lucky_One,
            size: 108,
          )));
    }

    return widgetList;
  }

  bool checkIfGetRewarded(int index) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);

    // 如果是在倒计时界面，不标识中奖的item
    if (!luckyGroup.isLottoRewardedTimeReached()) {
      return false;
    }
    if (widget.currentPeriodsLottoList[index] ==
        luckyGroup.getWinningNumberList()[index % 6]) {
      return true;
    }

    return false;
  }
}

class FlipLottoItemWidget extends StatefulWidget {
  int delayedTime;
  String text;
  bool getRewarded;
  int index;

  FlipLottoItemWidget(this.delayedTime, this.text, this.index,
      {this.getRewarded = false});

  @override
  _FlipLottoItemWidgetState createState() => new _FlipLottoItemWidgetState();
}

class _FlipLottoItemWidgetState extends State<FlipLottoItemWidget>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation flip_anim;
  bool animationStart = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    flip_anim = Tween(begin: 0.0, end: 2.0).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, .5, curve: Curves.easeOutCubic)));

    Future.delayed(Duration(seconds: widget.delayedTime ?? 0), () {
      animationStart = true;
      controller.forward().orCancel;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget emptyItem = Container(
      width: ScreenUtil().setWidth(108),
      height: ScreenUtil().setWidth(108),
      margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(5)),
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
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Transform.rotate(
              angle: flip_anim.value * pi,
              alignment: Alignment.center,
              child: animationStart
                  ? Container(
                      width: ScreenUtil().setWidth(108),
                      height: ScreenUtil().setWidth(108),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(5)),
                      child: CircularProgressWidget(
                        widget.text,
                        type: widget.getRewarded
                            ? CircularProgressType.Type_Lucky_Three
                            : (widget.index + 1) % 6 == 0
                                ? CircularProgressType.Type_Lucky_Two
                                : CircularProgressType.Type_Lucky_One,
                        size: 108,
                      ))
                  : emptyItem);
        });
  }
}
