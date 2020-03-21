// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnerSubordinateList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerSubordinateList _$PartnerSubordinateListFromJson(
    Map<String, dynamic> json) {
  return PartnerSubordinateList()
    ..lower1 = (json['lower1'] as List)
        ?.map((e) => e == null
            ? null
            : PartnerSubordinateItem.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..lower2 = (json['lower2'] as List)
        ?.map((e) => e == null
            ? null
            : PartnerSubordinateItem.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..pending = (json['pending'] as List)
        ?.map((e) => e == null
            ? null
            : PartnerSubordinateItem.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PartnerSubordinateListToJson(
        PartnerSubordinateList instance) =>
    <String, dynamic>{
      'lower1': instance.lower1,
      'lower2': instance.lower2,
      'pending': instance.pending
    };
