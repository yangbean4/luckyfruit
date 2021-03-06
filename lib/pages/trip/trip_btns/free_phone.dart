import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart'
    show UserInfo, DrawInfo, Sign, Reward;
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/widgets/ad_btn.dart';
import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/widgets/layer.dart' show GetReward;
import 'package:luckyfruit/widgets/modal.dart';
import 'package:provider/provider.dart';

class FreePhone extends StatelessWidget {
  final Widget child;

  FreePhone({Key key, this.child}) : super(key: key);

  showModal({bool isAuto = true}) async {
    if (isAuto) {
      String sessionVal =
          await Storage.getItem(TreeGroup.CACHE_IS_FIRST_CLICK_PHONE);
      print("freephone_showmodal:${BurialReport.sessionid}, $sessionVal");
      if (sessionVal != null &&
          BurialReport.sessionid.compareTo(sessionVal) == 0) {
        return;
      }
    }

    BurialReport.report('page_imp', {'page_code': '006'});
    BurialReport.report('phone_imp', {'time': DateTime.now().toString()});
    Storage.setItem(
        TreeGroup.CACHE_IS_FIRST_CLICK_PHONE, BurialReport.sessionid);

    Modal(
        verticalPadding: 0,
        horizontalPadding: 0,
        width: 1080,
        isUsePage: true,
        decorationColor: Color.fromRGBO(0, 0, 0, 0),
        childrenBuilder: (Modal modal) => <Widget>[
              Container(
                width: ScreenUtil().setWidth(1080),
                height: ScreenUtil().setWidth(120),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        modal.hide();
                      },
                      child: Container(
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setWidth(120),
                          child: Center(
                              child: Image.asset(
                            'assets/image/close.png',
                            width: ScreenUtil().setWidth(54),
                            height: ScreenUtil().setWidth(54),
                          ))))
                ]),
              ),
              Container(
                  height: ScreenUtil().setWidth(1700),
                  width: ScreenUtil().setWidth(932),
                  // padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/image/free_phone_bg.png'),
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fill),
                  ),
                  child: Stack(overflow: Overflow.visible, children: [
                    Container(
                      width: ScreenUtil().setWidth(865),
                      height: ScreenUtil().setWidth(1600),
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(70),
                          left: ScreenUtil().setWidth(37)),
                      padding: EdgeInsets.only(
                        bottom: ScreenUtil().setWidth(20),
                        top: ScreenUtil().setWidth(90),
                      ),
                      decoration: BoxDecoration(
                          // color: Color.fromRGBO(193, 245, 204, 1),
                          color: Color.fromRGBO(242, 234, 208, 1)),
                      child: _Group(),
                    ),
                    Positioned(
                      left: ScreenUtil().setWidth(-12),
                      top: ScreenUtil().setWidth(-18),
                      child: Image.asset(
                        'assets/image/phone_bvar.png',
                        width: ScreenUtil().setWidth(943),
                        height: ScreenUtil().setWidth(200),
                      ),
                    )
                  ]))
            ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModal(isAuto: false);
        BurialReport.report(
            'c_phone_entr', {'time': DateTime.now().toString()});
        BurialReport.report('event_entr_click', {'entr_code': '3'});
      },
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
      width: ScreenUtil().setWidth(817),
      height: ScreenUtil().setWidth(316),
      // padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
      // padding: EdgeInsets.all(
      //   ScreenUtil().setWidth(9),
      // ),
      margin: EdgeInsets.only(
        bottom: ScreenUtil().setWidth(31),
      ),
      decoration: BoxDecoration(
        // color: Color.fromRGBO(232, 252, 242, 1),
        // color: Color.fromRGBO(252, 250, 232, 1),
        image: DecorationImage(
            image: AssetImage('assets/image/phone_card_bg.png'),
            alignment: Alignment.center,
            fit: BoxFit.fill),
        boxShadow: <BoxShadow>[
          BoxShadow(
            spreadRadius: 0.0,
            blurRadius: ScreenUtil().setWidth(4),
            offset: Offset(ScreenUtil().setWidth(0), ScreenUtil().setWidth(2)),
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            // onTap: () {
            //   GetReward.showPhoneWindow('5', () {
            //     MoneyGroup moneyGroup =
            //         Provider.of<MoneyGroup>(context, listen: false);

            //     moneyGroup.showPhoneAnimation = 5;
            //   });
            // },
            child: Container(
              key: Consts.globalKeyPhonePosition,
              width: ScreenUtil().setWidth(214.2),
              height: ScreenUtil().setWidth(252),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(244, 176, 51, 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(30)),
                  )),
              child: Center(
                child: Image.asset(
                  'assets/image/phone11.png',
                  width: ScreenUtil().setWidth(131),
                  height: ScreenUtil().setWidth(180),
                ),
              ),
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(30),
          ),
          Container(
            width: ScreenUtil().setWidth(512),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SizedBox(height: ScreenUtil().setWidth(20)),
                Text('Apple iPhone 11 Pro Max 256G',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: FontFamily.bold,
                        color: MyTheme.blackColor,
                        fontSize: ScreenUtil().setSp(36),
                        fontWeight: FontWeight.bold)),
                // 进度条
                SizedBox(height: ScreenUtil().setWidth(30)),

                Container(
                    width: ScreenUtil().setWidth(503),
                    height: ScreenUtil().setWidth(26),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(69, 55, 46, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(30)),
                        )),
                    child: Stack(children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(503 * (piecesx / 100)),
                        height: ScreenUtil().setWidth(26),
                        decoration: BoxDecoration(
                          color: MyTheme.primaryColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(30)),
                          ),
                          gradient: LinearGradient(
                              begin: Alignment(0.0, -1.0),
                              end: Alignment(0.0, 1.0),
                              colors: [
                                Color.fromRGBO(254, 233, 94, 1),
                                Color.fromRGBO(244, 148, 82, 1),
                              ]),
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
                SizedBox(height: ScreenUtil().setWidth(30)),

                GestureDetector(
                    onTap: () {
                      piecesx == 100 ? print('qwe') : print('qwe');
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(172),
                      height: ScreenUtil().setWidth(62),
                      decoration: BoxDecoration(
                        color: piecesx == 100
                            ? MyTheme.primaryColor
                            : MyTheme.darkGrayColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(31))),
                      ),
                      child: Center(
                          child: Text('Redeem',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: FontFamily.bold,
                                  color: MyTheme.tipsColor,
                                  height: 1,
                                  fontSize: ScreenUtil().setSp(32),
                                  fontWeight: FontWeight.bold))),
                    )),
                Container(
                  height: ScreenUtil().setWidth(38),
                  margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Modal(
                              btnColors: [
                                Color.fromRGBO(242, 212, 80, 1),
                                Color.fromRGBO(245, 154, 34, 1),
                              ],
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
                                color: Color.fromRGBO(95, 77, 66, 1),
                                height: 1,
                                fontSize: ScreenUtil().setSp(32),
                                fontWeight: FontWeight.bold)),
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
    if (userModel.userInfo?.sign_times == 7 ||
        userModel.userInfo.is_today_sign == 1) {
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
                    // Container(height: ScreenUtil().setWidth(30)),
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

  int residue_times = 0;

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
      moneyGroup.updateUserInfo();
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
        moneyGroup.showPhoneAnimation = int.parse(reward.count);
      });
    } else if (reward.module == '2') {
      GetReward.showTreeWindow(reward.count, () {
        // moneyGroup.updateUserInfo();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    residue_times = widget.residue_times;
  }

  @override
  Widget build(BuildContext context) {
    bool disable = residue_times == 0;
    return Container(
      width: ScreenUtil().setWidth(826),
      height: ScreenUtil().setWidth(975),
      // decoration: BoxDecoration(
      //   boxShadow: <BoxShadow>[
      //     BoxShadow(
      //       spreadRadius: 0.0,
      //       blurRadius: ScreenUtil().setWidth(4),
      //       offset: Offset(ScreenUtil().setWidth(4), ScreenUtil().setWidth(8)),
      //       color: Color.fromRGBO(169, 156, 119, 1),
      //     ),
      //   ],
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: ScreenUtil().setWidth(826),
            height: ScreenUtil().setWidth(106),
            decoration: BoxDecoration(
                // color: Color.fromRGBO(52, 200, 130, 1),
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage("assets/image/free_phone_title_bg.png"),
                  fit: BoxFit.fill,
                ),
                color: Color.fromRGBO(0, 250, 232, 0),
                // gradient: LinearGradient(
                //     begin: Alignment(0, -1.0),
                //     end: Alignment(0, 1.0),
                //     colors: [
                //       Color.fromRGBO(245, 159, 38, 1),
                //       Color.fromRGBO(242, 213, 79, 1),
                //     ]),
                // boxShadow: <BoxShadow>[
                //   BoxShadow(
                //     spreadRadius: 0.0,
                //     blurRadius: ScreenUtil().setWidth(4),
                //     offset: Offset(
                //         ScreenUtil().setWidth(0), ScreenUtil().setWidth(8)),
                //     color: Color.fromRGBO(169, 156, 119, 1),
                //   ),
                // ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setWidth(50)),
                    topRight: Radius.circular(ScreenUtil().setWidth(50)))),
            child: Center(
                child: Text('3 lucky Draw Chances Per Day',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: FontFamily.black,
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(42),
                        fontWeight: FontWeight.bold))),
          ),
          Container(
            width: ScreenUtil().setWidth(816),
            height: ScreenUtil().setWidth(869),
            padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(0),
              ScreenUtil().setWidth(30),
              ScreenUtil().setWidth(0),
              ScreenUtil().setWidth(30),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(252, 250, 232, 1),
            ),
            child: Column(
              children: <Widget>[
                Container(
                    height: ScreenUtil().setWidth(689),
                    width: ScreenUtil().setWidth(694),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                          colors: [
                            Color.fromRGBO(255, 116, 47, 1),
                            Color.fromRGBO(255, 172, 54, 1),
                          ]),
                    ),
                    margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(30)),
                    padding: EdgeInsets.only(top: ScreenUtil().setWidth(22)),
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
                            spacing: ScreenUtil().setWidth(10),
                            runSpacing: ScreenUtil().setWidth(10),
                            alignment: WrapAlignment.center,
                            children: wrap);
                      },
                    )),
                AdButton(
                    ad_code: '209',
                    adUnitIdFlag: 2,
                    child: Container(
                      width: ScreenUtil().setWidth(274),
                      height: ScreenUtil().setWidth(90),
                      decoration: BoxDecoration(
                        gradient: disable
                            ? null
                            : LinearGradient(
                                begin: Alignment(0.0, -1.0),
                                end: Alignment(0.0, 1.0),
                                colors: [
                                    Color.fromRGBO(242, 212, 80, 1),
                                    Color.fromRGBO(245, 154, 34, 1),
                                  ]),
                        borderRadius: BorderRadius.all(Radius.circular(
                          ScreenUtil().setWidth(45),
                        )),
                        color: disable ? MyTheme.darkGrayColor : null,
                        // image: disable
                        //     ? null
                        //     : DecorationImage(
                        //         alignment: Alignment.center,
                        //         image: AssetImage('assets/image/ad_btn.png'),
                        //         fit: BoxFit.cover,
                        //       ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          disable
                              ? Container()
                              : Image.asset(
                                  'assets/image/free_phone_ad_icon.png',
                                  width: ScreenUtil().setWidth(72),
                                  height: ScreenUtil().setWidth(72),
                                ),
                          SizedBox(width: ScreenUtil().setWidth(15)),
                          Text(
                            'Free $residue_times/3',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setWidth(36),
                            ),
                          )
                        ],
                      ),
                    ),
                    onOk: (isFromAd) {
                      _goRun();
                      setState(() {
                        residue_times -= 1;
                      });
                    },
                    disable: disable,
                    fontSize: 50)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, Widget> imgMap = {
  '1': Image.asset(
    'assets/image/phone11.png',
    width: ScreenUtil().setWidth(83),
    height: ScreenUtil().setWidth(114),
  ),
  "2": Image.asset(
    'assets/tree/wishing.png',
    width: ScreenUtil().setWidth(130),
    height: ScreenUtil().setWidth(130),
  ),
  '3': Image.asset(
    'assets/image/phone11.png',
    width: ScreenUtil().setWidth(83),
    height: ScreenUtil().setWidth(114),
  ),
  "4": Image.asset(
    'assets/image/coin_full_bag.png',
    width: ScreenUtil().setWidth(115),
    height: ScreenUtil().setWidth(115),
  ),
  "5": Image.asset(
    'assets/image/coin_full_bag.png',
    width: ScreenUtil().setWidth(115),
    height: ScreenUtil().setWidth(115),
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
      // padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(20)),
      child: reward == null
          ? Center(
              child: Image.asset(
                // 'assets/image/reward_null.png',
                'assets/image/draw_bg.png',
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
                    image: AssetImage(active
                        ? 'assets/image/draw_active_bg.png'
                        : 'assets/image/draw_bg.png')),
                // border: active
                //     ? Border.all(
                //         color: Colors.white,
                //         width: ScreenUtil().setWidth(6),
                //         style: BorderStyle.solid,
                //       )
                //     : null,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(20))),
              ),
              padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(14)),
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
                              color: MyTheme.blackColor,
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
    if (wishTreeNum >= 100) {
      TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
      treeGroup.addWishTree();
      UserModel userModel = Provider.of<UserModel>(context, listen: false);
      userModel.getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(816),
      height: ScreenUtil().setWidth(312),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 250, 232, 1),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Container(
            //   width: ScreenUtil().setWidth(816),
            //   height: ScreenUtil().setWidth(106),
            //   decoration: BoxDecoration(
            //       // color: Color.fromRGBO(52, 200, 130, 1),
            //       gradient: LinearGradient(
            //           begin: Alignment(-1.0, 1.0),
            //           end: Alignment(1.0, -1.0),
            //           colors: [
            //             Color.fromRGBO(52, 200, 130, 1),
            //             Color.fromRGBO(39, 177, 112, 1),
            //           ]),
            //       borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(ScreenUtil().setWidth(50)),
            //           topRight: Radius.circular(ScreenUtil().setWidth(50)))),
            //   child: Center(
            //       child: Text('My Wishing Tree Pieces',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               fontFamily: FontFamily.black,
            //               color: Colors.white,
            //               fontSize: ScreenUtil().setSp(42),
            //               fontWeight: FontWeight.bold))),
            // ),
            Container(
              width: ScreenUtil().setWidth(816),
              height: ScreenUtil().setWidth(312),
              // width: ScreenUtil().setWidth(756),
              // height: ScreenUtil().setWidth(191),
              // margin: EdgeInsets.only(top: ScreenUtil().setWidth(20)),
              // padding: EdgeInsets.symmetric(
              //   horizontal: ScreenUtil().setWidth(30),
              //   vertical: ScreenUtil().setWidth(8),
              // ),
              // decoration: BoxDecoration(
              //   color: Color.fromRGBO(165, 206, 174, 1),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(208),
                    height: ScreenUtil().setWidth(252),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(244, 176, 51, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(30)),
                        )),
                    child: Center(
                      child: Image.asset(
                        'assets/tree/wishing.png',
                        width: ScreenUtil().setWidth(180),
                        height: ScreenUtil().setWidth(180),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(27),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('My Wishing Tree Pieces',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: FontFamily.black,
                                color: MyTheme.blackColor,
                                fontSize: ScreenUtil().setSp(42),
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: ScreenUtil().setWidth(43)),
                        Container(
                            width: ScreenUtil().setWidth(533),
                            height: ScreenUtil().setWidth(26),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(69, 55, 46, 1),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(30)),
                                )),
                            child: Stack(children: <Widget>[
                              Container(
                                width: ScreenUtil()
                                    .setWidth(533 * (wishTreeNum / 100)),
                                height: ScreenUtil().setWidth(26),
                                decoration: BoxDecoration(
                                  color: MyTheme.primaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(30)),
                                  ),
                                  gradient: LinearGradient(
                                      begin: Alignment(0.0, -1.0),
                                      end: Alignment(0.0, 1.0),
                                      colors: [
                                        Color.fromRGBO(254, 233, 94, 1),
                                        Color.fromRGBO(244, 148, 82, 1),
                                      ]),
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
                            ])),
                        SizedBox(height: ScreenUtil().setWidth(50)),
                        GestureDetector(
                            onTap: () {
                              _redeemTree(context);
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(240),
                              height: ScreenUtil().setWidth(66),
                              decoration: BoxDecoration(
                                color: wishTreeNum >= 100
                                    ? null
                                    : MyTheme.darkGrayColor,
                                gradient: wishTreeNum >= 100
                                    ? LinearGradient(
                                        begin: Alignment(0.0, -1.0),
                                        end: Alignment(0.0, 1.0),
                                        colors: [
                                            Color.fromRGBO(242, 212, 80, 1),
                                            Color.fromRGBO(245, 154, 34, 1),
                                          ])
                                    : null,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(33))),
                              ),
                              child: Center(
                                  child: Text('Redeem',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: FontFamily.bold,
                                          color: wishTreeNum >= 100
                                              ? Colors.white
                                              : MyTheme.tipsColor,
                                          height: 1,
                                          fontSize: ScreenUtil().setSp(36),
                                          fontWeight: FontWeight.bold))),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }
}

class _Sign extends StatefulWidget {
  final int sign_times;
  final int is_today_sign;

  _Sign({Key key, this.sign_times, this.is_today_sign}) : super(key: key);

  @override
  __SignState createState() => __SignState();
}

class __SignState extends State<_Sign> {
  bool hasUse = false;

  @override
  Widget build(BuildContext context) {
    bool disable =
        // false;
        widget.is_today_sign == 1 || hasUse || widget.sign_times >= 7;
    return Container(
        width: ScreenUtil().setWidth(815),
        height: ScreenUtil().setWidth(854),
        padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(24),
          ScreenUtil().setWidth(33),
          ScreenUtil().setWidth(24),
          ScreenUtil().setWidth(30),
        ),
        child: Container(
          width: ScreenUtil().setWidth(767),
          height: ScreenUtil().setWidth(791),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(767),
                height: ScreenUtil().setWidth(106),
                decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.center,
                      image: AssetImage("assets/image/free_phone_title_bg.png"),
                      fit: BoxFit.fill,
                    ),
                    color: Color.fromRGBO(0, 250, 232, 0),

                    // gradient: LinearGradient(
                    //     begin: Alignment(0, -1.0),
                    //     end: Alignment(0, 1.0),
                    //     colors: [
                    //       Color.fromRGBO(245, 159, 38, 1),
                    //       Color.fromRGBO(242, 213, 79, 1),
                    //     ]),
                    // boxShadow: <BoxShadow>[
                    //   BoxShadow(
                    //       spreadRadius: 8.0,
                    //       blurRadius: ScreenUtil().setWidth(40),
                    //       offset: Offset(ScreenUtil().setWidth(0),
                    //           ScreenUtil().setWidth(-18)),
                    //       // color: Color.fromRGBO(169, 156, 119, 1),
                    //       color: Colors.red),
                    // ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(50)),
                        topRight: Radius.circular(ScreenUtil().setWidth(50)))),
                child: Center(
                    child: Text('Sign Up For 7 Days To Get Reward',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: FontFamily.black,
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(42),
                            fontWeight: FontWeight.bold))),
              ),
              Container(
                width: ScreenUtil().setWidth(767),
                height: ScreenUtil().setWidth(685),
                padding: EdgeInsets.only(
                    top: ScreenUtil().setWidth(27),
                    bottom: ScreenUtil().setWidth(30)),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(252, 250, 232, 1),
                  // gradient: LinearGradient(
                  //     begin: Alignment(0.0, -1.0),
                  //     end: Alignment(0.0, 1.0),
                  //     colors: [
                  //       Color.fromRGBO(87, 226, 160, 1),
                  //       Color.fromRGBO(212, 249, 227, 1),
                  //     ]),
                ),
                child: Column(children: [
                  Selector<LuckyGroup, DrawInfo>(
                    selector: (context, provider) => provider.drawInfo,
                    builder: (context, DrawInfo drawInfo, _) {
                      List<Widget> wrap = [];
                      for (int index = 0;
                          index < (drawInfo?.sign?.length ?? 0);
                          index++) {
                        wrap.add(_PhoneItem(
                            disable: index < widget.sign_times,
                            index: index,
                            sign: drawInfo.sign[index]));
                      }
                      return Wrap(
                          spacing: ScreenUtil().setWidth(20),
                          runSpacing: ScreenUtil().setWidth(26),
                          alignment: WrapAlignment.center,
                          children: wrap);
                    },
                  ),
                  SizedBox(height: ScreenUtil().setWidth(20)),
                  AdButton(
                      ad_code: '210',
                      adUnitIdFlag: 1,
                      child: Container(
                        width: ScreenUtil().setWidth(274),
                        height: ScreenUtil().setWidth(90),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                            ScreenUtil().setWidth(45),
                          )),
                          gradient: disable
                              ? null
                              : LinearGradient(
                                  begin: Alignment(0.0, -1.0),
                                  end: Alignment(0.0, 1.0),
                                  colors: [
                                      Color.fromRGBO(242, 212, 80, 1),
                                      Color.fromRGBO(245, 154, 34, 1),
                                    ]),
                          color: disable ? MyTheme.darkGrayColor : null,
                          // image: disable
                          //     ? null
                          //     : DecorationImage(
                          //         alignment: Alignment.center,
                          //         image:
                          //             AssetImage('assets/image/ad_btn.png'),
                          //         fit: BoxFit.cover,
                          //       )
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            disable || widget.sign_times < 2
                                ? Container()
                                : Image.asset(
                                    'assets/image/free_phone_ad_icon.png',
                                    width: ScreenUtil().setWidth(72),
                                    height: ScreenUtil().setWidth(72),
                                  ),
                            SizedBox(width: ScreenUtil().setWidth(15)),
                            Text(
                              'Collect',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setWidth(36),
                              ),
                            )
                          ],
                        ),
                      ),
                      disable: disable,
                      useAd: widget.sign_times > 1,
                      onOk: (isFromAd) {
                        LuckyGroup luckyGroup =
                            Provider.of<LuckyGroup>(context, listen: false);

                        Sign sign = luckyGroup.drawInfo.sign[widget.sign_times];
                        MoneyGroup moneyGroup =
                            Provider.of<MoneyGroup>(context, listen: false);

                        if (sign.module != '1') {
                          TreeGroup treeGroup =
                              Provider.of<TreeGroup>(context, listen: false);

                          if (treeGroup.isFull) {
                            return Layer.locationFull();
                          }
                        }
                        moneyGroup
                            .beginSign(sign.sign, sign.count)
                            .then((value) {
                          print("beginSign_$value");
                          if (value) {
                            setState(() {
                              hasUse = true;
                            });
                          }
                        });
                      },
                      fontSize: 36)
                ]),
              )
            ],
          ),
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
      width: ScreenUtil().setWidth(162),
      height: ScreenUtil().setWidth(238),
      decoration: BoxDecoration(
        color: Color.fromRGBO(252, 250, 232, 1),
        image: DecorationImage(
            image: AssetImage('assets/image/sign_phone_bg.png'),
            alignment: Alignment.center,
            fit: BoxFit.fill),
        // borderRadius:
        //     BorderRadius.all(Radius.circular(ScreenUtil().setWidth(22))),
      ),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(162),
                height: ScreenUtil().setWidth(50),
                decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //     begin: Alignment(0, -1.0),
                    //     end: Alignment(0, 1.0),
                    //     colors: [
                    //       Color.fromRGBO(232, 87, 25, 1),
                    //       Color.fromRGBO(250, 130, 49, 1),
                    //     ]),
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
                            fontSize: ScreenUtil().setSp(32),
                            fontWeight: FontWeight.bold))),
              ),
              sign.module == '1'
                  ? Image.asset('assets/image/phone11.png',
                      width: ScreenUtil().setWidth(73),
                      height: ScreenUtil().setWidth(100))
                  : Image.asset('assets/tree/bonus.png',
                      width: ScreenUtil().setWidth(120),
                      height: ScreenUtil().setWidth(84)),
              Container(
                width: ScreenUtil().setWidth(82),
                height: ScreenUtil().setWidth(10),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(242, 234, 208, 1),
                  borderRadius: BorderRadius.all(Radius.elliptical(
                      ScreenUtil().setWidth(41), ScreenUtil().setWidth(5))),
                ),
              ),
              Container(
                child: Text(sign.content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: FontFamily.semibold,
                        color: MyTheme.blackColor,
                        height: 1,
                        fontSize:
                            ScreenUtil().setSp(sign.module == '1' ? 32 : 24),
                        fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(12),
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
                      'assets/image/sign_success.png',
                      width: ScreenUtil().setWidth(68),
                      height: ScreenUtil().setWidth(71),
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
