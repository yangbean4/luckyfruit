import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:luckyfruit/pages/trip/game/huge_win.dart';
import 'package:luckyfruit/pages/trip/game/times_reward.dart';
import 'package:luckyfruit/pages/trip/top_level_merger.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
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
  static toastSuccess(String msg) => _showToast('success', msg);

  /// 显示警告弹窗
  static toastWarning(String msg) => _showToast('warning', msg);

  /// 显示loading
  static loading(msg) => _showToast('loading', msg);

  /// 隐藏loading
  static loadingHide() => _future?.dismiss();

  // 领取金币
  static receiveLayer(num goldNumber, Function onOk) =>
      Modal(onOk: onOk, okText: '确定', children: <Widget>[
        Image.asset(
          'assets/image/treasure.png',
          width: ScreenUtil().setWidth(316),
          height: ScreenUtil().setWidth(207),
        ),
        Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(43),
            bottom: ScreenUtil().setWidth(28),
          ),
          child: Text(
            '领取成功',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setWidth(60),
                fontWeight: FontWeight.w600),
          ),
        ),
        SecondaryText('恭喜获得', color: MyTheme.secondaryColor),
        GoldText(Util.formatNumber(goldNumber))
      ])
        ..show();
// 新等级弹窗
  static newGrade(Tree tree) => Modal(
      onOk: () {},
      okText: '确定',
      children: <Widget>[
        TreeWidget(
          tree: tree,
          imgHeight: ScreenUtil().setWidth(218),
          imgWidth: ScreenUtil().setWidth(237),
          labelWidth: ScreenUtil().setWidth(110),
          primary: true,
        ),
        Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(31),
            bottom: ScreenUtil().setWidth(54),
          ),
          child: Text(
            tree.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: MyTheme.blackColor,
                fontSize: ScreenUtil().setWidth(60),
                fontWeight: FontWeight.w600),
          ),
        ),
        SecondaryText('升级成功', color: MyTheme.secondaryColor)
      ],
      footer: Container(
        width: ScreenUtil().setWidth(840),
        height: ScreenUtil().setWidth(497),
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setWidth(60),
          horizontal: ScreenUtil().setWidth(50),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(ScreenUtil().setWidth(100)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(740),
              height: ScreenUtil().setWidth(44),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '距离可以获得',
                    style: TextStyle(
                        color: MyTheme.blackColor,
                        fontSize: ScreenUtil().setWidth(38),
                        fontWeight: FontWeight.w600),
                    // 距离可以获得"全球分红树"还差33级
                  ),
                  Text(
                    '"全球分红树"',
                    style: TextStyle(
                        color: MyTheme.secondaryColor,
                        fontSize: ScreenUtil().setWidth(38),
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '还差${Tree.MAX_LEVEL - tree.grade}级',
                    style: TextStyle(
                        color: MyTheme.blackColor,
                        fontSize: ScreenUtil().setWidth(38),
                        fontWeight: FontWeight.w600),
                    // 距离可以获得"全球分红树"还差33级
                  ),
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(740),
              height: ScreenUtil().setWidth(170),
              // margin: EdgeInsets.only(
              //   top: ScreenUtil().setWidth(30),
              //   bottom: ScreenUtil().setWidth(24),
              // ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(270),
                    height: ScreenUtil().setWidth(130),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '1、2只LV37级果树合成',
                          style: TextStyle(
                              color: MyTheme.blackColor,
                              fontSize: ScreenUtil().setWidth(20),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '2、五洲树合成 ',
                          style: TextStyle(
                              color: MyTheme.blackColor,
                              fontSize: ScreenUtil().setWidth(20),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '3、个人努力达到100%获得',
                          style: TextStyle(
                              color: MyTheme.blackColor,
                              fontSize: ScreenUtil().setWidth(20),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/image/arrow.png',
                    width: ScreenUtil().setWidth(57),
                    height: ScreenUtil().setWidth(48),
                  ),
                  Image.asset(
                    'assets/image/topTree.png',
                    width: ScreenUtil().setWidth(148),
                    height: ScreenUtil().setWidth(170),
                  ),
                  Image.asset(
                    'assets/image/arrow.png',
                    width: ScreenUtil().setWidth(57),
                    height: ScreenUtil().setWidth(48),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(190),
                    height: ScreenUtil().setWidth(130),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '\$150.00',
                          style: TextStyle(
                              color: MyTheme.secondaryColor,
                              fontSize: ScreenUtil().setWidth(30),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '昨天收益(美元/只)',
                          style: TextStyle(
                              color: MyTheme.blackColor,
                              fontSize: ScreenUtil().setWidth(22),
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '每天领取分红',
                          style: TextStyle(
                              color: MyTheme.secondaryColor,
                              fontSize: ScreenUtil().setWidth(22),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(740),
              height: ScreenUtil().setWidth(29),
              // margin: EdgeInsets.only(
              //   top: ScreenUtil().setWidth(20),
              //   bottom: ScreenUtil().setWidth(13),
              // ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '当前进度：',
                    style: TextStyle(
                        color: MyTheme.blackColor,
                        fontSize: ScreenUtil().setWidth(24),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '${(tree.grade / Tree.MAX_LEVEL * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                        color: MyTheme.secondaryColor,
                        fontSize: ScreenUtil().setWidth(24),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
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
                        color: MyTheme.secondaryColor,
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(10))),
                      ),
                    ))
              ],
            ),
            Container(
              width: ScreenUtil().setWidth(740),
              height: ScreenUtil().setWidth(24),
              // margin: EdgeInsets.only(
              //   top: ScreenUtil().setWidth(26),
              // ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '进度达到',
                    style: TextStyle(
                        color: MyTheme.blackColor,
                        fontSize: ScreenUtil().setWidth(20),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '100%',
                    style: TextStyle(
                        color: MyTheme.secondaryColor,
                        fontSize: ScreenUtil().setWidth(20),
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '有概率获得1棵"全球分红数"限量10万只，领完为止！',
                    style: TextStyle(
                        color: MyTheme.blackColor,
                        fontSize: ScreenUtil().setWidth(20),
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          ],
        ),
      ))
    ..show();

  static locationFull() {
    Modal(
        autoHide: true,
        onCancel: () {},
        onOk: () {},
        okText: 'Ok',
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().setWidth(70)),
            child: Text(
              'The location is full, please merge the fruit tree or recycle the fruit tree before redeeming id!!',
              style: TextStyle(
                  color: MyTheme.blackColor,
                  fontSize: ScreenUtil().setWidth(46),
                  fontWeight: FontWeight.w500),
            ),
          )
        ]).show();
  }

// 回收弹窗
  static recycleLayer(
          Function onOk, String imgSrc, num recycleMoney, num goldNumber) =>
      Modal(onOk: onOk, onCancel: () {}, okText: '确定回收', children: <Widget>[
        Image.asset(
          imgSrc,
          width: ScreenUtil().setWidth(218),
          height: ScreenUtil().setWidth(237),
        ),
        Container(
          margin: EdgeInsets.only(
            top: ScreenUtil().setWidth(63),
            bottom: ScreenUtil().setWidth(50),
          ),
          child: SecondaryText(recycleMoney != null ? "回收获得" : '回收价格',
              color: MyTheme.secondaryColor),
        ),
        GoldText(recycleMoney != null
            ? '\$ ${Util.formatNumber(recycleMoney)}'
            : Util.formatNumber(goldNumber))
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

  static levelUp({String level, double getGlod, Function onOk}) {
    Modal(
        childrenBuilder: (modal) => <Widget>[
              ModalTitle('Level Up $level'),
              Image.asset(
                'assets/image/coin_full_bag.png',
                width: ScreenUtil().setWidth(227),
                height: ScreenUtil().setWidth(140),
              ),
              SecondaryText("Level up reward"),
              GoldText(
                Util.formatNumber(getGlod),
                iconSize: 72,
                textSize: 66,
              ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
                  child: AdButton(
                    btnText: '5x Reward',
                    onCancel: modal.hide,
                    onOk: () {
                      onOk();
                      modal.hide();
                    },
                  ))
            ]).show();
  }

  /// toast弹窗
  static _showToast(String type, String msg) {
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
        padding: EdgeInsets.all(ScreenUtil().setWidth(68)),
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
          mainAxisSize: MainAxisSize.min,
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
    var luckyWheelObj = new LuckyWheelWidget();

    Modal(
        onCancel: () {},
        horizontalPadding: ScreenUtil().setWidth(70),
        verticalPadding: ScreenUtil().setWidth(0),
        childrenBuilder: (modal) => <Widget>[
              luckyWheelObj,
            ])
      ..show();
  }

  /**
   * 显示限时分红树开始
   */
  static limitedTimeBonusTreeShowUp(TreeGroup treeGroup) {
    //TODO 从接口中接受该值，作为下一次合成时的条件
    bool shouldAppearTimeLimitedBonusTree = true;

    if (!shouldAppearTimeLimitedBonusTree) {
      return;
    }

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
                        "04:40",
                        style: TextStyle(
                            color: MyTheme.yellowColor,
                            fontFamily: FontFamily.bold,
                            fontSize: ScreenUtil().setWidth(60),
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
                child: SecondaryText("Limited time bouns tree"),
              ),
              AdButton(
                useAd: false,
                btnText: 'Claim',
                onCancel: modal.hide,
                onOk: () {
                  modal.hide();
                  // 调用种限时分红树接口
                  plantTimeLimitTree(treeGroup).then((code) {
                    if (code == 0) {
                      treeGroup.addTree(
                          tree: Tree(grade: 5, showCountDown: true));
                    }
                  });
                },
                interval: Duration(seconds: 0),
                tips:
                    "get 5 minutes  advertising revenue from the advertising platform",
              )
            ])
      ..show();
  }

  static Future<int> plantTimeLimitTree(TreeGroup treeGroup) async {
    dynamic plantTimeLimitMap;
    // plantTimeLimitMap = await Service()
    //     .plantTimeLimitTree({'acct_id': treeGroup.acct_id, 'tree_id': 100});
    //TODO 测试用
    plantTimeLimitMap = json.decode("""{
        "code":0,
        "msg":"success"
    }""");
    print("plantTimeLimitTree= $plantTimeLimitMap");
    int code = plantTimeLimitMap['code'] as num;
    String msg = plantTimeLimitMap['msg'] as String;
    print("plantTimeLimitTree返回的code=$code，msg=$msg");
    if (code == 1) {
      // 请求失败，
      toastWarning("plant failed causing netwoek issue...");
    }
    return code;
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
              "Get \$ 0.51 in 5mins through the Limited time bouns tree"),
          Container(
            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(60)),
            child: ModalTitle('\$0.51', color: MyTheme.primaryColor),
          )
        ]).show();
  }

  /// 显示合成38级时的抽奖弹窗
  static showTopLevelMergeWindow() {
    Modal(
        onCancel: () {},
        horizontalPadding: ScreenUtil().setWidth(70),
        childrenBuilder: (modal) => <Widget>[
              TopLevelMergeWidget(onReceivedResultFun: () {
                // TODO 测试
                // Layer.showHopsMergeWindow();
                // Layer.showContinentsMergeWindow();
                Layer.toastSuccess("抽到38级的树");
                modal.hide();
                // TODO 种上一颗38级树
              }),
            ]).show();
  }

  /// 五洲树合成弹窗
  static showContinentsMergeWindow() {
    Modal(
            onCancel: () {},
            childrenBuilder: (modal) => <Widget>[
                  ContinentsMergeWidget(onStartMergeFun: () {
                    Layer.toastSuccess("合成五洲树");
                    modal.hide();
                  }),
                ],
            width: 1000,
            verticalPadding: 0,
            horizontalPadding: 0,
            decorationColor: Colors.transparent)
        .show();
  }

  /// 啤酒花树合成弹窗
  static showHopsMergeWindow() {
    Modal(
            onCancel: () {},
            childrenBuilder: (modal) => <Widget>[
                  HopsMergeWidget(onStartMergeFun: () {
                    Layer.toastSuccess("合成啤酒花树");
                    modal.hide();
                  }),
                ],
            verticalPadding: 0,
            width: 1000,
            horizontalPadding: 0,
            decorationColor: Colors.transparent)
        .show();
  }

  /// 随机出现的越级升级弹窗, 出现越级弹窗的几个条件：
  /// 1. 新合成的树的等级要低于当前最高等级两级及以上；
  /// 2. 可购买等级要小于等于接口返回的purchase_tree_level
  /// 3. 每合成 compose_numbers次数后触发一次
  /// 4. 本地请求到广告了 // TODO
  static showBypassLevelUp(BuildContext context, Function onOk,
      Function onCancel, Tree source, Tree target) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    TreeGroup treeGroup = Provider.of<TreeGroup>(context, listen: false);

    if (source == null ||
        target == null ||
        source == target ||
        source.grade != target.grade ||
        // 1. 新合成的树的等级要低于当前最高等级两级及以上；
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
                      FourthText(
                        "Pomegranate tree",
                        fontsize: 30,
                        color: Color.fromARGB(38, 38, 38, 1),
                      ),
                    ]),
                    Image.asset(
                      'assets/image/arrow.png',
                      width: ScreenUtil().setWidth(76),
                      height: ScreenUtil().setWidth(48),
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
                        fontsize: 30,
                        color: Color.fromARGB(38, 38, 38, 1),
                      ),
                    ]),
                  ]),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
                  child: AdButton(
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
                  ))
            ]).show();
  }

  /// 购买树提示金币不足弹窗
  static showCoinInsufficientWindow() {
    Modal(
        childrenBuilder: (modal) => <Widget>[
              ModalTitle("Coin Shortage"),
              Container(height: ScreenUtil().setWidth(4)),
              Image.asset(
                'assets/image/coin_full_bag.png',
                width: ScreenUtil().setWidth(316),
                height: ScreenUtil().setWidth(208),
              ),
              Container(height: ScreenUtil().setWidth(30)),
              SecondaryText(
                "45 mins reward",
                color: MyTheme.blackColor,
              ),
              Container(height: ScreenUtil().setWidth(40)),
              GoldText(
                "1078.98t",
                textSize: 66,
              ),
              Padding(
                  padding: EdgeInsets.only(top: ScreenUtil().setWidth(60)),
                  child: AdButton(
                    btnText: 'Get it',
                    onCancel: () {
                      modal.hide();
                    },
                    onOk: () {
                      modal.hide();
                    },
                  )),
            ]).show();
  }

  /// 离线奖励弹窗
  static showOffLineRewardWindow() {
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
                width: ScreenUtil().setWidth(272),
                height: ScreenUtil().setWidth(140),
              ),
              Container(height: ScreenUtil().setWidth(45)),
              SecondaryText(
                "+1078.98t",
                fontsize: 66,
                color: MyTheme.blackColor,
              ),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setWidth(50)),
                child: Stack(overflow: Overflow.visible, children: [
                  AdButton(
                    btnText: '+2157.96t',
                    onCancel: () {
                      modal.hide();
                    },
                    onOk: () {
                      modal.hide();
                    },
                  ),
                  Positioned(
                      top: -10,
                      right: -8,
                      child: Image.asset(
                        'assets/image/twice_value_reward_icon.png',
                        width: ScreenUtil().setWidth(90),
                        height: ScreenUtil().setWidth(90),
                      ))
                ]),
              ),
            ]).show();
  }

  /// 5倍或10倍宝箱弹框
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

  /// 大转盘抽奖结果弹框
  static showLuckWheelWinResultWindow(int winType) {
    Modal(
        onCancel: () {},
        okText: "Claim",
        children: <Widget>[LuckyWheelWinResultWindow(winType: winType)]).show();
  }
}
