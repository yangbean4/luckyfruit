import 'dart:convert';
import 'dart:convert' as JSON;

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:luckyfruit/config/app.dart';
import 'package:luckyfruit/main.dart';
import 'package:luckyfruit/models/index.dart' show User, PersonalInfo, UserInfo;
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/burial_report.dart';
import 'package:luckyfruit/utils/daynamic_links.dart';
import 'package:luckyfruit/utils/device_info.dart';
import 'package:luckyfruit/utils/method_channel.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/widgets/layer.dart';

class UserModel with ChangeNotifier {
  static const String CACHE_KEY = 'user';

  //
  static const String m_currency_change = 'm_currency_change';
  static const String today_profit_update_time = 'today_profit_update_time';
  static const String profit_update_time = 'profit_update_time';

  UserInfo _userInfo;

  UserInfo get userInfo => _userInfo;

// 该模块下的初始化数据加载完成
  bool _dataLoad = false;

  bool get dataLoad => _dataLoad;

// 分享链接
  String _shareLink;

  String get shareLink => _shareLink;

  User _user;

  User get value => _user;

  PersonalInfo _personalInfo;

  PersonalInfo get personalInfo => _personalInfo;

  // 是否已经登录了Facebook
  bool hasLoginedFB = false;

  /// 初始化用户
  Future<User> initUser() async {
    // String res = await Storage.getItem(UserModel.CACHE_KEY);
    // 因为有 ‘上一次领取时间戳’ ‘当前配置版本号’ 需要在初始化获取 所有先全走请求不走缓存
    // REVIEW:后续改为 先取混存,再去获取 最后更新 并协同其他依赖于user的模块更新配置等
    String res;
    print("initMain1_3");
    if (res != null) {
      _user = User.fromJson(json.decode(res));
    } else {
      Map<String, dynamic> info = await DeviceIofo.getInfo();
      _user = await getUser(info);
      // _user.is_m = 1;
      BurialReport.init(_user.acct_id,
          app_version: info['app_version'],
          config_version: _user.version,
          is_m: _user.is_m.toString(),
          fbID: _user.rela_account);
      notifyListeners();
      loadOther();
      BurialReport.report('login', {
        'aid': info['os_type'] == 'android'
            ? info['gaid'] ?? info['aid']
            : info['idfa'],
        'userid': _user.acct_id,
        'app_version': info['app_version'],
        'config_version': _user.version
      });

      String res = await Storage.getItem(UserModel.m_currency_change);
      if (_user.update_time != null && res != _user.update_time) {
        Storage.setItem(UserModel.m_currency_change, _user.update_time);
        BurialReport.report('m_currency_change',
            {'m_currency_number': _user.acct_bal.toString(), 'type': '2'});
      }

      // String today_profit_update_time = await Storage.getItem(UserModel.today_profit_update_time);
      // if (_user.today_profit_update_time != null && today_profit_update_time != _user.today_profit_update_time) {
      //   Storage.setItem(UserModel.m_currency_change, _user.today_profit_update_time);
      //   BurialReport.report('pc_today_change', {
      //     'm_currency_number': _user.acct_bal.toString(),
      //   });
      // }

      // String res = await Storage.getItem(UserModel.m_currency_change);
      // if (_user.update_time != null && res != _user.update_time) {
      //   Storage.setItem(UserModel.m_currency_change, _user.update_time);
      //   BurialReport.report('m_currency_change', {
      //     'm_currency_number': _user.acct_bal.toString(),
      //   });
      // }
    }
  }

  loadOther() async {
    await getUserInfo();
    await getPersonalInfo();
    _dataLoad = true;
    notifyListeners();
  }

  upDate(Map<String, dynamic> map) async {
    await Service().updateUserInfo({
      'acct_id': value.acct_id,
    }..addAll(map));
  }

  // 更新userInfo
  getUserInfo() async {
    Map<String, dynamic> ajaxData = await Service().getUserInfo({
      'acct_id': value.acct_id,
      'device_id': value.device_id,
    });
    // 保存数据
    _userInfo = UserInfo.fromJson(ajaxData);
    notifyListeners();
    return _userInfo;
  }

// // 获取个人中心数据
  Future<PersonalInfo> getPersonalInfo({forceFetch: false}) async {
    if (_personalInfo != null && !forceFetch) {
      // 有就直接返回
      return Future.value(_personalInfo);
    } else {
      Map<String, dynamic> userMap = await Service().getPersonalInfo(
          {"acct_id": value.acct_id, "device_id": value.device_id});
      PersonalInfo personalInfo = PersonalInfo.fromJson(userMap);
      _personalInfo = personalInfo;
      notifyListeners();
      return personalInfo;
    }
  }

  /// 获取用户信息
  Future<User> getUser(Map<String, dynamic> data) async {
    Map<dynamic, dynamic> deviceMsgMap = await channelBus
        .callNativeMethod(Event_Name.get_device_message_from_native);

    data.addAll(Map<String, dynamic>.from(deviceMsgMap));
    data['is_share'] = DynamicLink.link == null ? 1 : 2;

    print("init_user_index ${data.toString()}");
    dynamic userMap = await Service().getUser(data);
    User user = User.fromJson(userMap);
    return user;
  }

  Future<bool> loginWithFB() async {
    bool loginSuccess = false;
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    print('--------------------------------------------${result}');
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        await Service().relaRelated({
          'acct_id': value.acct_id,
          'rela_type': 1,
          'avatar': profile['picture']['data']['url'],
          'name': profile['name'],
          'rela_account': profile['id'] ?? profile['email']
        });
        await getUserInfo();

        Storage.clearAllCache();
        Initialize.initMain();
        // 登录成功
        hasLoginedFB = true;
        loginSuccess = true;
        break;

      case FacebookLoginStatus.cancelledByUser:
        print(FacebookLoginStatus.cancelledByUser);
        Layer.toastWarning(
            'There is a problem with facebook, please try again later');
        break;
      case FacebookLoginStatus.error:
        print(FacebookLoginStatus.error);
        Layer.toastWarning(
            'There is a problem with facebook, please try again later');

        break;
    }

    return loginSuccess;
  }

// /// 设置用户信息
// void setUser(User user) {
//   // _user = user;
//   // 这里不直接替换对象的原因是为了在结果没有返回或返回空值的情况下使用默认值
//   if (_user == null) {
//     _user = user;
//   } else {
//     if (user.acct_id.isNotEmpty) _user.acct_id = user.acct_id;
//     _user.acct_bal = user.acct_bal ?? '';
//     _user.nickname = user.nickname ?? '';
//     _user.icon_path = user.icon_path ?? '';
//     _user.last_leave_time = user.last_leave_time ?? '';

//     Storage.setItem('user', _user.toJson().toString());

//     notifyListeners();
//   }
// }
}
