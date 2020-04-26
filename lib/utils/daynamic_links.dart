import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/provider/lucky_group.dart';
import 'package:luckyfruit/models/index.dart' show ShaerConfig;
import 'package:provider/provider.dart';

class DynamicLink {
  static String userId;
  static initDynamicLinks(String acct_id) async {
    userId = acct_id;
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    update(deepLink, acct_id);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      update(deepLink, acct_id);
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  static update(Uri deepLink, String acct_id) {
    if (deepLink != null) {
      String url = deepLink.toString();
      String code = url.split('code=')[1];
      Service().inviteCode({'acct_id': acct_id, 'invite_code': code});
    }
  }

  static Future<String> getLinks(BuildContext context) async {
    LuckyGroup luckyGroup = Provider.of<LuckyGroup>(context, listen: false);
    ShaerConfig shaerConfig = luckyGroup.shaerConfig;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: shaerConfig.uriPrefix,
        link: Uri.parse('${shaerConfig.fireLink}?code=$userId'),
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
          title: shaerConfig.title,
          description: shaerConfig.subtitle,
          imageUrl: Uri.parse(shaerConfig.imageUrl),
        ));
    final url = await parameters.buildUrl();
    print(url);
    return url.toString();
    // final ShortDynamicLink shortLink = await parameters.buildShortLink();
    // return shortLink.shortUrl.toString();
  }
}
