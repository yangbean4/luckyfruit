import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/pages/trip/game/continents_merge_widget.dart';
import 'package:luckyfruit/pages/trip/game/hops_merge_widget.dart';
import 'package:luckyfruit/pages/trip/game/huge_win.dart';
import 'package:luckyfruit/pages/trip/game/lucky_wheel.dart';
import 'package:luckyfruit/pages/trip/game/times_reward.dart';
import 'package:luckyfruit/pages/trip/top_level_merger.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/utils/bgm.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/utils/share_util.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import './ad_btn.dart';
import './modal.dart';
import 'friends_fest_reward_widget.dart';

/// 公共函数库
class Layer {
  static ToastFuture _future;

  /// 显示完成弹窗
  static toastSuccess(String msg, {int padding = 68}) =>
      _showToast('success', msg, padding: padding);

  /// 显示警告弹窗
  static toastWarning(String msg, {int padding = 68}) =>
      _showToast('warning', msg, padding: padding);

  /// 显示loading
  static loading(msg) => _showToast('loading', msg);

  /// 隐藏loading
  static loadingHide() => _future?.dismiss();

  static partnerCash(BuildContext context, {Function onOK}) {
    AnimationController _controller;
    AnimationController _controller2;
    BurialReport.report('page_imp', {'page_code': '036'});

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
                        if (onOK != null) {
                          onOK();
                        }
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
                height: ScreenUtil().setWidth(1540),
                width: ScreenUtil().setWidth(1080),
                // padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil().setWidth(965),
                      // height: ScreenUtil().setWidth(1450),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(55)),
                      padding: EdgeInsets.only(
                          bottom: ScreenUtil().setWidth(20),
                          top: ScreenUtil().setWidth(170)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(30))),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().setWidth(908),
                            height: ScreenUtil().setWidth(994),
                            child: Stack(overflow: Overflow.visible, children: [
                              Image.asset(
                                'assets/image/partner_cash.png',
                                width: ScreenUtil().setWidth(908),
                                height: ScreenUtil().setWidth(994),
                              ),
                              // Positioned(
                              //     left: ScreenUtil().setWidth(-10),
                              //     top: ScreenUtil().setWidth(113),
                              //     child: Container(
                              //       width: ScreenUtil().setWidth(328),
                              //       height: ScreenUtil().setWidth(744),
                              //       child: Lottie.asset(
                              //         'assets/lottiefiles/data.json',
                              //         controller: _controller,
                              //         onLoaded: (composition) {
                              //           _controller.duration =
                              //               composition.duration;
                              //           _controller
                              //             ..value = 0
                              //             ..forward();
                              //         },
                              //       ),
                              //     )),
                              Positioned(
                                  right: ScreenUtil().setWidth(-90),
                                  top: ScreenUtil().setWidth(-395),
                                  child: Container(
                                    width: ScreenUtil().setWidth(1080),
                                    height: ScreenUtil().setWidth(1920),
                                    child: Lottie.asset(
                                      'assets/lottiefiles/data.json',
                                      width: ScreenUtil().setWidth(1080),
                                      height: ScreenUtil().setWidth(1920),
                                      // controller: _controller2,
                                      // onLoaded: (composition) {
                                      //   _controller2.duration =
                                      //       composition.duration;
                                      //   _controller2
                                      //     ..value = 0
                                      //     ..forward();
                                      // },
                                    ),
                                  )),
                            ]),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(30),
                          ),
                          Text(
                            "More Partner,More Cash",
                            style: TextStyle(
                              color: Color.fromRGBO(51, 51, 51, 1),
                              fontFamily: FontFamily.regular,
                              fontSize: ScreenUtil().setWidth(60),
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(60),
                          ),
                          GestureDetector(
                            onTap: () {
                              modal.hide();
                              BurialReport.report(
                                  'invite_entr', {'entr_code': '008'});

                              ShareUtil.share(context);
                              if (onOK != null) {
                                onOK();
                              }
                            },
                            child: PrimaryButton(
                              width: 600,
                              height: 124,
                              child: Center(
                                child: Text(
                                  'Invite',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(56),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        top: ScreenUtil().setWidth(-161),
                        left: ScreenUtil().setWidth(85),
                        child: Container(
                          width: ScreenUtil().setWidth(952),
                          height: ScreenUtil().setWidth(288),
                          child: Center(
                              child: Image.asset(
                            'assets/image/invite_bvar.png',
                            width: ScreenUtil().setWidth(952),
                            height: ScreenUtil().setWidth(288),
                          )),
                          // decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //         alignment: Alignment.center,
                          //         fit: BoxFit.contain,
                          //         image: AssetImage(
                          //             'assets/image/invite_bvar.png'))),
                        )),
                  ],
                ),
              )
            ]).show();
  }

// 新等级弹窗
  static newGrade(Tree tree, {num amount, Function onOk, bool showBottom}) =>
      Modal(
              onOk: () {
                if (onOk != null) onOk();
              },
              okText: 'Claim',
              children: <Widget>[
                ModalTitle('${tree.name}'),
                Container(height: ScreenUtil().setWidth(47)),
                TreeWidget(
                  tree: tree,
                  imgHeight: ScreenUtil().setWidth(236),
                  imgWidth: ScreenUtil().setWidth(216),
                  labelWidth: ScreenUtil().setWidth(80),
                  primary: true,
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setWidth(30),
                    bottom: ScreenUtil().setWidth(47),
                  ),
                  child: Text(
                    'Update successed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: FontFamily.regular,
                        color: MyTheme.blackColor,
                        fontSize: ScreenUtil().setSp(50),
                        fontWeight: FontWeight.w400),
                  ),
                ),
                // SecondaryText('升级成功', color: MyTheme.secondaryColor)
              ],
              footer: !showBottom
                  ? Container()
                  : Container(
                      width: ScreenUtil().setWidth(840),
                      height: ScreenUtil().setWidth(497),
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(50),
                        right: ScreenUtil().setWidth(50),
                        top: ScreenUtil().setWidth(50),
                        bottom: ScreenUtil().setWidth(57),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(100)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              width: ScreenUtil().setWidth(444),
                              height: ScreenUtil().setWidth(84),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text:
                                      '${Tree.MAX_LEVEL - tree.grade} grades away from the "Bouns Tree=',
                                  style: TextStyle(
                                      color: MyTheme.blackColor,
                                      fontSize: ScreenUtil().setSp(40),
                                      fontFamily: FontFamily.bold,
                                      height: 1.1,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                      text: '${amount}',
                                      style: TextStyle(
                                          color: Color.fromRGBO(255, 80, 52, 1),
                                          fontSize: ScreenUtil().setSp(40),
                                          fontFamily: FontFamily.bold,
                                          height: 1.1,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '"',
                                      style: TextStyle(
                                          color: MyTheme.blackColor,
                                          fontSize: ScreenUtil().setSp(40),
                                          fontFamily: FontFamily.bold,
                                          height: 1,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )),
                          Container(
                            width: ScreenUtil().setWidth(740),
                            height: ScreenUtil().setWidth(144),
                            // padding: EdgeInsets.only(
                            //   right: ScreenUtil().setWidth(119),
                            // ),
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setWidth(18),
                              bottom: ScreenUtil().setWidth(18),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: ScreenUtil().setWidth(360),
                                  height: ScreenUtil().setWidth(90),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '1.Merge 5 continental trees\n2.Merge any 2 trees in Level 37\n3.Stay active in the game',
                                        style: TextStyle(
                                            color: MyTheme.blackColor,
                                            fontFamily: FontFamily.regular,
                                            height: 1,
                                            fontSize: ScreenUtil().setSp(26),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(66),
                                ),
                                Image.asset(
                                  'assets/image/arrow.png',
                                  width: ScreenUtil().setWidth(57),
                                  height: ScreenUtil().setWidth(48),
                                ),
                                SizedBox(
                                  width: ScreenUtil().setWidth(86),
                                ),
                                Container(
                                  width: ScreenUtil().setWidth(105),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/image/topTree.png',
                                          width: ScreenUtil().setWidth(105),
                                          height: ScreenUtil().setWidth(120),
                                        ),
                                        Text(
                                          'Bouns Tree',
                                          style: TextStyle(
                                              color: MyTheme.blackColor,
                                              fontFamily: FontFamily.regular,
                                              height: 1,
                                              fontSize: ScreenUtil().setSp(20),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ]),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(7),
                          ),
                          Container(
                              width: ScreenUtil().setWidth(740),
                              height: ScreenUtil().setWidth(36),
                              // margin: EdgeInsets.only(
                              //   top: ScreenUtil().setWidth(20),
                              //   bottom: ScreenUtil().setWidth(13),
                              // ),
                              child: RichText(
                                text: TextSpan(
                                    text: 'your progress:',
                                    style: TextStyle(
                                        color: MyTheme.blackColor,
                                        fontSize: ScreenUtil().setSp(30),
                                        fontFamily: FontFamily.semibold,
                                        height: 1.3,
                                        fontWeight: FontWeight.w500),
                                    children: [
                                      TextSpan(
                                          text:
                                              '${(100 * tree.grade / Tree.MAX_LEVEL).toStringAsFixed(2)}%',
                                          style: TextStyle(
                                              color: MyTheme.primaryColor,
                                              fontSize: ScreenUtil().setSp(40),
                                              height: 1,
                                              fontFamily: FontFamily.bold,
                                              fontWeight: FontWeight.bold))
                                    ]),
                              )),
                          SizedBox(
                            height: ScreenUtil().setWidth(10),
                          ),
                          Stack(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(740),
                                height: ScreenUtil().setWidth(20),
                                decoration: BoxDecoration(
                                  color: MyTheme.grayColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(10))),
                                ),
                              ),
                              Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Container(
                                    width: ScreenUtil().setWidth(
                                        (tree.grade / Tree.MAX_LEVEL) * 740),
                                    height: ScreenUtil().setWidth(20),
                                    decoration: BoxDecoration(
                                      color: MyTheme.primaryColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(10))),
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: ScreenUtil().setWidth(29),
                          ),
                          Container(
                            width: ScreenUtil().setWidth(740),
                            height: ScreenUtil().setWidth(24),
                            // margin: EdgeInsets.only(
                            //   top: ScreenUtil().setWidth(26),
                            // ),
                            child: Text(
                              'when your progress reach 100%,you probably will get a “Bouns Tree”.',
                              style: TextStyle(
                                  color: MyTheme.tipsColor,
                                  fontFamily: FontFamily.regular,
                                  height: 1,
                                  fontSize: ScreenUtil().setSp(23),
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    ))
          .show();

  static locationFull() {
    Modal(
        autoHide: true,
        onCancel: () {},
        onOk: () {},
        horizontalPadding: 100,
        btnColors: [
          Color.fromRGBO(242, 212, 80, 1),
          Color.fromRGBO(245, 154, 34, 1),
        ],
        okText: 'Ok',
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(70)),
            child: Text(
              'The location is full, please merge the fruit tree or recycle the fruit tree before redeem!',
              style: TextStyle(
                  color: MyTheme.blackColor,
                  fontFamily: FontFamily.regular,
                  fontSize: ScreenUtil().setSp(46),
                  fontWeight: FontWeight.w400),
            ),
          )
        ]).show();
  }

// 回收弹窗
  static recycleLayer(Function onOk, String imgSrc, Tree tree) {
    String message;
    String goldOrCashImageUrl;
    if (tree?.type == TreeType.Type_Wishing) {
      // 是许愿树,则发放金额,其他类型的发放金币
      if (tree?.recycleMoney == null) {
        message = "\$--";
      } else {
        message = '\$${Util.formatNumber(tree?.recycleMoney)}';
      }
      goldOrCashImageUrl = "assets/image/bg_dollar.png";
    } else {
      message = Util.formatNumber(tree.recycleGold) ?? "--";
      goldOrCashImageUrl = "assets/image/gold.png";
    }

    Modal(
        onOk: onOk,
        onCancel: () {},
        okText: 'Claim',
        dismissDurationInMilliseconds: Modal.DismissDuration,
        children: <Widget>[
          Image.asset(
            imgSrc,
            width: ScreenUtil().setWidth(218),
            height: ScreenUtil().setWidth(237),
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil().setWidth(30),
              bottom: ScreenUtil().setWidth(38),
            ),
            child: SecondaryText(
              'Recycling price',
            ),
          ),
          GoldText(
            message,
            textSize: 66,
            imgUrl: goldOrCashImageUrl,
          ),
          SizedBox(
            height: ScreenUtil().setWidth(47),
          ),
        ])
      ..show();
  }

  static getWishing(Function onOk, Tree tree) {
    Modal(onOk: onOk, onCancel: () {}, okText: "Claim", children: [
      ModalTitle('Wishing Tree'),
      Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(45)),
        child: TreeWidget(
          tree: tree,
          imgHeight: ScreenUtil().setWidth(218),
          imgWidth: ScreenUtil().setWidth(237),
          labelWidth: ScreenUtil().setWidth(110),
          primary: true,
        ),
      ),
      SecondaryText(
          "The pieces are gathered, wishing tree is successfully redeemed!"),
    ]).show();
  }

  static levelUp(String level, {double getGlod, Function onOk}) {
    BurialReport.report('page_imp', {'page_code': '005'});

    Modal(
        dismissDurationInMilliseconds: Modal.DismissDuration,
        childrenBuilder: (modal) => <Widget>[
              ModalTitle('Level Up $level'),
              SizedBox(height: ScreenUtil().setWidth(38)),
              Image.asset(
                'assets/image/coin_full_bag.png',
                width: ScreenUtil().setWidth(229),
                height: ScreenUtil().setWidth(225),
              ),
              SecondaryText("Level up reward"),
              SizedBox(height: ScreenUtil().setWidth(36)),
              GoldText(
                Util.formatNumber(getGlod),
                iconSize: 72,
                textSize: 66,
              ),
              SizedBox(height: ScreenUtil().setWidth(46)),
              Selector<UserModel, UserInfo>(
                  selector: (context, provider) => provider.userInfo,
                  builder: (_, UserInfo userInfo, __) {
                    return AdButton(
                      ad_code: '203',
                      adUnitIdFlag: 1,
                      btnText: '5x Reward',
                      onCancel: modal.hide,
                      onOk: () {
                        onOk();
                        modal.hide();
                      },
                      tips:
                          "Number of videos reset at 12am&12pm (${userInfo.ad_times} times left)",
                    );
                  })
            ]).show();
  }

  /// toast���窗
  static _showToast(String type, String msg, {int padding = 68}) {
    Widget icon;
    switch (type) {
      case 'loading':
        icon = SpinKitFadingCircle(
          color: Colors.white,
          size: ScreenUtil().setWidth(60),
        );
        break;
      case 'warning':
        icon = Icon(
          Icons.error_outline,
          color: Colors.white,
          size: ScreenUtil().setWidth(60),
        );
        loadingHide();
        break;
      default:
        icon = Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: ScreenUtil().setWidth(60),
        );
    }

    Widget widget = Center(
      child: Container(
        width: ScreenUtil().setWidth(400),
        height: ScreenUtil().setWidth(400),
        padding: EdgeInsets.all(ScreenUtil().setWidth(padding)),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(30))),
          color: Color.fromRGBO(0, 0, 0, 0.6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              msg,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: ScreenUtil().setSp(34),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().setWidth(40)),
              child: icon,
            )
          ],
          mainAxisSize: MainAxisSize.max,
        ),
      ),
    );

    _future = showToastWidget(
      type == 'loading'
          ? Container(
              color: Color.fromRGBO(0, 0, 0, .1),
              child: widget,
            )
          : widget,
      duration: Duration(
        milliseconds: type == 'loading' ? 300000 : 3000,
      ),
      dismissOtherToast: false,
      handleTouch: true,
    );
  }

  ///大转盘抽奖
  static showLuckyWheel(BuildContext context) {
//    Modal(
//        onCancel: () {},
//        horizontalPadding: ScreenUtil().setWidth(70),
//        verticalPadding: ScreenUtil().setWidth(0),
//        closeType: CloseType.CLOSE_TYPE_TOP_RIGHT,
//        childrenBuilder: (modal) => <Widget>[
////              LuckyWheelWidget(modal),
////              LuckyWheelWrapperWidget(),
//            ])
//      ..show();

    Storage.getItem(Consts.SP_KEY_GUIDANCE_WHEEL).then((value) {
      if (value != null) {
        return;
      }
      LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
      luckyGroup.setShowLuckyWheelGuidance = true;
    });

    showDialog(context: context, builder: (_) => LuckyWheelWrapperWidget());
  }

  static messageNotification(Function onOk) {
    BurialReport.report('page_imp', {'page_code': '026'});

    Modal(
        onCancel: () {
          BurialReport.report('reminder', {"type": '2'});
        },
        okText: 'Yes',
        onOk: () {
          BurialReport.report('reminder', {"type": '1'});
          onOk();
        },
        children: [
          ModalTitle('Turn On Reminders'),
          Container(
            height: ScreenUtil().setWidth(31),
          ),
          Image.asset(
            'assets/image/bg_dollar.png',
            width: ScreenUtil().setWidth(330),
            height: ScreenUtil().setWidth(330),
          ),
          Container(
            height: ScreenUtil().setWidth(31),
          ),
          Text(
            'Would you like to be reminded when your“Limted Bouns Tree” earnings arrive？',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: MyTheme.blackColor,
                fontFamily: FontFamily.regular,
                height: 1,
                fontSize: ScreenUtil().setSp(42),
                fontWeight: FontWeight.w400),
          ),
          Container(
            height: ScreenUtil().setWidth(30),
          ),
        ]).show();
  }

  static howGetMoney() {
    BurialReport.report('page_imp', {'page_code': '032'});

    Modal(
        verticalPadding: 0,
        horizontalPadding: 0,
        marginBottom: 0,
        width: 1080,
        decorationColor: Color.fromRGBO(0, 0, 0, 0),
        childrenBuilder: (Modal modal) => <Widget>[
              Container(
                  width: ScreenUtil().setWidth(1080),
                  height: ScreenUtil().setHeight(1920),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(1080),
                          height: ScreenUtil().setWidth(140),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      modal.hide();
                                    },
                                    child: Container(
                                        width: ScreenUtil().setWidth(200),
                                        height: ScreenUtil().setWidth(140),
                                        child: Center(
                                            child: Image.asset(
                                          'assets/image/close.png',
                                          width: ScreenUtil().setWidth(54),
                                          height: ScreenUtil().setWidth(54),
                                        ))))
                              ]),
                        ),
                        Container(
                            height: ScreenUtil().setWidth(2133),
                            width: ScreenUtil().setWidth(1080),
                            // padding: EdgeInsets.only(top: ScreenUtil().setWidth(0)),
                            child: Container(
                              width: ScreenUtil().setWidth(992),
                              height: ScreenUtil().setWidth(2133),
                              child: Image.asset(
                                'assets/image/how_get_money.png',
                                width: ScreenUtil().setWidth(992),
                                height: ScreenUtil().setWidth(2133),
                              ),
                            )),
                      ],
                    ),
                  ))
            ]).show();
  }

  /// 显示限时分红树开始
  static void showLimitedTimeBonusTree(
      TreeGroup treeGroup, UnlockNewTreeLevel value) {
    Modal(
        childrenBuilder: (modal) => <Widget>[
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(45)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/image/countdown_time_limited_bouns_tree.png",
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setWidth(80),
                      ),
                      Text(
                        Util.formatCountDownTimer(
                            Duration(seconds: value?.duration)),
                        style: TextStyle(
                            color: MyTheme.yellowColor,
                            fontFamily: FontFamily.bold,
                            fontSize: ScreenUtil().setSp(60),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
              ModalTitle('Awesome'),
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(45)),
                child: TreeWidget(
                  tree: treeGroup.topLevelTree,
                  imgHeight: ScreenUtil().setWidth(218),
                  imgWidth: ScreenUtil().setWidth(237),
                  labelWidth: ScreenUtil().setWidth(110),
                  primary: true,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(60)),
                child: SecondaryText("Limited time bonus tree"),
              ),
              AdButton(
                useAd: false,
                btnText: 'Claim',
                onCancel: modal.hide,
                onOk: () {
                  modal.hide();
                  treeGroup.addTree(
                      tree: Tree(
                    grade: Tree.MAX_LEVEL,
                    type: TreeType.Type_TimeLimited_Bonus,
                    duration: value?.duration,
                    amount: value?.amount.toDouble(),
                    showCountDown: true,
                    treeId: value.tree_id,
                    timePlantedLimitedBonusTree:
                        DateTime.now().millisecondsSinceEpoch,
                  ));
                },
                interval: Duration(seconds: 0),
                tips:
                    "Continued received ${Util.formatCountDownTimer(Duration(seconds: value?.duration))} minutes ads earnings from Lcuky Fruit",
              )
            ])
      ..show();
  }

  static Future<dynamic> plantTimeLimitTree(
      TreeGroup treeGroup, num treeId) async {
    dynamic plantTimeLimitMap;
    plantTimeLimitMap = await Service()
        .plantTimeLimitTree({'acct_id': treeGroup.acct_id, 'tree_id': treeId});
    // 测试用
    // plantTimeLimitMap = json.decode("""{
    // "code": 0,
    // "msg": "The tree has been planted",
    // "data":{"tree_id": 1,"amount": 0.01,"duration": 300}}
    // """);
    return plantTimeLimitMap;
  }

  /**
   * 显示限时分红树结束
   */
  static limitedTimeBonusTreeEndUp(Tree tree) {
    TreeGroup treeGroup;
    if (tree == null) {
      return;
    }
    Modal(
        dismissDurationInMilliseconds: Modal.DismissDuration,
        onOk: () {
          treeGroup.deleteSpecificTree(tree);
          treeGroup.setCurrentLimitedBonusTree = null;
          Bgm.playMoney();
          // 调用种限时分红树接口
          plantTimeLimitTree(treeGroup, tree.treeId).then((map) {
            print("plantTimeLimitTree: $map");
          });

          treeGroup.checkShowFirstGetMoney();
        },
        okText: "Claim",
        children: [
          ModalTitle('Awesome'),
          Selector<TreeGroup, TreeGroup>(
              builder: (context, value, child) {
                treeGroup = value;
                return Container(
                  margin:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(45)),
                  child: TreeWidget(
                    tree: treeGroup.topLevelTree,
                    imgHeight: ScreenUtil().setWidth(218),
                    imgWidth: ScreenUtil().setWidth(237),
                    labelWidth: ScreenUtil().setWidth(110),
                    primary: true,
                  ),
                );
              },
              selector: (context, provider) => provider),
          SecondaryText(
              "Get \$ ${tree.amount ?? "--"} in ${Duration(seconds: tree?.originalDuration).inSeconds ?? "--"} second(s) through the Limited time bonus tree"),
          Container(
            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(60)),
            child: ModalTitle('\$${tree.amount ?? "--"}',
                color: MyTheme.primaryColor),
          )
        ]).show();
  }

  /// 37级合成38级后,弹出弹框通知用户
  static topLevelMergeEndShowup(TreeGroup treeGroup, String type, String name,
      UnlockNewTreeLevel treeLevel) {
    Modal(
        onOk: () {
          // 种上一颗38级树
          treeGroup.addTree(
              tree: Tree(
                  grade: Tree.MAX_LEVEL,
                  type: type,
                  recycleMoney:
                      treeLevel?.amount > 0 ? treeLevel?.amount : null,
                  treeId: treeLevel?.tree_id));
        },
        okText: "Claim",
        children: [
          ModalTitle('Awesome'),
          Container(
            margin: EdgeInsets.only(
              // top: ScreenUtil().setWidth(45),
              bottom: ScreenUtil().setWidth(25),
            ),
            child: TreeWidget(
              tree: Tree(grade: Tree.MAX_LEVEL, type: type),
              imgHeight: ScreenUtil().setWidth(218),
              imgWidth: ScreenUtil().setWidth(237),
              labelWidth: ScreenUtil().setWidth(110),
              primary: true,
            ),
          ),
          SecondaryText(
            "Get $name",
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            height: ScreenUtil().setWidth(45),
          ),
        ]).show();
  }

  /// 显示合成38级时的抽奖弹窗
  static showTopLevelMergeWindow(
      TreeGroup treeGroup, Tree source, Tree target) {
    TopLevelMergeWidget widget;
    Modal(
        width: 900,
        decorationColor: Color(0xFFD1E7D6),
        horizontalPadding: 40,
        onCancel: () {
          return widget.enableClose();
        },
        closeType: CloseType.CLOSE_TYPE_BOTTOM_CENTER,
        childrenBuilder: (modal) => <Widget>[
              widget = TopLevelMergeWidget(
                  onReceivedResultFun: (type, name, newLevel) {
                Layer.toastSuccess("Get Level 38 Tree");
                print("Get Level 38 Tree: type=$type");
                modal.hide();

                // 这里删除两棵37级的树木
                treeGroup?.deleteSpecificTree(source);
                treeGroup?.deleteSpecificTree(target);
                if (type == TreeType.Type_TimeLimited_Bonus) {
                  // 限������分红树,单���处理
                  showLimitedTimeBonusTree(treeGroup, newLevel);
                  BurialReport.report('currency_incr', {
                    'type': '3',
                    'currency': newLevel?.amount.toString(),
                  });
                } else {
                  if (type == TreeType.Type_Wishing) {
                    BurialReport.report('currency_incr', {
                      'type': '4',
                      'currency': newLevel?.amount.toString(),
                    });
                  }
                  // 许愿树,需要传递回收时的奖励金额, 其他树都是统一弹出弹框
                  topLevelMergeEndShowup(treeGroup, type, name, newLevel);
                }
              }),
            ]).show();
  }

  /// 五洲树合成弹窗
  static showContinentsMergeWindow() {
    Modal(
            onCancel: () {},
            closeType: CloseType.CLOSE_TYPE_BOTTOM_CENTER,
            childrenBuilder: (modal) => <Widget>[
                  ContinentsMergeWidget(onStartMergeFun: () {
                    Layer.toastSuccess("Merge Continents Trees");
                    modal.hide();
                    // 合成全球分红树,弹出弹窗
                    gainGlobleBonusTreeWindow();
                  }),
                ],
            width: 1000,
            verticalPadding: 0,
            horizontalPadding: 0,
            marginBottom: 0,
            decorationColor: Colors.transparent)
        .show();
  }

  //五洲树合成全球分红树后弹框提示
  static gainGlobleBonusTreeWindow() {
    Modal(onOk: () {}, okText: "Claim", children: <Widget>[
      ModalTitle("Bonus Tree"),
      Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
        child: Image.asset(
          'assets/image/globle_bonus_tree_gain.png',
          width: ScreenUtil().setWidth(402),
          height: ScreenUtil().setWidth(356),
        ),
      ),
      Container(height: ScreenUtil().setWidth(25)),
    ]).show();
  }

  /// 啤酒花树合成弹���
  static showHopsMergeWindow(num rewardDollar, Tree source, Tree target) {
    Modal(
            onCancel: () {},
            closeType: CloseType.CLOSE_TYPE_BOTTOM_CENTER,
            childrenBuilder: (modal) => <Widget>[
                  HopsMergeWidget(
                      source: source,
                      target: target,
                      onStartMergeFun: () {
                        Layer.showMoneyRewardAfterHopsMerge(rewardDollar);
                        modal.hide();
                      }),
                ],
            verticalPadding: 0,
            width: 1000,
            horizontalPadding: 0,
            marginBottom: 0,
            decorationColor: Colors.transparent)
        .show();
  }

  /// 随机���现的越级升级弹窗, 出现越级弹窗的几个条件：
  /// 1. 新合���的树的等级要低于当前最高等级两级及以上；
  /// 2. 可购买等级要小于等于接口返回的purchase_tree_level
  /// 3. 每合成 compose_numbers次数后触发��次
  /// 4. 本地请求到广告了
  static showBypassLevelUp(BuildContext context, Function onOk,
      Function onCancel, Tree source, Tree target) async {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    if (source == null ||
        target == null ||
        source == target ||
        source.grade != target.grade ||
        // 1. 新合成��树的等级要低于当前最高等级两级及以上；
        source.grade >= treeGroup.maxLevel() - 3 ||
        // 2. 可购买等级要小于等于接口返回的purchase_tree_level
        treeGroup.minLevel > luckyGroup?.issed?.purchase_tree_level ||
        // 3. 每合成 compose_numbers次数后触发一次
        treeGroup.totalMergeCount % luckyGroup?.issed?.compose_numbers != 0) {
      // 不满足条件，不弹出弹框，走正常流程
      onCancel();
      return;
    }

    /// 4. 本地请求到广告了
//    bool isReady = await MoAd.getInstance(context).isMopubRewardVideoReady();
//    if (!isReady) {
//      // 不满足条件，不弹出弹框，走正常流程
//      onCancel();
//      return;
//    }
    Modal(
        childrenBuilder: (modal) => <Widget>[
              ModalTitle("Free Upgrade"),
              Container(height: ScreenUtil().setWidth(37)),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(children: [
                        TreeWidget(
                          tree: Tree(grade: source.grade + 1),
                          imgHeight: ScreenUtil().setWidth(236),
                          imgWidth: ScreenUtil().setWidth(216),
                          labelWidth: ScreenUtil().setWidth(80),
                          primary: true,
                        ),
                        Container(height: ScreenUtil().setWidth(32)),
                        Text(
                          Tree(grade: source.grade + 1).name,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                              fontFamily: FontFamily.regular,
                              color: MyTheme.blackColor,
                              fontSize: ScreenUtil().setSp(36),
                              fontWeight: FontWeight.w400),
                        ),
                      ]),
                    ),
                    Image.asset(
                      'assets/image/arrow.png',
                      width: ScreenUtil().setWidth(84),
                      height: ScreenUtil().setWidth(56),
                    ),
                    Expanded(
                      child: Column(children: [
                        TreeWidget(
                          tree: Tree(grade: source.grade + 1 + 1),
                          imgHeight: ScreenUtil().setWidth(236),
                          imgWidth: ScreenUtil().setWidth(216),
                          labelWidth: ScreenUtil().setWidth(80),
                          primary: true,
                        ),
                        Container(height: ScreenUtil().setWidth(32)),
                        Text(
                          Tree(grade: source.grade + 1 + 1).name,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: TextStyle(
                              fontFamily: FontFamily.regular,
                              color: MyTheme.blackColor,
                              fontSize: ScreenUtil().setSp(36),
                              fontWeight: FontWeight.w400),
                        ),
                      ]),
                    ),
                  ]),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(38)),
                  child: Selector<UserModel, UserInfo>(
                      selector: (context, provider) => provider.userInfo,
                      builder: (_, UserInfo userInfo, __) {
                        return AdButton(
                          ad_code: '206',
                          adUnitIdFlag: 1,
                          btnText: 'Upgrade',
                          onCancel: () {
                            print("取消了越级升级");
                            modal.hide();
                            onCancel();
                          },
                          onOk: () {
                            print("点击了越级升级");
                            modal.hide();
                            onOk();
                          },
                          tips:
                              "Number of videos reset at 12am&12pm (${userInfo.ad_times} times left)",
                        );
                      }))
            ]).show();
  }

  /// 购买树提示金币不足弹窗
  static showCoinInsufficientWindow(num time, num gold, Function onOk) {
    Modal(
        childrenBuilder: (modal) => <Widget>[
              ModalTitle("Coin Shortage"),
              Container(height: ScreenUtil().setWidth(36)),
              Image.asset(
                'assets/image/coin_full_bag.png',
                width: ScreenUtil().setWidth(229),
                height: ScreenUtil().setWidth(225),
              ),
              Container(height: ScreenUtil().setWidth(18)),
              SecondaryText(
                "${Util.formatNumber(time)} mins reward",
                color: MyTheme.blackColor,
              ),
              Container(height: ScreenUtil().setWidth(36)),
              GoldText(
                Util.formatNumber(gold),
                textSize: 66,
              ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(46)),
                  child: Selector<UserModel, UserInfo>(
                      selector: (context, provider) => provider.userInfo,
                      builder: (_, UserInfo userInfo, __) {
                        return AdButton(
                          btnText: 'Got it',
                          adUnitIdFlag: 2,
                          ad_code: '207',
                          onCancel: () {
                            modal.hide();
                          },
                          onOk: () {
                            modal.hide();
                            onOk();
                          },
                        );
                      })),
            ]).show();
  }

  /// 离线奖励弹窗
  static showOffLineRewardWindow(num glod, Function onOk) {
    Modal(
        childrenBuilder: (modal) => <Widget>[
              ModalTitle("Offline Earnings"),
              Container(height: ScreenUtil().setWidth(29)),
              SecondaryText(
                "You Earned",
                color: MyTheme.blackColor,
              ),
              Container(height: ScreenUtil().setWidth(40)),
              Image.asset(
                'assets/image/coin_full_bag.png',
                width: ScreenUtil().setWidth(229),
                height: ScreenUtil().setWidth(225),
              ),
              Container(height: ScreenUtil().setWidth(20)),
              SecondaryText(
                "+${Util.formatNumber(glod)}",
                fontsize: 66,
                color: MyTheme.blackColor,
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(46)),
                child: Stack(overflow: Overflow.visible, children: [
                  AdButton(
                    ad_code: '208',
                    adUnitIdFlag: 2,
                    btnText: '+${Util.formatNumber(glod * 2)}',
                    onCancel: () {
                      modal.hide();
                      onOk(false);
                    },
                    onOk: () {
                      modal.hide();
                      onOk(true);
                    },
                    // tips:
                    //     "Number of videos reset at 12am&12pm (${userInfo.ad_times} times left)",
                  ),
                  Positioned(
                      top: 0,
                      right: ScreenUtil().setWidth(80),
                      child: Image.asset(
                        'assets/image/value2.png',
                        width: ScreenUtil().setWidth(124),
                        height: ScreenUtil().setWidth(108),
                      ))
                ]),
              ),
            ]).show();
  }

  /// 5倍或10倍宝���弹框
  static show5TimesTreasureWindow(int type, Function _onCancel) {
    Modal(
        childrenBuilder: (modal) => <Widget>[
              TimesRewardWidget(
                typeOfTimes: type,
                onOk: () {
                  modal.hide();
                },
                onCancel: () {
                  modal.hide();
                  _onCancel();
                },
              )
            ]).show();
  }

  /// 大转盘抽���结果弹框
  static showLuckWheelWinResultWindow(int winType, num coinNum) {
    Modal(
        okText: "Claim",
        btnColors: <Color>[
          Color(0xffF1D34E),
          Color(0xffF59A22),
        ],
        onOk: () {
          //将获取的金币增加到账户上
          EVENT_BUS.emit(MoneyGroup.ADD_GOLD, coinNum.toDouble());
        },
        horizontalPadding: 10,
        dismissDurationInMilliseconds: Modal.DismissDuration,
        children: <Widget>[
          LuckyWheelWinResultWindow(
            winType: winType,
            coinNum: coinNum,
          )
        ]).show();
  }

  /// 雌雄啤��花树合成后的现金奖励弹窗
  static showMoneyRewardAfterHopsMerge(num rewardDollar) {
    Modal(
        onOk: () {
          // 本地增加money
          EVENT_BUS.emit(MoneyGroup.ADD_MONEY, rewardDollar?.toDouble());
        },
        okText: "Claim",
        children: <Widget>[
          Image.asset(
            'assets/image/bg_dollar.png',
            width: ScreenUtil().setWidth(278),
            height: ScreenUtil().setWidth(170),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
            child: SecondaryText(
              "You‘ve got",
              fontWeight: FontWeight.w400,
              fontFamily: FontFamily.regular,
            ),
          ),
          GoldText(
            Util.formatNumber(rewardDollar),
            imgUrl: "assets/image/icon_dollar.png",
            iconSize: 72,
            textSize: 66,
            fontFamily: FontFamily.semibold,
            fontWeight: FontWeight.w500,
          ),
          Container(height: ScreenUtil().setWidth(35)),
        ]).show();
  }

  /// 提现时如果没有登录FB,则提示登录
  static void remindFacebookLoginWhenWithDraw(UserModel userModel) {
    BurialReport.report('page_imp', {'page_code': '024'});
    Modal(
        onOk: () {
          userModel.loginWithFB();
        },
        onCancel: () {},
        okText: "Login",
        closeType: CloseType.CLOSE_TYPE_TOP_RIGHT,
        horizontalPadding: 73,
        childrenBuilder: (modal) => <Widget>[
              ModalTitle("Redeem Tips"),
              SizedBox(height: ScreenUtil().setWidth(58)),
              Text(
                  "To ensure your account security and data synchronization across multiple devices, please login with your FB account.",
                  softWrap: true,
                  style: TextStyle(
                      color: Color.fromRGBO(83, 83, 83, 1),
                      fontSize: ScreenUtil().setSp(40),
                      fontFamily: FontFamily.regular,
                      fontWeight: FontWeight.w400)),
              SizedBox(height: ScreenUtil().setWidth(118)),
              Image.asset(
                'assets/image/fb.png',
                width: ScreenUtil().setWidth(140),
                height: ScreenUtil().setWidth(140),
              ),
              SizedBox(height: ScreenUtil().setWidth(80))
            ])
      ..show();
  }

  /// 7天邀请活动
  static void showSevenDaysInviteEventWindow(BuildContext context) {
    if (context == null) {
      return;
    }
    BurialReport.report('page_imp', {'page_code': '035'});

    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    List<dynamic> friends = userModel.value.invite_friend ?? [];
    dynamic inviteFriendsNum = 0;
    if (friends != null && friends.length > 0) {
      inviteFriendsNum = friends[0] ?? 0;
    }

    List rewardedList = [];
    if (friends != null && friends.length > 1) {
      rewardedList = friends[1];
    }

    List<dynamic> timerList = userModel.value.residue_7days_time;
    dynamic timerStr = "-- --";
    if (timerList != null && timerList.length > 1) {
      timerStr = "${timerList[0] ?? 0}d ${timerList[1] ?? 0}h";
    }

    FriendsFestStatusType first = FriendsFestStatusType.Status_Disable;
    FriendsFestStatusType second = FriendsFestStatusType.Status_Disable;
    FriendsFestStatusType third = FriendsFestStatusType.Status_Disable;

    if (rewardedList.contains(1)) {
      first = FriendsFestStatusType.Status_Rewarded;
    } else if (inviteFriendsNum >= 1) {
      first = FriendsFestStatusType.Status_Enable;
    }

    if (rewardedList.contains(3)) {
      second = FriendsFestStatusType.Status_Rewarded;
    } else if (inviteFriendsNum >= 3) {
      second = FriendsFestStatusType.Status_Enable;
    }

    if (rewardedList.contains(5)) {
      third = FriendsFestStatusType.Status_Rewarded;
    } else if (inviteFriendsNum >= 5) {
      third = FriendsFestStatusType.Status_Enable;
    }

    num progrssValue = min(inviteFriendsNum / 5.0, 1.0);
    Modal(
        onCancel: () {},
        width: 900,
        closeType: CloseType.CLOSE_TYPE_TOP_RIGHT,
        verticalPadding: 0,
        horizontalPadding: 0,
        childrenBuilder: (modal) => <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setWidth(174),
                    width: ScreenUtil().setWidth(900),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(100)),
                        topRight: Radius.circular(ScreenUtil().setWidth(100)),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0),
                          colors: <Color>[
                            Color(0xFFf59f26),
                            Color(0xFFf2d54f),
                          ]),
                    ),
                    child: Center(
                      child: ModalTitle(
                        'Friends Fest',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -ScreenUtil().setWidth(360),
                    child: Image.asset(
                      'assets/image/friends_fest_header_cover.png',
                      height: ScreenUtil().setWidth(576),
                      width: ScreenUtil().setWidth(900),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setWidth(80),
              ),
              Text(
                "Get rewarded for EVERY invite accepted!",
                style: TextStyle(
                    color: MyTheme.blackColor,
                    height: 1,
                    fontFamily: FontFamily.bold,
                    fontSize: ScreenUtil().setSp(42),
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                child: Container(
                  width: ScreenUtil().setWidth(280),
                  height: ScreenUtil().setWidth(55),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/image/friends_fest_timer_bg.png',
                      ),
                      Align(
                        alignment: Alignment(0.2, 0.3),
                        child: Text(
                          timerStr,
                          style: TextStyle(
                              color: Colors.white,
                              height: 1,
                              fontFamily: FontFamily.semibold,
                              fontSize: ScreenUtil().setSp(34),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  SizedBox(
                    width: ScreenUtil().setWidth(800),
                    height: ScreenUtil().setWidth(55),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation(Color(0xFFFF961A)),
                        value: progrssValue,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FriendsFestRewardWidget(
                          FriendsFestProgressType.Progress_One, first),
                      FriendsFestRewardWidget(
                          FriendsFestProgressType.Progress_Three, second),
                      FriendsFestRewardWidget(
                          FriendsFestProgressType.Progress_Five, third),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setWidth(75),
              ),
              Container(
                width: ScreenUtil().setWidth(244),
                height: ScreenUtil().setWidth(80),
                decoration: BoxDecoration(
                  color: Color(0xFF3EA1FE),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(40))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset(
                      'assets/image/friends_fest_people_couple.png',
                      width: ScreenUtil().setWidth(68),
                      height: ScreenUtil().setWidth(60),
                    ),
                    Text(
                      "$inviteFriendsNum/5",
                      style: TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontFamily: FontFamily.bold,
                          fontSize: ScreenUtil().setSp(46),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(60),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "More Partner,More Cash",
                      style: TextStyle(
                          color: Color(0xffB4B4B4),
                          height: 1,
                          fontFamily: FontFamily.semibold,
                          fontSize: ScreenUtil().setSp(40),
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: ScreenUtil().setWidth(20),
                    ),
                    GestureDetector(
                      onTap: () {
                        modal.hide();
                        partnerCash(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: ImageIcon(
                          AssetImage("assets/image/friends_fest_help.png"),
                          size: ScreenUtil().setWidth(60),
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(40),
              ),
              GestureDetector(
                onTap: () {
//                  modal.hide();
                  BurialReport.report('invite_entr', {'entr_code': '007'});

                  ShareUtil.share(context);
                },
                child: PrimaryButton(
                    width: 600,
                    height: 124,
                    colors: const <Color>[
                      Color.fromRGBO(49, 200, 84, 1),
                      Color.fromRGBO(36, 185, 71, 1)
                    ],
                    child: Center(
                        child: Text(
                      "Invite",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        height: 1,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(56),
                      ),
                    ))),
              ),
              SizedBox(
                height: ScreenUtil().setWidth(60),
              ),
            ])
      ..show();
  }
}

class GetReward {
  static void showLimitedTimeBonusTree(int duration, Function onOk) {
    Modal(
        onCancel: () {},
        dismissDurationInMilliseconds: Modal.DismissDuration,
        childrenBuilder: (modal) => <Widget>[
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(45)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/image/countdown_time_limited_bouns_tree.png",
                        width: ScreenUtil().setWidth(80),
                        height: ScreenUtil().setWidth(80),
                      ),
                      Text(
                        Util.formatCountDownTimer(Duration(seconds: duration)),
                        style: TextStyle(
                            color: MyTheme.yellowColor,
                            fontFamily: FontFamily.bold,
                            fontSize: ScreenUtil().setSp(60),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
              ModalTitle('Awesome'),
              Container(
                margin:
                    EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(45)),
                child: TreeWidget(
                  // imgSrc: 'assets/image/dividend_tree.png',
                  // label: '38',
                  tree: Tree(
                      grade: Tree.MAX_LEVEL,
                      type: TreeType.Type_TimeLimited_Bonus),
                  imgHeight: ScreenUtil().setWidth(218),
                  imgWidth: ScreenUtil().setWidth(237),
                  labelWidth: ScreenUtil().setWidth(110),
                  primary: true,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(60)),
                child: SecondaryText("Limited time bonus tree"),
              ),
              AdButton(
                useAd: false,
                btnText: 'Claim',
                onOk: () {
                  modal.hide();
                  onOk();
                },
                interval: Duration(seconds: 0),
                tips:
                    "Continued received ${Util.formatCountDownTimer(Duration(seconds: duration))} minutes ads earnings from Lcuky Fruit",
              )
            ])
      ..show();
  }

  static showGoldWindow(num glod, Function onOk) {
    Modal(
        okText: 'Claim',
        onOk: onOk,
        btnColors: [
          Color.fromRGBO(242, 212, 80, 1),
          Color.fromRGBO(245, 154, 34, 1),
        ],
        dismissDurationInMilliseconds: Modal.DismissDuration,
        childrenBuilder: (modal) => <Widget>[
              Container(
                height: ScreenUtil().setWidth(70),
                child: Text(
                  "Awesome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.blackColor,
                      height: 1,
                      fontFamily: FontFamily.bold,
                      fontSize: ScreenUtil().setSp(70),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(height: ScreenUtil().setWidth(20)),
              Image.asset(
                'assets/image/coin_full_bag.png',
                width: ScreenUtil().setWidth(229),
                height: ScreenUtil().setWidth(225),
              ),
              Container(height: ScreenUtil().setWidth(14)),
              Text(
                "You‘ve got",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: MyTheme.blackColor,
                    height: 1,
                    fontFamily: FontFamily.regular,
                    fontSize: ScreenUtil().setSp(50),
                    fontWeight: FontWeight.w400),
              ),
              Container(height: ScreenUtil().setWidth(45)),
              GoldText(Util.formatNumber(glod), textSize: 66),
              Container(height: ScreenUtil().setWidth(45)),
            ]).show();
  }

  static showPhoneWindow(String chips, Function onOk) {
    Modal(
        okText: 'Claim',
        onOk: onOk,
        btnColors: [
          Color.fromRGBO(242, 212, 80, 1),
          Color.fromRGBO(245, 154, 34, 1),
        ],
        childrenBuilder: (modal) => <Widget>[
              Container(
                height: ScreenUtil().setWidth(70),
                child: Text(
                  "Awesome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.blackColor,
                      height: 1,
                      fontFamily: FontFamily.bold,
                      fontSize: ScreenUtil().setSp(70),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(height: ScreenUtil().setWidth(36)),
              Image.asset(
                'assets/image/phone11.png',
                width: ScreenUtil().setWidth(165),
                height: ScreenUtil().setWidth(226),
              ),
              Container(height: ScreenUtil().setWidth(26)),
              Text(
                "You‘ve got $chips phone chips",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: MyTheme.blackColor,
                    height: 1,
                    fontFamily: FontFamily.regular,
                    fontSize: ScreenUtil().setSp(50),
                    fontWeight: FontWeight.w400),
              ),
              Container(height: ScreenUtil().setWidth(45)),
            ]).show();
  }

  static showTreeWindow(String chips, Function onOk) {
    Modal(
        okText: 'Claim',
        onOk: onOk,
        btnColors: [
          Color.fromRGBO(242, 212, 80, 1),
          Color.fromRGBO(245, 154, 34, 1),
        ],
        childrenBuilder: (modal) => <Widget>[
              Container(
                height: ScreenUtil().setWidth(70),
                child: Text(
                  "Awesome",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyTheme.blackColor,
                      height: 1,
                      fontFamily: FontFamily.bold,
                      fontSize: ScreenUtil().setSp(70),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(height: ScreenUtil().setWidth(36)),
              TreeWidget(
                  // imgSrc: 'assets/tree/wishing.png',
                  // label: Tree.MAX_LEVEL.toString(),
                  tree:
                      Tree(grade: Tree.MAX_LEVEL, type: TreeType.Type_Wishing),
                  imgHeight: ScreenUtil().setWidth(236),
                  imgWidth: ScreenUtil().setWidth(216),
                  labelWidth: ScreenUtil().setWidth(80),
                  primary: true),
              Container(height: ScreenUtil().setWidth(36)),
              Text(
                "You‘ve got $chips Wishing Tree chips",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: MyTheme.blackColor,
                    height: 1,
                    fontFamily: FontFamily.regular,
                    fontSize: ScreenUtil().setSp(50),
                    fontWeight: FontWeight.w400),
              ),
              Container(height: ScreenUtil().setWidth(46)),
            ]).show();
  }
}
