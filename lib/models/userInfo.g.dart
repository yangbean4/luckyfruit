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
    ..sign_times = json['sign_times'] as num;
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'acct_bal': instance.acct_bal,
      'separate_amount': instance.separate_amount,
      'coin': instance.coin,
      'wishTreeNum': instance.wishTreeNum,
      'phoneNum': instance.phoneNum,
      'sign_times': instance.sign_times
    };
