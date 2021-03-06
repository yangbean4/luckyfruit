import 'package:flutter/material.dart';
import 'package:luckyfruit/pages/how_to_play.dart';

import 'package:luckyfruit/pages/illustration/illustration.dart';
import 'package:luckyfruit/pages/lotto/lotto_page.dart';
import 'package:luckyfruit/pages/mine/privacy_page.dart';
import 'package:luckyfruit/pages/mine/settings.dart';
import 'package:luckyfruit/pages/mine/widthdraw.dart';
import 'package:luckyfruit/pages/partner/instruction.dart';
import 'package:luckyfruit/pages/partner/invitation_record.dart';
import 'package:luckyfruit/pages/partner/partner_profit_page.dart';
import '../pages/Home.dart';
import '../pages/rank_page.dart';
import 'package:luckyfruit/pages/trip/dividend.dart';
import 'package:luckyfruit/pages/map/map.dart' show MapPage;
import 'package:luckyfruit/pages/mine/mine.dart' show MinePage;
import 'package:luckyfruit/pages/partner/partner.dart';
import 'package:luckyfruit/pages/mine/message.dart';
import 'package:luckyfruit/pages/mine/records.dart';
import 'package:luckyfruit/pages/mine/invitation.dart';
import 'package:luckyfruit/pages/map/bonus_tree.dart';
import 'package:luckyfruit/pages/loading_page.dart';

final routes = {
  'Home': (context) => Home(),
  'Illustration': (context) => Illustration(),
  // 'app.content': (content, {arguments}) => AppPage(arguments: arguments),
  '404': (context) => Text("404"),
  'RankPage': (context) => RankPage(),
  'Dividend': (context) => Dividend(),
  'map': (context) => MapPage(),
  'lotto': (context) => LottoPage(),
  'partner': (context) => Partner(),
  'InvitatioinPage': (context, {arguments}) => InvitationRecordListPage(
        partnerSubordinateList: arguments,
      ),
  'PartnerProfit': (context) => PartnerProfitPageWidget(),
  'WithDrawPage': (context, {arguments}) => WithDrawPage(amount: arguments),
  'mine': (context) => MinePage(),
  'message': (context) => MessagePage(),
  'records': (context) => RecordsPage(),
  'invitationCodePage': (context) => InvitationCodePage(),
  'bonusTreePage': (context) => BonusTree(),
  'settings': (context) => SettingsPage(),
  'privacyPage': (context) => PrivacyPage(),
  'instructionPage': (context) => InstructionPage(),
  'loadingPage': (context) => LoadingPage(),
  'howToPlay': (context) => HowToPlay(),
};

var onGenerateRoute = (RouteSettings routeSettings) {
  final String name = routeSettings.name;

  final Function pageBuilder = routes[name];
  if (pageBuilder != null) {
    Route route;
    if (routeSettings.arguments != null) {
      route = MaterialPageRoute(
          builder: (context) =>
              pageBuilder(context, arguments: routeSettings.arguments));
    } else {
      route = MaterialPageRoute(builder: (context) => pageBuilder(context));
    }
    return route;
  } else {
    // miss match
    final Function notFoundPageBuilder = routes['404'];
    final Route route =
        MaterialPageRoute(builder: (context) => notFoundPageBuilder(context));
    return route;
  }
};
