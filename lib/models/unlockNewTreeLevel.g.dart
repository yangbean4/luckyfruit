// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlockNewTreeLevel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnlockNewTreeLevel _$UnlockNewTreeLevelFromJson(Map<String, dynamic> json) {
  return UnlockNewTreeLevel()
    ..tree_type = json['tree_type'] as num
    ..tree_id = json['tree_id'] as num
    ..amount = json['amount'] as num
    ..duration = json['duration'] as num
    ..is_push_on = json['is_push_on'] as num;
}

Map<String, dynamic> _$UnlockNewTreeLevelToJson(UnlockNewTreeLevel instance) =>
    <String, dynamic>{
      'tree_type': instance.tree_type,
      'tree_id': instance.tree_id,
      'amount': instance.amount,
      'duration': instance.duration,
      'is_push_on': instance.is_push_on
    };
