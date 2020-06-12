/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-06-12 14:36:53
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-06-12 14:41:40
 */
import 'package:flutter/material.dart';

class GardenNews {
  static bool dialogIsShow = false;
  static show(context) {
    if (!dialogIsShow) {
      dialogIsShow = true;
      showDialog(
          context: context,
          builder: (_) => _GardenNews(onClose: () {
                dialogIsShow = false;
              }));
    }
  }
}

class _GardenNews extends StatefulWidget {
  final void Function() onClose;

  _GardenNews({Key key, this.onClose}) : super(key: key);

  @override
  __GardenNewsState createState() => __GardenNewsState();
}

class __GardenNewsState extends State<_GardenNews>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Tween<double> curTween;
  int giftId;
  int awardCount = 0;
  String awardType = '';
  Map<String, dynamic> res;
  Duration duration = Duration(milliseconds: 1500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
      body: Stack(children: [
        Center(child: Container()),
      ]),
    );
  }
}
