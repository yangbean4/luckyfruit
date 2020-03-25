// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unlock_new_tree_level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Unlock_new_tree_level _$Unlock_new_tree_levelFromJson(
    Map<String, dynamic> json) {
  return Unlock_new_tree_level()
    ..tree_type = json['tree_type'] as num
    ..tree_id = json['tree_id'] as num
    ..amount = json['amount'] as num
    ..duration = json['duration'] as num;
}

Map<String, dynamic> _$Unlock_new_tree_levelToJson(
        Unlock_new_tree_level instance) =>
    <String, dynamic>{
      'tree_type': instance.tree_type,
      'tree_id': instance.tree_id,
      'amount': instance.amount,
      'duration': instance.duration
    };
