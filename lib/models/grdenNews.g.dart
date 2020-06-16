// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grdenNews.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrdenNews _$GrdenNewsFromJson(Map<String, dynamic> json) {
  return GrdenNews()
    ..stolen_acct_id = json['stolen_acct_id'] as String
    ..type = json['type'] as num
    ..tree_type = json['tree_type'] as String
    ..content = json['content'] as String
    ..percent = json['percent'] as String
    ..is_show = json['is_show'] as String
    ..add_time = json['add_time'] as String
    ..nickname = json['nickname'] as String
    ..avatar = json['avatar'] as String
    ..deblock_city = json['deblock_city'] as num
    ..space_time = json['space_time'] as String
    ..level = json['level'] as num;
}

Map<String, dynamic> _$GrdenNewsToJson(GrdenNews instance) => <String, dynamic>{
      'stolen_acct_id': instance.stolen_acct_id,
      'type': instance.type,
      'tree_type': instance.tree_type,
      'content': instance.content,
      'percent': instance.percent,
      'is_show': instance.is_show,
      'add_time': instance.add_time,
      'nickname': instance.nickname,
      'avatar': instance.avatar,
      'deblock_city': instance.deblock_city,
      'space_time': instance.space_time,
      'level': instance.level
    };
