// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partnerWrap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerWrap _$PartnerWrapFromJson(Map<String, dynamic> json) {
  return PartnerWrap()
    ..friends = json['friends'] == null
        ? null
        : PartnerSubordinateList.fromJson(
            json['friends'] as Map<String, dynamic>)
    ..fb_no_login = json['fb_no_login'] as num
    ..direct_profit = json['direct_profit'] as num
    ..indirect_profit = json['indirect_profit'] as num
    ..total_profit = json['total_profit'] as num
    ..friends_total = json['friends_total'] as num;
}

Map<String, dynamic> _$PartnerWrapToJson(PartnerWrap instance) =>
    <String, dynamic>{
      'friends': instance.friends,
      'fb_no_login': instance.fb_no_login,
      'direct_profit': instance.direct_profit,
      'indirect_profit': instance.indirect_profit,
      'total_profit': instance.total_profit,
      'friends_total': instance.friends_total
    };
