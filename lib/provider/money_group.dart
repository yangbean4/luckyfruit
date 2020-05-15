import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart' show UserInfo;
import 'package:luckyfruit/models/invite_award.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/pages/trip/trip_btns/free_phone.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/bgm.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/event_bus.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/widgets/layer.dart';

import './tree_group.dart';
import './user_model.dart';

class MoneyGroup with ChangeNotifier {
  UserModel _userModel;
  LuckyGroup _luckyGroup;

  // 对TreeGroup Provider引用
  TreeGroup treeGroup;

  MoneyGroup();

  // 存储数据用句柄
  static const String CACHE_KEY = 'MoneyGroup';

  // 设置金币倍数
  static const String SET_INCREASE = 'SET_INCREASE';

// 用于增加/减少 金币金钱的事件句柄
  static const String ADD_GOLD = 'ADD_GOLD';
  static const String ACC_GOLD = 'ACC_GOLD';
  static const String TREE_ADD_GOLD = 'TREE_ADD_GOLD';
  static const String ADD_MONEY = 'ADD_MONEY';
  static const String ACC_MONEY = 'ACC_MONEY';

  // 升级时减少总金币
  static const String ACC_ALL_GOLD = 'ACC_ALL_GOLD';

  // 触发等级检查
  static const String ADD_ALL_GOLD = 'ADD_ALL_GOLD';

  // 该模块下的初始化数据加载完成
  bool _dataLoad = false;

  bool get dataLoad => _dataLoad;

  bool _showGoldAnimation = false;

  bool get showGoldAnimation => _showGoldAnimation;

  UserInfo _userInfo;

// 保存 接口获取的用户信息
  UserInfo get userInfo => _userInfo;

  String acct_id;

  bool _isHome = false;

  /// 是否有限时分红树活跃中，在重启App时，有限时分红树的时候读取本地缓存，没有的时候读取接口数据
  num LBTreeActive = 0;

// 定时器引用
  Timer _timer;

// 金币
  double _gold = 400;

  double get gold => _gold;

  // 总金币;用于升级使用
  double _allgold = 0;

  double get allgold => _gold;

// 金钱
  double _money = 0;

  double get money => _money;

  // 更新时间
  DateTime _upDateTime;

  DateTime get upDateTime => _upDateTime;

  UserModel get userModel => _userModel;

  // double _makeGoldSped;

  // 多倍金币时的产生金币的 倍数
  int _makeGoldIncrease = 1;

  int get makeGoldIncrease => _makeGoldIncrease;

  double get makeGoldSped => treeGroup?.makeGoldSped;

  static BuildContext context;

  // 离线收益计算
  addUnLineGet(DateTime upDateTime, num sped) {
    if (upDateTime != null && sped != null && _isHome) {
      num diffTime = DateTime.now().difference(upDateTime).inSeconds;
      // 小于10分钟没有奖励
      if (diffTime > App.NO_UN_LINE_TIME) {
        diffTime = diffTime > App.UN_LINE_TIME ? App.UN_LINE_TIME : diffTime;
        Layer.showOffLineRewardWindow(sped * diffTime, (bool isDouble) {
          addGold(sped * diffTime * (isDouble ? 2 : 1));

          List<dynamic> timerList = userModel.value.residue_7days_time;
          bool timeReached =
              timerList != null && timerList.isNotEmpty ? false : true;

          timeReached = true;
          // 关闭后出现分享活动弹框或者Cash Gift Packs
          if (!timeReached) {
            Layer.showSevenDaysInviteEventWindow(context);
          } else {
            Layer.partnerCash(context, onOK: () {
              if (_luckyGroup.issed.merge_number == 0) {
                FreePhone().showModal();
              }
            });
          }
        });
      }
      // 加过就卸载避免多次添加
      EVENT_BUS.off(TreeGroup.LOAD);
      EVENT_BUS.off(Event_Name.JUMP_TO_HOME);
    }
  }

  bool isDirty(group) =>
      group.isEmpty || group['upDateTime'] == null || group['upDateTime'] == '';

  Map<String, dynamic> getUseGroup(String str1, Map<String, dynamic> group2) {
    Map<String, dynamic> group1 = Util.decodeStr(str1);
    Map<String, dynamic> group = {};
    if (isDirty(group1) || isDirty(group2)) {
      group = isDirty(group1) ? group2 : group1;
    } else {
      DateTime upDateTime1 = DateTime.fromMicrosecondsSinceEpoch(
          int.tryParse(group1['upDateTime']) * 1000);
      DateTime upDateTime2 = DateTime.fromMicrosecondsSinceEpoch(
          int.tryParse(group2['upDateTime']) * 1000);
      // 如果远端的更新时间在本地时间之前（即有可能是保存是接口没有上报成功），则使用本地的，否则使用哪一个都一样
      group = upDateTime1.isAfter(upDateTime2) ? group1 : group2;
      // 如果存在活跃的限时分红树，则使用本地缓存的数据取money
      if (group1['LBTreeActive'] == '1') {
        group = group1;
      }
    }
    return group;
  }

  void setTreeGroup(Map<String, dynamic> group) {
    if (group != null && group.isNotEmpty) {
      String t = group['upDateTime'];
      _gold = group['_gold'] != null && group['_gold'] != ''
          ? double.tryParse(group['_gold'].toString())
          : _gold;
      _allgold = group['_allgold'] != null
          ? double.tryParse(group['_allgold'].toString())
          : 0.0;
      _money = group['_money'] != null
          ? double.tryParse((group['_money']).toString())
          : 0.0;
      DateTime upDateTime = t == null || t == ''
          ? null
          : DateTime.fromMicrosecondsSinceEpoch(int.tryParse(t) * 1000);

      if (upDateTime != null) {
        // 如果此时没有makeGoldSped的值的话就等通知
        addUnLineGet(upDateTime, treeGroup.makeGoldSped);
        EVENT_BUS.on(TreeGroup.LOAD,
            (_) => addUnLineGet(upDateTime, treeGroup.makeGoldSped));
        EVENT_BUS.on(Event_Name.JUMP_TO_HOME, (_) {
          _isHome = true;
          addUnLineGet(upDateTime, treeGroup.makeGoldSped);
        });
      }
      notifyListeners();
    }
  }

  //初始化 form请求&Storage
  Future<MoneyGroup> init(
      TreeGroup _treeGroup, UserModel userModel, LuckyGroup luckyGroup) async {
    num startCoin = luckyGroup.issed.first_reward_coin;
    _luckyGroup = luckyGroup;
    _gold = startCoin.toDouble();
    acct_id = userModel.value.acct_id;
    treeGroup = _treeGroup;
    _userModel = userModel;
    String res = await Storage.getItem(MoneyGroup.CACHE_KEY);
    Map<String, dynamic> ajaxData =
        await Service().getUserInfo({'acct_id': acct_id});
    // 保存数据
    _userInfo = UserInfo.fromJson(ajaxData);
    setTreeGroup(getUseGroup(res, {
      'upDateTime': ajaxData['last_leave_time'],
      '_gold': ajaxData['coin'],
      '_allgold': ajaxData['_allgold'],
      '_money': ajaxData['acct_bal'],
    }));

    EVENT_BUS.on(MoneyGroup.ADD_GOLD, (gold) => addGold(gold));
    EVENT_BUS.on(MoneyGroup.ACC_GOLD, (gold) => accGold(gold));
    EVENT_BUS.on(MoneyGroup.ADD_MONEY, (gold) => addMoney(gold));
    EVENT_BUS.on(MoneyGroup.ACC_MONEY, (gold) => accMoney(gold));
    // 升级时使用
    EVENT_BUS.on(MoneyGroup.ACC_ALL_GOLD, (gold) => accAllGold(gold));

    // 设置金币产生倍数
    EVENT_BUS.on(MoneyGroup.SET_INCREASE, (increase) {
      _makeGoldIncrease = increase;
    });
    // 退出时保存数据 并取消记时器
    EVENT_BUS.on(Event_Name.APP_PAUSED, (_) {
      save(now: true);
      _timer?.cancel();
    });
    const period = const Duration(seconds: App.SAVE_INTERVAL);
    Timer.periodic(period, (timer) {
      _timer = _timer;
      save(now: true);
    });

    // EVENT_BUS.on(MoneyGroup.TREE_ADD_GOLD, (makeGoldSped) {
    //   addGold(makeGoldSped * makeGoldIncrease * App.SAVE_INTERVAL,
    //       showAnimate: false);
    // });

    save();
    _dataLoad = true;
    return this;
  }

  treeAddGold(makeGoldAmout) {
    // 每8秒本地更新一次金币数量
    addGold(makeGoldAmout * makeGoldIncrease, showAnimate: false);
  }

  timeLimitedTreeAddMoney(double amout) {
    // 限时分红树，每8秒本地更新一次余额
    addMoney(amout, playAudio: false, playAnimation: false);
  }

  // 用户签到
  beginSign(String reward_id, String number) async {
    Map<String, dynamic> res = await Service().beginSign(
        {'acct_id': acct_id, "reward_id": reward_id, "count": number});
    await updateUserInfo();
    if (res == null) {
      GetReward.showPhoneWindow(number, () {});
    } else {
      Invite_award invite_award = Invite_award.fromJson(res);
      GetReward.showLimitedTimeBonusTree(invite_award.duration, () {
        treeGroup.addTree(
            tree: Tree(
          grade: Tree.MAX_LEVEL,
          type: TreeType.Type_TimeLimited_Bonus,
          duration: invite_award.duration,
          amount: invite_award.amount.toDouble(),
          showCountDown: true,
          treeId: invite_award.tree_id,
          timePlantedLimitedBonusTree: DateTime.now().millisecondsSinceEpoch,
        ));
      });
    }
  }

// 更新userInfo
  updateUserInfo() async {
    _userInfo = await _userModel.getUserInfo();
    notifyListeners();
  }

  // 将对象转为json
  Map<String, dynamic> toJson() => {
        'upDateTime': _upDateTime.millisecondsSinceEpoch.toString(),
        '_gold': _gold,
        '_money': _money,
        '_allgold': _allgold,
        'LBTreeActive': LBTreeActive.toString()
      };

  save({bool now = false}) {
    notifyListeners();
    if (now) {
      _saveThis();
    } else {}
  }

  _saveThis() async {
    _upDateTime = DateTime.now();
    String data = jsonEncode(this);
    print("_saveThis: data= $data");
    bool saveSuccess = await Storage.setItem(MoneyGroup.CACHE_KEY, data);

    await Service().updateUserInfo({
      'acct_id': acct_id,
      'coin': _gold,
      'last_leave_time': _upDateTime.millisecondsSinceEpoch.toString(),
      '_allgold': _allgold,
      'paypal_account': _userInfo?.paypal_account,
      'makeGoldSped': treeGroup?.makeGoldSped,
      'hasMaxLevel': treeGroup?.hasMaxLevel,
    });

    // 通知等级检查
    print("addGold: gold=$gold, _gold=$_gold, _allgold=$_allgold");

    return saveSuccess;
  }

  addTimeMakeGlod(inSeconds) {
    addGold(inSeconds * treeGroup.makeGoldSped);
  }

// 升级是清除金币
  accAllGold(g) {
    _allgold = 0;
    save();
  }

  addGold(double gold, {bool showAnimate = true}) {
    // gold = gold * 10000;
    _gold = double.parse((_gold + gold).toStringAsFixed(2));
    _allgold = double.parse((_allgold + gold).toStringAsFixed(2));
    if (showAnimate) {
      _showGoldAnimation = true;
      Bgm.playClaimGold();
      notifyListeners();
    }
    EVENT_BUS.emit(MoneyGroup.ADD_ALL_GOLD, _allgold);

    // Bgm.coinIncrease();
    save();
  }

  bool checkAddTree(double usegold) {
    bool canGo = usegold < _gold;
    if (canGo) {
      _gold -= usegold;
      save();
    }
    return canGo;
  }

  accGold(double gold) {
    _gold -= gold;
    save();
  }

  accMoney(double money) {
    _money -= money;
    save();
  }

  addMoney(double money, {bool playAudio = true, bool playAnimation = true}) {
    if (playAudio) {
      Bgm.playMoney();
    }
    _money += money;
    // 展示美元动画
    if (playAnimation) {
      _showDollarImgTrans = true;
    }
    BurialReport.report('m_currency_change',
        {'m_currency_number': _money.toString(), 'type': '1'});
    save();
  }

  hideGoldAnimation() {
    _showGoldAnimation = false;
    notifyListeners();
  }

  /// 是否显示美元数目文案淡出效果
  bool _showDollarAmountFading = false;

  bool get showDollarAmountFading => _showDollarAmountFading;

  set setShowDollarAmountFading(bool show) {
    _showDollarAmountFading = show;
    notifyListeners();
  }

  /// 是否显示美元图片移动效果
  bool _showDollarImgTrans = false;

  bool get showDollarImgTrans => _showDollarImgTrans;

  set setShowDollarImgTrans(bool show) {
    _showDollarImgTrans = show;
    notifyListeners();
  }
}
