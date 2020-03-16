// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_friends.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rank_friends _$Rank_friendsFromJson(Map<String, dynamic> json) {
  return Rank_friends()
    ..acct_id = json['acct_id'] as String
    ..superior1 = json['superior1'] as String
    ..rela_account = json['rela_account'] as String
    ..avatar = json['avatar'] as String
    ..amount = json['amount'] as String
    ..separate_amount = json['separate_amount'] as String
    ..hasTree = json['hasTree'] as num;
}

Map<String, dynamic> _$Rank_friendsToJson(Rank_friends instance) =>
    <String, dynamic>{
      'acct_id': instance.acct_id,
      'superior1': instance.superior1,
      'rela_account': instance.rela_account,
      'avatar': instance.avatar,
      'amount': instance.amount,
      'separate_amount': instance.separate_amount,
      'hasTree': instance.hasTree
    };
