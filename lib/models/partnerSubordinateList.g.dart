// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnerSubordinateList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerSubordinateList _$PartnerSubordinateListFromJson(
    Map<String, dynamic> json) {
  return PartnerSubordinateList()
    ..lower1 = json['lower1'] == null
        ? null
        : PartnerSubordinateItem.fromJson(
            json['lower1'] as Map<String, dynamic>)
    ..lower2 = json['lower2'] == null
        ? null
        : PartnerSubordinateItem.fromJson(
            json['lower2'] as Map<String, dynamic>)
    ..pending = json['pending'] == null
        ? null
        : PartnerSubordinateItem.fromJson(
            json['pending'] as Map<String, dynamic>);
}

Map<String, dynamic> _$PartnerSubordinateListToJson(
        PartnerSubordinateList instance) =>
    <String, dynamic>{
      'lower1': instance.lower1,
      'lower2': instance.lower2,
      'pending': instance.pending
    };
