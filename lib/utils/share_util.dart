import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:luckyfruit/models/index.dart' show ShaerConfig;
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/daynamic_links.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:social_share_plugin/social_share_plugin.dart';

import 'method_channel.dart';

class ShareUtil {
//  static void ShareFacebookImage(BuildContext context) async {
//    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
//
//    BurialReport.report('invite_entr', {'entr_code': '004'});
//
//    // 系统选择图片
//    // File file = await ImagePicker.pickImage(source: ImageSource.gallery);
//
//    // 读取包中图片 写入app的cache文件夹 再分享
//    // final ByteData bytes = await rootBundle.load('assets/instruction.jpg');
//    // final Uint8List list = bytes.buffer.asUint8List();
//
//    // 读取网络图片 写入app的cache文件夹 再分享
//    var request = await HttpClient()
//        .getUrl(Uri.parse(luckyGroup.shaerConfig.imageUrl[0]));
//    var response = await request.close();
//    Uint8List list = await consolidateHttpClientResponseBytes(response);
//
//    final tempDir = await getTemporaryDirectory();
//    String path = '${tempDir.path}/berwachung.jpg';
//    File file = await new File(path).create();
//    file.writeAsBytesSync(list);
//
//    await SocialSharePlugin.shareToFeedFacebook(
//        caption: 'caption',
//        path: path,
//        onSuccess: (_) {
//          print('FACEBOOK SUCCESS');
//          return;
//        },
//        onCancel: () {
//          print('FACEBOOK CANCELLED');
//          return;
//        },
//        onError: (error) {
//          print('FACEBOOK ERROR $error');
//          return;
//        });
//  }

//  static void ShareFacebookLink(BuildContext context, String imagesrc) async {
//    final String url = await DynamicLink.getLinks(context: context, imageSrc: imagesrc);
//    // final String url = 'https://luckyfruit-firelink.mklucky.com/c2Sd';
//
//    // 分享网站 设置 标题 图片等 https://developers.facebook.com/docs/sharing/webmasters/
//
//    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
//    ShaerConfig shaerConfig = luckyGroup.shaerConfig;
//    await SocialSharePlugin.shareToFeedFacebookLink(
//        quote: shaerConfig.quote ?? 'Merge Garden🏡，Win Rewards🎁！',
//        url: url,
//        // url: 'https://carbaba.com/tobR',
//        onSuccess: (_) {
//          print('FACEBOOK SUCCESS');
//          return;
//        },
//        onCancel: () {
//          print('FACEBOOK CANCELLED');
//          return;
//        },
//        onError: (error) {
//          print('FACEBOOK ERROR $error');
//          return;
//        });
//  }

//  static void ShareFacebookMessager(
//      BuildContext context, String imagesrc) async {
//    final String url = await DynamicLink.getLinks(context: context, imageSrc: imagesrc);
//    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
//    ShaerConfig shaerConfig = luckyGroup.shaerConfig;
//    ChannelBus().callNativeMethod("sendMessage", arguments: {
//      "urlActionTitle": "Visit",
//      "url": url,
//      "title": shaerConfig.title,
//      "subtitle": shaerConfig.subtitle,
//      "imageUrl": imagesrc
//    });
//  }

//  static void share(BuildContext context) {
//    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
//    List<String> imgList = luckyGroup.shaerConfig.imageUrl;
//    showDialog(
//        context: context,
//        builder: (_) => _Layer(
//              imgList: imgList,
//              onOk: (int index, int type) {
//                if (type == 0) {
//                  ShareUtil.ShareFacebookLink(context, imgList[index]);
//                } else {
//                  ShareUtil.ShareFacebookMessager(context, imgList[index]);
//                }
//              },
//            ));
//  }

  static void share(BuildContext context) async {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    List<String> imgList = luckyGroup.shaerConfig.imageUrl;
    ShaerConfig shaerConfig = luckyGroup.shaerConfig;
    String quote = shaerConfig.quote ?? 'Merge Garden🏡，Win Rewards🎁！';
    String url =
        await DynamicLink.getLinks(context: context, imageSrc: imgList[0]);
    Share.share('$quote $url');

    BurialReport.reportAdjust(
        BurialReport.Adjust_Event_Token_Invite);
  }
}

class _Layer extends StatefulWidget {
  final List<String> imgList;
  final Function onOk;

  _Layer({Key key, this.imgList, this.onOk}) : super(key: key);

  @override
  __LayerState createState() => __LayerState();
}

class __LayerState extends State<_Layer> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.0),
        body: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setHeight(1920),
            child: Stack(
              children: <Widget>[
                // Positioned(
                //   top: ScreenUtil().setWidth(366),
                //   child: Container(
                //     height: ScreenUtil().setWidth(531),
                //     child: _DesktopCarousel(children: [
                //       Image.network(
                //         'https://mergegarden-cdn.mkfruit.com/cdn/img/share_pic3.png',
                //         width: ScreenUtil().setWidth(943),
                //         height: ScreenUtil().setWidth(531),
                //       ),
                //       Image.network(
                //         'https://mergegarden-cdn.mkfruit.com/cdn/img/share_pic3.png',
                //         width: ScreenUtil().setWidth(943),
                //         height: ScreenUtil().setWidth(531),
                //       ),
                //       Image.network(
                //         'https://mergegarden-cdn.mkfruit.com/cdn/img/share_pic3.png',
                //         width: ScreenUtil().setWidth(943),
                //         height: ScreenUtil().setWidth(531),
                //       ),
                //       Image.network(
                //         'https://mergegarden-cdn.mkfruit.com/cdn/img/share_pic3.png',
                //         width: ScreenUtil().setWidth(943),
                //         height: ScreenUtil().setWidth(531),
                //       ),
                //     ]),
                //   ),
                // ),
                Positioned(
                  top: ScreenUtil().setWidth(366),
                  left: ScreenUtil().setWidth(76),
                  child: GestureDetector(
                    onTap: () {},
                    child: CachedNetworkImage(
                      imageUrl: widget.imgList[0],
                      width: ScreenUtil().setWidth(943),
                      height: ScreenUtil().setWidth(531),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                          width: ScreenUtil().setWidth(1080),
                          height: ScreenUtil().setWidth(484),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(232, 232, 232, 1),
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    Radius.circular(ScreenUtil().setWidth(50)),
                                topRight:
                                    Radius.circular(ScreenUtil().setWidth(50)),
                              )),
                          child: Stack(children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(1080),
                              height: ScreenUtil().setWidth(484),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        widget.onOk(index, 0);
                                      },
                                      child: Container(
                                        width: ScreenUtil().setWidth(270),
                                        height: ScreenUtil().setWidth(270),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/image/facebook.png',
                                                width:
                                                    ScreenUtil().setWidth(180),
                                                height:
                                                    ScreenUtil().setWidth(180),
                                              ),
                                              Text(
                                                'Facebook',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      53, 59, 87, 1),
                                                  fontSize:
                                                      ScreenUtil().setWidth(48),
                                                ),
                                              )
                                            ]),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        widget.onOk(index, 1);
                                      },
                                      child: Container(
                                        width: ScreenUtil().setWidth(270),
                                        height: ScreenUtil().setWidth(270),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Image.asset(
                                                'assets/image/Messenger.png',
                                                width:
                                                    ScreenUtil().setWidth(180),
                                                height:
                                                    ScreenUtil().setWidth(180),
                                              ),
                                              Text(
                                                'Messenger',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      53, 59, 87, 1),
                                                  fontSize:
                                                      ScreenUtil().setWidth(48),
                                                ),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ]),
                            ),
                            Positioned(
                              right: 0,
                              top: ScreenUtil().setWidth(0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: ScreenUtil().setWidth(140),
                                  height: ScreenUtil().setWidth(140),
                                  child: Center(
                                    child: Image.asset(
                                      'assets/image/share_close.png',
                                      width: ScreenUtil().setWidth(40),
                                      height: ScreenUtil().setWidth(40),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ])),
                    )),
              ],
            ),
          ),
        ));
  }
}

// Container(
//   height: carouselHeight,
//   child: _DesktopCarousel(children: carouselCards),
// ),

// final carouselCards = <Widget>[
//     _CarouselCard(
//       demo: studyDemos['shrine'],
//       asset: const AssetImage('assets/studies/shrine_card.png'),
//       assetColor: const Color(0xFFFEDBD0),
//       assetDark: const AssetImage('assets/studies/shrine_card_dark.png'),
//       assetDarkColor: const Color(0xFF543B3C),
//       textColor: shrineBrown900,
//       studyRoute: ShrineApp.loginRoute,
//     ),

const _desktopCardsPerPage = 4;
const _horizontalDesktopPadding = 81.0;

class _DesktopCarousel extends StatefulWidget {
  const _DesktopCarousel({Key key, this.children}) : super(key: key);

  final List<Widget> children;

  @override
  _DesktopCarouselState createState() => _DesktopCarouselState();
}

class _DesktopCarouselState extends State<_DesktopCarousel> {
  static const cardPadding = 15.0;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _builder(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: cardPadding,
      ),
      child: widget.children[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    var showPreviousButton = false;
    var showNextButton = true;
    // Only check this after the _controller has been attached to the ListView.
    if (_controller.hasClients) {
      showPreviousButton = _controller.offset > 0;
      showNextButton =
          _controller.offset < _controller.position.maxScrollExtent;
    }
    final totalWidth = MediaQuery.of(context).size.width -
        (_horizontalDesktopPadding - cardPadding) * 2;
    final itemWidth = totalWidth / _desktopCardsPerPage;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalDesktopPadding - cardPadding,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const _SnappingScrollPhysics(),
            controller: _controller,
            itemExtent: itemWidth,
            itemCount: widget.children.length,
            itemBuilder: (context, index) => _builder(index),
          ),
        ),
        if (showPreviousButton)
          _DesktopPageButton(
            onTap: () {
              _controller.animateTo(
                _controller.offset - itemWidth,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
          ),
        if (showNextButton)
          _DesktopPageButton(
            isEnd: true,
            onTap: () {
              _controller.animateTo(
                _controller.offset + itemWidth,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            },
          ),
      ],
    );
  }
}

class _SnappingScrollPhysics extends ScrollPhysics {
  const _SnappingScrollPhysics({ScrollPhysics parent}) : super(parent: parent);

  @override
  _SnappingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return _SnappingScrollPhysics(parent: buildParent(ancestor));
  }

  double _getTargetPixels(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
  ) {
    final itemWidth = position.viewportDimension / _desktopCardsPerPage;
    var item = position.pixels / itemWidth;
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return math.min(
      item.roundToDouble() * itemWidth,
      position.maxScrollExtent,
    );
  }

  @override
  Simulation createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = this.tolerance;
    final target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}

class _DesktopPageButton extends StatelessWidget {
  const _DesktopPageButton({
    Key key,
    this.isEnd = false,
    this.onTap,
  }) : super(key: key);

  final bool isEnd;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    final buttonSize = 58.0;
    final padding = _horizontalDesktopPadding - buttonSize / 2;
    return Align(
      alignment: isEnd
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        margin: EdgeInsetsDirectional.only(
          start: isEnd ? 0 : padding,
          end: isEnd ? padding : 0,
        ),
        child: Tooltip(
          message: isEnd
              ? MaterialLocalizations.of(context).nextPageTooltip
              : MaterialLocalizations.of(context).previousPageTooltip,
          child: Material(
            color: Colors.black.withOpacity(0.5),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Icon(
                isEnd ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
