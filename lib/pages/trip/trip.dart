import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import './game/game.dart';
// import 'package:luckyfruit/provider/tree_group.dart';
// import 'package:luckyfruit/mould/tree.mould.dart';
// import 'package:luckyfruit/widgets/layer.dart';
import 'package:luckyfruit/provider/money_group.dart';
import 'package:luckyfruit/theme/index.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/widgets/breathe_text.dart';

class Trip extends StatefulWidget {
  Trip({Key key}) : super(key: key);

  @override
  _TripState createState() => _TripState();
}

class _TripState extends State<Trip> {
  @override
  Widget build(BuildContext context) {
    TourismMap tourismMap = Provider.of<TourismMap>(context);

// 创建线性渐变,蓝色强调色到绿色强调色的渐变
// 这里的渐变效果是从左往右的线性渐变
    Gradient gradient = LinearGradient(colors: [
      Color.fromRGBO(255, 172, 30, 1),
      Color.fromRGBO(255, 131, 30, 1),
    ]);
// 根据渐变创建shader
// 范围是从左上角(0,0),到右下角(size.width,size.height)全屏幕范围
    Shader shader = gradient.createShader(
      Rect.fromLTWH(
          0, 0, ScreenUtil().setWidth(300), ScreenUtil().setWidth(300)),
    );
    return Stack(
      children: <Widget>[
        Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Expanded(
                child: Container(
                  width: ScreenUtil().setWidth(1080),
                  // height: ,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(1080),
                        // height: ScreenUtil().setWidth(812),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          alignment: Alignment.center,
                          image: AssetImage(tourismMap.cityImgSrc),
                          fit: BoxFit.cover,
                        )),
                      ),
                      Positioned(
                        bottom: ScreenUtil().setWidth(46),
                        left: ScreenUtil().setWidth(256),
                        child: Image.asset(
                          tourismMap.carImgSrc,
                          width: ScreenUtil().setWidth(687),
                          height: ScreenUtil().setWidth(511),
                        ),
                      ),
                      Positioned(
                        bottom: ScreenUtil().setWidth(88),
                        left: ScreenUtil().setWidth(88),
                        child: Image.asset(
                          tourismMap.manImgSrc,
                          width: ScreenUtil().setWidth(172),
                          height: ScreenUtil().setWidth(352),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Game(),
            ])),
        Positioned(
          bottom: ScreenUtil().setWidth(930),
          left: 0,
          child: Selector<MoneyGroup, Map<String, double>>(
            selector: (context, provider) => ({
              'makeGoldSped': provider.makeGoldSped,
              'gold': provider.gold,
            }),
            builder: (context, Map<String, double> map, child) {
              return Container(
                width: ScreenUtil().setWidth(600),
                height: ScreenUtil().setWidth(150),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(ScreenUtil().setWidth(75)))),
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      right: 0,
                      child: Container(
                        width: ScreenUtil().setWidth(400),
                        height: ScreenUtil().setWidth(150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BreatheAnimation(
                              child: Container(
                                width: ScreenUtil().setWidth(400),
                                child: Text(
                                  Util.formatNumber(map['gold']),
                                  style: TextStyle(
                                      foreground: Paint()..shader = shader,
                                      fontFamily: FontFamily.black,
                                      fontSize: ScreenUtil().setWidth(68),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '${Util.formatNumber(map['makeGoldSped'])}/s',
                              style: TextStyle(
                                  color: MyTheme.blackColor,
                                  fontFamily: FontFamily.bold,
                                  fontSize: ScreenUtil().setWidth(46),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: ScreenUtil().setWidth(-20),
                      left: ScreenUtil().setWidth(60),
                      child: Image.asset(
                        'assets/image/gold.png',
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setWidth(120),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        // 移除此处, 回收改为 在拖动树木时添加按钮处
        // Positioned(
        //   bottom: ScreenUtil().setWidth(880),
        //   right: 0,
        //   child: Selector<TreeGroup, Function>(
        //     selector: (context, provider) => provider.recycle,
        //     builder: (context, Function recycle, child) {
        //       return DragTarget(
        //           builder: (context, candidateData, rejectedData) {
        //         return Container(
        //             width: ScreenUtil().setWidth(226),
        //             height: ScreenUtil().setWidth(252),
        //             decoration: BoxDecoration(
        //               image: DecorationImage(
        //                 image: AssetImage('assets/image/recycle.png'),
        //                 fit: BoxFit.contain,
        //               ),
        //             ));
        //       }, onWillAccept: (Tree source) {
        //         Layer.recycleLayer(() => recycle(source), source.treeImgSrc,
        //             source.recycleGold);
        //         return true;
        //       }, onAccept: (Tree source) {
        //         return true;
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }
}
