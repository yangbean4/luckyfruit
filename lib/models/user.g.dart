// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..acct_id = json['acct_id'] as String
    ..nickname = json['nickname'] as String
    ..icon_path = json['icon_path'] as String
    ..last_leave_time = json['last_leave_time'] as String
    ..acct_bal = json['acct_bal'] as num;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'acct_id': instance.acct_id,
      'nickname': instance.nickname,
      'icon_path': instance.icon_path,
      'last_leave_time': instance.last_leave_time,
      'acct_bal': instance.acct_bal
    };
