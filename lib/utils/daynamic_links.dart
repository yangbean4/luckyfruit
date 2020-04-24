import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:luckyfruit/service/index.dart';

class DynamicLink {
  static initDynamicLinks(String acct_id) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;
    update(deepLink, acct_id);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      update(deepLink, acct_id);
    }, onError: (OnLinkErrorException e) async {
      print('deepLink-----------------------onLinkError');
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

  static Future<String> getLinks(String code) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        // uriPrefix: 'luckyfruit-firelink.mklucky.com',
        // link: Uri.parse(
        //     'https://luckymerge-cdn.mklucky.com/cdn/zip/index.html?code=$code'),
        uriPrefix: 'carbaba.com',
        link: Uri.parse(
            'http://d1tfe40abnerwd.cloudfront.net/san/sdk/index.html?code=$code'),
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
          title: 'Example of a Dynamic Link',
          description: 'This link works whether app is installed or not!',
          imageUrl: Uri.parse(
              "http://static01.nyt.com/images/2015/02/19/arts/international/19iht-btnumbers19A/19iht-btnumbers19A-facebookJumbo-v2.jpg"),
        ));
    final url = await parameters.buildUrl();
    print(url);
    return url.toString();
    // final ShortDynamicLink shortLink = await parameters.buildShortLink();
    // return shortLink.shortUrl.toString();
  }
}
