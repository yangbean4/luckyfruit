import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:luckyfruit/utils/burial_report.dart';

import 'package:luckyfruit/utils/daynamic_links.dart';
import 'package:social_share_plugin/social_share_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/models/index.dart' show ShaerConfig;
import 'method_channel.dart';

class ShareUtil {
  static void ShareFacebookImage(BuildContext context) async {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);

    BurialReport.report('invite_entr', {'entr_code': '004'});

    // 系统选择图片
    // File file = await ImagePicker.pickImage(source: ImageSource.gallery);

    // 读取包中图片 写入app的cache文件夹 再分享
    // final ByteData bytes = await rootBundle.load('assets/instruction.jpg');
    // final Uint8List list = bytes.buffer.asUint8List();

    // 读取网络图片 写入app的cache文件夹 再分享
    var request = await HttpClient()
        .getUrl(Uri.parse(luckyGroup.shaerConfig.imageUrl[0]));
    var response = await request.close();
    Uint8List list = await consolidateHttpClientResponseBytes(response);

    final tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/berwachung.jpg';
    File file = await new File(path).create();
    file.writeAsBytesSync(list);

    await SocialSharePlugin.shareToFeedFacebook(
        caption: 'caption',
        path: path,
        onSuccess: (_) {
          print('FACEBOOK SUCCESS');
          return;
        },
        onCancel: () {
          print('FACEBOOK CANCELLED');
          return;
        },
        onError: (error) {
          print('FACEBOOK ERROR $error');
          return;
        });
  }

  static void ShareFacebookLink(BuildContext context, String imagesrc) async {
    final String url = await DynamicLink.getLinks(context, imageSrc: imagesrc);
    // final String url = 'https://luckyfruit-firelink.mklucky.com/c2Sd';

    // 分享网站 设置 标题 图片等 https://developers.facebook.com/docs/sharing/webmasters/
    await SocialSharePlugin.shareToFeedFacebookLink(
        quote: 'quote',
        url: url,
        // url: 'https://carbaba.com/tobR',
        onSuccess: (_) {
          print('FACEBOOK SUCCESS');
          return;
        },
        onCancel: () {
          print('FACEBOOK CANCELLED');
          return;
        },
        onError: (error) {
          print('FACEBOOK ERROR $error');
          return;
        });
  }

  static void ShareFacebookMessager(
      BuildContext context, String imagesrc) async {
    final String url = await DynamicLink.getLinks(context, imageSrc: imagesrc);
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    ShaerConfig shaerConfig = luckyGroup.shaerConfig;
    ChannelBus().callNativeMethod("sendMessage", arguments: {
      "urlActionTitle": "Visit",
      "url": url,
      "title": shaerConfig.title,
      "subtitle": shaerConfig.subtitle,
      "imageUrl": shaerConfig.imageUrl
    });
  }

  static void share(BuildContext context) {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    List<String> imgList = luckyGroup.shaerConfig.imageUrl;
    showDialog(
        context: context,
        builder: (_) => _Layer(
              imgList: imgList,
              onOk: (int index, int type) {
                if (type == 0) {
                  ShareUtil.ShareFacebookLink(context, imgList[index]);
                } else {
                  ShareUtil.ShareFacebookMessager(context, imgList[index]);
                }
              },
            ));
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
        backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
        body: Container(
          width: ScreenUtil().setWidth(1080),
          height: ScreenUtil().setHeight(1920),
          child: Stack(
            children: <Widget>[
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: ScreenUtil().setWidth(1080),
                    height: ScreenUtil().setHeight(484),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(232, 232, 232, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().setWidth(50)),
                          topRight: Radius.circular(ScreenUtil().setWidth(50)),
                        )),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      width: ScreenUtil().setWidth(180),
                                      height: ScreenUtil().setWidth(180),
                                    ),
                                    Text(
                                      'Facebook',
                                      style: TextStyle(
                                        color: Color.fromRGBO(53, 59, 87, 1),
                                        fontSize: ScreenUtil().setWidth(48),
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
                                      width: ScreenUtil().setWidth(180),
                                      height: ScreenUtil().setWidth(180),
                                    ),
                                    Text(
                                      'Messenger',
                                      style: TextStyle(
                                        color: Color.fromRGBO(53, 59, 87, 1),
                                        fontSize: ScreenUtil().setWidth(48),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ]),
                  )),
              Positioned(
                right: 0,
                bottom: ScreenUtil().setWidth(400),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(140),
                    height: ScreenUtil().setHeight(140),
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
            ],
          ),
        ));
  }
}
