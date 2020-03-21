// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cityInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityInfo _$CityInfoFromJson(Map<String, dynamic> json) {
  return CityInfo()
    ..id = json['id'] as String
    ..continent = json['continent'] as String
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..bg_img = json['bg_img'] as String
    ..fruit_img = json['fruit_img'] as String
    ..sort = json['sort'] as String
    ..add_time = json['add_time'] as String;
}

Map<String, dynamic> _$CityInfoToJson(CityInfo instance) => <String, dynamic>{
      'id': instance.id,
      'continent': instance.continent,
      'code': instance.code,
      'name': instance.name,
      'bg_img': instance.bg_img,
      'fruit_img': instance.fruit_img,
      'sort': instance.sort,
      'add_time': instance.add_time
    };
