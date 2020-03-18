// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reward _$RewardFromJson(Map<String, dynamic> json) {
  return Reward()
    ..type = json['type'] as String
    ..sign = json['sign'] as String
    ..module = json['module'] as String
    ..count = json['count'] as String
    ..content = json['content'] as String;
}

Map<String, dynamic> _$RewardToJson(Reward instance) => <String, dynamic>{
      'type': instance.type,
      'sign': instance.sign,
      'module': instance.module,
      'count': instance.count,
      'content': instance.content
    };
