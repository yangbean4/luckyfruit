import 'dart:math';

class TreePoint {
  // 水平位置
  int x;
  // 垂直位置
  int y;
  TreePoint({this.x, this.y});
}

class Tree extends TreePoint {
  // 等级
  int grade;
  // 该等级生产的次数
  int gradeNumber;
  //

  // 指数
  double get p => grade <= 10 ? 1 : 1 + (grade - 10) * 0.1;
  // 单位时间产生金币
  double get gold => (25 * pow(2, (grade - 1))).toDouble();
  // 单位时间产生金币
  double get money => grade.toDouble();
  // 回收可以得到的钱
  double get recycleMoney => grade.toDouble();
  // 树的名字
  String get name => '石榴树';

  // Delay 多少秒后能买下一个果树
  int get delay => (21 * pow(1.5501, grade - 3)).toInt();

  // 种一棵需要的钱 初始值
  double get f => gold * delay * p;
// ---------------------------------------------------------------------
  // 种一棵需要的钱 终值
  double get end => f * pow(1.07005, gradeNumber - 1);
  // 种一棵需要的钱
  double get consumeGold => end >= 23 * f ? 23 * f : end;
  //
  String get treeImgSrc => 'assets/image/tree.png';

  Tree({this.grade, this.gradeNumber = 1, int x, int y}) : super(x: x, y: y);

  factory Tree.formJson(Map<String, dynamic> json) => Tree()
    ..x = int.parse(json['x'].toString())
    ..y = int.parse(json['y'].toString())
    ..grade = int.parse(json['grade'].toString());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'x': this.x,
        'y': this.y,
        'grade': this.grade,
      };
}
