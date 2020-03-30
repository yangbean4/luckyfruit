import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/pages/trip/game/huge_win.dart';
import 'package:luckyfruit/pages/trip/game/times_reward.dart';
import 'package:luckyfruit/pages/trip/top_level_merger.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/user_model.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:oktoast/oktoast.dart';

import 'package:luckyfruit/theme/index.dart';
import 'package:provider/provider.dart';
import './modal.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import './ad_btn.dart';
import 'package:luckyfruit/pages/trip/game/lucky_wheel.dart';
import 'package:luckyfruit/pages/trip/game/continents_merge_widget.dart';
import 'package:luckyfruit/pages/trip/game/hops_merge_widget.dart';
import 'package:luckyfruit/utils/index.dart';

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

// 新等级弹窗
  static newGrade(Tree tree, {num amount}) => Modal(
      onOk: () {},
      okText: 'Claim',
      children: <Widget>[
        ModalTitle('${tree.name} Tree'),
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
      footer: Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                        Radius.circular(ScreenUtil().setWidth(10))),
                  ),
                ),
                Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: ScreenUtil()
                          .setWidth((tree.grade / Tree.MAX_LEVEL) * 740),
                      height: ScreenUtil().setWidth(20),
                      decoration: BoxDecoration(
                        color: MyTheme.primaryColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(10))),
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
      )).show();

  static locationFull() {
    Modal(
        autoHide: true,
        onCancel: () {},
        onOk: () {},
        horizontalPadding: 100,
        okText: 'Ok',
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(70)),
            child: Text(
              'The location is full, please merge the fruit tree or recycle the fruit tree before redeeming id!!',
              style: TextStyle(
                  color: MyTheme.blackColor,
                  fontSize: ScreenUtil().setSp(46),
                  fontWeight: FontWeight.w500),
            ),
          )
        ]).show();
  }

// 回收弹窗
  static recycleLayer(
          Function onOk, String imgSrc, num recycleMoney, num goldNumber) =>
      Modal(onOk: onOk, onCancel: () {}, okText: 'Claim', children: <Widget>[
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
            recycleMoney != null
                ? '\$ ${Util.formatNumber(recycleMoney)}'
                : Util.formatNumber(goldNumber),
            textSize: 66),
        SizedBox(
          height: ScreenUtil().setWidth(47),
        ),
      ])
        ..show();

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

  static levelUp(String s, {String level, double getGlod, Function onOk}) {
    Modal(
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
                      btnText: '5x Reward',
                      onCancel: modal.hide,
                      onOk: () {
                        onOk();
                        modal.hide();
                      },
                      tips:
                          "Number of videos reset at 12:00 am&pm (${userInfo.ad_times} times left)",
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
  static showLuckyWheel() {
    Modal(
        onCancel: () {},
        horizontalPadding: ScreenUtil().setWidth(70),
        verticalPadding: ScreenUtil().setWidth(0),
        closeType: CloseType.CLOSE_TYPE_TOP_RIGHT,
        childrenBuilder: (modal) => <Widget>[
              LuckyWheelWidget(modal),
            ])
      ..show();
  }

  /// 显示限时分红树开始
  static void showLimitedTimeBonusTree(
      TreeGroup treeGroup, UnlockNewTreeLevel value) {
    Modal(
        onCancel: () {},
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
              ModalTitle('Congratulations'),
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
                  // 调用种限时分红树接口
                  plantTimeLimitTree(treeGroup, value).then((map) {
                    if (map == null || map['data'] == null) {
                      // 请求失败，
                      toastWarning("Failed, Try Again Later");
                      return;
                    }

                    treeGroup.addTree(
                        tree: Tree(
                      grade: Tree.MAX_LEVEL,
                      type: TreeType.Type_BONUS,
                      duration: value?.duration,
                      amount: value?.amount,
                      showCountDown: true,
                    ));
                  });
                },
                interval: Duration(seconds: 0),
                tips:
                    "Continued received ${Util.formatCountDownTimer(Duration(seconds: value?.duration))} minutes ads earnings from Lcuky Fruit",
              )
            ])
      ..show();
  }

  static Future<dynamic> plantTimeLimitTree(
      TreeGroup treeGroup, UnlockNewTreeLevel value) async {
    dynamic plantTimeLimitMap;
    plantTimeLimitMap = await Service().plantTimeLimitTree(
        {'acct_id': treeGroup.acct_id, 'tree_id': value?.tree_id});
    //TODO 测试用
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
  static limitedTimeBonusTreeEndUp(BuildContext context, Tree tree) {
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);
    Modal(
        onOk: () {
          treeGroup.deleteTreeAfterTimeLimitedTreeFinished(tree);
        },
        onCancel: () {
          treeGroup.deleteTreeAfterTimeLimitedTreeFinished(tree);
        },
        okText: "Claim",
        children: [
          ModalTitle('Congratulations'),
          Container(
            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(45)),
            child: TreeWidget(
              tree: treeGroup.topLevelTree,
              imgHeight: ScreenUtil().setWidth(218),
              imgWidth: ScreenUtil().setWidth(237),
              labelWidth: ScreenUtil().setWidth(110),
              primary: true,
            ),
          ),
          SecondaryText(
              "Get \$ ${tree.amount} in 5mins through the Limited time bonus tree"),
          Container(
            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(60)),
            child: ModalTitle('\$${tree.amount}', color: MyTheme.primaryColor),
          )
        ]).show();
  }

  /// 显示合成38级时的抽奖弹窗
  static showTopLevelMergeWindow(TreeGroup treeGroup) {
    Modal(
        width: 940,
        horizontalPadding: ScreenUtil().setWidth(70),
        childrenBuilder: (modal) => <Widget>[
              TopLevelMergeWidget(onReceivedResultFun: () {
                Layer.toastSuccess("Get Level 38 Tree");
                modal.hide();
                // TODO 种上一颗38级树
                treeGroup.addTree(
                    tree: Tree(
                  grade: Tree.MAX_LEVEL,
                ));
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
                  }),
                ],
            width: 1000,
            verticalPadding: 0,
            horizontalPadding: 0,
            marginBottom: 0,
            decorationColor: Colors.transparent)
        .show();
  }

  /// 啤酒花树合成弹���
  static showHopsMergeWindow() {
    Modal(
            onCancel: () {},
            closeType: CloseType.CLOSE_TYPE_BOTTOM_CENTER,
            childrenBuilder: (modal) => <Widget>[
                  HopsMergeWidget(onStartMergeFun: () {
                    Layer.showMoneyRewardAfterHopsMerge();
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

  /// 随机出现的越级升级弹窗, 出现越级弹窗的几个条件：
  /// 1. 新合���的树的等级要低于当前最高等级两级及以上；
  /// 2. 可购买等级要小于等于接口返回的purchase_tree_level
  /// 3. 每合成 compose_numbers次数后触发��次
  /// 4. 本地请求到广告了 // TODO
  static showBypassLevelUp(BuildContext context, Function onOk,
      Function onCancel, Tree source, Tree target) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    if (source == null ||
        target == null ||
        source == target ||
        source.grade != target.grade ||
        // 1. 新合成��树的等级要低于当前最高等级两级及以上；
        source.grade >= treeGroup.maxLevel - 2 ||
        // 2. 可购买等级要小于等于接口返回的purchase_tree_level
        treeGroup.minLevel > luckyGroup?.issed?.purchase_tree_level ||
        // 3. 每合成 compose_numbers次数后触发一次
        treeGroup.totalMergeCount % luckyGroup?.issed?.compose_numbers != 0) {
      // 不满足条件，不弹出弹框，走正常流程
      onCancel();
      return;
    }
    Modal(
        childrenBuilder: (modal) => <Widget>[
              ModalTitle("Free Upgrade"),
              Container(height: ScreenUtil().setWidth(37)),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(children: [
                      TreeWidget(
                        tree: Tree(grade: source.grade + 1),
                        imgHeight: ScreenUtil().setWidth(236),
                        imgWidth: ScreenUtil().setWidth(216),
                        labelWidth: ScreenUtil().setWidth(80),
                        primary: true,
                      ),
                      Container(height: ScreenUtil().setWidth(32)),
                      //TODO 替换树名称和图片
                      FourthText(
                        "Pomegranate tree",
                        fontsize: 36,
                        fontFamily: FontFamily.regular,
                        fontWeight: FontWeight.w400,
                        color: MyTheme.blackColor,
                      ),
                    ]),
                    Image.asset(
                      'assets/image/arrow.png',
                      width: ScreenUtil().setWidth(84),
                      height: ScreenUtil().setWidth(56),
                    ),
                    Column(children: [
                      TreeWidget(
                        // TODO 添加控制条件
                        tree: Tree(grade: source.grade + 1 + 1),
                        imgHeight: ScreenUtil().setWidth(236),
                        imgWidth: ScreenUtil().setWidth(216),
                        labelWidth: ScreenUtil().setWidth(80),
                        primary: true,
                      ),
                      Container(height: ScreenUtil().setWidth(32)),
                      FourthText(
                        "Litchi tree",
                        fontsize: 36,
                        fontFamily: FontFamily.regular,
                        fontWeight: FontWeight.w400,
                        color: MyTheme.blackColor,
                      ),
                    ]),
                  ]),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(38)),
                  child: Selector<UserModel, UserInfo>(
                      selector: (context, provider) => provider.userInfo,
                      builder: (_, UserInfo userInfo, __) {
                        return AdButton(
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
                              "Number of videos reset at 12:00 am&pm (${userInfo.ad_times} times left)",
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
                    btnText: '+${Util.formatNumber(glod * 2)}',
                    onCancel: () {
                      modal.hide();
                      onOk(true);
                    },
                    onOk: () {
                      modal.hide();
                      onOk(false);
                    },
                    // tips:
                    //     "Number of videos reset at 12:00 am&pm (${userInfo.ad_times} times left)",
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
  static show5TimesTreasureWindow(int type) {
    Modal(
        childrenBuilder: (modal) => <Widget>[
              TimesRewardWidget(
                typeOfTimes: type,
                onOk: () {
                  modal.hide();
                },
                onCancel: () {
                  modal.hide();
                },
              )
            ]).show();
  }

  /// 大转盘抽���结果弹框
  static showLuckWheelWinResultWindow(int winType, num coinNum) {
    Modal(okText: "Claim", horizontalPadding: 10, children: <Widget>[
      LuckyWheelWinResultWindow(
        winType: winType,
        coinNum: coinNum,
      )
    ]).show();
  }

  /// 雌雄啤��花树合成后的现金奖励弹窗
  static showMoneyRewardAfterHopsMerge() {
    Modal(onOk: () {}, okText: "Claim", children: <Widget>[
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
        "7.00",
        imgUrl: "assets/image/icon_dollar.png",
        iconSize: 72,
        textSize: 66,
        fontFamily: FontFamily.semibold,
        fontWeight: FontWeight.w500,
      ),
      Container(height: ScreenUtil().setWidth(35)),
    ]).show();
  }
}
