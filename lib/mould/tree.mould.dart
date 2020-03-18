import 'dart:math';

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

  Tree(
      {this.grade,
      this.gradeNumber = 1,
      int x,
      int y,
      this.type,
      this.recycleMoney,
      this.showCountDown = false})
      : super(x: x, y: y);

  // 等级
  int grade;
  // 该等级生产的次数
  int gradeNumber;
  // 标志是否是特殊的树
  String type;
  bool showCountDown;

  // 回收可以得到的钱
  double recycleMoney;

  // 指数
  double get p => grade <= 10 ? 1 : 1 + (grade - 10) * 0.1;
  // 单位时间产生金币  38级的树不产生金币
  double get gold =>
      grade == Tree.MAX_LEVEL ? 0 : (25 * pow(2, (grade - 1))).toDouble();
  // 单位时间产生金币
  double get money => grade.toDouble();
  // 回收可以得到的钱
  // double get recycleMoney => grade.toDouble();
  // 树的名字
  String get name => '石榴树';

  // Delay 多少秒后能买下一个果树
  int get delay => (21 * pow(1.5501, grade - 3)).toInt();

  // 种一棵需要的钱 初始值
  double get f => gold * delay * p;

  double get recycleGold => f * 0.5;
// ---------------------------------------------------------------------
  // 种一棵需要的钱 终值
  double get end => f * pow(1.07005, gradeNumber - 1);
  // 种一棵需要的钱
  double get consumeGold => end >= 23 * f ? 23 * f : end;
  //
  String get treeImgSrc => type != null
      ? 'assets/tree/$type.png'
      : 'assets/tree/tree${grade % 3 + 1}.png';

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
