// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo()
    ..acct_bal = json['acct_bal'] as num
    ..separate_amount = json['separate_amount'] as String
    ..coin = json['coin'] as String
    ..wishTreeNum = json['wishTreeNum'] as num
    ..phoneNum = json['phoneNum'] as num
    ..sign_times = json['sign_times'] as num
    ..nickname = json['nickname'] as String
    ..avatar = json['avatar'] as String
    ..invite_code = json['invite_code'] as String
    ..worker_visible = json['worker_visible'] as num
    ..direct_friend_visible = json['direct_friend_visible'] as num
    ..paypal_account = json['paypal_account'] as String
    ..ad_times = json['ad_times'] as num
    ..residue_times = json['residue_times'] as num
    ..is_today_sign = json['is_today_sign'] as num
    ..level = json['level'] as String
    ..first_mention = json['first_mention'] as num;
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'acct_bal': instance.acct_bal,
      'separate_amount': instance.separate_amount,
      'coin': instance.coin,
      'wishTreeNum': instance.wishTreeNum,
      'phoneNum': instance.phoneNum,
      'sign_times': instance.sign_times,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'invite_code': instance.invite_code,
      'worker_visible': instance.worker_visible,
      'direct_friend_visible': instance.direct_friend_visible,
      'paypal_account': instance.paypal_account,
      'ad_times': instance.ad_times,
      'residue_times': instance.residue_times,
      'is_today_sign': instance.is_today_sign,
      'level': instance.level,
      'first_mention': instance.first_mention
    };
