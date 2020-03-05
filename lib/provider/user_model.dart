import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:luckyfruit/models/index.dart';
import 'package:luckyfruit/service/index.dart';
import 'package:luckyfruit/utils/storage.dart';
import 'package:luckyfruit/utils/device_info.dart';

class UserModel with ChangeNotifier {
  User _user;
  static const String CACHE_KEY = 'user';

  User get value => _user;

  /// 初始化用户
  Future<User> initUser() async {
    String res = await Storage.getItem(UserModel.CACHE_KEY);
    if (res != null) {
      _user = User.fromJson(json.decode(res));
    } else {
      Map<String, dynamic> info = await DeviceIofo.getInfo();
      await getUser(info);
    }
  }

  /// 获取用户信息
  Future<User> getUser(Map<String, dynamic> data) async {
    dynamic userMap = await Service().getUser(data);
    User user = User.fromJson(userMap);
    setUser(user);
    return user;
  }

  /// 设置用户信息
  void setUser(User user) {
    // _user = user;
    // 这里不直接替换对象的原因是为了在结果没有返回或返回空值的情况下使用默认值
    if (_user == null) {
      _user = user;
    } else {
      if (user.acct_id.isNotEmpty) _user.acct_id = user.acct_id;
      _user.acct_bal = user.acct_bal ?? '';
      _user.nickname = user.nickname ?? '';
      _user.icon_path = user.icon_path ?? '';
      _user.last_leave_time = user.last_leave_time ?? '';

      Storage.setItem('user', _user.toJson().toString());

      notifyListeners();
    }
  }
}
