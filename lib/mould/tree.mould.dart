import 'dart:math';
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
      this.duration = 200,
      this.showCountDown = false})
      // 要求传 amount的 时候 type必须为分红树
      // 有倒计时时必须是分红树
      : assert(
            amount == null || (amount != null && type == TreeType.Type_BONUS)),
        assert(showCountDown == false ||
            (showCountDown && type == TreeType.Type_BONUS)),
        originalDuration = duration,
        super(x: x, y: y);

  // 分红树倒计时时长(走动的过程中会动态更新)
  int duration;
  // 分红树倒计时时长,跟durat)ion初始值一致,但是不会改变
  int originalDuration;
  // 分红树 多少钱
  double amount;
  // 等级
  int grade;
  // 该等级生产的次数
  int gradeNumber;
  // 标志是否是特殊的树
  String type;
  bool showCountDown;
  // 服务端返回的treeId字段
  num treeId;

  // 回收可以得到的钱
  num recycleMoney;

  String get name => type != null
      ? Consts.TreeNameWithType[type]
      : Consts.TreeNameWithGrade[grade - 1];

  double get recycleGold => recycleMoney != null
      ? 0
      : double.parse(
          Tree.treeConfig.recover_content[grade.toString()].toString());

  List get _makeTreeUseGoldList => Tree.treeConfig?.content[grade.toString()];

  double get consumeGold =>
      double.tryParse((gradeNumber > _makeTreeUseGoldList.length - 1
              ? _makeTreeUseGoldList[_makeTreeUseGoldList.length - 1]
              : _makeTreeUseGoldList[gradeNumber])
          .toString());

//   // 单位时间产生金币  38级的树不产生金币
//   double get gold =>
//       grade == Tree.MAX_LEVEL ? 0 : (25 * pow(2, (grade - 1))).toDouble();
  double get gold => grade == Tree.MAX_LEVEL
      ? 0.0
      : double.tryParse(
          Tree.treeConfig?.tree_content[grade.toString()].toString());
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
    ..grade = json['grade'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'x': this.x,
        'y': this.y,
        'type': this.type,
        'recycleMoney': this.recycleMoney,
        'grade': this.grade,
      };
}
