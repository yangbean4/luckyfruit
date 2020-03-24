// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inviterData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviterData _$InviterDataFromJson(Map<String, dynamic> json) {
  return InviterData()
    ..acct_id = json['acct_id'] as String
    ..nickname = json['nickname'] as String
    ..avatar = json['avatar'] as String
    ..level = json['level'] as String;
}

Map<String, dynamic> _$InviterDataToJson(InviterData instance) =>
    <String, dynamic>{
      'acct_id': instance.acct_id,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'level': instance.level
    };
