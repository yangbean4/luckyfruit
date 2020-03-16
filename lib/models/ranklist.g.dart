// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ranklist _$RanklistFromJson(Map<String, dynamic> json) {
  return Ranklist()
    ..friends = (json['friends'] as List)
        ?.map((e) =>
            e == null ? null : Rank_friends.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..bounsTrees = (json['bounsTrees'] as List)
        ?.map((e) => e == null
            ? null
            : Rank_bonus_trees.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$RanklistToJson(Ranklist instance) => <String, dynamic>{
      'friends': instance.friends,
      'bounsTrees': instance.bounsTrees
    };
