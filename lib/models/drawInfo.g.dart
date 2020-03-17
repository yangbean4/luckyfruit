// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrawInfo _$DrawInfoFromJson(Map<String, dynamic> json) {
  return DrawInfo()
    ..sign = (json['sign'] as List)
        ?.map(
            (e) => e == null ? null : Sign.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..reward = (json['reward'] as List)
        ?.map((e) =>
            e == null ? null : Reward.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DrawInfoToJson(DrawInfo instance) =>
    <String, dynamic>{'sign': instance.sign, 'reward': instance.reward};
