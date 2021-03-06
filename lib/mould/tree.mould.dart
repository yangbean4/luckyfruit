import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/models/index.dart' show TreeConfig;

class TreePoint {
  // 水平位置
  int x;

  // 垂直位置
  int y;

  TreePoint({
    this.x,
    this.y,
  });
}

class FlowerPoint extends TreePoint {
  int count;
  bool showGridAnimate = true;
  bool showGridReverse = false;
  bool showFlyAnimate = false;
  bool showFlowerAnimate = false;

  FlowerPoint(x, y, {this.count}) : super(x: x, y: y);
}

class Tree extends TreePoint {
  static const int MAX_LEVEL = 38;
  static TreeConfig treeConfig;

  static init(TreeConfig _treeConfig) {
    treeConfig = _treeConfig;
  }

  Tree(
      {this.grade,
      this.gradeNumber = 0,
      int x,
      int y,
      this.type,
      this.recycleMoney,
      this.treeId,
      this.amount,
      this.timePlantedLimitedBonusTree,
      this.duration = 200,
      this.showCountDown = false})
      // 要求传 amount的 时候 type必须为分红树
      // 有倒计时时必须是分红树
      : assert(amount == null ||
            (amount != null && type == TreeType.Type_TimeLimited_Bonus)),
        assert(showCountDown == false ||
            (showCountDown && type == TreeType.Type_TimeLimited_Bonus)),
        originalDuration = duration,
        super(x: x, y: y);

  // 分红树倒计时时长(走动的过程中会动态更新)
  int duration;

  // 分红树倒计时时长,跟durat)ion初始值一致,但是不会改变
  int originalDuration;

  /// 限时分红树已经获取到的奖励部分
  double limitedBonusedAmount = 0.0;

  // 种下限时分红树的时间
  int timePlantedLimitedBonusTree;

  // 分红树 多少钱
  double amount;

  // 等级
  int grade;

  // 该等级生产的次数
  int gradeNumber;

  // 标志是否是特殊的树
  String type;
  bool showCountDown;
  // 标识是启动App后第一次访问（在限时分红树使用）
  String initFlag;
  // 服务端返回的treeId字段
  num treeId;

  // 回收可以得到的钱
  num recycleMoney;

  String get name => type != null
      ? Consts.TreeNameWithType[type]
      : Consts.TreeNameWithGrade[grade - 1];

  List get color => Consts.TreeBottomColorList[grade.toString()];

  double get recycleGold => recycleMoney != null
      ? 0
      : double.parse(
          Tree.treeConfig.recover_content[grade.toString()].toString());

  // 当前级别所能购买的最大等级的树木
  int get highLevelCanPurchese =>
      Tree.treeConfig?.highlevel_purchaselevel[grade.toString()];

  List get _makeTreeUseGoldList => Tree.treeConfig?.content[grade.toString()];

  double get consumeGold =>
      double.tryParse((gradeNumber > _makeTreeUseGoldList.length - 1
              ? _makeTreeUseGoldList[_makeTreeUseGoldList.length - 1]
              : _makeTreeUseGoldList[gradeNumber])
          .toString());

//   double get gold =>
//       grade == Tree.MAX_LEVEL ? 0 : (25 * pow(2, (grade - 1))).toDouble();
  // 单位时间产生金币，38级的全球分红树和限时分红树不产生金币，
  double get gold {
    double gold = double.tryParse(
            Tree.treeConfig?.tree_content[grade.toString()].toString()) ??
        0.0;

//    print("getGold: grade:${grade.toString()}, gold:$gold, type: $type");
    return (type == TreeType.Type_TimeLimited_Bonus ||
            type == TreeType.Type_Globle_Bonus)
        ? 0.0
        : gold;
  }

//   // 指数
//   double get p => grade <= 10 ? 1 : 1 + (grade - 10) * 0.1;

//   // 单位时间产生金币
//   double get money => grade.toDouble();
//   // 回收可以得到的钱
//   // double get recycleMoney => grade.toDouble();
//   // 树的名字

//   // Delay 多少秒后能买下一个果树
//   int get delay => (21 * pow(1.5501, grade - 3)).toInt();

//   // 种一棵需要的钱 初始值
//   double get f => gold * delay * p;

//   double get recycleGold => f * 0.5;
// // ---------------------------------------------------------------------
//   // 种一棵需要的钱 终值
//   double get end => f * pow(1.07005, gradeNumber - 1);
//   // 种一棵需要的钱
//   double get consumeGold => end >= 23 * f ? 23 * f : end;

  //
  String get treeImgSrc =>
      type != null ? 'assets/tree/$type.png' : 'assets/tree/tree$grade.png';

  factory Tree.formJson(Map<String, dynamic> json) => Tree()
    ..x = json['x']
    ..y = json['y']
    ..type = json['type']
    ..recycleMoney = json['recycleMoney']
    ..grade = json['grade']
    ..duration = json['duration']
    ..originalDuration = json['originalDuration']
    ..amount = json['amount']
    ..treeId = json['treeId']
    ..gradeNumber = json['gradeNumber']
    ..limitedBonusedAmount = json['limitedBonusedAmount']
    ..timePlantedLimitedBonusTree = json['timePlantedLimitedBonusTree']
    ..showCountDown = json['showCountDown'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'x': this.x,
        'y': this.y,
        'type': this.type,
        'grade': this.grade,
        'gradeNumber': this.gradeNumber,
        'recycleMoney': this.recycleMoney,
        'treeId': this.treeId,
        'duration': this.duration,
        'amount': this.amount,
        'limitedBonusedAmount': this.limitedBonusedAmount,
        'showCountDown': this.showCountDown,
        'originalDuration': this.originalDuration,
        'timePlantedLimitedBonusTree': this.timePlantedLimitedBonusTree,
      };
}
