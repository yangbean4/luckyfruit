// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sign _$SignFromJson(Map<String, dynamic> json) {
  return Sign()
    ..type = json['type'] as String
    ..sign = json['sign'] as String
    ..count = json['count'] as String
    ..module = json['module'] as String
    ..content = json['content'] as String;
}

Map<String, dynamic> _$SignToJson(Sign instance) => <String, dynamic>{
      'type': instance.type,
      'sign': instance.sign,
      'count': instance.count,
      'module': instance.module,
      'content': instance.content
    };
