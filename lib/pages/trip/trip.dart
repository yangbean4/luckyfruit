import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import './game/game.dart';
import 'package:luckyfruit/provider/tree_group.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/widgets/layer.dart';
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
                        bottom: ScreenUtil().setWidth(140),
                        left: ScreenUtil().setWidth(296),
                        child: Image.asset(
                          tourismMap.carImgSrc,
                          width: ScreenUtil().setWidth(455),
                          height: ScreenUtil().setWidth(276),
                        ),
                      ),
                      Positioned(
                        bottom: ScreenUtil().setWidth(140),
                        left: ScreenUtil().setWidth(152),
                        child: Image.asset(
                          tourismMap.manImgSrc,
                          width: ScreenUtil().setWidth(110),
                          height: ScreenUtil().setWidth(313),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Game(),
            ])),
        Positioned(
          bottom: ScreenUtil().setWidth(1175),
          left: 0,
          child: Selector<MoneyGroup, Map<String, double>>(
            selector: (context, provider) => ({
              'makeGoldSped': provider.makeGoldSped,
              'gold': provider.gold,
            }),
            builder: (context, Map<String, double> map, child) {
              return Container(
                width: ScreenUtil().setWidth(500),
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
                        width: ScreenUtil().setWidth(300),
                        height: ScreenUtil().setWidth(150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            BreatheText(
                              child: Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(300),
                                child: Text(
                                  Util.formatNumber(map['gold']),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: MyTheme.secondaryColor,
                                      fontSize: ScreenUtil().setWidth(44),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Text(
                              '${Util.formatNumber(map['makeGoldSped'])}b/s',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: MyTheme.blackColor,
                                  fontSize: ScreenUtil().setWidth(38),
                                  fontWeight: FontWeight.w600),
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
        Positioned(
          bottom: ScreenUtil().setWidth(1110),
          right: 0,
          child: Selector<TreeGroup, Function>(
            selector: (context, provider) => provider.recycle,
            builder: (context, Function recycle, child) {
              return DragTarget(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                        width: ScreenUtil().setWidth(226),
                        height: ScreenUtil().setWidth(252),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/image/recycle.png'),
                            fit: BoxFit.contain,
                          ),
                        ));
                  },
                  onWillAccept: (Tree source) {
                    Layer.recycleLayer(() => recycle(source), source.treeImgSrc,
                        source.recycleMoney);
                    return false;
                  },
                  onAccept: (Tree source) {});
            },
          ),
        ),
      ],
    );
  }
}
