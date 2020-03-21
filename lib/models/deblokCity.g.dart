// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deblokCity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeblokCity _$DeblokCityFromJson(Map<String, dynamic> json) {
  return DeblokCity()
    ..city_id = json['city_id'] as String
    ..is_open_box = json['is_open_box'] as String;
}

Map<String, dynamic> _$DeblokCityToJson(DeblokCity instance) =>
    <String, dynamic>{
      'city_id': instance.city_id,
      'is_open_box': instance.is_open_box
    };
