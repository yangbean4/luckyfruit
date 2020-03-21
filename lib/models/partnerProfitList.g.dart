// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnerProfitList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerProfitList _$PartnerProfitListFromJson(Map<String, dynamic> json) {
  return PartnerProfitList()
    ..code = json['code'] as num
    ..msg = json['msg'] as String
    ..data = (json['data'] as List)
        ?.map((e) => e == null
            ? null
            : PartnerProfitItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PartnerProfitListToJson(PartnerProfitList instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
