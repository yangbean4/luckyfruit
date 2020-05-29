// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lotto_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lotto_list _$Lotto_listFromJson(Map<String, dynamic> json) {
  return Lotto_list()
    ..code = json['code'] as num
    ..msg = json['msg'] as String
    ..data = (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : LottoListItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$Lotto_listToJson(Lotto_list instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
