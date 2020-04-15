// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barrageMsg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarrageMsg _$BarrageMsgFromJson(Map<String, dynamic> json) {
  return BarrageMsg()
    ..id = json['id'] as String
    ..punch_time = json['punch_time'] as String
    ..nickname = json['nickname'] as String
    ..num = json['num'] as String
    ..module = json['module'] as String;
}

Map<String, dynamic> _$BarrageMsgToJson(BarrageMsg instance) =>
    <String, dynamic>{
      'id': instance.id,
      'punch_time': instance.punch_time,
      'nickname': instance.nickname,
      'num': instance.num,
      'module': instance.module
    };
