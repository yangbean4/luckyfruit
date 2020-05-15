/*
 * @Description: 
 * @Author:  bean^ <bean_4@163.com>
 * @Date: 2020-05-11 10:43:13
 * @LastEditors:  bean^ <bean_4@163.com>
 * @LastEditTime: 2020-05-13 10:55:18
 */
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:luckyfruit/models/index.dart' show ShaerConfig;
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:provider/provider.dart';

class DynamicLink {
  static String userId;
  static Uri link;
  static String shareLink;

  static initDynamicLinks({String acct_id}) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    update(deepLink: deepLink, acct_id: acct_id);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      print("dynamiclink_${dynamicLink.link}_$acct_id");
      final Uri deepLink = dynamicLink?.link;
      update(deepLink: deepLink, acct_id: acct_id);
    }, onError: (OnLinkErrorException e) async {
      print("dynamiclink_${e.message}");
    });
  }

  static setUserId(String acct_id) {
    update(acct_id: acct_id);
  }

  static update({Uri deepLink, String acct_id}) {
    link = link ?? deepLink;
    userId = userId ?? acct_id;

    if (link != null && userId != null) {
      String url = link.toString();
      String code = url.split('code=')[1];
      Service().inviteCode({'acct_id': userId, 'invite_code': code});
    }
  }

  static Future<String> getLinks(
      {String imageSrc, ShaerConfig shaerConfig, BuildContext context}) async {
    if (shareLink != null) {
      return shareLink;
    }
    ShaerConfig _shaerConfig = shaerConfig;
    if (shaerConfig == null) {
      LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
      _shaerConfig = luckyGroup.shaerConfig;
    }

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: _shaerConfig.uriPrefix,
        link: Uri.parse('${_shaerConfig.fireLink}?code=$userId'),
        androidParameters: AndroidParameters(
          packageName: 'goodluck.lucky.money.mergegarden.win.cash',
          minimumVersion: 0,
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
        // iosParameters: IosParameters(
        //   bundleId: 'com.google.FirebaseCppDynamicLinksTestApp.dev',
        //   minimumVersion: '0',
        // ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: _shaerConfig.title,
          description: _shaerConfig.subtitle,
          imageUrl: Uri.parse(imageSrc ?? _shaerConfig.imageUrl[0]),
        ));
//    return url.toString();

    String resultUrl;

    try {
      final ShortDynamicLink shortDynamicLink =
          await parameters.buildShortLink();
      resultUrl = shortDynamicLink.shortUrl.toString();
      print("get dynatmic_short link: $resultUrl");
    } catch (e) {
      final url = await parameters.buildUrl();
      resultUrl = url.toString();
      print("get dynatmic_long link: $resultUrl)");
    }
    shareLink = resultUrl.toString();
    return resultUrl;
  }
}
