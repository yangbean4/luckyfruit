// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'levelRoule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelRoule _$LevelRouleFromJson(Map<String, dynamic> json) {
  return LevelRoule()
    ..id = json['id'] as String
    ..level = json['level'] as String
    ..need_coin_prefix = json['need_coin_prefix'] as String
    ..need_coin_times = json['need_coin_times'] as String
    ..deblock_city = json['deblock_city'] as String
    ..award_coin_prefix = json['award_coin_prefix'] as String
    ..award_coin_time = json['award_coin_time'] as String;
}

Map<String, dynamic> _$LevelRouleToJson(LevelRoule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'need_coin_prefix': instance.need_coin_prefix,
      'need_coin_times': instance.need_coin_times,
      'deblock_city': instance.deblock_city,
      'award_coin_prefix': instance.award_coin_prefix,
      'award_coin_time': instance.award_coin_time
    };
