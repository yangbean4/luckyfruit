import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:luckyfruit/models/cityInfo.dart';
import 'package:luckyfruit/pages/revenge/tree_grid_of_revenge.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/provider/tourism_map.dart';
import 'package:luckyfruit/widgets/revenge_gold_flowing_widget.dart';
import 'package:luckyfruit/widgets/revenge_shovel_widget.dart';
import 'package:provider/provider.dart';

class TripOfRevengePage extends StatefulWidget {
  String deblockCityId;
  String acctId;

  /// 类别：0=>虚拟用户,1=>fb 好友
  String type;
  final Map<String, String> argumentsMap;

  TripOfRevengePage(this.argumentsMap)
      : acctId = argumentsMap['acctId'],
        deblockCityId = argumentsMap['deblockCityId'],
        type = argumentsMap['type'];

  @override
  _TripOfRevengePageState createState() => _TripOfRevengePageState();
}

class _TripOfRevengePageState extends State<TripOfRevengePage> {
  String cityImgSrc = 'assets/city/newyork.png';

  @override
  void initState() {
    super.initState();

    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    CityInfo cityInfo = luckyGroup.cityInfoList?.firstWhere(
        (c) => c.id == widget.deblockCityId,
        orElse: () => luckyGroup.cityInfoList[0]);
    String cityName = cityInfo?.code?.replaceAll(' ', '')?.toLowerCase();
    print("TripOfRevengePage_cityName= ${cityName}");
    if (cityName != null && cityName.isNotEmpty) {
      cityImgSrc = 'assets/city/$cityName.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil().setWidth(1080),
        height: ScreenUtil().setHeight(1920),
        child: Stack(overflow: Overflow.visible, children: <Widget>[
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
                            //城市图片
                            Container(
                              width: ScreenUtil().setWidth(1080),
                              // height: ScreenUtil().setWidth(812),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                alignment: Alignment.center,
                                image: AssetImage(cityImgSrc),
                                fit: BoxFit.cover,
                              )),
                            ),
                            // 车辆图片
                            Selector<TourismMap, String>(
                              selector: (context, provider) =>
                                  provider.carImgSrc,
                              builder: (context, String carImgSrc, child) {
                                return Positioned(
                                  bottom: ScreenUtil().setWidth(46),
                                  left: ScreenUtil().setWidth(276),
                                  child: Image.asset(
                                    carImgSrc,
                                    width: ScreenUtil().setWidth(687),
                                    height: ScreenUtil().setWidth(511),
                                  ),
                                );
                              },
                            ),
                            // 人物图片
                            Selector<TourismMap, String>(
                              selector: (context, provider) =>
                                  provider.manImgSrc,
                              builder: (context, String manImgSrc, child) {
                                return Positioned(
                                  bottom: ScreenUtil().setWidth(88),
                                  left: ScreenUtil().setWidth(180),
                                  child: Image.asset(
                                    manImgSrc,
                                    width: ScreenUtil().setWidth(172),
                                    height: ScreenUtil().setWidth(352),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // 主游戏网格视图
                    TreeGridOfRevengeWidget(
                        widget.acctId, int.tryParse(widget.type)),
                  ])),
          // 偷树时喷涌出的金币效果
          RevengeGoldFlowingFlyGroup(),
          // 偷树时小铲子的效果
          RevengeShovelWidget(),
        ]),
      ),
    );
  }
}
