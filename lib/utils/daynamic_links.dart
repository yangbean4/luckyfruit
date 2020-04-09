import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLink {
  static initDynamicLinks(String acct_id) async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      // Navigator.pushNamed(context, deepLink.path);
      print('deepLink-----------------------$deepLink');
      print('deepLink.path------------------------${deepLink.path}');
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print('deepLink-----------------------$deepLink');
        print('deepLink.path------------------------${deepLink.path}');
      }
    }, onError: (OnLinkErrorException e) async {
      print('deepLink-----------------------onLinkError');
      print(e.message);
    });
  }

  static Future<String> getLinks(String code) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'luckyfruit-firelink.mklucky.com',
      link: Uri.parse(
          'https://luckymerge-cdn.mklucky.com/cdn/zip/index.html?code=$code'),
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
    );
    final url = await parameters.buildUrl();
    print(url);
    return url.toString();
    // final ShortDynamicLink shortLink = await parameters.buildShortLink();
    // return shortLink.shortUrl.toString();
  }
}
