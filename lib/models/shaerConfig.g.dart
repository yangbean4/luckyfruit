// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shaerConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShaerConfig _$ShaerConfigFromJson(Map<String, dynamic> json) {
  return ShaerConfig()
    ..uriPrefix = json['uriPrefix'] as String
    ..fireLink = json['fireLink'] as String
    ..title = json['title'] as String
    ..subtitle = json['subtitle'] as String
    ..imageUrl = (json['imageUrl'] as List)?.map((e) => e as String)?.toList()
    ..quote = json['quote'] as String
    ..adjustUrl = json['adjustUrl'] as String;
}

Map<String, dynamic> _$ShaerConfigToJson(ShaerConfig instance) =>
    <String, dynamic>{
      'uriPrefix': instance.uriPrefix,
      'fireLink': instance.fireLink,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'imageUrl': instance.imageUrl,
      'quote': instance.quote,
      'adjustUrl': instance.adjustUrl
    };
