// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_award.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invite_award _$Invite_awardFromJson(Map<String, dynamic> json) {
  return Invite_award()
    ..tree_type = json['tree_type'] as num
    ..tree_id = json['tree_id'] as num
    ..amount = json['amount'] as num
    ..duration = json['duration'] as num;
}

Map<String, dynamic> _$Invite_awardToJson(Invite_award instance) =>
    <String, dynamic>{
      'tree_type': instance.tree_type,
      'tree_id': instance.tree_id,
      'amount': instance.amount,
      'duration': instance.duration
    };
