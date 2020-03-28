// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_bonus_trees.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rank_bonus_trees _$Rank_bonus_treesFromJson(Map<String, dynamic> json) {
  return Rank_bonus_trees()
    ..acct_id = json['acct_id'] as String
    ..superior1 = json['superior1'] as String
    ..rela_account = json['rela_account'] as String
    ..avatar = json['avatar'] as String
    ..amount = json['amount'] as String
    ..separate_amount = json['separate_amount'] as String
    ..tree_num = json['tree_num'] as num;
}

Map<String, dynamic> _$Rank_bonus_treesToJson(Rank_bonus_trees instance) =>
    <String, dynamic>{
      'acct_id': instance.acct_id,
      'superior1': instance.superior1,
      'rela_account': instance.rela_account,
      'avatar': instance.avatar,
      'amount': instance.amount,
      'separate_amount': instance.separate_amount,
      'tree_num': instance.tree_num
    };
