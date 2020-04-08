import 'package:flutter/material.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:luckyfruit/widgets/modal.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/models/index.dart'
    show UserInfo, DrawInfo, Sign, Reward;
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';

import 'package:luckyfruit/theme/public/elliptical_widget.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/widgets/layer.dart' show GetReward;

class FreePhone extends StatelessWidget {
  final Widget child;
  FreePhone({Key key, this.child}) : super(key: key);

  _showModal() {
    Modal(
        verticalPadding: 0,
        horizontalPadding: 0,
        width: 1080,
        decorationColor: Color.fromRGBO(0, 0, 0, 0),
        childrenBuilder: (Modal modal) => <Widget>[
              Container(
                width: ScreenUtil().setWidth(1080),
                height: ScreenUtil().setWidth(240),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        modal.hide();
                      },
                      child: Container(
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setWidth(240),
                          child: Center(
                              child: Image.asset(
                            'assets/image/close.png',
                            width: ScreenUtil().setWidth(54),
                            height: ScreenUtil().setWidth(54),
                          ))))
                ]),
              ),
              Container(
                height: ScreenUtil().setWidth(1600),
                width: ScreenUtil().setWidth(1080),
                // padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(840),
                      // height: ScreenUtil().setWidth(1450),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(120)),
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(20),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(100))),
                      ),
                      child: _Group(),
                    ),
                    Positioned(
                        top: ScreenUtil().setWidth(-61),
                        left: ScreenUtil().setWidth(103),
                        child: Container(
                          width: ScreenUtil().setWidth(869),
                          height: ScreenUtil().setWidth(182),
                          child: Center(
                              child: ModalTitle(
                            'Get Mobile Phone For Free',
                            fontsize: 58,
                            color: MyTheme.blackColor,
                          )),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                      'assets/image/phone_bvar.png'))),
                        )),
                  ],
                ),
              )
            ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showModal,
      child: child,
    );
  }
}

class _Phone extends StatelessWidget {
  final int piecesx;
  const _Phone({Key key, this.piecesx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(840),
      height: ScreenUtil().setWidth(476),
      // padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
      padding: EdgeInsets.fromLTRB(
        ScreenUtil().setWidth(56),
        ScreenUtil().setWidth(108),
        ScreenUtil().setWidth(76),
        ScreenUtil().setWidth(36),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ScreenUtil().setWidth(100)),
            topRight: Radius.circular(ScreenUtil().setWidth(100))),
        boxShadow: <BoxShadow>[
          BoxShadow(
            spreadRadius: 0.0,
            blurRadius: ScreenUtil().setWidth(40),
            offset: Offset(ScreenUtil().setWidth(0), ScreenUtil().setWidth(14)),
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
          // BoxShadow(
          //   spreadRadius: 0.0,
          //   blurRadius: ScreenUtil().setWidth(40),
          //   offset:
          //       Offset(ScreenUtil().setWidth(0), ScreenUtil().setWidth(-14)),
          //   color: Colors.white,
          // ),
        ],
        // borderRadius:
        //     BorderRadius.all(Radius.circular(ScreenUtil().setWidth(60))),
        border: Border.all(
          // color: const Color.fromRGBO(255, 172, 30, 1),
          color: Colors.white,
          width: ScreenUtil().setWidth(8),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(272),
            height: ScreenUtil().setWidth(332),
            decoration: BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.center,
                fit: BoxFit.contain,
                image: AssetImage('assets/image/phone_bg.png'),
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/image/phone11.png',
                width: ScreenUtil().setWidth(186),
                height: ScreenUtil().setWidth(255),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(411),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: ScreenUtil().setWidth(20)),
                Text('Apple iPhone 11 Pro Max 256G',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: FontFamily.bold,
                        color: MyTheme.blackColor,
                        fontSize: ScreenUtil().setSp(36),
                        fontWeight: FontWeight.bold)),
                // 进度条
                SizedBox(height: ScreenUtil().setWidth(18)),

                Container(
                    width: ScreenUtil().setWidth(410),
                    height: ScreenUtil().setWidth(26),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(222, 220, 216, 1),
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(13))),
                    ),
                    child: Stack(children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(410 * (piecesx / 100)),
                        height: ScreenUtil().setWidth(26),
                        decoration: BoxDecoration(
                          color: MyTheme.primaryColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(13))),
                        ),
                      ),
                      Center(
                          child: Text(
                        '$piecesx/100',
                        style: TextStyle(
                            fontFamily: FontFamily.bold,
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(26),
                            height: 1,
                            fontWeight: FontWeight.bold),
                      )),
                    ])),
                SizedBox(height: ScreenUtil().setWidth(32)),

                GestureDetector(
                    onTap: () {
                      piecesx == 100 ? print('qwe') : print('qwe');
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(240),
                      height: ScreenUtil().setWidth(66),
                      decoration: BoxDecoration(
                        color: piecesx == 100
                            ? MyTheme.primaryColor
                            : MyTheme.darkGrayColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(33))),
                      ),
                      child: Center(
                          child: Text('Redeem',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: FontFamily.bold,
                                  color: MyTheme.tipsColor,
                                  height: 1,
                                  fontSize: ScreenUtil().setSp(36),
                                  fontWeight: FontWeight.bold))),
                    )),
                Container(
                  height: ScreenUtil().setWidth(30),
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Modal(
                              horizontalPadding: 100,
                              // onCancel: () {},
                              onOk: () {},
                              okText: 'Ok',
                              autoHide: true,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: ScreenUtil().setWidth(70)),
                                  child: Text(
                                    "You don't have enough mobile phone chips," +
                                        'join the“collect phone chips"activity to get more chips.',
                                    style: TextStyle(
                                        color: MyTheme.blackColor,
                                        fontFamily: FontFamily.regular,
                                        fontSize: ScreenUtil().setSp(46),
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ]).show();
                        },
                        child: Text('Address >>',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontFamily: FontFamily.semibold,
                                color: MyTheme.primaryColor,
                                height: 1,
                                fontSize: ScreenUtil().setSp(34),
                                fontWeight: FontWeight.normal)),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Group extends StatefulWidget {
  _Group({Key key}) : super(key: key);

  @override
  __GroupState createState() => __GroupState();
}

class __GroupState extends State<_Group> {
  ScrollController controller =
      ScrollController(keepScrollOffset: false, initialScrollOffset: 0.0);
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MoneyGroup userModel = Provider.of<MoneyGroup>(context, listen: false);
    if (userModel.userInfo?.sign_times == 7) {
      Future.delayed(Duration(milliseconds: 300)).then((e) {
        controller?.animateTo(ScreenUtil().setWidth(870.0),
            duration: Duration(milliseconds: 800), curve: Curves.easeOutQuad);
      });
    }
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<MoneyGroup, UserInfo>(
      selector: (context, probider) => probider.userInfo,
      builder: (context, UserInfo userInfo, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _Phone(piecesx: userInfo?.phoneNum ?? 0),
            Expanded(
                child: SingleChildScrollView(
              controller: controller,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(height: ScreenUtil().setWidth(30)),
                    _Sign(
                        sign_times: userInfo?.sign_times ?? 0,
                        is_today_sign: userInfo.is_today_sign ?? 1),
                    Container(height: ScreenUtil().setWidth(30)),
                    _Reward(residue_times: userInfo.residue_times),
                    Container(height: ScreenUtil().setWidth(30)),
                    _Wishing(wishTreeNum: userInfo?.wishTreeNum ?? 0),
                    Container(height: ScreenUtil().setWidth(30)),
                  ]),
            )),
          ],
        );
      },
    );
  }
}

class _Reward extends StatefulWidget {
  final int residue_times;
  _Reward({Key key, this.residue_times}) : super(key: key);

  @override
  __RewardState createState() => __RewardState();
}

class __RewardState extends State<_Reward> {
  int index;
  int startInterval = 20;
  int endInterval = 150;
  int speed = 15;
  int server = 1;

  _goRun() async {
    Layer.loading('loading...');

    MoneyGroup moneyGroup = Provider.of<MoneyGroup>(context, listen: false);

    Map<String, dynamic> ajax = await Service().lotteryDraw({
      'acct_id': moneyGroup.acct_id,
    });
    if (ajax == null) {
      Layer.toastWarning('Today you have drawn three times');
    } else {
      setState(() {
        index = 1;
        server = ajax['sign'];
      });
      Layer.loadingHide();

      _runAnimation(startInterval);
    }
  }

  _runAnimation(int interval) {
    Future.delayed(Duration(milliseconds: interval)).then((e) {
      if (interval >= endInterval && index == server) {
        _runEnd();
      } else {
        _runAnimation(interval > endInterval ? endInterval : interval + speed);
        setState(() {
          // 等级是从1 开始的; 最大为8
          index = index % 8 + 1;
        });
      }
    });
  }

  _runEnd() {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    Reward reward = luckyGroup.drawInfo.reward
        .firstWhere((i) => i.sign == server.toString());
    MoneyGroup moneyGroup = Provider.of<MoneyGroup>(context, listen: false);
    if (reward.module == '5') {
      double gold = moneyGroup.makeGoldSped * int.parse(reward.count);
      GetReward.showGoldWindow(gold, () {
        moneyGroup.addGold(gold);
      });
    } else if (reward.module == '4') {
      double gold = double.parse(reward.count);
      GetReward.showGoldWindow(gold, () {
        moneyGroup.addGold(gold);
      });
    } else if (reward.module == '1') {
      GetReward.showPhoneWindow(reward.count, () {
        // moneyGroup.updateUserInfo();
      });
    } else if (reward.module == '2') {
      GetReward.showTreeWindow(reward.count, () {
        // moneyGroup.updateUserInfo();
      });
    }
    moneyGroup.updateUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(760),
      height: ScreenUtil().setWidth(1036),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(760),
            height: ScreenUtil().setWidth(840),
            margin: EdgeInsets.only(
                // top: ScreenUtil().setWidth(24),
                bottom: ScreenUtil().setWidth(50)),
            padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(53),
              ScreenUtil().setWidth(53),
              ScreenUtil().setWidth(53),
              ScreenUtil().setWidth(22),
            ),
            decoration: BoxDecoration(
              color: MyTheme.grayColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().setWidth(60))),
            ),
            child: Column(
              children: <Widget>[
                Text('3 lucky draw chances per day',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: FontFamily.bold,
                        color: MyTheme.blackColor,
                        height: 1,
                        fontSize: ScreenUtil().setSp(48),
                        fontWeight: FontWeight.bold)),
                Container(
                    height: ScreenUtil().setWidth(646),
                    width: ScreenUtil().setWidth(646),
                    margin: EdgeInsets.only(top: ScreenUtil().setWidth(24)),
                    child: Selector<LuckyGroup, DrawInfo>(
                      selector: (context, provider) => provider.drawInfo,
                      builder: (context, DrawInfo drawInfo, _) {
                        // 转盘排序
                        List<int> indexLixt = [1, 2, 3, 8, 9, 4, 7, 6, 5];
                        List<Widget> wrap = [];

                        if (drawInfo?.reward != null) {
                          wrap = indexLixt
                              .map((index) {
                                return drawInfo?.reward?.firstWhere(
                                    (re) => re.sign == index.toString(),
                                    orElse: () => null);
                              })
                              .map((re) => _RewardItem(
                                    reward: re,
                                    active: re?.sign == index.toString(),
                                  ))
                              .toList();
                        }
                        return Wrap(
                            spacing: ScreenUtil().setWidth(8),
                            runSpacing: ScreenUtil().setWidth(8),
                            alignment: WrapAlignment.center,
                            children: wrap);
                      },
                    )),
              ],
            ),
          ),
          AdButton(
              // residue_times
              btnText: 'Free ${widget.residue_times}/3',
              tips: null,
              disable: widget.residue_times == 0,
              width: 400,
              height: 100,
              onOk: () {
                _goRun();
              },
              fontSize: 50)
        ],
      ),
    );
  }
}

Map<String, Widget> imgMap = {
  '1': Image.asset(
    'assets/image/phone11.png',
    width: ScreenUtil().setWidth(87),
    height: ScreenUtil().setWidth(120),
  ),
  "2": Image.asset(
    'assets/tree/wishing.png',
    width: ScreenUtil().setWidth(111),
    height: ScreenUtil().setWidth(122),
  ),
  '3': Image.asset(
    'assets/image/phone11.png',
    width: ScreenUtil().setWidth(87),
    height: ScreenUtil().setWidth(120),
  ),
  "4": Image.asset(
    'assets/image/coin_full_bag.png',
    width: ScreenUtil().setWidth(170),
    height: ScreenUtil().setWidth(87),
  ),
  "5": Image.asset(
    'assets/image/coin_full_bag.png',
    width: ScreenUtil().setWidth(170),
    height: ScreenUtil().setWidth(87),
  )
};

class _RewardItem extends StatelessWidget {
  final bool active;
  final Reward reward;
  const _RewardItem({Key key, this.active, this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(210),
      height: ScreenUtil().setWidth(210),
      child: reward == null
          ? Center(
              child: Image.asset(
                'assets/image/reward_null.png',
                width: ScreenUtil().setWidth(210),
                height: ScreenUtil().setWidth(215),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                // color: Color.fromRGBO(251, 236, 209, 1),
                image: DecorationImage(
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    image: AssetImage('assets/image/draw_bg.png')),
                border: active
                    ? Border.all(
                        color: MyTheme.primaryColor,
                        width: ScreenUtil().setWidth(6),
                        style: BorderStyle.solid,
                      )
                    : null,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(20))),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    imgMap[reward.module] ?? Container(),
                    Container(
                      child: Text(reward.content,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: FontFamily.bold,
                              color: Color.fromRGBO(209, 109, 20, 1),
                              height: 1,
                              fontSize: ScreenUtil().setSp(28),
                              fontWeight: FontWeight.bold)),
                    )
                  ]),
            ),
    );
  }
}

class _Wishing extends StatelessWidget {
  final int wishTreeNum;
  const _Wishing({Key key, this.wishTreeNum}) : super(key: key);

  _redeemTree(BuildContext context) async {
    if (wishTreeNum == 100) {
      TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
      treeGroup.addWishTree();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(760),
      height: ScreenUtil().setWidth(348),
      decoration: BoxDecoration(
        color: MyTheme.grayColor,
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(60))),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(760),
              height: ScreenUtil().setWidth(100),
              decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setWidth(40)),
                    topRight: Radius.circular(ScreenUtil().setWidth(40)),
                  )),
              child: Center(
                child: Text('My Wishing Tree Pieces',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: FontFamily.bold,
                        color: Colors.white,
                        height: 1,
                        fontSize: ScreenUtil().setSp(48),
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(718),
              height: ScreenUtil().setWidth(212),
              margin: EdgeInsets.only(top: ScreenUtil().setWidth(16)),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(48),
                vertical: ScreenUtil().setWidth(14),
              ),
              decoration: BoxDecoration(
                  // color: Color.fromRGBO(251, 236, 209, 1),
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(ScreenUtil().setWidth(30)),
                bottomRight: Radius.circular(ScreenUtil().setWidth(30)),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setWidth(100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/tree/wishing.png',
                          width: ScreenUtil().setWidth(91),
                          height: ScreenUtil().setWidth(100),
                        ),
                        Container(
                            width: ScreenUtil().setWidth(410),
                            height: ScreenUtil().setWidth(26),
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(18)),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(222, 220, 216, 1),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(13))),
                            ),
                            child: Stack(children: <Widget>[
                              Container(
                                width: ScreenUtil()
                                    .setWidth(410 * (wishTreeNum / 100)),
                                height: ScreenUtil().setWidth(26),
                                decoration: BoxDecoration(
                                  color: MyTheme.primaryColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(13))),
                                ),
                              ),
                              Center(
                                  child: Text(
                                '$wishTreeNum/100',
                                style: TextStyle(
                                    fontFamily: FontFamily.bold,
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(26),
                                    height: 1,
                                    fontWeight: FontWeight.bold),
                              )),
                            ]))
                      ],
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        _redeemTree(context);
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(240),
                        height: ScreenUtil().setWidth(66),
                        decoration: BoxDecoration(
                          color: wishTreeNum == 100
                              ? MyTheme.primaryColor
                              : MyTheme.darkGrayColor,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(33))),
                        ),
                        child: Center(
                            child: Text('Redeem',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: FontFamily.bold,
                                    color: MyTheme.tipsColor,
                                    height: 1,
                                    fontSize: ScreenUtil().setSp(36),
                                    fontWeight: FontWeight.bold))),
                      )),
                ],
              ),
            )
          ]),
    );
  }
}

class _Sign extends StatelessWidget {
  final int sign_times;
  final int is_today_sign;
  _Sign({Key key, this.sign_times, this.is_today_sign}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(760),
        height: ScreenUtil().setWidth(840),
        padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(0),
          ScreenUtil().setWidth(58),
          ScreenUtil().setWidth(0),
          ScreenUtil().setWidth(54),
        ),
        decoration: BoxDecoration(
          color: MyTheme.grayColor,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(60))),
          // border: Border.all(
          //   color: const Color.fromRGBO(255, 172, 30, 1),
          //   width: 2,
          //   style: BorderStyle.solid,
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Sign Up For 7 Days To Get Reward',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: FontFamily.black,
                    color: MyTheme.blackColor,
                    height: 1,
                    fontSize: ScreenUtil().setSp(46),
                    fontWeight: FontWeight.w900)),
            Container(
                width: ScreenUtil().setWidth(760),
                height: ScreenUtil().setWidth(500),
                child: Selector<LuckyGroup, DrawInfo>(
                  selector: (context, provider) => provider.drawInfo,
                  builder: (context, DrawInfo drawInfo, _) {
                    List<Widget> wrap = [];
                    for (int index = 0;
                        index < (drawInfo?.sign?.length ?? 0);
                        index++) {
                      wrap.add(_PhoneItem(
                          disable: index < sign_times,
                          index: index,
                          sign: drawInfo.sign[index]));
                    }
                    return Wrap(
                        spacing: ScreenUtil().setWidth(24),
                        runSpacing: ScreenUtil().setWidth(24),
                        alignment: WrapAlignment.center,
                        children: wrap);
                  },
                )),
            AdButton(
                btnText: 'Sign in',
                tips: null,
                disable: is_today_sign == 1,
                width: 364,
                height: 100,
                onOk: () {
                  LuckyGroup luckyGroup =
                      Provider.of<LuckyGroup>(context, listen: false);

                  Sign sign = luckyGroup.drawInfo.sign[sign_times + 1];
                  MoneyGroup moneyGroup =
                      Provider.of<MoneyGroup>(context, listen: false);

                  GetReward.showPhoneWindow(sign.count, () {
                    moneyGroup.beginSign(sign.sign, sign.count);
                  });
                },
                fontSize: 50)
          ],
        ));
  }
}

class _PhoneItem extends StatelessWidget {
  final int index;
  final Sign sign;
  final bool disable;
  const _PhoneItem({Key key, this.index, this.disable, this.sign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(160),
      height: ScreenUtil().setWidth(236),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20))),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(160),
                height: ScreenUtil().setWidth(48),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(124, 186, 124, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ScreenUtil().setWidth(20)),
                      topRight: Radius.circular(ScreenUtil().setWidth(20)),
                    )),
                child: Center(
                    child: Text('Day ${index + 1}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontFamily.bold,
                            color: Colors.white,
                            height: 1,
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.bold))),
              ),
              Image.asset('assets/image/phone11.png',
                  width: ScreenUtil().setWidth(73),
                  height: ScreenUtil().setWidth(100)),
              EllipticalWidget(
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setWidth(10),
                color: MyTheme.grayColor,
              ),
              Container(
                child: Text(sign.content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: FontFamily.bold,
                        color: Color.fromRGBO(209, 109, 20, 1),
                        height: 1,
                        fontSize: ScreenUtil().setSp(28),
                        fontWeight: FontWeight.bold)),
              )
            ],
          ),
          disable
              ? Positioned(
                  child: Container(
                    width: ScreenUtil().setWidth(160),
                    height: ScreenUtil().setWidth(236),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.5),
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(20))),
                    ),
                    child: Center(
                        child: Image.asset(
                      'assets/image/success.png',
                      width: ScreenUtil().setWidth(80),
                      height: ScreenUtil().setWidth(80),
                    )),
                  ),
                  left: 0,
                  top: 0)
              : Container(),
        ],
      ),
    );
  }
}
