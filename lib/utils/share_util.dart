import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    var request =
        await HttpClient().getUrl(Uri.parse(luckyGroup.shaerConfig.imageUrl));
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

  static void ShareFacebookLink(BuildContext context) async {
    final String url = await DynamicLink.getLinks(context);
    // final String url = 'https://luckyfruit-firelink.mklucky.com/c2Sd';

    // 分享网站 设置 标题 图片等 https://developers.facebook.com/docs/sharing/webmasters/
    await SocialSharePlugin.shareToFeedFacebookLink(
        quote: 'quote',
        url: url,
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

  static void ShareFacebookMessager(BuildContext context) async {
    // await FacebookShare.sendMessage(
    //     urlActionTitle: "Visit",
    //     url: "https://nemob.id",
    //     title: "Promotion",
    //     subtitle: "Get your promotion now!",
    //     imageUrl:
    //         "https://d1whtlypfis84e.cloudfront.net/guides/wp-content/uploads/2018/03/10173552/download6.jpg");
  }
}
