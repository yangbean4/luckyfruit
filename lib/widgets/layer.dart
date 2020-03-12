import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:luckyfruit/utils/index.dart';
import 'package:oktoast/oktoast.dart';

import 'package:luckyfruit/theme/index.dart';
import './modal.dart';
import 'package:luckyfruit/theme/public/public.dart';
import 'package:luckyfruit/mould/tree.mould.dart';
import 'package:luckyfruit/widgets/tree_widget.dart';
import 'package:luckyfruit/provider/tree_group.dart';

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
        SecondaryText('恭喜获得'),
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
        SecondaryText('升级成功')
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
                    '还差${TreeGroup.MAX_LEVEL - tree.grade}级',
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
                    '${(tree.grade / TreeGroup.MAX_LEVEL * 100).toStringAsFixed(2)}%',
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
                          .setWidth((tree.grade / TreeGroup.MAX_LEVEL) * 740),
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

// 回收弹窗
  static recycleLayer(Function onOk, String imgSrc, num goldNumber) =>
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
          child: SecondaryText('回收价格'),
        ),
        GoldText(Util.formatNumber(goldNumber))
      ])
        ..show();

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
      dismissOtherToast: true,
      handleTouch: true,
    );
  }
}
